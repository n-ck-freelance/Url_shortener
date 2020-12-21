json.urls do
  json.array! @short_urls do |short_url|
    json.merge! short_url.public_attributes
  end
end
