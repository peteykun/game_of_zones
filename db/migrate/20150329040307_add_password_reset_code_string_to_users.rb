class AddPasswordResetCodeStringToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_reset_code, :string
  end
end
