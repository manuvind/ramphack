class AddPathToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :path, :text
  end
end
