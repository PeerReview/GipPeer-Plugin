class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|

      t.string :title

      t.datetime :start_date

      t.datetime :end_date

      t.text :introduction

      t.text :outroduction
    end

  end
end
