class ParticipantsController < ApplicationController

    def create
        @participant = Participant.new(participant_params)
        @participant.updated_by = current_user
        if @participant.save
            puts @participant.inspect
            render json: @participant.as_json(include: [ { event_detail: { include: [:event, :event_type] } }, :user ])
        else
            puts @participant.errors.full_messages
            render :'common/error'
        end
    end

    def update
        @participant = Participant.find(params[:id])
        @participant.updated_by = current_user
        if @participant.update(participant_params.merge(updated_by: current_user))
            render json: @participant.as_json(include: [{ event_detail: { include: %i[event event_type] } }, :user])
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
        params.require(:participant).permit(:id, :user_id, { event_detail_attributes: %i[event event_type] }, :participation_day, :contender_status_id)
    end

end
