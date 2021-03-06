module Percolator
  class GetSpotifyArtist < TXS
    def run artist_name
      url = build_url artist_name
      response = Unirest.get URI.encode(url)
      results = response.body['artists']['items'] unless response.body.empty?

      return failure :artist_not_found if results.nil?

      artist = narrow_down(artist_name, results) unless results.empty?

      return failure :artist_not_found if artist.nil?

      success(data: artist)
    end

    def narrow_down artist_name, results
      return results.first if artist_name == results.first['name']

      results.find do |c|
        diff = Percolator::Hamming.run [artist_name, c['name']]
        diff <= 3
      end
    end

    def build_url artist_name
      'https://api.spotify.com/v1/search?q=' + artist_name + '&type=artist'
    end
  end
end


#.first['id'] unless response.body['artists']['items'].empty?
