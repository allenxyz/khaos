class CreateAffinities < ActiveRecord::Migration
  def change
    create_table :affinities do |t|
      t.float :aff

      t.timestamps
    end
  end
end
