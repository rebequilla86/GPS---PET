class AddIsWalkerAndRaceToPet < ActiveRecord::Migration
  def change
    add_column :pets, :is_walker, :string
    add_column :pets, :race, :string
  end
end
