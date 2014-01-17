class UpdateQuestionsMatrix < ActiveRecord::Migration
  def change
    add_column :questions, :matrix, :boolean, default: false
  end
end