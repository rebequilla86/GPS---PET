class FixNumPets < ActiveRecord::Migration
  def change
  	rename_column :users, :num_pets, :walker
  end
end
