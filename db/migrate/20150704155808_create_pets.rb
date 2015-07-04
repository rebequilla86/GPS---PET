class CreatePets < ActiveRecord::Migration
  def change
    create_table :pets do |t|
      t.string :name
      t.integer :num_chip
      t.datetime :born_date
      t.string :color_hair
      t.string :color_eyes
      t.text :comment

      t.timestamps null: false
    end
  end
end
