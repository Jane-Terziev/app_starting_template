module Authentication
  class RegisterUser
    include ApplicationService
    inject_dependencies({ user_repository: User })

    class Validator < ApplicationContract
      params do
        required(:email).filled(Types::Email)
        required(:password).filled(:string, min_size?: 5)
        required(:password_confirmation).filled(:string, min_size?: 5)
        required(:first_name).filled(:string)
        required(:last_name).filled(:string)
      end

      rule(:password, :password_confirmation) do
        if values[:password] != values[:password_confirmation]
          key(:password).failure("must match password confirmation.")
          key(:password_confirmation).failure("must match password.")
        end
      end
    end

    def run(params:, warden:)
      validate_params(params)
        .and_then { verify_email_not_taken }
        .and_then { create_user }
        .and_then { set_session(warden) }
        .and_then { publish_events }
    end

    private

    def verify_email_not_taken
      return Success.new unless user_repository.exists?(email: @sanitized_params[:email])

      Failure.new(error: ServiceError.new(message: "User already exists."))
    end

    def create_user
      @user = user_repository.new(
        id: SecureRandom.uuid,
        email: @sanitized_params[:email],
        password: @sanitized_params[:password],
        first_name: @sanitized_params[:first_name],
        last_name: @sanitized_params[:last_name]
      )

      unless @user.save
        return Failure.new(
          error: InternalError.new(message: "Could not create user.", internal_details: @user.errors.full_messages)
        )
      end

      apply_event(
        event_name: "users.created_event",
        payload: {
          id: @user.id,
          email: @user.email,
          first_name: @user.first_name,
          last_name: @user.last_name
        }
      )

      Success.new
    end

    def set_session(warden)
      warden.set_user(@user, scope: :user)

      Success.new
    end
  end
end
