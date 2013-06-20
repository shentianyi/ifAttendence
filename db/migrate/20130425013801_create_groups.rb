class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :nr
      t.string :name
      
      t.integer :captain_id

      t.timestamps
    end
  end
end
