import "../css/app.css";
import DarkModeManager from "./src/DarkModeManager.js";
import "@tailwindplus/elements";

// Initialize when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    new DarkModeManager();
  });
} else {
  new DarkModeManager();
}
