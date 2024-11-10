module Authentication
  class AuthorizeUser < ::ApplicationService
    class Contract < ApplicationContract
      params do
        required(:resource).value(Types::StrippedString, :filled?)
        required(:action).value(Types::StrippedString, :filled?)
      end
    end

    def run(params:)
      validate_params(params)
        .and_then { find_user }
        .and_then { check_permissions }
    end

    private

    def find_user
      @user = current_user_repository.authenticated_identity
      return Failure.new(error: ErrorMessage.new(message: "Please sign in before continuing.")) unless @user

      Success.new
    end

    def check_permissions
      return Failure.new(error: ErrorMessage.new(message: "User not authorized to perform the action.")) unless @user.has_permission?(
        resource: @sanitized_params[:resource],
        action: @sanitized_params[:action]
      )

      Success.new
    end
  end
end
