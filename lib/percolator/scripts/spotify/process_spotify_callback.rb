module Percolator
  class ProcessSpotifyCallback < TXS
    def run params
      return failure :user_declined_spotify_auth if params[:error]

      spotify_auth_url = 'https://accounts.spotify.com/api/token'

      request_options = {
        headers: {'Accept' => 'application/json'},
        parameters: {
          :code          => params[:code],
          :grant_type    => 'authorization_code',
          :redirect_uri  => ENV['SPOTIFY_REDIRECT_URI'],
          :client_id     => ENV['SPOTIFY_CLIENT_ID'],
          :client_secret => ENV['SPOTIFY_SECRET']
        }
      }

      response = Unirest.post URI.encode(spotify_auth_url), request_options

      return failure :spotify_request_failure unless response.code == 200
      return failure :problem_getting_tokens if response.body['error']

      success data: response.body
    end
  end
end
