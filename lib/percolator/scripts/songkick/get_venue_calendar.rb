module Percolator
  class GetVenueArtists < TXS
    def run params
      url = 'http://api.songkick.com/api/3.0/venues/' + params[:songkick_id] +
            '/calendar.json?apikey=' + ENV['SONGKICK_API_KEY']

      response = Unirest.get URI.encode(url)

      return failure :artist_search_failure unless response.code == 200

      events  = response.body['resultsPage']['results']['event']

      return failure :no_upcoming_shows if events.nil?

      artists = events.map do |r|
        r['performance'].map { |a| a['displayName'] }
      end.flatten.uniq

      success(data: artists)
    end
  end
end
