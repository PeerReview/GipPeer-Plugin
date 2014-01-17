class AddArchiveToSurveys < ActiveRecord::Migration
	def change
		add_column :surveys, :archive, :boolean, default: false
	end
end