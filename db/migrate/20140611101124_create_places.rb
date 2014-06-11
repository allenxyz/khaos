class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
    	t.string :loc
    	t.float :longitude
    	t.float :latitude
    	t.integer :rec_id


      t.timestamps
    end
  end
end
