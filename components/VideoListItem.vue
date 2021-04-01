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
              <span class="headline">Video files to attach</span>
            </v-card-title>
            <v-card-text>
              <v-container>
                <div class="font-weight-bold">
                  {{ video.name }}
                </div>
                <v-form v-model="valid">
                  <v-file-input
                    v-moddel="audioFile"
                    required
                    :rules="[(v) => !!v || 'Item is required']"
                    class="mt-6"
                    placeholder=".wav"
                    accept="audio/wav"
                    label="Audio file"
                    outlined
                    dense
                    prepend-icon="mdi-waveform"
                  ></v-file-input>

                  <v-file-input
                    v-moddel="transcriptionFile"
                    required
                    :rules="[(v) => !!v || 'Item is required']"
                    class="mt-6"
                    placeholder=".textgrid"
                    accept="textgrid"
                    label="Transcription file"
                    outlined
                    dense
                    prepend-icon="mdi-format-letter-starts-with"
                  ></v-file-input>
                  <v-file-input
                    v-moddel="silencesFile"
                    :rules="[(v) => !!v || 'Item is required']"
                    required
                    class="mt-6"
                    placeholder=".textgrid"
                    accept="textgrid"
                    label="Silences file"
                    outlined
                    dense
                    prepend-icon="mdi-account-voice"
                  ></v-file-input>
                  <v-file-input
                    v-moddel="topicsFile"
                    required
                    :rules="[(v) => !!v || 'Item is required']"
                    class="mt-6"
                    placeholder=".txt"
                    accept="txt"
                    label="Topics"
                    outlined
                    dense
                    prepend-icon="mdi-shape"
                  ></v-file-input>
                </v-form>
              </v-container>
              <small>*complement files for the video </small>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="dialog = false"> Cancel </v-btn>
              <v-btn
                color="primary"
                depressed
                @click="
                  dialog = false
                  isProcessing = true
                "
              >
                Analyze
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
        <v-btn text @click="triggerCWL"> Trigger CWL</v-btn>
        <div>{{ cwlState }}</div>
        <div v-if="isProcessing" class="light-blue--text ml-4">
          The video is processing. It may take several minutes to complete. You can can come later to this list.
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
      dialog: false,
      audioFile: null,
      transcriptionFile: null,
      silencesFile: null,
      topicsFile: null,
      cwlState: null,
    }
  },
  methods: {
    async triggerCWL() {
      const headers = {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        'api-key': 'in1uP28Y1Et9YGp95VLYzhm5Jgd5M1r0CKI7326RHwbVcHGa',
      }

      const response = await fetch('http://localhost:8080/jobs', {
        method: 'POST',
        headers,
        body: JSON.stringify({
          name: this.video.name,
          workflow: 'cwl/sleep.cwl',
          input: { time: '3s' },
        }),
      })
      const data = await response.json()

      const statusInterval = setInterval(async () => {
        const statusResponse = await fetch(data.uri, {
          method: 'GET',
          headers,
        })
        const dataStatus = await statusResponse.json()
        console.log('🎹this is the one to multiply', dataStatus)
        this.cwlState = dataStatus.state
        if (dataStatus.state === 'Success') {
          clearInterval(statusInterval)
        }
      }, 1000)
    },
    // save selected video in vuex store
    setVideo() {
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
