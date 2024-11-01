namespace :authentication do
  desc "Create Permissions. Permissions are used to manage access."
  task create_permissions: :environment do
    date = DateTime.current
    permissions = [
      # { id: 1, resource: 'orders', action: 'create', description: 'Allow user to create orders', created_at: date, updated_at: date }
    ]
    Authentication::Domain::Permission.upsert_all(permissions)
  end

  desc "Create Roles. Roles are used as a way to group permissions."
  task create_roles: :environment do
    date = DateTime.current
    roles = [ { id: 1, name: "Admin", created_at: date, updated_at: date } ]
    Authentication::Domain::Role.upsert_all(roles)
    Authentication::Domain::RolePermission.upsert_all
  end

  desc "Setup, create permissions and roles"
  task setup: :environment do
    Rake::Task["permission_management:create_permissions"].execute
    Rake::Task["permission_management:create_roles"].execute
  end
end
