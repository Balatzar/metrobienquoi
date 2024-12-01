import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    station: Object,
    connections: Array,
  };

  connect() {
    this.initializeMap();
  }

  initializeMap() {
    // Create map
    this.map = L.map(this.element);

    // Add OpenStreetMap tiles
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      maxZoom: 19,
      attribution: "© OpenStreetMap contributors",
    }).addTo(this.map);

    // Add marker for winning station with custom icon
    const winningIcon = L.divIcon({
      className:
        "bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500 w-6 h-6 rounded-full border-2 border-white shadow-lg",
      iconSize: [24, 24],
      iconAnchor: [12, 12],
    });

    L.marker([this.stationValue.latitude, this.stationValue.longitude], {
      icon: winningIcon,
    })
      .bindPopup(
        `<b>${this.stationValue.name}</b><br>${this.stationValue.city}`
      )
      .addTo(this.map);

    // Add markers for connections with custom icon
    const connectionIcon = L.divIcon({
      className:
        "bg-gradient-to-r from-indigo-400 to-purple-400 w-6 h-6 rounded-full border-2 border-white shadow-lg",
      iconSize: [24, 24],
      iconAnchor: [12, 12],
    });

    this.connectionsValue.forEach((connection) => {
      L.marker([connection.latitude, connection.longitude], {
        icon: connectionIcon,
      })
        .bindPopup(`<b>${connection.name}</b><br>${connection.city}`)
        .addTo(this.map);
    });

    // Fit bounds to show all markers
    const bounds = [
      [this.stationValue.latitude, this.stationValue.longitude],
      ...this.connectionsValue.map((c) => [c.latitude, c.longitude]),
    ];
    this.map.fitBounds(bounds, { padding: [50, 50] });
  }
}
