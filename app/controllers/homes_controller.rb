# frozen_string_literal: true

class HomesController < ApplicationController
  def index
    render json: { title: 'My name is rails' }
  end
end
