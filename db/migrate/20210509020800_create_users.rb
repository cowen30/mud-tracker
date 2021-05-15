class CreateUsers < ActiveRecord::Migration[6.1]
  
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :password_digest
      t.boolean :active, default: true, null: false

      t.integer :updated_by
      t.timestamps
    end

    add_foreign_key :users, :users, column: :updated_by
  end

end
