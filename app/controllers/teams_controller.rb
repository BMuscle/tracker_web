# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :participating_teams, only: :index
  before_action :management_teams, only: :index

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

  def participating_teams
    @participating_teams = current_user.participating_teams
  end

  def management_teams
    @management_teams = current_user.management_teams
  end
end
