class CreatePermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :permissions do |t|
      t.string :resource, null: false
      t.string :action, null: false
      t.string :description, null: false

      t.timestamps
    end
  end
end
