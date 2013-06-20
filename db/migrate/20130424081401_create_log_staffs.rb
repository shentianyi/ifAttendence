class CreateLogStaffs < ActiveRecord::Migration
  def change
    create_table :log_staffs do |t|
      t.string :staffNr
      t.string :staffName
      t.string :workunitNr
      t.boolean :oldState
      t.boolean :newState
      t.integer :time

    end
  end
end
