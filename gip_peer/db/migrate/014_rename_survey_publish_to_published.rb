class RenameSurveyPublishToPublished < ActiveRecord::Migration
	def change
		rename_column :surveys, :publish, :published
	end
end