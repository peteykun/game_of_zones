class AddPasswordResetCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_reset_code, :integer
  end
end
