require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pry-byebug'

require_relative '../lib/percolator.rb'

class Percolator::Server < Sinatra::Application
  configure do
    set :server, 'thin'
    use Rack::Session::Cookie, expires_after: 2592000,
                               secret: ENV['percolator_session_secret']
  end

  before do
  end

  helpers do
    def symbolize_keys hash
      Hash[hash.to_a.map { |x| [x.first.to_sym, x.last] }]
    end
  end

  get '/' do
    @auth_url = 'https://accounts.spotify.com/authorize/?client_id=' +
                ENV['SPOTIFY_CLIENT_ID'] +
                '&response_type=code&redirect_uri=' +
                ENV['SPOTIFY_REDIRECT_URI'] +
                '&scope=playlist-modify-private+playlist-modify-public&state=profile%2Factivity'
    send_file 'public/index.html'
  end

  post '/venues/search' do
    headers['Content-Type'] = 'application/json'
    params = symbolize_keys JSON.parse(request.body.read)
    result = Percolator::SongkickVenueSearch.run params
    data = result.success? ? result.data : []
    data.to_json
  end

  get '/venues/:songkick_id' do
    headers['Content-Type'] = 'application/json'
    artist_names = Percolator::GetVenueArtists.run params

    unless artist_names.success?
      halt 200, {success: false, error: 'No upcoming shows.'}.to_json
    end

    artist_names.data.to_json
  end

  # send found songs to spotify
  post '/venue_profile' do
  end

  get '/spotify_callback' do
  end
end
