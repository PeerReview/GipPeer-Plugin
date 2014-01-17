class CreateQoptions < ActiveRecord::Migration
  def change
    create_table :qoptions do |t|

    	t.string :option

    	t.belongs_to :question
    	
    end
 	
 	add_index :qoptions, :question_id
  
  end
end
