module Authentication
  class AuthorizeUser < ::ApplicationService
    class Validator < ApplicationValidator
      attribute :resource, :string
      attribute :action, :string

      validates :resource, :action, presence: true
    end

    inject_dependencies({ user_permission_repository: UserPermission })

    def run(params:)
      validate_params(params)
        .and_then { find_user }
        .and_then { check_permission }
    end

    private

    def find_user
      @user = current_user_repository.authenticated_identity
      return Failure.new(error: ServiceError.new(message: "Please sign in before continuing.")) unless @user

      Success.new
    end

    def check_permission
      return Success.new if user_permission_exists?

      Failure.new(error: ServiceError.new(message: "User not authorized to perform the action."))
    end

    def user_permission_exists?
      user_permission_repository
        .joins(:permission)
        .where(permission: { action: @validator.action, resource: @validator.resource })
        .where(user_id: @user.id)
        .exists?
    end
  end
end
