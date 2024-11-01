class CurrentUserRepository < ActiveSupport::CurrentAttributes
  attribute :authenticated_identity
end
