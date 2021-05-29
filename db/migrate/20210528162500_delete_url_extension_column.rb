class DeleteUrlExtensionColumn < ActiveRecord::Migration[6.1]

    def change
        remove_column :events, :url
    end

end
