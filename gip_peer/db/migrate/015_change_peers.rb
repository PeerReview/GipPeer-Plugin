class ChangePeers < ActiveRecord::Migration
   def up
    remove_column :peers, :group_id
    add_column :peers, :project_id, :integer
  end

  def down
    add_column :peers, :group_id, :integer
    remove_column :peers, :project_id
  end
end
