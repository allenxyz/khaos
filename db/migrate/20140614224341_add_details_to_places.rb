class AddDetailsToPlaces < ActiveRecord::Migration
  def change
  	add_column :places, :full_address, :string
  	add_column :places, :img, :string
  	add_column :places, :url, :string
  end
end
