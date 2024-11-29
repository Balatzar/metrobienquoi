import { Controller } from "@hotwired/stimulus";
import SlimSelect from "slim-select";

export default class extends Controller {
  connect() {
    this.select = new SlimSelect({
      select: this.element,
      settings: {
        placeholderText: "Select stations",
        allowDeselect: true,
        closeOnSelect: false,
      },
    });
  }

  disconnect() {
    this.select.destroy();
  }
}
