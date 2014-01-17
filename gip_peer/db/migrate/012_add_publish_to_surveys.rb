class AddPublishToSurveys < ActiveRecord::Migration
	def change
		add_column :surveys, :publish, :boolean, default: false
	end
end