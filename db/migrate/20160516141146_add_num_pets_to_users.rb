class AddNumPetsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :num_pets, :integer
  end
end
