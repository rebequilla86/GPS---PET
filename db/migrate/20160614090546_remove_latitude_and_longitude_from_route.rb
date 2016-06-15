class RemoveLatitudeAndLongitudeFromRoute < ActiveRecord::Migration
  def change
    remove_column :routes, :latitude, :float
    remove_column :routes, :longitude, :float
  end
end
