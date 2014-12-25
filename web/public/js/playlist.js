(function () {

  Playlist = {}
  Playlist.controller = function () {}

  var artistTrack = function (track) {
    return [
      m('a', {
        href: track.external_urls.spotify,
        target: '_blank'
      }, track.name),
      m('br')
    ]
  }

  var playlistItem = function (artistProfile) {
    var tracks = artistProfile.tracks.map(artistTrack);

    return [
      m('.playlist-item', [
        artistProfile.name,
        m('br'),
        tracks,
        m('br')
      ])
    ]
  }

  Playlist.view = function (ctrl) {
    if (vm.artistProfiles().error) { return vm.artistProfiles().error }
    var html = vm.artistProfiles().map(playlistItem);
    return html
  }

})()
