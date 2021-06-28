class UsersController < ApplicationController

    skip_before_action :authorized, only: %i[new create reset_load reset_confirm reset_save]

    def index
        @users = User.where(active: true).order(last_name: :asc)
    end

    def welcome
        @user = current_user
        if @user.active || @user.verification_code.nil?
            redirect_to @user
        end
    end

    def create
        @user = User.new(user_params)
        @user.save
        helpers.send_welcome_email @user
        session[:user_id] = @user.id
        redirect_to '/welcome'
    end

    def verify
        @user = User.find(params[:user_id])
        verification_code = params[:verification_code]
        if verification_code == @user.verification_code
            @user.verification_code = nil
            @user.active = true
            @user.updated_by = @user.id
            @user.save
            redirect_to @user
        end
    end

    def reset_load
        @user = User.find_by(id: params[:user_id])
        if !@user.nil? && @user.reset_code == params[:reset_code]
            render :reset_password_form
        else
            render :reset_password
        end
    end

    def reset_confirm
        @user = User.find_by(email: params[:email])
        unless @user.nil?
            helpers.send_password_reset_email @user
        end
        render :reset_password_confirm
    end

    def reset_save
        @user = User.find_by(email: params[:email])
        if !@user.nil? && @user.reset_code == params[:reset_code]
            @user.password = params[:password]
            @user.reset_code = nil
            @user.save
            render :reset_password_save
        else
            render :'common/error'
        end
    end

    def show
        @user = User.find(params[:id])
        if !@user.active
            redirect_to '/'
        else
            @participants = Participant.includes(event_detail: [ :event, :event_type ]).where(user_id: params[:id]).order(Arel.sql('events.date DESC'), Arel.sql('participants.participation_day DESC'), Arel.sql('event_types.display_order ASC'))
            @new_participant = Participant.new
            @new_participant.event_detail = EventDetail.new
            @events = Event.where(archived: false).order(date: :desc)
            @event_types = EventType.includes(:brand).order(Arel.sql('brands.id ASC'), display_order: :asc)
            @active_tab = 'details'
            if !params['tab'].nil?
                @active_tab = params['tab']
            end
        end
    end

    private
        def user_params
            params.require(:user).permit(:first_name, :last_name, :email, :username, :password, :password_confirmation)
        end

end
