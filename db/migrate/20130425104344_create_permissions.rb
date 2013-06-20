class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :res
      t.string :ope
      t.string :desc

    end
  end
end
