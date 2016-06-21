class ChangeDateFormatInWalks < ActiveRecord::Migration
  def change
  	change_column :walks, :walker, :string
  end
end
