import "../css/app.css";

import "idiomorph"


// Live reload client
(async function () {
  let lastModified = Date.now();

  async function checkForChanges() {
    try {
      const response = await fetch('/__live_reload__');
      const data = await response.json();

      if (data.modified > lastModified) {
        console.log('[Live Reload] Changes detected, morphing...');
        try {
          const html = await (await fetch(window.location.href)).text();
          Idiomorph.morph(document.documentElement, html);
        } catch (e) {
          console.error(e);
          window.location.reload();
        }
      }
      lastModified = data.modified;
    } catch (err) {
      console.error('[Live Reload] Error checking for changes:', err);
    }
  }

  // Check every 3 seconds
  setInterval(checkForChanges, 3000);
  console.log('[Live Reload] Watching for asset changes...');
})();
