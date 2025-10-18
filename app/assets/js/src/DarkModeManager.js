
export default class DarkModeManager {
  constructor() {
    this.mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
    this.init();
  }

  init() {
    this.updateDarkMode();
    this.watchSystemPreference();
  }

  updateDarkMode() {
    if (this.mediaQuery.matches) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  }

  watchSystemPreference() {
    this.mediaQuery.addEventListener('change', () => {
      this.updateDarkMode();
    });
  }
}
