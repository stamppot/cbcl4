require 'csv'
require 'hashery'

class ExportAnswersHelper

  def to_danish(str)
    if str.respond_to? :gsub
      str.gsub("Ã¸", "ø").gsub("Ã¦", "æ").gsub("Ã…", "Å")
    else
      str
    end
  end

  def score_rapports_to_csv(csv_score_rapports, survey_id)
    survey = Survey.find(survey_id)
    header = journal_csv_header.keys + survey.scores.map {|s| s.variable}
    
    csv_rows = csv_score_rapports
      .select {|csr| !csr.survey_answer.nil? }
      .inject([]) do |rows,csr|
      if csr.survey_answer.nil?
        puts "csr.survey_answer.nil? #{csr.inspect}" 
      end
      journal_entry = JournalEntry.where(
        survey_answer_id: csr.survey_answer_id,
        center_id: csr.center_id, 
        group_id: csr.team_id).first
      info = 
      if !journal_entry.nil?
        journal_entry.answer_info.split(";")
      elsif csr.survey_answer
        csr.survey_answer.info.values
      else
        puts "no answer_info found in journal_entry or survey_answer: #{csr.inspect}  je: #{csr.journal_entry.inspect}"
        "Ingen info #{journal_entry.inspect}"
      end

      rows << info + csr.answer.split(';;')
      rows
    end

    output = CSV.generate(:col_sep => ";", :row_sep => :auto, :encoding => 'utf-8') do |csv_output|
      csv_output << header
      csv_rows.each { |line| csv_output << line }
    end
  end
  
  # merged pregenerated csv_answer string with header and journal information
  def export_survey_answers(csv_survey_answers, survey_id)
    survey = Survey.find(survey_id)
    header = journal_csv_header.keys + survey.variables.map {|v| v.var}
    
    csv_rows = csv_survey_answers.inject([]) do |rows,csa|
      puts "csa.journal.nil? #{csa.inspect} #{csa.journal.inspect}  sa: #{csa.survey_answer.inspect}" if csa.journal.nil?

      journal_entry = JournalEntry.where(
        survey_answer_id: csa.survey_answer_id,
        center_id: csa.center_id, 
        group_id: csa.team_id).first
      info = 
      if !journal_entry.nil? && journal_entry.answer_info
        journal_entry.answer_info.split(";")
      elsif csa.journal_info
        csa.journal_info.split(";;")
      elsif csa.survey_answer
        csa.survey_answer.info.values
      else
        puts "no answer_info found in journal_entry or survey_answer: #{csa.inspect}  je: #{csa.journal_entry.inspect}"
        ["ingen info: sa_id: #{csa.survey_answer_id} csa: #{csa.inspect} "]
      end

      if !csa || !csa.answer
        puts "No csa: #{info.inspect}"
      end
      rows << info + (csa && csa.answer && csa.answer.split(';;') || [] )
      rows
    end

    output = CSV.generate(:col_sep => ";", :row_sep => :auto, :encoding => 'utf-8') do |csv_output|
      csv_output << header
      csv_rows.each { |line| csv_output << line }
    end
  end

  # header vars grouped by survey
  # def survey_headers(survey_id)
  #   s = Survey.find(survey_id)
  #   s.variables.map {|var| var.var}
  # end

  def journal_csv_header
    keys = %w{ssghafd ssghnavn safdnavn pid projekt pkoen palder pnation besvarelsesdato pfoedt}
    keys.inject(Dictionary.new) {|h, key| h[key] = nil; h }
  end
  
end