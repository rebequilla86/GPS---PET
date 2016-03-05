class AddDogsAndExperienceToPets < ActiveRecord::Migration
  def change
    add_column :pets, :dogs, :string
    add_column :pets, :experience, :text
  end
end
