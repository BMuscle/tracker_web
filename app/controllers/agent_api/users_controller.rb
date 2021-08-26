# frozen_string_literal: true

module AgentApi
  class UsersController < AgentController
    skip_before_action :authenticate_agent

    def log_in
      user = User.find_for_database_authentication(email: user_params[:email])

      return head :not_found if user.nil?

      if user.valid_password?(user_params[:password])
        user.agent&.destroy!

        agent = Agent.create!(user: user)
        render json: { agent: { guid: agent.guid, token: agent.token } }
      else
        head :not_found
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end
  end
end
