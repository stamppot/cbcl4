# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Cbcl4::Application.load_tasks

namespace :thinking_sphinx do
	task :configure do   	# alias for ts:configure
	  	Rake::Task["ts:configure"].invoke
	end
end