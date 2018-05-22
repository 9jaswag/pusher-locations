# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready =>
  makeNum = (arr) ->
    arr.forEach (arr) ->
      arr.lat = Number(arr.lat)
      arr.lng = Number(arr.lng)
      return
    arr

  saveTrip = (positionData) ->
    token = $('meta[name="csrf-token"]').attr('content')
    $.ajax
      url: '/trips'
      type: 'post'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', token
        return
      data: positionData
      success: (response) ->
        # console.log response
        url = """#{window.location.protocol}//#{window.location.host}/trips/#{response.uuid}"""
        # initMap response.checkins[0]
        checkins = makeNum response.checkins
        updateMap checkins
        $('.name-form').addClass('collapse')
        $('.share-url').append """
          <h6 class="m-0 text-center">Hello <strong>#{response.name}</strong>, here's your location sharing link: <a href="#{url}">#{url}</a></h6>
        """
        return
    return

  getLocation = (name) ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (position) ->
        coord = position.coords
        timestamp = position.timestamp
        data =
          lat: coord.latitude,
          lng: coord.longitude,
          name: name
        saveTrip data
    return

  $('.name-form').on 'submit', (event) ->
    event.preventDefault()
    formData = $(this).serialize()
    name = formData.split('=')[1]
    data = getLocation(name)
    return

  initMap = (location) ->
    center = 
      lat: Number location.lat
      lng: Number location.lng
    map = new (google.maps.Map)(document.getElementById('map'),
      zoom: 16
      center: center
      disableDefaultUI: true)
    marker = new (google.maps.Marker)(
      position: center
      map: map)
    return

  updateMap = (checkins) ->
    console.log checkins
    center = 
      lat: checkins[0].lat
      lng: checkins[0].lng
    map = new (google.maps.Map)(document.getElementById('map'),
      zoom: 13
      center: center)
    marker = new (google.maps.Marker)(
      position: center
      map: map)

    flightPath = new (google.maps.Polyline)(
      path: checkins,
      geodesic: true
      strokeColor: '#FF0000'
      strokeOpacity: 1.0
      strokeWeight: 2)
    flightPath.setMap map
    return

  if location.pathname.startsWith('/trips')
    userLocation =
      lat: $('#lat').val(),
      lng: $('#lng').val()
    initMap userLocation
    newLoc =
      lat: 6.571336,
      lng: 3.3694995
    updateMap(userLocation, newLoc)
