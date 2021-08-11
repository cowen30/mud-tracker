module ParticipantsHelper

    def get_legionnaire_count(user)
        Participant.joins(:event_detail).where(user: user, event_details: { event_type_id: [1, 3, 7, 8, 11, 12] }).distinct.count
    end

    def get_total_distance(user)
        base_distance = Participant.where(user: user).includes(:event_detail).joins(:event_detail).where.not(event_details: { event_type_id: [7, 8, 12] }).sum(:lap_distance)
        base_distance += Participant.where(user: user).where('additional_laps >= 1').includes(:event_detail).joins(:event_detail).where.not(event_details: { event_type_id: [7, 8, 12] }).sum('event_details.lap_distance * participants.additional_laps')
        base_distance
    end

    def get_total_elevation(user)
        Participant.where(user: user).includes(:event_detail).joins(:event_detail).sum(:lap_elevation)
    end

end
