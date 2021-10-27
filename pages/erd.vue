<template>
  <v-container fluid>
    <v-row style="max-width: 1320px; margin: 0 auto">
      <v-col sm="6" cols="12">
        <tabs />
      </v-col>
      <v-col sm="6" cols="12">
        <video-player />
      </v-col>
    </v-row>
    <v-row>
      <v-col sm="2" cols="12" style="overflow: hidden" class="order-2 order-sm-1">
        <v-switch v-model="normalization" inset dense label="Normalize" />
        <HeatmapD3TopicsLegend />
        <HeatmapD3GradientLegend v-if="!normalization"></HeatmapD3GradientLegend>
        <HeatmapD3DivergingLegend v-if="normalization"></HeatmapD3DivergingLegend>
        <HeatmapD3BinaryLegend />
      </v-col>
      <v-col sm="10" cols="12" class="order-1">
        <HeatmapD3HeatMap :normalization="normalization" />
      </v-col>
    </v-row>
    <v-row justify="end">
      <v-btn v-on:click="exportCSV">Export to CSV</v-btn>
    </v-row>
  </v-container>
</template>

<script>
import get_feature_names from '~/apollo/get_feature_names.gql'
import get_video_metadata from '~/apollo/get_video_metadata'

export default {
  data() {
    return {
      reveal: false,
      isPlaying: false,
      cursor: 0,
      featureNames: [],
      normalization: true,
      video_metadata: {}
    }
  },
  computed: {
    defaultEnabledFeatures() {
      return this.$store.state.features.selectedFeatures
    },
    selectedFeatures() {
      return this.featureNames?.filter((filed) => filed.active)
    },
    featureNamesStore() {
      return this.$store.state.features.featureNames
    },
    video_hash() {
      // Retrieve selected video from vuex store
      return this.$store.state.videos.selectedVideo?.hash
    },
  },
  apollo: {
    get_feature_names: {
      query: get_feature_names,
      result({ data, loading, networkStatus }) {
        if (data && data.get_feature_names) {
          const featureNames = data.get_feature_names.fields
            .map((field) => ({
              label: field.name,
              active: this.defaultEnabledFeatures.includes(field.name),
              description: field.description,
            }))
            .filter((filed) => {
              return filed.label !== 'grouped_seconds' && filed.label !== 'min_timestamp'
            })
          this.featureNames = featureNames
          this.$store.commit('features/UPDATE_FEATURES_NAME', this.featureNames)
        }
      },
      error(error) {
        this.error = JSON.stringify(error.message)
      },
    },
    videoMetadata: {
      variables() {
        return {
          hash: this.video_hash,
        }
      },
      query: get_video_metadata,
      result({ data }) {
        if (data) {
          this.video_metadata = data.videoMetadata[0]
        }
      },
      error(error) {
        this.error = JSON.stringify(error.message)
        console.error('Error', this.error)
      },
    },
  },
  methods: {
    play() {
      this.$refs.myvideo.play()
      this.isPlaying = true
    },
    stop() {
      this.$refs.myvideo.pause()
      this.isPlaying = false
    },
    exportCSV() {
      const url = `https://emo-spectre.sharkwing.com/output/job-${this.video_metadata.job_id}/output.csv`
      const options = {
        headers: {
          'api-key': this.$config.xenonAPIKey,
        }
      };
      fetch(url, options)
        .then(res => res.blob())
        .then(blob => URL.createObjectURL(blob))
        .then(href => {
          Object.assign(document.createElement('a'), {
            href,
            download: 'output.csv'
          }).click();
        });
    }
  },
}
</script>
