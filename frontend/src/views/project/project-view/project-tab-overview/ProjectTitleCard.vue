<template>
  <v-card class="greeting-card">
    <v-row class="ma-0 pa-0">
      <v-col cols="8">
        <v-card-title class="text-no-wrap pt-1 ps-2">
          {{ $t('Welcome to the Project') }}
        </v-card-title>

        <v-card-text class="d-flex align-center mt-2 pb-2 ps-2">
          <div class="mr-2">
            {{ $t('Project Name') }}
          </div>
          <div class="text-xl font-weight-semibold primary--text">
            {{ title }}
          </div>
        </v-card-text>
        <v-card-text class="d-flex align-center mt-2 pb-2 ps-2">
          <div class="mr-2">
            {{ $t('Current Sprint') }}
          </div>
          <div class="text-xl font-weight-semibold primary--text">
            {{ sprintTitle }}
          </div>
        </v-card-text>
      </v-col>

      <v-col cols="4">
        <v-img
          height="180"
          width="159"
          :src="require(`@/assets/images/misc/triangle-${$vuetify.theme.dark ? 'dark' : 'light'}.png`)"
          class="greeting-card-bg"
        ></v-img>
        <v-img height="108" max-width="83" class="greeting-card-trophy" src="@/assets/images/misc/trophy.png"></v-img>
      </v-col>
    </v-row>
  </v-card>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      default: '',
    },
    sprintTitle: {
      type: String,
      default: '',
    },
  },
}
</script>

<style lang="scss" scoped>
.greeting-card {
  position: relative;

  .greeting-card-bg {
    position: absolute;
    bottom: 0;
    right: 0;
  }

  .greeting-card-trophy {
    position: absolute;
    bottom: 10%;
    right: 8%;
  }
}

// rtl
.v-application {
  &.v-application--is-rtl {
    .greeting-card-bg {
      right: initial;
      left: 0;
      transform: rotateY(180deg);
    }

    .greeting-card-trophy {
      left: 8%;
      right: initial;
    }
  }
}
</style>
