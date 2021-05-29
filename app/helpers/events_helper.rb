module EventsHelper

    def can_edit_event(event)
        logged_in? && !event.archived
    end

end
