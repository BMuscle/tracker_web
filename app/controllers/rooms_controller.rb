# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :rooms, only: :index
  before_action :room, only: :show

  def create
    team = current_user.can_take_teams.find(params[:team_id])
    @room = Room.new(room_params.merge!(team: team))

    if @room.save
      render :show
    else
      head :unprocessable_entity
    end
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end

  def rooms
    @rooms = current_user.can_take_teams.includes(:rooms).find(params[:team_id]).rooms
  end

  def room
    @room = current_user.can_take_teams.includes(:rooms).find(params[:team_id]).rooms.find(params[:id])
  end
end
