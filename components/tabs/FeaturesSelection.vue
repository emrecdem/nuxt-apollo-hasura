<template>
  <div>
    <v-chip-group v-model="selectedFeatures" column multiple>
      <div v-for="(feature, index) in featureNames" :key="index">
        <v-tooltip bottom transition="none" :disabled="!feature.label">
          <template #activator="{ on }">
            <v-chip filter outlined :value="feature.label" v-on="on">
              {{ feature.description ? feature.description : feature.label }}
            </v-chip>
          </template>
          <span>{{ feature.label }}</span>
        </v-tooltip>
      </div>
    </v-chip-group>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: {
    ...mapGetters({
      activeFeatures: 'features/getActiveFeatures',
    }),
    featureNames() {
      return this.$store.state.features.featureNames
    },
    selectedFeatures: {
      get() {
        return this.$store.state.features.selectedFeatures
      },
      set(selectedFeatures) {
        this.$store.commit('features/UPDATE_SELECTED_FEATURES', selectedFeatures)
      },
    },
  },
}
</script>
