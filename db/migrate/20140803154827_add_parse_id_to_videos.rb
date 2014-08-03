class AddParseIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :parse_id, :string
  end
end
