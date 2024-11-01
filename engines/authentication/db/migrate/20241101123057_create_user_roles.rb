class CreateUserRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :user_roles do |t|
      t.references :role
      t.references :user

      t.timestamps
    end
  end
end
