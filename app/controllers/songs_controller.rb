class SongsController < ApplicationController
  def search
    spotify_search = SpotifySearch.new
    @songs = spotify_search.recommendations(bpm_params)
  end

  private

  def bpm_params
    { :min_tempo => bpm, :max_tempo => bpm + 0.9 }
  end

  def bpm
    @bpm ||= params[:bpm].to_f
  end
end
