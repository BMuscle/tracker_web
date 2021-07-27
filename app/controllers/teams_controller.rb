# frozen_string_literal: true

class TeamsController < ApplicationController
  def index
    @teams = Team.can_take_teams(current_user)
  end

  def show
    @team = Team.can_take_teams(current_user).find(params[:id])
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      render :show
    else
      head :unprocessable_entity
    end
  end

  private

  def team_params
    params.require(:team).permit(:name).merge!(user: current_user)
  end
end
