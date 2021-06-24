class ParticipantsController < ApplicationController

    def create
        @participant = Participant.new(participant_params)
        @participant.updated_by = current_user
        if @participant.save
            puts @participant.inspect
            render json: @participant.as_json(include: [ { event_detail: { include: [:event, :event_type] } }, :user ])
        else
            render :'common/error'
        end
    end

    def destroy
        @participant = Participant.find(params[:id])
        unless @participant.destroy
            render :'common/error'
        end
    end

    private
        def participant_params
            params.require(:participant).permit(:user_id, { event_detail_attributes: [ :event_id, :event_type_id ] }, :participation_day, :contender_status_id)
        end

end
