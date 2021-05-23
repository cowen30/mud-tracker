class Participant < ApplicationRecord
    belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
    belongs_to :event_detail, :class_name => 'EventDetail', :foreign_key => 'event_detail_id'
    belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'
end
