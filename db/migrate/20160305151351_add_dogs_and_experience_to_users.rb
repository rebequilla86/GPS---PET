class AddDogsAndExperienceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dogs, :string
    add_column :users, :experience, :text
  end
end
