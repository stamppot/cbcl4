class MissingData
  
  def fill_missing_answer_cells
    questions = [25, 20, 19, 18, 272]
    added_cells = []
    # this question should have so many rating answercells
    qs = Question.find(questions)
    q_sizes = qs.build_hash {|q| [q.id, q.question_cells.ratings.size] }
    # result = []
    too_few = []
    q_sizes.each do |q_id, numbers|
      numbers = numbers.first
      answers = Answer.all(:conditions => ['question_id = ?', q_id])
      full, not_full = answers.partition do |answer|
        ac_size = answer.answer_cells.ratings.size
        if ac_size > numbers # too many
          # puts "More #{ac_size} < #{numbers} Answer #{answer.inspect}"
          # result << {:q_id => q_id, :numbers => numbers, :a_id => answer.id, :a_cells => ac_size }
          remove_doubles(answer)
        elsif ac_size < numbers # too few, missing cells
          too_few << {:q_id => q_id, :numbers => numbers, :a_id => answer.id, :a_cells => ac_size }
          # puts "Less: #{too_few.inspect}"
          added_cells << {answer.id => add_missing_cells(answer) }
        elsif
          ac_size == numbers
        end
        # puts "Checking next answer: #{answer.id}"
      end
    end
    # result
    puts "Added cells: #{added_cells.inspect}"
    added_cells
  end

  # add cells for correct row,col. Value = 9
  def add_missing_cells(answer)
    a_cells = answer.answer_cells.ratings #.map {|a| [a.row, a.col] }
    count = 0
    # find missing
    cells = a_cells.map {|a| [a.row, a.col] }
    cell_arr = cells.first
    return if !(cell_arr && cell_arr.size == 2) 

    q_cells = answer.question.question_cells.ratings.map {|a| [a.row, a.col] }
    q_cells_size = q_cells.size
    missing_cells = q_cells - cells
    # puts "Answer: #{answer.id}\nmissing cells: #{missing_cells.inspect}"
    new_cells = []
    missing_cells.each do |m_cell|
      row, col = m_cell
      find_row = row - 1 # try one before this
      cells_away = 1 # how far the found cell is from the one to fill in
      while((prev_item = a_cells.detect { |c| c.row == find_row}).nil? && find_row > 0) do
        find_row -= 1
        cells_away += 1
      end
      # puts "find_row: #{find_row} cells_away: #{cells_away}"
      if prev_item && (item = prev_item.item) && find_row > 0 && find_row < q_cells_size
        cells_away.times { item.succ! }
        # puts "new item: #{item}, m_cell: #{m_cell.inspect} prev_cell: #{prev_item.inspect}"
        unless exists = answer.answer_cells(true).find_by_row_and_col(row, col)
          new_cells << ac = answer.answer_cells.create(:item => item, :row => row, :col => col, :answertype => 'Rating', :value => '')
          count += 1
          # puts "AC created: #{ac.inspect}, item: #{item}, row: #{row}, m_cell: #{m_cell.inspect}"
        end
      end
      row = col = find_row = cells_away = prev_item = exists = nil
    end if answer.survey_answer.done
    puts "COUNT #{count} ANswer #{answer.id} q_id #{answer.question_id} r,c,i: " + new_cells.map {|c| [c.row, c.col, c.item].join(', ')}.join('  ')
    answer = answer.question = nil
    count
  end

  def find_duplicates
    questions = [25, 20, 19, 18, 272]
    aas = Answer.all :conditions => ['question_id IN (?)', questions]
    dupes = aas.map {|a| a.answer_cells.ratings.map {|c| [c.row, c.col, a.id]} }.dups
    dupes.map do |dup|
      AnswerCell.find_by_row_and_col(dup[0], dup[1], :conditions => ['answer_id = ?', dup.last])
    end
  end
  
  def remove_doubles(answer)
    ratings = answer.answer_cells.ratings(true)
    duplicates = ratings.map {|c| [c.row, c.col]}.dups

    # find all cells for a duplicate 
    duplicates.map do |dup|
      dup_cells = ratings.find_all { |r| r.row == dup.first && r.col == dup.last }
      # delete cell with empty item
      good, bad = dup_cells.partition {|c| c.item }
      bad.shift # remove first
      bad.each {|c| c.destroy }
      # for the leftovers, the first is ok
      good.shift
      # good.map { |c| puts "GOOD dup: #{c.inspect}"; c.destroy } 
      puts "BAD! #{answer.id} bad cells: #{bad.inspect}"
      bad
    end
  end
  
  
end