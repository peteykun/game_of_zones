class RemoveUserIdFromRegions < ActiveRecord::Migration
  def change
    remove_column :regions, :user_id, :integer
  end
end
