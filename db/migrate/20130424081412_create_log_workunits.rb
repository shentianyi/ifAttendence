class CreateLogWorkunits < ActiveRecord::Migration
  def change
    create_table :log_workunits do |t|
      t.string :workunitNr
      t.string :oldState
      t.string :newState
      t.string :desc
      t.integer :time

    end
  end
end
