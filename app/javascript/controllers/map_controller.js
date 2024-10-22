import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    const map = new mapboxgl.Map({
      container: this.element,  // The container is still dynamically the current element
      style: "mapbox://styles/mapbox/streets-v12",
      center: [-0.12,51.51], // starting position
      zoom: 2 // starting zoom

    });

    // Add markers to the map and fit to bounds
    this.#addMarkersToMap(map);  // Pass the map instance as an argument
    this.#fitMapToMarkers(map);  // Pass the map instance as an argument
  }

  #addMarkersToMap(map) {
    this.markersValue.forEach((marker) => {
      const customMarker = document.createElement('div')
      customMarker.style.height = "30px"
      customMarker.style.width = "30px"
      customMarker.style.backgroundImage =`url('${marker.image_url}')`
      customMarker.style.backgroundSize = "contain"
      const popup = new mapboxgl.Popup().setHTML(marker.info_window)
      new mapboxgl.Marker({element: customMarker})
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        // .addTo(this.map)
        .addTo(map)
    })
  }

  #fitMapToMarkers(map) {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 100, maxZoom: 15, duration: 10 })
  }
}
