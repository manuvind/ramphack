class User < ActiveRecord::Base
  has_many :videos

  def self.upload_video
  end
end
