module Authentication
  class RegisterUser < ::ApplicationService
    class Validator < ApplicationValidator
      attribute :email, :string
      attribute :password, :string
      attribute :first_name, :string
      attribute :last_name, :string

      validates :email, :password, :first_name, :last_name, presence: true
      validates :email, format: { with: EMAIL_REGEX, message: "is in invalid format." }
      validates :password, confirmation: true, length: { minimum: 5 }
    end

    inject_dependencies({ user_repository: User })

    def run(params:, warden:)
      result = validate_params(params)
                 .and_then { verify_email_not_taken }

      ActiveRecord::Base.transaction do
        result
          .and_then { create_user }
          .tap { result = _1; raise ActiveRecord::Rollback if _1.failure? }
      end

      result
        .and_then { set_session(warden) }
        .and_then { publish_events }
    end

    private

    def verify_email_not_taken
      return Success.new unless user_repository.exists?(email: @validator.email)

      Failure.new(error: ServiceError.new(message: "User already exists."))
    end

    def create_user
      @user = user_repository.new(
        id: SecureRandom.uuid,
        email: @validator.email,
        password: @validator.password,
        first_name: @validator.first_name,
        last_name: @validator.last_name
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
