class SongsController < ApplicationController
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
end
