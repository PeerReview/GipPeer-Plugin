class UpdateAnswersUser < ActiveRecord::Migration
	def change
		add_column :answers, :peer_id, :integer
	end
end
