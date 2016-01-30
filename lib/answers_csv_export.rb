require 'csv'
# require 'facets/dictionary'

# create csv with columns of all variables from multiple surveys (different surveys)
# 1. establish which variables are needed. Group by survey_id. Get variables of these survey_ids
# 2. foreach  group of survey_answer by journal, get variable_values. Iterate over all possible variables (in surveys).
# 2.1  when variable is found in survey_answer's variable_values, add value, otherwise add nil (to ensure correct placement in table)
#
#
#

class AnswersCsvExport

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

  def wide_table(center_id, survey_ids = [])
    vars = Variable.find_all_by_survey_id(survey_ids).map { |v| v.var.to_sym}
    # puts "vars: #{vars.inspect}"
    vars.unshift :title
    # puts "vars: #{vars.inspect}"

    output = ""
    output = CSV.generate(:col_sep => ";", :row_sep => :auto, :encoding => 'utf-8') do |csv_output|
      csv_output << vars

      journals = Journal.where(:center_id => center_id)
      journals.find_each(:batch_size => 25) do |j|
        sas = j.answered_entries.sort_by {|e| e.survey_id}.map {|e| e.survey_answer } # TODO: must have same followup
        title = j.title
        vvs = sas.inject({}) {|h, sa| h.merge!(sa.variable_values); h }
        row = vars.map { |var| vvs[var] || nil }

        row.unshift title
        csv_output << row
      end
    end

    puts "output:\n#{output}"
    output
  end
  
  def score_rapports_to_csv(csv_score_rapports, survey_id)
    survey = Survey.find(survey_id)
    header = journal_csv_header.keys + survey.scores.map {|s| s.variable}
    
    csv_rows = csv_score_rapports.inject([]) do |rows,csa|
      rows << csa.survey_answer.info.values.map {|v| to_danish(v)} + csa.answer.split(';;')
      rows
    end

    output = CSV.generate(:col_sep => ";", :row_sep => :auto, :encoding => 'utf-8') do |csv_output|
      csv_output << header
      csv_rows.each { |line| csv_output << line }
    end
  end
    
  # merged pregenerated csv_answer string with header and journal information
  def to_csv(csv_survey_answers, survey_id)
    survey = Survey.find(survey_id)
    header = journal_csv_header.keys + survey.variables.map {|v| v.var}
    
    csv_rows = csv_survey_answers.inject([]) do |rows,csa|
      rows << csa.journal_info.split(';;') + csa.answer.split(';;')
      rows
    end

    output = CSV.generate(:col_sep => ";", :row_sep => :auto, :encoding => 'utf-8') do |csv_output|
      csv_output << header
      csv_rows.each { |line| csv_output << line }
    end
  end

  # header vars grouped by survey
  def survey_headers(survey_id)
    s = Survey.find(survey_id)
    s.variables.map {|var| var.var}
  end

  def journal_csv_header
    c = Dictionary.new
    c["ssghafd"] = nil
    c["ssghnavn"] = nil
    c["safdnavn"] = nil
    c["pid"] = nil
    c["projekt"] = nil
    c["pkoen"] = nil
    c["palder"] = nil
    c["pnation"] = nil
    c["besvarelsesdato"] = nil
    c["pfoedt"] = nil
    c
  end

  def journal_to_csv(journal)
    journal.info.values
  end
  
end