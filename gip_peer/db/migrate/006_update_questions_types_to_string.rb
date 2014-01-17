class UpdateQuestionsTypesToString < ActiveRecord::Migration
  def change
       change_column :questions, :question_type, :string
  end
end