module Authentication
  class RolePermission < ApplicationRecord
    self.table_name = "role_permissions"

    belongs_to :role
    belongs_to :permission
  end
end
