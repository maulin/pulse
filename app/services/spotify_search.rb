class SpotifySearch
  def initialize
    get_access_token
  end

  def recommendations(params)
    conn = web_api
    params.merge!({ :seed_genres => "pop,rock,metal,r-n-b,rock-n-roll" })
    resp = conn.get do |req|
      req.url "/v1/recommendations", params
      req.headers["Authorization"] = "Bearer #{@access_token}"
      req.headers["Accept"] = "application/json"
    end
    JSON.parse(resp.body)["tracks"]
  end

  #private

  def get_access_token
    conn = accounts
    resp = conn.post do |req|
      req.headers["Authorization"] = "Basic #{encoded_client_and_secret}"
      req.body = { :grant_type => "client_credentials" }
    end
    @access_token = JSON.parse(resp.body)["access_token"]
  end

  def accounts
    Faraday.new(:url => token_url) do |faraday|
      faraday.request :url_encoded
      faraday.adapter :net_http
    end
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

  def token_url
    "https://accounts.spotify.com/api/token"
  end

  def encoded_client_and_secret
    Base64.strict_encode64("#{ENV['SPOTIFY_CLIENT_ID']}:#{ENV['SPOTIFY_CLIENT_SECRET']}")
  end
end
