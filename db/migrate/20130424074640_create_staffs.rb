class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.string :nr
      t.string :name
      t.boolean :state, :default=>false
      t.string :salt
      t.string :pwd
      
      t.integer :workunit_id
      t.integer :group_id
    end
  end
end
