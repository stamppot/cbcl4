require 'csv'
# require 'facets/dictionary'

# create csv with columns of all variables from multiple surveys (different surveys)
# 1. establish which variables are needed. Group by survey_id. Get variables of these survey_ids
# 2. foreach  group of survey_answer by journal, get variable_values. Iterate over all possible variables (in surveys).
# 2.1  when variable is found in survey_answer's variable_values, add value, otherwise add nil (to ensure correct placement in table)
#
#
#

class WideAnswersExport

  def get_columns(center_id)
    query = "select j.title as title, j.`code` as code, j.sex, j.birthdate, sa.survey_id, concat('s', sa.survey_id, '_', 'item', ac.item) as item,  ac.value, ac.value_text from survey_answers sa
      inner join journals j on j.id = sa.journal_id
      inner join answers a on sa.id = a.survey_answer_id
      inner join answer_cells ac on ac.answer_id = a.id
      where sa.center_id = #{center_id}
      group by item"
    items = ActiveRecord::Base.connection.execute(query).each(:as => :hash).inject({}) do |col,j| 
      col[j['item']] = j['item'];
      col
    end
  end

  # a table with variables and values for the given surveys in one row
  # def wide_table(center_id, survey_ids = [])
  #   vars = Variable.find_all_by_survey_id(survey_ids).map { |v| v.var.to_sym}
  #   # puts "vars: #{vars.inspect}"
  #   vars.unshift :title
  #   # puts "vars: #{vars.inspect}"

  #   output = ""
  #   output = CSV.generate(:col_sep => ";", :row_sep => :auto, :encoding => 'utf-8') do |csv_output|
  #     csv_output << vars

  #     journals = Journal.where(:center_id => center_id)
  #     journals.find_each(:batch_size => 25) do |j|
  #       sas = j.answered_entries.sort_by {|e| e.survey_id}.map {|e| e.survey_answer } # TODO: must have same followup
  #       title = j.title
  #       vvs = sas.inject({}) {|h, sa| h.merge!(sa.variable_values); h }
  #       row = vars.map { |var| vvs[var] || nil }

  #       row.unshift title
  #       csv_output << row
  #     end
  #   end

  #   puts "output:\n#{output}"
  #   output
  # end
  
  # a table with variables and values for the given surveys in one row
  def wide_table(survey_answers, survey_ids = [])
    vars = Variable.find_all_by_survey_id(survey_ids).map { |v| v.var.to_sym}
    # puts "vars: #{vars.inspect}"
    vars.unshift :title
    # TODO: must have same followup
    by_journal = survey_answers.group_by {|sa| sa.journal_id}
    # puts "wide_table: sas: #{survey_answers.count}"

    journal_titles = {}
    by_journal.keys.in_groups_of(200).each do |batch| 
      Journal.where("id IN (?)", batch.compact).select('id, title').each {|j| journal_titles[j.id] ||= j.title }
    end
    
    output = ""
    output = CSV.generate(:col_sep => ";", :row_sep => :auto, :encoding => 'utf-8') do |csv_output|
      csv_output << vars

      by_journal.each do |journal_id, sas|
        title = journal_titles[journal_id]
        vvs = sas.inject({}) {|h, sa| h.merge!(sa.variable_values_with_texts); h }
        row = vars.map { |var| vvs[var] || nil }.compact

        puts "title: #{title.inspect}   row: #{row.inspect}  size: #{row.size}"
        row.unshift title
        puts "row: #{row.inspect} size: #{row.size}"
        csv_output << row
      end
    end

    # puts "output:\n#{output}"
    output
  end

  def csv_export_single_answer(survey_answer)
    wide_table([survey_answer], [survey_answer.survey_id])
  end
  
end