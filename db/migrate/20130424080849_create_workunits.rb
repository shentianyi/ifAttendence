class CreateWorkunits < ActiveRecord::Migration
  def change
    create_table :workunits do |t|
      t.string :nr
      t.string :state, :default=>"stop"

    end
  end
end
