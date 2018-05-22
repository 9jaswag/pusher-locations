# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready =>
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
        url = """#{window.location.protocol}//#{window.location.host}/trips/#{response.uuid}"""
        initMap response
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
          long: coord.longitude,
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
      lng: Number location.long
    map = new (google.maps.Map)(document.getElementById('map'),
      zoom: 16
      center: center)
    marker = new (google.maps.Marker)(
      position: center
      map: map)
    return

  if location.pathname.startsWith('/trips')
    userLocation =
      lat: $('#lat').val(),
      long: $('#long').val()
    initMap userLocation
