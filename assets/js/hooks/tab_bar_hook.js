export const TabBarHook = {
  mounted() {
    this.updateActiveState();
    this.handleEvent("lv:page-focus", () => this.updateActiveState());
  },

  updated() {
    this.updateActiveState();
  },

  getTabBarItems() {
    return Array.from(this.el.querySelectorAll('[data-slot="tab-bar-item"]'));
  },

  updateActiveState() {
    const activePath = this.el.dataset.activePath;
    this.getTabBarItems().forEach(item => {
      const itemPath = new URL(item.href).pathname;
      const isActive = itemPath === activePath;
      if (isActive) {
        item.dataset.active = "true";
        item.setAttribute("aria-current", "page");
      } else {
        item.dataset.active = "false";
        item.removeAttribute("aria-current");
      }
    });
  }
};