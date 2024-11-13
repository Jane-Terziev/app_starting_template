module Authentication
  class AuthenticateUser
    include ApplicationService
    inject_dependencies({ user_repository: User })

    class Validator < ApplicationContract
      params do
        required(:email).filled(Types::Email)
        required(:password).filled(:string, min_size?: 5)
      end
    end

    def run(params:, warden:)
      validate_params(params)
        .and_then { find_user }
        .and_then { check_password }
        .and_then { set_session(warden) }
    end

    private

    def find_user
      @user = user_repository.find_by(email: @sanitized_params[:email])

      return Failure.new(error: ServiceError.new(message: "Invalid Credentials")) unless @user

      Success.new
    end

    def check_password
      return Success.new if @user.valid_password?(@sanitized_params[:password])

      Failure.new(error: ServiceError.new(message: "Invalid Credentials"))
    end

    def set_session(warden)
      warden.set_user(@user, scope: :user)

      Success.new
    end
  end
end
