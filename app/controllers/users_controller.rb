# frozen_string_literal: true

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
		begin
			@user = User.new(user_params)
		rescue ActionController::ParameterMissing => e
			respond_to do |format|
				format.html { render :'common/error' }
				format.json { render json: { message: 'Missing required parameters', error: e }, status: :bad_request }
			end && return
		end

		unless validate_password(params[:password])
			respond_to do |format|
				format.html { render :'common/error' }
				format.json { render json: { message: 'Password does not meet security requirements' }, status: :bad_request }
			end && return
		end

		if @user.save
			helpers.send_welcome_email @user
			session[:user_id] = @user.id
			redirect_to '/welcome'
		else
			render :'common/error'
		end
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
		@participants = Participant.includes(event_detail: %i[event event_type]).where(user_id: params[:id]).order(Arel.sql('events.date DESC'), Arel.sql('participants.participation_day DESC'), Arel.sql('event_types.display_order ASC'))
		@tm_legionnaire = helpers.get_legionnaire_count(@user)
		@distance = helpers.get_total_distance(@user)
		@elevation = helpers.get_total_elevation(@user)
		@new_participant = Participant.new
		@new_participant.event_detail = EventDetail.new
		@events = Event.where(archived: false).order(date: :desc)
		@event_types = EventType.includes(:brand).order(Arel.sql('brands.id ASC'), display_order: :asc)
		@active_tab = params['tab'].nil? ? 'details' : params['tab']
	end

	def resend_verification
		@user = current_user
		render json: { message: 'User is already verified' }, status: :no_content && return if @user.active

		begin
			helpers.send_welcome_email @user
			render json: { message: 'Email sent', error: e }, status: :ok
		rescue e
			render json: { message: 'Unexpected error', error: e }, status: :internal_server_error
		end
	end

	private

	def user_params
		params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation).tap do |user_params|
			user_params.require(%i[first_name last_name email password password_confirmation])
		end
	end

	def validate_password(password)
		password.length.between?(8, 100) && /[A-Z]/.match(password) && /[!@#$%^&*]/.match(password)
	end

end
