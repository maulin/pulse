class SongsController < ApplicationController
  after_action :track_search, :only => :search

  def search
    spotify_search = SpotifySearch.new
    itunes_search = ItunesSearch.new

    query = bpm_query.merge({ :seed_genres => seed_genres.join(",") })
    @spotify_songs = spotify_search.recommendations(query)
    @itunes_songs = itunes_search.get(@spotify_songs)
  end

  private

  def bpm_query
    { :min_tempo => bpm, :max_tempo => bpm + 0.9 }
  end

  def bpm
    @bpm ||= params[:bpm].to_f
  end

  def seed_genres
    @seed_genres = SpotifySearch::GENRES.sample(5)
  end

  def track_search
    Keen.publish("search", { :request_ip => request.remote_ip, :bpm => bpm }) if bpm > 0
  end
end
