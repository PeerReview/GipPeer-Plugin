class CreateAnswers < ActiveRecord::Migration

  def change
    create_table :answers do |t|

      t.text :answer

      t.text :default

      t.belongs_to :question

    end

    add_index :answers, :question_id

  end
end
