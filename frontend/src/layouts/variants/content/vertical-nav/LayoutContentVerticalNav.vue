<template>
  <layout-content-vertical-nav :nav-menu-items="menuItems">
    <slot></slot>

    <!-- Slot: Navbar -->
    <template #navbar="{ isVerticalNavMenuActive, toggleVerticalNavMenuActive }">
      <div
        class="navbar-content-container"
      >
        <!-- Left Content: Search -->
        <div class="d-flex align-center">
        </div>

        <!-- Right Content: I18n, Light/Dark, Notification & User Dropdown -->
        <div class="d-flex align-center right-row">
          <app-bar-i18n></app-bar-i18n>
          <app-bar-theme-switcher class="mx-4"></app-bar-theme-switcher>
          <app-bar-user-menu></app-bar-user-menu>
        </div>
      </div>
    </template>

    <!-- Slot: Footer -->
    <template #footer>
      <div class="d-flex justify-space-between">
        <span>COPYRIGHT &copy; {{ new Date().getFullYear() }} <a
          href="https://www.managetech.io/"
          class="text-decoration-none"
          target="_blank"
        >MANAGETECH.IO</a><span class="d-none d-md-inline">, All rights Reserved</span></span>
        <div class="align-center d-none d-md-flex">
          <span>Beta Version</span>
          <v-icon
            color="error"
            class="ms-2"
          >
            {{ icons.mdiHeartOutline }}
          </v-icon>
        </div>
      </div>
    </template>
  </layout-content-vertical-nav>
</template>

<script>
import LayoutContentVerticalNav from '@/@core/layouts/variants/content/vertical-nav/LayoutContentVerticalNav.vue'
import navMenuItems from '@/navigation/vertical'
import useVerticalMenu from '@/navigation/vertical/useVerticalMenu'

// App Bar Components
import AppBarSearch from '@core/layouts/components/app-bar/AppBarSearch.vue'
import AppBarI18n from '@core/layouts/components/app-bar/AppBarI18n.vue'
import AppBarThemeSwitcher from '@core/layouts/components/app-bar/AppBarThemeSwitcher.vue'
import AppBarUserMenu from '@core/layouts/components/app-bar/AppBarUserMenu.vue'
import AppBarNotification from '@core/layouts/components/app-bar/AppBarNotification.vue';
import { mdiMenu, mdiHeartOutline } from '@mdi/js';

export default {
  components: {
    LayoutContentVerticalNav,

    // App Bar Components
    AppBarSearch,
    AppBarI18n,
    AppBarThemeSwitcher,
    AppBarUserMenu,
    AppBarNotification,
  },
  setup() {

    const {menuItems} = useVerticalMenu()

    return {
      navMenuItems,
      menuItems,

      icons: {
        mdiMenu,
        mdiHeartOutline,
      },
    }
  },
}
</script>

<style lang="scss" scoped>
.navbar-content-container {
  height: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-grow: 1;
  position: relative;
}
</style>
