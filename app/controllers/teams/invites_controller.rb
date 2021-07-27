# frozen_string_literal: true

module Teams
  class InvitesController < ApplicationController
    def update
      @team = Team.can_take_teams(current_user).find(params[:id])
      @team.update_invite!
    end

    def confirm
      @team = Team.includes(:team_users).find_by!(invite_guid: team_invite_params[:guid])
      if @team.already_user(current_user)
        render json: { id: @team.id, already: true }
      elsif @team.invite_in_expired?
        render json: { expired: true }, status: :bad_request
      else
        TeamUser.create!(user: current_user, team: @team)
        render json: { id: @team.id, already: false }
      end
    end

    private

    def team_invite_params
      params.required(:team).permit(:guid)
    end
  end
end
