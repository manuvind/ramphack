class AddUseToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :use, :boolean
  end
end
