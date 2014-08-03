class User < ActiveRecord::Base
  has_many :videos

  require "youtube_it"
  require "parse-ruby-client"
  Parse.init(:application_id => "7VQugUXdb7jzGtAVzuqhkJqW89DVQktrRjK7V35h", :api_key => "UR39PVyUb8c5erA3TFTKmNhGXU9b0HvkgymyDOZZ")


  def video_upload
    client = YouTubeIt::Client.new(:username => ENV['USERNAME'], :password =>  ENV['PASSWORD'], :dev_key => "AI39si6UTnzD7wL4GDxjtrtCoXQcuOUrqXT7UkIA4mPpPRbNr8hDVtI9nWb_GG1a86YffywakjXDjCWan-9h26lDVBK7DXzpPw")
    you_result = client.video_upload(File.open(self.path), :title => self.name,:description => self.context, :category => 'People',:keywords => %w[cool blah test], :dev_tag => 'tagdev')
    self.url = you_result.player_url
    self.save
  end

  def parse_upload
    video = Parse::Object.new("Video")
    if self.parse_id
      video_query = Parse::Query.new("Video")
      video_query.eq("objectId", self.parse_id)
      video = video_query.get
    end
    video["url"] = self.url
    video["use"] = true
    result = video.save
    self.parse_id = result["objectId"]
    self.save
  end
end
