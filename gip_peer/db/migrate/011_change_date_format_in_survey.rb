class ChangeDateFormatInSurvey < ActiveRecord::Migration
	def self.up
		change_column :surveys, :start_date, :date 
		change_column :surveys, :end_date, :date
	end

	def self.down
		change_column :surveys, :start_date, :datetime
		change_column :surveys, :start_date, :datetime
	end
end
