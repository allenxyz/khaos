class CreateAffinities < ActiveRecord::Migration
  def change
    create_table :affinities do |t|
      t.float :aff
      t.integer :tag_id

      t.timestamps
    end
  end
end
