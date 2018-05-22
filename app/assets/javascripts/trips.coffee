# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready =>
  tripId = ''
  startingPoint = {}

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
        tripId = response.id
        url = """#{window.location.protocol}//#{window.location.host}/trips/#{response.uuid}"""
        checkins = makeNum response.checkins
        initMap()
        $('.name-form').addClass('collapse')
        $('.share-url').append """
          <h6 class="m-0 text-center">Hello <strong>#{response.name}</strong>, here's your location sharing link: <a href="#{url}">#{url}</a></h6>
        """
        getCurrentLocation()
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
        startingPoint = data
        saveTrip data
    return

  $('.name-form').on 'submit', (event) ->
    event.preventDefault()
    formData = $(this).serialize()
    name = formData.split('=')[1]
    data = getLocation(name)
    return

  initMap = ->
    center = 
      lat: startingPoint.lat
      lng: startingPoint.lng
    map = new (google.maps.Map)(document.getElementById('map'),
      zoom: 17
      center: center
      disableDefaultUI: true)
    marker = new (google.maps.Marker)(
      position: center
      map: map)
    return
  
  updateMap = (checkin) ->
    console.log 'updating map'
    center = 
      lat: startingPoint.lat
      lng: startingPoint.lng
    map = new (google.maps.Map)(document.getElementById('map'),
      zoom: 17
      center: center)
    marker = new (google.maps.Marker)(
      position: center
      map: map)

    flightPath = new (google.maps.Polyline)(
      path: [new google.maps.LatLng(startingPoint.lat, startingPoint.lng), new google.maps.LatLng(checkin.lat, checkin.lng)],
      strokeColor: '#FF0000'
      strokeOpacity: 1.0
      strokeWeight: 2)
    flightPath.setMap map

    setTimeout(getCurrentLocation, 5000)
    return

  updateCurrentLocation = (tripData, id) ->
    token = $('meta[name="csrf-token"]').attr('content')
    $.ajax
      url: "/trips/#{id}/checkins"
      type: 'post'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', token
        return
      data: tripData
      success: (response) ->
        updateMap response
        return
    return

  getCurrentLocation = ->
    console.log 'getting current location'
    navigator.geolocation.getCurrentPosition (position) ->
      data =
        lat: position.coords.latitude,
        lng: position.coords.longitude
      updateCurrentLocation(data, tripId)
    return


  # if location.pathname.startsWith('/trips')
  #   userLocation =
  #     lat: $('#lat').val(),
  #     lng: $('#lng').val()
  #   initMap userLocation
  #   newLoc =
  #     lat: 6.571336,
  #     lng: 3.3694995
  #   updateMap(userLocation, newLoc)
