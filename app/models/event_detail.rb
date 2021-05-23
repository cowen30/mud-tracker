class EventDetail < ApplicationRecord
    belongs_to :event, :class_name => 'Event', :foreign_key => 'event_id'
    belongs_to :event_type, :class_name => 'EventType', :foreign_key => 'event_type_id'
end
