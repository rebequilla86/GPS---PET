class ChangePetsNumChip < ActiveRecord::Migration
	def up
    change_column :pets, :num_chip, :string
  end
  def down
    change_column :pets, :num_chip, :integer
  end
end
