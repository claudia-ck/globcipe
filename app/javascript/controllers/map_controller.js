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
      style: "mapbox://styles/mapbox/streets-v12"
    });

    // Add markers to the map and fit to bounds
    this.#addMarkersToMap(map);  // Pass the map instance as an argument
    this.#fitMapToMarkers(map);  // Pass the map instance as an argument
  }

  #addMarkersToMap(map) {
    this.markersValue.forEach((marker) => {
      // Create a popup with the HTML content from the controller
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(map);  // Add marker to the specific map instance
    });
  }

  #fitMapToMarkers(map) {
    const bounds = new mapboxgl.LngLatBounds();
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));

    map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });  // Adjust view for the specific map instance
  }
}
