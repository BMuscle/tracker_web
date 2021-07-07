# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :account_login

  def show
    render json: { email: current_user[:email] }
  end

  private

  # I don't want to redirect because it's an API. So don't use authenticate_account
  def user_login
    return render json: {} unless user_signed_in?
  end
end
