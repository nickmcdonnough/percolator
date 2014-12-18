require 'unirest'
require 'ostruct'
# require 'pg'

require_relative 'percolator/scripts/txs.rb'
require_relative 'percolator/scripts/hamming.rb'
require_relative 'percolator/scripts/songkick/get_venue_calendar.rb'
require_relative 'percolator/scripts/songkick/search_artists.rb'
require_relative 'percolator/scripts/songkick/search_venues.rb'
require_relative 'percolator/scripts/spotify/get_spotify_artist.rb'
require_relative 'percolator/scripts/spotify/get_artist_top_songs.rb'

module Percolator
end
