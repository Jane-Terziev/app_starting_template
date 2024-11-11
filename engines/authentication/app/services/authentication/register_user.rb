module Authentication
  class RegisterUser < ::ApplicationService
    class Validator < ApplicationValidator
      attribute :email
      validates :email, presence: true, format: { with: EMAIL_REGEX, message: "is in invalid format." }

      attribute :password
      validates :password, confirmation: true, presence: true, length: { minimum: 5 }

      attribute :first_name
      validates :first_name, presence: true

      attribute :last_name
      validates :last_name, presence: true
    end

    inject_dependencies({ user_repository: User })

    def run(params:, warden:)
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

    def verify_email_not_taken
      return Success.new unless user_repository.exists?(email: @validator.email)

      Failure.new(error: ErrorMessage.new(message: "User already exists."))
    end

    def create_user
      @user = user_repository.create_new(
        email: @validator.email,
        password: @validator.password,
        first_name: @validator.first_name,
        last_name: @validator.last_name
      )

      return Success.new if user_repository.save(@user)

      message = "Could not create user. #{@user.errors.full_messages.join('. ')}"
      Failure.new(error: InternalError.new(message: message, details: @user.errors.full_messages))
    end

    def set_session(warden)
      warden.set_user(@user, scope: :user)

      Success.new
    end
  end
end
