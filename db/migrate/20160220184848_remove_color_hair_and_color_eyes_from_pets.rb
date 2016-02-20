class RemoveColorHairAndColorEyesFromPets < ActiveRecord::Migration
  def change
    remove_column :pets, :color_hair, :string
    remove_column :pets, :color_eyes, :string
  end
end
