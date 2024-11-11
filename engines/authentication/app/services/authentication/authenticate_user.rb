module Authentication
  class AuthenticateUser < ::ApplicationService
    class Validator < ApplicationValidator
      attribute :email
      validates :email, presence: true, format: { with: EMAIL_REGEX, message: "is in invalid format." }

      attribute :password
      validates :password, presence: true, length: { minimum: 5, message: "must be longer than 5 characters." }
    end

    inject_dependencies({ user_repository: User })

    def run(params:, warden:)
      validate_params(params)
        .and_then { find_user }
        .and_then { check_password }
        .and_then { set_session(warden) }
        .and_then { publish_all(@user) }
    end

    private

    def find_user
      @user = user_repository.find_by(email: @validator.email)

      return Failure.new(error: ErrorMessage.new(message: "Invalid Credentials")) unless @user

      Success.new
    end

    def check_password
      return Success.new if @user.valid_password?(@validator.password)

      Failure.new(error: ErrorMessage.new(message: "Invalid Credentials"))
    end

    def set_session(warden)
      warden.set_user(@user, scope: :user)

      Success.new
    end
  end
end
