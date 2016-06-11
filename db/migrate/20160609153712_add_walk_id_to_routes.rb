class AddWalkIdToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :walk_id, :integer
  end
end
