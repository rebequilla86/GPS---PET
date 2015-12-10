class AddUserIdToPets < ActiveRecord::Migration
  def change
    add_reference :pets, :user
  end
end