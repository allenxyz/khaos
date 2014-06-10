class CreateDatabases < ActiveRecord::Migration
  def change
    create_table :databases do |t|
      t.string :loc
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
