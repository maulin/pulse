class ItunesSearch
  def get(songs)
    conn = connection
    results = []
    songs.each do |song|
      params = {
        :term => "#{song["artists"].first["name"]} - #{song["name"]}",
        :entity => "musicTrack",
        :limit => 1,
      }
      resp = conn.get do |req|
        req.url "/search", params
        req.headers["Accept"] = "application/json"
      end
      result = JSON.parse(resp.body)["results"][0]
      results << result if result.present?
    end
    results
  end

  #private

  def connection
    Faraday.new(:url => base_url) do |faraday|
      faraday.request :url_encoded
      faraday.adapter :net_http
    end
  end

  def base_url
    "https://itunes.apple.com"
  end
end
