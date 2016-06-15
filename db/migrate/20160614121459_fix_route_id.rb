class FixRouteId < ActiveRecord::Migration
  def change
    rename_column :locations, :route_id, :track_id
  end
end
