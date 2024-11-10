module Authentication
  class UserPermission < ApplicationRecord
    self.table_name = "user_permissions"

    belongs_to :user
    belongs_to :permission
  end
end
