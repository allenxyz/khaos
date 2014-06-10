class CreateRecs < ActiveRecord::Migration
  def change
    create_table :recs do |t|
      t.string :loc
      t.integer :data_id

      t.timestamps
    end
  end
end
