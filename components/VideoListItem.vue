<template>
  <v-row>
    <v-col cols="3">
      <transition name="fade">
        <video v-if="video.src" :src="video.src" width="100%" height="140" controls></video>
      </transition>
    </v-col>
    <v-col cols="8">
      <div class="font-weight-bold">{{ video.name }}</div>
      <div class="caption grey--text">Sha256: {{ video.hash }}</div>
      <div class="caption grey--text">src: {{ video.src }}</div>
      <div class="d-flex mt-6">
        <!--              There is no data on the server about this video:-->
        <v-btn color="primary" :loading="isProcessing" @click="setVideo">
          <v-icon left>mdi-movie-filter-outline</v-icon>
          Analyze
        </v-btn>
        <div v-if="isProcessing" class="light-blue--text ml-4">
          The video is processing. It may take several minutes to complete. <br />You can can come later to this list.
        </div>
      </div>
    </v-col>
    <v-col cols="1">
      <v-btn v-if="!isProcessing" icon color="#aaa" @click="$emit('removeVideo')">
        <v-icon> mdi-close </v-icon>
      </v-btn>
    </v-col>
  </v-row>
</template>
<script>
export default {
  name: 'VideoListItem',
  props: {
    video: { type: Object, default: () => ({}) },
    isProcessing: { type: Boolean, default: false },
  },
  methods: {
    // save selected video in vuex store
    setVideo() {
      // Navigate to the screen if the video is not being processed
      if (!this.isProcessing) {
        this.$router.push({ name: 'erd', query: { video: this.video.id } })
        this.$store.dispatch('videos/selectVideo', this.$props.video)
      }

      this.$emit('onAnaliseVideo')
    },
  },
}
</script>

<style>
video.video {
  width: 100%;
}

video {
  background-color: black;
  border-radius: 8px;
  outline: none;
}
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}
</style>
