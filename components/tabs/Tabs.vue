<template>
  <v-card outlined max-height="350">
    <v-tabs v-model="tab">
      <v-tab>Info</v-tab>
      <v-tab>Features</v-tab>
    </v-tabs>
    <v-card-text style="height: 300px; overflow: auto">
      <v-tabs-items v-model="tab">
        <v-tab-item>
          <TabsInfo />
        </v-tab-item>
        <v-tab-item>
          <TabsFeaturesSelection />
        </v-tab-item>
      </v-tabs-items>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  computed: {
    selectedFeatures() {
      return this.$store.state.features.selectedFeatures
    },
    tab: {
      get() {
        return this.$store.state.general.selectedTab
      },
      set(value) {
        this.$store.commit('general/SELECTED_TAB', value)
      },
    },
  },
}
</script>

<style scoped></style>
