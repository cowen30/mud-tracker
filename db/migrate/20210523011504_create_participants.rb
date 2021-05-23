class CreateParticipants < ActiveRecord::Migration[6.1]
  def change
    create_table :participants do |t|
      t.integer :user_id
      t.integer :event_detail_id
      t.string :participation_day
      t.integer :contender_status_id

      t.integer :updated_by
      t.timestamps
    end

    add_foreign_key :participants, :users, column: :user_id
    add_foreign_key :participants, :event_details, column: :event_detail_id
    add_foreign_key :participants, :users, column: :updated_by
  end
end
