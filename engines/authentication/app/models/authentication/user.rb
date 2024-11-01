module Authentication
  class User < AggregateRoot
    self.table_name = "users"

    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

    has_many :roles
    has_many :user_permissions
    has_many :permissions, through: :user_permissions

    def self.create_new(id: SecureRandom.uuid, email:, password:, first_name:, last_name:)
      new(
        id: id,
        email: email,
        password: password,
        first_name: first_name,
        last_name: last_name
      )
    end

    def has_permission?(resource:, action:)
      permissions.find { _1.resource == resource && _1.action == action }.any?
    end
  end
end
