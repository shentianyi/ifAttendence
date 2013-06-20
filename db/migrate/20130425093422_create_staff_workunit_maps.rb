class CreateStaffWorkunitMaps < ActiveRecord::Migration
  def change
    create_table :staff_workunit_maps do |t|
      t.integer :staff_id
      t.integer :workunit_id

    end
  end
end
