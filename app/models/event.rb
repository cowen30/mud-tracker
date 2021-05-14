class Event < ApplicationRecord
    # Helpful for understanding how to relate foreign keys: https://stackoverflow.com/questions/13867587/getting-a-value-from-a-table-through-a-foreign-key-in-rails
    belongs_to :user, :foreign_key => :updated_by
end
