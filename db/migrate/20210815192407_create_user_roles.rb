class CreateUserRoles < ActiveRecord::Migration[6.1]

    def change
        create_table :user_roles do |t|
            t.integer :user_id
            t.integer :role_id
            t.timestamps
        end

        add_foreign_key :user_roles, :users
        add_foreign_key :user_roles, :roles
    end

end
