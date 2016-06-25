class SongsController < ApplicationController
  def search
    spotify_search = SpotifySearch.new
    @songs = spotify_search.recommendations(bpm_params)
  end

  private

  def bpm_params
    min_bpm = params[:bpm].to_f
    { :min_tempo => min_bpm, :max_tempo => min_bpm + 0.9 }
  end
end
