<template>
  <v-row v-if="video.name">
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

        <v-dialog v-model="dialog" persistent max-width="600px">
          <template v-slot:activator="{ on, attrs }">
            <v-btn v-bind="attrs" color="primary" :loading="isProcessing" v-on="on" @click="setVideo">
              <v-icon left>mdi-movie-filter-outline</v-icon>
              Analyze
            </v-btn>
          </template>
          <v-card>
            <v-card-title>
              <span class="headline">Video files to Analyze</span>
            </v-card-title>
            <v-card-text>
              <v-container>
                <div class="font-weight-bold">
                  {{ video.name }}
                </div>

                <v-file-input
                  class="mt-6"
                  placeholder=".wav"
                  accept="audio/wav"
                  label="Audio file"
                  outlined
                  dense
                  prepend-icon="mdi-waveform"
                ></v-file-input>

                <v-file-input
                  class="mt-6"
                  placeholder=".textgrid"
                  accept="textgrid"
                  label="Transcription file"
                  outlined
                  dense
                  prepend-icon="mdi-format-letter-starts-with"
                ></v-file-input>
                <v-file-input
                  class="mt-6"
                  placeholder=".textgrid"
                  accept="textgrid"
                  label="Silences file"
                  outlined
                  dense
                  prepend-icon="mdi-account-voice"
                ></v-file-input>
                <v-file-input
                  class="mt-6"
                  placeholder=".txt"
                  accept="txt"
                  label="Topics"
                  outlined
                  dense
                  prepend-icon="mdi-shape"
                ></v-file-input>
              </v-container>
              <small>*complement files for the video </small>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="dialog = false"> Close </v-btn>
              <v-btn
                color="blue darken-1"
                text
                @click="
                  dialog = false
                  isProcessing = true
                "
              >
                Save
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>

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
  data() {
    return {
      dialog: true,
    }
  },
  methods: {
    // save selected video in vuex store
    setVideo() {
      this.$emit('onAnaliseVideo', this.video)
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
