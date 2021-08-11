class AddAdditionalLapsToParticipants < ActiveRecord::Migration[6.1]

    def change
        add_column :participants, :additional_laps, :integer
    end

end
