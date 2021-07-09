# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: :sign_up

  def show
    render json: { email: current_user[:email] }
  end

  # Do not start session
  def sign_up
    User.create!(user_params)
    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
