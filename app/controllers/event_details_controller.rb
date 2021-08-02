class EventDetailsController < ApplicationController

    def create
        @event_detail = EventDetail.new(event_detail_params)
        @event_detail.created_by = current_user
        @event_detail.updated_by = current_user
        if @event_detail.save
            render json: @event_detail.as_json
        else
            render :'common/error'
        end
    end

    def update
        @event_detail = EventDetail.find(params[:id])
        @event_detail.updated_by = current_user
        if @event_detail.update(event_detail_params.merge(updated_by: current_user))
            render json: @event_detail.as_json(include: { updated_by: { only: %i[id first_name last_name] } })
        else
            render json: {
                status: :internal_server_error,
                message: 'Error'
            }.to_json
        end
    end

    def destroy
        @event_detail = EventDetail.find(params[:id])
        if @event_detail.destroy
            redirect_to '/'
        else
            render :'common/error'
        end
    end

    private

    def event_detail_params
        params.require(:event_detail).permit(:event_id, :event_type_id, :lap_distance, :lap_elevation)
    end

end
