class CreateWorkunitStates < ActiveRecord::Migration
  def change
    create_table :workunit_states do |t|
      t.string :state

    end
  end
end
