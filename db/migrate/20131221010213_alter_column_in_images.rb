class AlterColumnInImages < ActiveRecord::Migration
  def change
    rename_column :images, :path, :photo
  end
end
