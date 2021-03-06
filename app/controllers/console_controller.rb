class ConsoleController < ApplicationController

	layout "console"

	def index
		# @name = @current_user_cached.login
	end 

	def commands 
		["COMMANDS", "HELP", "HELLO", "PING", "ENABLE_SETTING", "JOURNAL", "LOGINS", "TASKS", "JOURNAL_ID"]
	end

	def command

		cmd = params[:cmd]
		puts "CONSOLE PARAMS : #{params.inspect}"

		args = (params[:args] || "").split(" ")
			
		is_error = false

		response = { :output => "", :isError => false, :isHtml => false }


		output =
		case cmd
		when "COMMANDS"
			{:output => commands.inspect}
		when "HELP"
			{:output => help((args.shift || "" ).upcase)}
		when "ECHO"
			{:output => args.join(" ")}
		when "HELLO"
			{:output => "WORLD"}
		when "PING"
			{:output => "PONG"}
		when "ENABLE_SETTING"
			args = params[:args].split(" ")
			center = args.shift
			setting = args.shift
			value = args.shift
			enable_setting(center, setting, value)
		when "JOURNAL"
			journal_id = args.shift
			journal = Journal.find journal_id
			{:output => journal.inspect }
		when "LOGINS"
			journal_id = args.shift
			logins = show_logins(journal_id)
			{:output => logins.inspect}
		when "TASKS"
			journal_id = args.shift
			tasks = show_tasks(journal_id)
			{:output => tasks.to_a.inspect}
		when "JOURNAL_ID"
			alt_id = args.shift
			journal = Journal.find_all_by_alt_id(alt_id)
			{:output => journal.to_a.inspect}
		else
			output = {:isError => true, :output => "SYNTAX ERROR"}
		end

		response.merge!(output)
		render :json => response
	end

	def help(cmd)
		msg =
		case cmd
		when "COMMANDS"
			"Show all commands"
		when "HELP"
			"Show this"
		when "HELLO"
			"Say hello"
		when "PING"
			"Play a game of ping pong"
		when "ENABLE_SETTING"
			"Change a CenterSetting. args: center_id, setting, value"
		when "JOURNAL"
			"Show a journal. Args: journal_id"
		when "LOGINS"
			"Show all logins for a journal. Args: journal_id"
		when "TASKS"
			"Show all tasks for a journal. Args: journal_id"
		when "JOURNAL_ID"
			"Show journal_id for a journal with a given alt_id. Args: alt_id"
		else
			"No help needed?  See #{commands}"
		end
	end

	def show_tasks(journal_id)
		Task.where(:journal_id => journal_id)
	end

	def show_logins(journal_id)
		journal = Journal.find journal_id
		journal.journal_entries.map {|e| [e.survey.short_name(e.follow_up), e.login_user.login, e.password]}
	end

	def enable_setting(center, name, value, response = {})
		is_error = false
		output = ""

		if center.nil? || name.nil? || value.nil?
			is_error = true
			output = "Invalid args: center: #{center.inspect} setting: #{setting.inspect} value: #{value.inspect}"
		end

		if setting = CenterSetting.find_by_center_id_and_name(center.to_i, name)
			setting.value = value

			if !setting.valid?
				is_error = true
				output = settings.errors.join(" ")
			end

			if setting.save
				output = "Changed #{name.inspect} to #{value} for Center #{center}"
			end
		else
			is_error = true
			output = "Couldn't find setting #{name.inspect}"
		end


		response[:isError] = is_error
		response[:output] = output
		response
	end

end