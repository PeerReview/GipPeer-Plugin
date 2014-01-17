class UpdateAnswersProject < ActiveRecord::Migration
	def change
		add_column :answers, :project_id, :integer
	end
end
