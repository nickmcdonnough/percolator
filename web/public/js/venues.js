(function () {

  Venue = {}

  Venue.controller = function () {
    var ctrl = {
      searchForVenue: function (e) {
        e.preventDefault();
        m.request({
          url: '/venues/search',
          method: 'POST',
          data: { venue: e.currentTarget.venue.value }
        }).then(vm.venues)
      },
      getVenueArtists: function (venue, e) {
        e.preventDefault();
        clearSelectedResults();
        e.target.className += ' venue-selection';
        m.request({
          url: '/venues/' + venue.id,
          method: 'GET'
        }).then(fetchArtistProfiles)
          .then(vm.artistProfiles)
          .then(vm.view.bind(null, 'playlist'))
      }
    }
    return ctrl
  }

  function clearSelectedResults () {
    var results = document.getElementsByClassName('venue-search-result');
    var playlistDiv = document.getElementById('playlist');
    playlistDiv.style.height = '400px';
    for (var i = 0; i < results.length; i++) {
      results[i].className = 'venue-search-result'
    }
  }

  function fetchArtistProfiles (artistNames) {
    if (artistNames.length > 0) {
      var promises = artistNames.map(function (name) {
        return fetchArtist(name)
          .then(fetchTracks)
          .then(buildProfile.curry(name))
      })
      return m.sync(promises)
    } else {
      return {error: 'No upcoming shows.'}
    }
  }

  function fetchArtist (name) {
    // think about adding background: true to the request for future reloader animation
    var artistSearchUrl = 'https://api.spotify.com/v1/search?q=' + name + '&type=artist';
    return m.request({url: artistSearchUrl, method: 'GET'}).then(function(artistResults) {
      var artist = artistResults.artists.items[0];
      return artist ? artist : {name: name}
    })
  }

  function fetchTracks (artist) {
    if (artist.id === undefined) { return [] }

    var artistTopTracksUrl = 'https://api.spotify.com/v1/artists/' + artist.id + '/top-tracks?country=US';
    return m.request({url: artistTopTracksUrl, method: 'GET'}).then(function(trackResults) {
      return trackResults.tracks
    })
  }

  function buildProfile (name, tracks) {
    var topThree = tracks.slice(0, 3);
    return {name: name, tracks: topThree}
  }

  var venueSearchResult = function (ctrl, v) {
    return [
      m('a', {
        onclick: ctrl.getVenueArtists.bind(null, v),
        href: '#'
      }, m('.venue-search-result', [
        v.name,
        m('br'),
        v.address,
        m('br'),
        v.website ? v.website.replace(/http:|\//ig,'') : null
      ])),
      m('br')
    ]
  }

  var venueSearchForm = function (ctrl) {
    return [
      m('.col-md-4', {class: 'venue-search-form'}, [
        m('form', { onsubmit: ctrl.searchForVenue },  [  // revisit 12/17
          m('input[name=venue]', {type: 'text', class: 'form-control'})
        ])
      ])
    ]
  }

  Venue.view = function (ctrl) {
    var form = venueSearchForm(ctrl);
    var results = vm.venues().map(venueSearchResult.bind(null, ctrl));
    var resultDiv = m('.col-md-3', [
      results[0] ? m('h5', 'Search results:') : null,
      results
    ])
    return [form, resultDiv]
  }
})()
