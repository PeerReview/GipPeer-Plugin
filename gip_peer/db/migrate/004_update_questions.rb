class UpdateQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :question_type, :text
  end
end