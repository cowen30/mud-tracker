class UpdateEventDetailConstraint < ActiveRecord::Migration[6.1]

    def change
        remove_foreign_key :participants, :event_details
        add_foreign_key :participants, :event_details, column: :event_detail_id, on_delete: :cascade
    end

end
