class SpotifySearch
  GENRES = File.new("config/spotify_genres.txt").readlines.each { |l| l.chomp! }

  def self.token
    unless token_valid?
      get_access_token
    end
    @token
  end

  def self.token_valid?
    @token.present? && Time.current - @token_fetched_at <= 3500
  end

  def recommendations(params)
    return [] if params[:min_tempo] == 0

    conn = web_api
    resp = conn.get do |req|
      req.url "/v1/recommendations", params
      req.headers["Authorization"] = "Bearer #{self.class.token}"
      req.headers["Accept"] = "application/json"
    end
    JSON.parse(resp.body)["tracks"]
  end

  #private

  def self.get_access_token
    conn = Faraday.new(:url => "https://accounts.spotify.com/api/token") do |faraday|
      faraday.request :url_encoded
      faraday.adapter :net_http
    end

    resp = conn.post do |req|
      req.headers["Authorization"] = "Basic #{encoded_client_and_secret}"
      req.body = { :grant_type => "client_credentials" }
    end
    @token = JSON.parse(resp.body)["access_token"]
    @token_fetched_at = Time.current
  end

  def self.encoded_client_and_secret
    Base64.strict_encode64("#{ENV['SPOTIFY_CLIENT_ID']}:#{ENV['SPOTIFY_CLIENT_SECRET']}")
  end

  def web_api
    Faraday.new(:url => base_url) do |faraday|
      faraday.request :url_encoded
      faraday.adapter :net_http
    end
  end

  def base_url
    "https://api.spotify.com"
  end
end
