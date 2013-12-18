class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :location, index: true
      t.string :title
      t.text :description
      t.string :path, :null => false

      t.timestamps
    end
  end
end
