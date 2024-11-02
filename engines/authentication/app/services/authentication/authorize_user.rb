module Authentication
  class AuthorizeUser < ::ApplicationService
    class Contract < ApplicationContract
      params do
        required(:resource).value(Types::StrippedString, :filled?)
        required(:action).value(Types::StrippedString, :filled?)
      end
    end

    def initialize(current_user_repository: CurrentUserRepository)
      self.current_user_repository = current_user_repository
      super()
    end

    def call(params)
      validate_params(params)
        .and_then { find_user }
        .and_then { check_permissions }
    end

    private

    attr_accessor :current_user_repository

    def contract
      Contract
    end

    def find_user
      @user = current_user_repository.authenticated_identity
      return Failure.new(error: "Please sign in before continuing.") unless @user

      Success.new
    end

    def check_permissions
      return Failure.new(error: "User not authorized to perform the action.") unless @user.has_permission?(
        resource: @sanitized_params[:resource],
        action: @sanitized_params[:action]
      )

      Success.new
    end
  end
end
