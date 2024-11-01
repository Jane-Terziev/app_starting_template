class CreateUserPermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :user_permissions do |t|
      t.references :user
      t.references :permission

      t.timestamps
    end
  end
end
