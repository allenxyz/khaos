class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
    	t.integer :google_id
    	t.time :start_time
    	t.string :summary
    	t.string :url

      t.timestamps
    end
  end
end
