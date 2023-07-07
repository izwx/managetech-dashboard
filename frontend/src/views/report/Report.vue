<template>
  <v-row>
    <v-col cols="4">
      <company-report></company-report>
    </v-col>
    <v-col cols="4">
      <project-report></project-report>
    </v-col>
    <v-col cols="4">
      <developer-report></developer-report>
    </v-col>
  </v-row>
</template>

<script>
import CompanyReport from './CompanyReport.vue'
import ProjectReport from './ProjectReport.vue'
import DeveloperReport from './DeveloperReport.vue'
export default {
  components: {
    CompanyReport,
    ProjectReport,
    DeveloperReport,
  },
}
</script>
