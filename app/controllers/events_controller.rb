class EventsController < ApplicationController

    skip_before_action :authorized, only: %i[index show]

    def index
        @events = Event.where(archived: false).order(date: :desc)
        @event_years = @events.select(:date).map { |event| event.date.year }.uniq
        @event_brands = @events.includes(:brand).map(&:brand).uniq.sort!
    end

  def create
    @event = Event.new(event_params)
    @event.created_by = current_user
    @event.updated_by = current_user
    if @event.save
      redirect_to @event
    else
      render :'common/error'
    end
  end

  def show
    @event = Event.find(params[:id])
    @can_edit_event = helpers.can_edit_event(@event)
    @event_details = EventDetail.where(event_id: params[:id])
    @participants = Participant.includes(:event_detail).where(event_detail: { event_id: params[:id] })
    if logged_in?
      @user_list = User.where(id: current_user.id)
      @event_types = EventType.where(brand_id: @event.brand_id).order(display_order: :asc)
    end
    @new_participant = Participant.new
    @new_participant.event_detail = EventDetail.new
  end

    def show
        @event = Event.find(params[:id])
        @can_edit_event = helpers.can_edit_event(@event)
        @event_details = EventDetail.where(event_id: params[:id])
        @participants = Participant.includes(:event_detail).where(event_detail: { event_id: params[:id] })
        if logged_in?
            @user_list = User.where(id: current_user.id)
            @event_types = EventType.where(brand_id: @event.brand_id).order(display_order: :asc)
        end
        @new_participant = Participant.new
        @new_participant.event_detail = EventDetail.new
        @active_tab = 'details'
        @active_tab = params['tab'] unless params['tab'].nil?
    end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params.merge(updated_by: current_user))
      redirect_to @event
    else
      render :'common/error'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.archived = true
    @event.updated_by = current_user
    if @event.save
      redirect_to events_path
    else
      render :'common/error'
    end
  end

  private
    def event_params
      params.require(:event).permit(:name, :brand_id, :address, :city, :state, :country, :date)
    end

end
