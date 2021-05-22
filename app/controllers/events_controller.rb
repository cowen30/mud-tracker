class EventsController < ApplicationController

  skip_before_action :authorized, only: [:index, :show]

  def index
    @events = Event.where(archived: false).order(date: :desc)
  end

  def create
    @event = Event.new(event_params)
    @event.updated_by = current_user.id
    if @event.save
      redirect_to @event
    else
      render :index
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.updated_by = current_user.id
    if @event.update(event_params)
      redirect_to @event
    else
      redirect_to @event
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.archived = true
    @event.updated_by = current_user.id
    if @event.save
      redirect_to events_path
    else
      redirect_to @event
    end
  end

  private
    def event_params
      params.require(:event).permit(:name, :brand_id, :city, :state, :country, :date, :url, :archived)
    end

end
