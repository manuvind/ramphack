json.array!(@videos) do |video|
  json.extract! video, :id, :name, :context, :user_id
  json.url video_url(video, format: :json)
end
