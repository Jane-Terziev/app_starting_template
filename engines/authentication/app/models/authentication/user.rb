module Authentication
  class User < ApplicationRecord
    self.table_name = "users"

    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

    has_many :roles
    has_many :user_permissions
    has_many :permissions, through: :user_permissions

    def has_permission?(resource:, action:)
      permissions.find { _1.resource == resource && _1.action == action }.any?
    end
  end
end
