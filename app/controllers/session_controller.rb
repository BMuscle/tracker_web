# frozen_string_literal: true

class SessionController < ApplicationController
  def log_in
    user = User.find_for_database_authentication(email: user_params[:email])

    return head :not_found if user.nil?

    if user.valid_password?(user_params[:password])
      sign_in :user, user
      render :no_content
    else
      head :not_found
    end
  end

  def log_out
    log_out current_user
    render :no_content
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
