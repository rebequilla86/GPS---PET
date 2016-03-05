class RemoveIsWalkerFromPets < ActiveRecord::Migration
  def change
    remove_column :pets, :is_walker, :string
  end
end
