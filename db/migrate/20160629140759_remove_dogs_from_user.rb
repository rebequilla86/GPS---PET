class RemoveDogsFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :dogs, :string
  end
end
