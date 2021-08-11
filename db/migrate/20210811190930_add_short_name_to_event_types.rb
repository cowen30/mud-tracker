class AddShortNameToEventTypes < ActiveRecord::Migration[6.1]

    def change
        add_column :event_types, :short_name, :string
    end

end
