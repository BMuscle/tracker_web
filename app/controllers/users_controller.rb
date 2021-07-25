# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: :sign_up

  def show
    render json: { id: current_user.id, email: current_user.email }
  end

  # Do not start session
  def sign_up
    create_user_params = user_params
    if create_user_params[:password] == create_user_params[:password_confirmation]
      User.create!(create_user_params)
      head :no_content
    else
      head :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
