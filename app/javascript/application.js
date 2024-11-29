// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import SlimSelect from "slim-select";

// Make SlimSelect available globally for the Stimulus controller
window.SlimSelect = SlimSelect;
