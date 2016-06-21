class AddTimerToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :timer, :datetime
  end
end
