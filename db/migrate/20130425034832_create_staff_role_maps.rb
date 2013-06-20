class CreateStaffRoleMaps < ActiveRecord::Migration
  def change
    create_table :staff_role_maps do |t|
      t.integer :staff_id
      t.integer :role_id

    end
  end
end
