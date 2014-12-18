module Percolator
  class SongkickVenueSearch < TXS
    def run params
      url = 'http://api.songkick.com/api/3.0/search/venues.json?apikey=' +
            ENV['SONGKICK_API_KEY'] + '&query=' + params[:venue]
      response = Unirest.get URI.encode(url)

      unless response.code == 200
        return failure :venue_search_failure
      end

      results = response.body['resultsPage']['results']['venue']

      if results.empty?
        return failure(:no_venue_search_results)
      end

      venues = results.map do |r|
        {
          :id      => r['id'],
          :name    => r['displayName'],
          :website => r['website'],
          :address => r['street']
        }
      end

      success(data: venues)
    end
  end
end
