class Event < ApplicationRecord
    # Helpful for understanding how to relate foreign keys: https://stackoverflow.com/questions/13867587/getting-a-value-from-a-table-through-a-foreign-key-in-rails
    belongs_to :brand, :class_name => 'Brand', :foreign_key => 'brand_id'

    belongs_to :created_by, :class_name => 'User', :foreign_key => 'created_by'
    belongs_to :approved_by, :class_name => 'User', :foreign_key => 'approved_by', optional: true
    belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'
end
