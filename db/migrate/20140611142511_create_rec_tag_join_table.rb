class CreateRecTagJoinTable < ActiveRecord::Migration
  def change
  	create_join_table :recs, :tags
  end
end
