class AddRatingToPlace < ActiveRecord::Migration
  def change
  	add_column :places, :rating, :integer
  end
end
