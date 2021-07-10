# frozen_string_literal: true

class SessionController < ApplicationController
  skip_before_action :authenticate_user

  def log_in
    user = User.find_for_database_authentication(email: user_params[:email])

    return head :not_found if user.nil?

    if user.valid_password?(user_params[:password])
      sign_in :user, user
      head :no_content
    else
      head :not_found
    end
  end

  def log_out
    if sign_out current_user
      head :no_content
    else
      head :not_found
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
