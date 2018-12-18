namespace :thinking_sphinx do
  desc "Alias for ts:configure"
  task configure: :environment do
	# alias for ts:configure
	Rake::Task["ts:configure"].invoke
	end

  task index: :environment do
	Rake::Task["ts:index"].invoke
   end

  task start: :environment do
	Rake::Task["ts:start"].invoke
   end

   task stop: :environment do
	Rake::Task["ts:stop"].invoke
   end

   task restart: :environment do
	Rake::Task["ts:restart"].invoke
   end

   task rebuild: :environment do
	Rake::Task["ts:rebuild"].invoke
   end

   task generate: :environment do
	Rake::Task["ts:generate"].invoke
   end

   task status: :environment do
	Rake::Task["ts:status"].invoke
   end

   task clear: :environment do
	Rake::Task["ts:clear"].invoke
   end

   task clear_rt: :environment do
	Rake::Task["ts:clear_rt"].invoke
   end
end