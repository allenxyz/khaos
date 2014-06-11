class CreatePlaceTagJoinTable < ActiveRecord::Migration
  def change
    create_join_table :places, :tags
  end
end
