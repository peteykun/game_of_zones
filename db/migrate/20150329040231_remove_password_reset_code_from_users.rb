class RemovePasswordResetCodeFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :password_reset_code, :integer
  end
end
