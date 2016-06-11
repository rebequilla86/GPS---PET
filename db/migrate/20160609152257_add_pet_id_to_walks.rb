class AddPetIdToWalks < ActiveRecord::Migration
  def change
    add_column :walks, :pet_id, :integer
  end
end
