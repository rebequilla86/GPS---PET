class CreateWalks < ActiveRecord::Migration
  def change
    create_table :walks do |t|
      t.string :name
      t.time :duration
      t.datetime :last_data_received
      t.integer :state
      t.integer :walker

      t.timestamps null: false
    end
  end
end
