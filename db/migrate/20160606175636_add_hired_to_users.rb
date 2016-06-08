class AddHiredToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hired, :integer
  end
end
