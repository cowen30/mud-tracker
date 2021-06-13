class AddResetCodeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :reset_code, :string
  end
end
