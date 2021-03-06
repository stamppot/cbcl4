# encoding: utf-8
require 'csv'
# require 'FasterCSV'

class ExportCsvHelper

  def to_danish(str)
    if str.respond_to? :gsub
      str.gsub("Ã¸", "ø").gsub("Ã¦", "æ").gsub("Ã…", "Å")
    else
      str
    end
  end
  
  def to_csv(rows, separator = ";")
    return "" unless rows.any?
    return rows.first.join(";") if rows.second.nil?
    csv = CSV.generate(:col_sep => separator, :row_sep => :auto, :encoding => 'utf-8') do |csv|
      first_row = rows.first
      is_array = first_row.is_a?(Array)
      puts "to_csv first_row: #{first_row.class}  is_array: #{is_array}"
      headers = is_array && first_row || first_row.keys
      add_headers = is_array && !(rows.first & rows.second).empty? || first_row != rows.second
      if add_headers
        csv << headers
      end
      rows.each { |row| csv << (is_array && row || row.values) }
    end
    csv
  end

  def get_mail_merge_login_users_rows(journal_entries)
    return [["email", "navn", "fornavn", "login", "password", "alt_id", "mor_navn"]] if !journal_entries.any?
    puts "jaurnal_entries: #{journal_entries}"
    results = journal_entries.inject([]) do |results, entry|
      if entry.login_user && entry.not_answered?
        row = {
          :email => entry.journal.parent_email,
          :navn => to_danish(entry.journal.title),
          :fornavn => to_danish(entry.journal.firstname),
          :login => entry.login_user.login, 
          :password => entry.password,
          :alt_id => entry.journal.alt_id,
          :mor_navn => to_danish(entry.journal.parent_name)
        }
        results << row
      end
      results
    end
    puts "results: #{results.class} \n #{results.inspect}"
    header = results.first.keys.map &:to_s
    results = results.map &:values
    results.unshift(header)
  end

  # used for reminders
  def get_entries_status(journal_entries)
    surveys = get_distinct_surveys(journal_entries).values # Survey.all.to_hash(&:id).invert
    journal_groups = journal_entries.group_by {|je| je.journal}

    results = []
    journal_groups.each do |j, journal_entries|
      row = Dictionary.new
      row[:kode] = j.code
      row[:navn] = j.title
      row[:køn] = j.sex_text
      row[:fornavn] = to_danish(j.firstname)
      row[:email] = j.parent_email
      row[:alt_id] = j.alt_id
      row[:mor_navn] = to_danish(j.parent_name)

      entries = journal_entries.group_by(&:survey_id)
      surveys.each do |survey|
        entry = entries[survey.id] && entries[survey.id].first
        survey_prefix = survey.short_name
        row["#{survey_prefix}_status".to_sym] = entry && entry.status || ""
        row["#{survey_prefix}_login".to_sym] = entry && entry.login_user && entry.login_user.login || ""
        row["#{survey_prefix}_password".to_sym] = entry && entry.password || ""
        row["#{survey_prefix}_oprettet".to_sym] = entry && entry.created_at.strftime("%Y-%m-%d") || ""
        row["#{survey_prefix}_rykker_status".to_sym] = entry && entry.reminder_state || ""
      end
      results << row
    end
    results
  end    


  def get_distinct_surveys(journal_entries)
    surveys = {}
    num_surveys = journal_entries.map(&:survey_id).uniq.size
    journal_entries.each do |entry|
      surveys[entry.survey_id] ||= entry.survey
      break if(surveys.size == num_surveys) 
    end
    surveys
  end
end