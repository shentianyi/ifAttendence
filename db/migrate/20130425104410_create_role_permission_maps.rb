class CreateRolePermissionMaps < ActiveRecord::Migration
  def change
    create_table :role_permission_maps do |t|
      t.integer :role_id
      t.integer :permission_id

    end
  end
end
