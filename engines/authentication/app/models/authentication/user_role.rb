module Authentication
  class UserRole < ApplicationRecord
    belongs_to :user
    belongs_to :role
  end
end
