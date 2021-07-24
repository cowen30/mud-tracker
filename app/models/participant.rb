class Participant < ApplicationRecord
    belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
    belongs_to :event_detail, :class_name => 'EventDetail', :foreign_key => 'event_detail_id'
    belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'

    accepts_nested_attributes_for :event_detail, reject_if: :check_event_detail

    protected

    def check_event_detail(event_detail_attr)
        event_detail = EventDetail.find_or_create_by(event_id: event_detail_attr[:event], event_type_id: event_detail_attr[:event_type])
        self.event_detail = event_detail
    end

end
