module Authentication
  class AuthenticateUser < ::ApplicationService
    class Contract < ApplicationContract
      params do
        required(:email).value(Types::StrippedString, :filled?)
        required(:password).value(Types::StrippedString, :filled?)
      end

      rule(:email).validate(:email_format)
      rule(:password).validate(:password_format)
    end

    def initialize(user_repository: User, **args)
      super(**args)
      self.user_repository = user_repository
    end

    def call(params:, warden:)
      validate_params(params)
        .and_then { find_user }
        .and_then { check_password }
        .and_then { set_session(warden) }
        .and_then { publish_all(@user) }
    end

    private

    attr_accessor :user_repository

    def contract
      Contract
    end

    def find_user
      @user = user_repository.find_by(email: @sanitized_params[:email])

      return Failure.new(error: ErrorMessage.new(message: "Invalid Credentials")) unless @user

      Success.new
    end

    def check_password
      return Failure.new(error: ErrorMessage.new(message: "Invalid Credentials")) unless @user.valid_password?(@sanitized_params[:password])

      Success.new
    end

    def set_session(warden)
      warden.set_user(@user, scope: :user)

      Success.new
    end
  end
end
