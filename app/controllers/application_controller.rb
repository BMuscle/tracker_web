# frozen_string_literal: true

class ApplicationController < ActionController::API
  # XMLHttpRequest
  before_action :check_xhr_header
  before_action :authenticate_user

  rescue_from ActiveRecord::RecordInvalid, with: :error422

  private

  def check_xhr_header
    return if request.xhr?

    render json: { error: 'forbidden' }, status: :forbidden
  end

  # I don't want to redirect because it's an API. So don't use devise authenticate_user
  def authenticate_user
    return head :not_found unless user_signed_in?
  end

  def error422(error)
    render json: error.record.errors.details, status: :bad_request
  end
end
