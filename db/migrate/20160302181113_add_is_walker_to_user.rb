class AddIsWalkerToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_walker, :string
  end
end
