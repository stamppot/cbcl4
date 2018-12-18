namespace :thinking_sphinx do
  desc "Alias for ts:configure"
  task configure: :environment do
	# alias for ts:configure
	Rake::Task["ts:configure"].invoke
	end
end