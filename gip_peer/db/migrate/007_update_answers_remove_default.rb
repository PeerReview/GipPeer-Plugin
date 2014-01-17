class UpdateAnswersRemoveDefault < ActiveRecord::Migration
	def up
		remove_column :answers, :default
	end

	def down
		add_column :answers, :default, :text
	end
end