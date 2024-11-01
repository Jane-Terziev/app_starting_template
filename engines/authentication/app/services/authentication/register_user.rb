module Authentication
  class RegisterUser < ::ApplicationService
    include Import[user_repository: "authentication.user_repository"]

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

    def call(params, warden)
      ActiveRecord::Base.transaction do
        result = validate_params(params)
                   .and_then { verify_email_not_taken }
                   .and_then { create_user }
                   .and_then { set_session(warden) }

        raise TransactionError.new(result) if result.failure?

        result
      end.and_then { publish_all(@user) }

    rescue TransactionError => e
      e.result
    end

    private

    def contract
      Contract
    end

    def verify_email_not_taken
      return Failure.new(error: "User already exists.") if user_repository.exists?(email: @sanitized_params[:email])

      Success.new
    end

    def create_user
      @user = user_repository.create_new(
        email: @sanitized_params[:email],
        password: @sanitized_params[:password],
        first_name: @sanitized_params[:first_name],
        last_name: @sanitized_params[:last_name]
      )

      return Failure.new(error: "Could not create user. Please try again later") unless user_repository.save(@user)

      Success.new
    end

    def set_session(warden)
      warden.set_user(@user, scope: :user)

      Success.new
    end
  end
end
