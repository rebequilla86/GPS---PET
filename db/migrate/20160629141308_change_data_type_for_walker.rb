class ChangeDataTypeForWalker < ActiveRecord::Migration
  def change
  	change_column :walks, :walker, 'integer USING CAST(walker AS integer)'
  end
end