class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.integer :gps_id
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
