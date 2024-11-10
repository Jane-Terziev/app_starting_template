module Authentication
  class Role < ApplicationRecord
    self.table_name = "roles"

    has_many :role_permissions
    has_many :permissions, through: :role_permissions
  end
end
