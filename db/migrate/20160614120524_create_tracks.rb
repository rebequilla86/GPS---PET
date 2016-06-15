class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :file_name
      t.integer :walk_id

      t.timestamps null: false
    end
  end
end
