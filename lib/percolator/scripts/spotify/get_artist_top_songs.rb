module Percolator
  class GetArtistTopSongs < TXS
    def run artist_id
      url = build_url artist_id
      response = Unirest.get URI.encode(url)
      top_three = response.body['tracks'].first 3

      top_three.map do |s|
        {
          name: s['name'],
          uri: s['uri'],
          url: s['external_urls']['spotify']
        }
      end
    end

    def build_url id
      'https://api.spotify.com/v1/artists/' + id + '/top-tracks?country=US'
    end
  end
end
