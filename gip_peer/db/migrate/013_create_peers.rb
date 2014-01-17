class CreatePeers < ActiveRecord::Migration
  def change
    create_table :peers do |t|
      t.belongs_to :survey
      t.integer	:survey_id
      t.integer :group_id
      t.integer :user_id
      t.boolean :completed, :default => false
    end
  end
end
