json.array!(@tracks) do |route|
  json.extract! route, :id
  json.url route_url(track, format: :json)
end
