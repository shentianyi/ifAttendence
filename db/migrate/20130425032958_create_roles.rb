class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :nr
      t.string :name

    end
  end
end
