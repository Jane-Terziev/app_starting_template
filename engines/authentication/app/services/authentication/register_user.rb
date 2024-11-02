module Authentication
  class RegisterUser < ::ApplicationService
    class Contract < ApplicationContract
      params do
        required(:email).value(Types::StrippedString, :filled?)
        required(:password).value(Types::StrippedString, :filled?)
        required(:password_confirmation).value(Types::StrippedString, :filled?)
        required(:first_name).value(Types::StrippedString, :filled?)
        required(:last_name).value(Types::StrippedString, :filled?)
      end

      rule(:email).validate(:email_format)
      rule(:password).validate(:password_format)

      rule(:password, :password_confirmation) do
        if values[:password] != values[:password_confirmation]
          key(:password).failure("must match with password confirmation")
          key(:password_confirmation).failure("must match with password")
        end
      end
    end

    def initialize(user_repository: User, **args)
      super(**args)
      self.user_repository = user_repository
    end

    def call(params:, warden:)
      ActiveRecord::Base.transaction do
        validate_params(params)
          .and_then { verify_email_not_taken }
          .and_then { create_user }
          .and_then { set_session(warden) }
          .tap { raise TransactionError.new(_1) if _1.failure? }
      end

      publish_all(@user)
    end

    private

    attr_accessor :user_repository

    def contract
      Contract
    end

    def verify_email_not_taken
      return Failure.new(error: ErrorMessage.new(message: "User already exists.")) if user_repository.exists?(email: @sanitized_params[:email])

      Success.new
    end

    def create_user
      @user = user_repository.create_new(
        email: @sanitized_params[:email],
        password: @sanitized_params[:password],
        first_name: @sanitized_params[:first_name],
        last_name: @sanitized_params[:last_name]
      )

      unless user_repository.save(@user)
        return Failure.new(error: InternalError.new(message: "Could not create user.", details: @user.errors.to_hash))
      end

      Success.new
    end

    def set_session(warden)
      warden.set_user(@user, scope: :user)

      Success.new
    end
  end
end
