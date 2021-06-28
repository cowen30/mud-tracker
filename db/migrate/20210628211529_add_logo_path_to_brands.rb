class AddLogoPathToBrands < ActiveRecord::Migration[6.1]

    def change
        add_column :brands, :logo_path, :string
    end

end
