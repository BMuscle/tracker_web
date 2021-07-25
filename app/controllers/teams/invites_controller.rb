# frozen_string_literal: true

module Teams
  class InvitesController < ApplicationController
    def update
      @team = Team.can_take_teams(current_user).find(params[:id])
      @team.update_invite!
    end
  end
end
