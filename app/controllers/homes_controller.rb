# frozen_string_literal: true

class HomesController < ApplicationController
  skip_before_action :authenticate_user

  def index
    render json: { title: 'My name is rails' }
  end
end
