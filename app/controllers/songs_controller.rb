class SongsController < ApplicationController
  def search
    spotify_search = SpotifySearch.new
    itunes_search = ItunesSearch.new
    @spotify_songs = spotify_search.recommendations(bpm_params)
    @itunes_songs = itunes_search.get(@spotify_songs)
  end

  private

  def bpm_params
    { :min_tempo => bpm, :max_tempo => bpm + 0.9 }
  end

  def bpm
    @bpm ||= params[:bpm].to_f
  end
end
