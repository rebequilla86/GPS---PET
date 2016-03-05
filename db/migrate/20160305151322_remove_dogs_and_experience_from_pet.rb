class RemoveDogsAndExperienceFromPet < ActiveRecord::Migration
  def change
    remove_column :pets, :dogs, :string
    remove_column :pets, :experience, :text
  end
end
