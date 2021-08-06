module ParticipantsHelper

    def get_legionnaire_count(user)
        Participant.joins(:event_detail).where(user: user, event_details: { event_type_id: [1, 3, 7, 8, 11, 12] }).distinct.count
    end

    def get_total_distance(user)
        Participant.where(user: user).includes(:event_detail).joins(:event_detail).sum(:lap_distance)
    end

    def get_total_elevation(user)
        Participant.where(user: user).includes(:event_detail).joins(:event_detail).sum(:lap_elevation)
    end

end
