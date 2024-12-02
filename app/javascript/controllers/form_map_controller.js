import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["map", "select", "error"];

  connect() {
    this.markers = new Map(); // Store markers by station ID
    this.initializeMap();
    this.setupSelectListener();
    // Initialize markers for pre-selected stations
    this.updateMapForSelectedStations();
  }

  initializeMap() {
    this.map = L.map(this.mapTarget);

    // Add OpenStreetMap tiles
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      maxZoom: 19,
      attribution: "© OpenStreetMap contributors",
    }).addTo(this.map);

    // Set default view to Paris
    this.map.setView([48.8566, 2.3522], 11);
  }

  setupSelectListener() {
    this.selectTarget.addEventListener("change", () => {
      this.updateMapForSelectedStations();
      // Hide error when user makes a new selection
      this.hideError();
    });

    // Prevent form submission if validation fails
    const form = this.element.querySelector("form");
    if (form) {
      form.addEventListener("submit", (e) => {
        if (!this.isValid()) {
          e.preventDefault();
          this.showError();
        }
      });
    }
  }

  isValid() {
    return this.selectTarget.selectedOptions.length >= 2;
  }

  showError() {
    if (this.hasErrorTarget) {
      this.errorTarget.classList.remove("hidden");
    }
  }

  hideError() {
    if (this.hasErrorTarget) {
      this.errorTarget.classList.add("hidden");
    }
  }

  updateMapForSelectedStations() {
    if (!this.map) return;

    const selectedOptions = Array.from(this.selectTarget.selectedOptions);
    const selectedIds = new Set(selectedOptions.map((opt) => opt.value));

    // Remove markers for unselected stations
    for (const [stationId, marker] of this.markers.entries()) {
      if (!selectedIds.has(stationId)) {
        this.map.removeLayer(marker);
        this.markers.delete(stationId);
      }
    }

    // Add markers for newly selected stations
    const promises = selectedOptions
      .filter((opt) => !this.markers.has(opt.value))
      .map((opt) => this.addMarkerForStation(opt.value));

    // After all markers are added, fit bounds
    Promise.all(promises).then(() => {
      if (this.markers.size > 0) {
        const bounds = Array.from(this.markers.values()).map((marker) =>
          marker.getLatLng()
        );
        this.map.fitBounds(bounds, { padding: [50, 50] });
      }
    });
  }

  addMarkerForStation(stationId) {
    return fetch(`/stations/${stationId}.json`)
      .then((response) => response.json())
      .then((station) => {
        const icon = L.divIcon({
          className:
            "bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500 w-6 h-6 rounded-full border-2 border-white shadow-lg",
          iconSize: [24, 24],
          iconAnchor: [12, 12],
        });

        const marker = L.marker([station.latitude, station.longitude], {
          icon: icon,
        })
          .bindPopup(`<b>${station.name}</b><br>${station.city}`)
          .addTo(this.map);

        this.markers.set(stationId, marker);
      });
  }
}
