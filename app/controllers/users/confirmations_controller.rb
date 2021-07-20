# frozen_string_literal: true

module Users
  class ConfirmationsController < Devise::ConfirmationsController
    skip_before_action :authenticate_user

    def authenticate
      user = User.confirm_by_token(params[:confirmation_token])

      if user.errors.empty?
        head :no_content
      else
        # resource.errors, status: :unprocessable_entity){ render :new }
        head :unprocessable_entity
      end
    end

    # protected

    # The path used after resending confirmation instructions.
    # def after_resending_confirmation_instructions_path_for(resource_name)
    #   super(resource_name)
    # end

    # The path used after confirmation.
    # def after_confirmation_path_for(resource_name, resource)
    #   super(resource_name, resource)
    # end
  end
end
