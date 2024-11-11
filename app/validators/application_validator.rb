class ApplicationValidator
  include ActiveModel::Model
  include ActiveModel::Attributes

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  EMAIL_ERROR_MESSAGE = "must be a valid email."
end
