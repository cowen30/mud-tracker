class CreateEvents < ActiveRecord::Migration[6.1]

  def change
    create_table :events do |t|
      t.string :name
      t.integer :brand_id
      t.string :city
      t.string :state
      t.string :country
      t.date :date
      t.string :url
      t.string :latitude
      t.string :longitude
      t.boolean :archived, default: false, null: false

      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end

    add_foreign_key :events, :brands
    add_foreign_key :events, :users, column: :created_by
    add_foreign_key :events, :users, column: :updated_by
  end
  
end
