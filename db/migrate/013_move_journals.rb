class MoveJournalsToOwnTable
  def self.up
    run_sql = true
    commands = []
    Journal.all.map do |j|
    	sql = %{REPLACE INTO journals (id, created_at, updated_at, title, code, team_id, center_id, delta) 
    		VALUES (#{j.id}, '#{j.created_at.to_s(:db)}', '#{j.updated_at.to_s(:db)}', "#{j.title}", '#{j.code}', #{j.parent_id}, #{j.center_id}, 0)
    	}
    	puts sql
    	ActiveRecord::Base.connection.execute(sql) if run_sql
    	commands << sql
    end

   	ActiveRecord::Base.connection.execute("update journals set team_id = NULL where team_id = center_id") if run_sql

    Journal.delete_all if run_sql
    puts commands.join("; ")
  end
end