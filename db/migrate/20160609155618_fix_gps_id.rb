class FixGpsId < ActiveRecord::Migration
  def change
  	rename_column :routes, :gps_id, :file_name
  	change_column :routes, :file_name, :string
  end
end
