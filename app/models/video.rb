class Video < ActiveRecord::Base
  belongs_to :user

  require 'dotenv'
  Dotenv.load
  require 'youtube_it'
  require 'parse-ruby-client'
  Parse.init(:application_id => "7VQugUXdb7jzGtAVzuqhkJqW89DVQktrRjK7V35h", :api_key => "UR39PVyUb8c5erA3TFTKmNhGXU9b0HvkgymyDOZZ")
  
  def video_upload
    client = YouTubeIt::Client.new(:username => ENV['USERNAME'], :password => ENV['PASSWORD'], :dev_key => "AI39si6UTnzD7wL4GDxjtrtCoXQcuOUrqXT7UkIA4mPpPRbNr8hDVtI9nWb_GG1a86YffywakjXDjCWan-9h26lDVBK7DXzpPw")
    byebug
    youObj = client.video_upload(File.open(self.path), :title => self.name, :description => self.context, :category => 'People',:keywords => %w[cool blah test])
    self.url = youObj.player_url
    self.save
  end

  def parse_upload
    byebug
    video = Parse::Object.new("Video")
    if self.parse_id
      video_query = Parse::Query.new("Video")
      video_query.eq("objectId", self.parse_id)
      video = video_query.get
    end

    video["url"] = self.url
    video["use"] = self.use
    result = video.save
    self.parse_id = result["objectId"]
    self.save
    if self.use
      self.not_use_other
    end
  end

  def not_use_other
    videos = Video.all
    videos.each do |video|
      if video.id != self.id && video.use == true
        video.use = false
        video.save
        video_query = Parse::Query.new("Video")
        video_query.eq("objectId", video.parse_id)
        video_obj = video_query.get[0]
        byebug
        video_obj["use"] = false
        byebug
        video_obj.save
      end
    end
  end

end
