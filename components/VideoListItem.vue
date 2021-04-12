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
      <!--              There is no data on the server about this video:-->
      <v-dialog v-model="dialog" persistent max-width="600px">
        <template v-slot:activator="{ on, attrs }">
          <v-btn v-bind="attrs" color="warning" :loading="isProcessing" v-on="on" @click="setVideo">
            <v-icon left>mdi-movie-filter-outline</v-icon>
            Upload Video files || View Details
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

              <v-form ref="form" v-model="valid" lazy-validation>
                <v-select
                  v-model="pitch"
                  item-text="name"
                  item-value="value"
                  class="mt-6 ml-8"
                  dense
                  :items="[
                    { name: 'High pitch', value: 'woman' },
                    { name: 'Low pitch', value: 'man' },
                  ]"
                  label="Pitch frequency"
                  outlined
                  required
                ></v-select>

                <v-file-input
                  v-model="audioFile"
                  required
                  :rules="[(v) => !!v || 'Item is required']"
                  placeholder=".wav"
                  accept="audio/wav"
                  label="Audio file"
                  outlined
                  dense
                  prepend-icon="mdi-file-music-outline"
                ></v-file-input>

                <v-file-input
                  v-model="transcriptionFile"
                  required
                  :rules="[(v) => !!v || 'Item is required']"
                  placeholder=".textgrid"
                  accept="textgrid"
                  label="Transcription file"
                  outlined
                  dense
                  prepend-icon="mdi-file-document-outline"
                ></v-file-input>
                <v-file-input
                  v-model="silencesFile"
                  :rules="[(v) => !!v || 'Item is required']"
                  required
                  placeholder=".textgrid"
                  accept="textgrid"
                  label="Silences file"
                  outlined
                  dense
                  prepend-icon="mdi-file-document-outline"
                ></v-file-input>
                <v-file-input
                  v-model="topicsFile"
                  required
                  :rules="[(v) => !!v || 'Item is required']"
                  placeholder=".txt"
                  accept="txt"
                  label="Topics"
                  outlined
                  dense
                  prepend-icon="mdi-file-document-outline"
                ></v-file-input>
              </v-form>
            </v-container>
            <small>*complement files for the video </small>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue darken-1" text @click="resetValidation"> Cancel </v-btn>
            <v-btn color="primary" depressed @click="validateForm"> Analyze </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
      <v-btn text @click="triggerCWL"> Trigger CWL</v-btn>
      <div>{{ cwlState }}</div>

      <div v-if="cwlState === 'SystemError'" @click="openLogFile">
        <v-dialog v-model="logDialog" width="900px" scrollable>
          <template v-slot:activator="{ on, attrs }">
            <v-btn color="error" dark v-bind="attrs" small v-on="on" @click="openLogFile"> See log file </v-btn>
          </template>
          <v-card>
            <v-card-title>
              <span class="headline">Log file</span>
            </v-card-title>
            <v-card-text>
              <pre>{{ logText }}</pre>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn text @click="logDialog = false"> return </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </div>
      <div v-if="isProcessing" class="light-blue--text ml-4">
        The video is processing. It may take several minutes to complete. You can can come later to this list.
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
import config from '~/nuxt.config'
const NUXT_XENON_API_KEY = config.publicRuntimeConfig.xenonAPIKey

const headers = {
  Accept: 'application/json',
  'Content-Type': 'application/json',
  'api-key': NUXT_XENON_API_KEY,
}

export default {
  name: 'VideoListItem',
  props: {
    video: { type: Object, default: () => ({}) },
  },
  data() {
    return {
      valid: true,
      dialog: false,
      audioFile: null,
      transcriptionFile: null,
      silencesFile: null,
      topicsFile: null,
      pitch: '',
      cwlState: null,
      dataStatus: null,
      logDialog: false,
      logText: '',
    }
  },
  computed: {
    isProcessing() {
      return this.cwlState === 'Running' || this.cwlState === 'Waiting'
    },
  },
  methods: {
    async openLogFile() {
      const response = await fetch(this.dataStatus.log, {
        method: 'GET',
        headers,
      })
      this.logText = await response.json()
    },
    async validateForm() {
      await this.$refs.form.validate()
      if (this.$refs.form.value) {
        this.dialog = false
        this.triggerCWL()
      }
    },
    resetValidation() {
      this.dialog = false
      this.$refs.form.resetValidation()
    },
    async triggerCWL() {
      /**
       * Upload files to the server
       */

      // CONTINUE HERE: IT DOESNT UPLOAD THE FILES YET
      const formdata = new FormData()
      formdata.append(this.audioFile.name, this.audioFile, this.audioFile.name)
      formdata.append(this.transcriptionFile.name, this.transcriptionFile, this.transcriptionFile.name)
      formdata.append(this.silencesFile.name, this.silencesFile, this.silencesFile.name)
      formdata.append(this.topicsFile.name, this.topicsFile, this.topicsFile.name)

      const requestOptions = {
        method: 'POST',
        body: formdata,
        redirect: 'follow',
      }

      fetch('http://localhost:7000/upload', requestOptions)
        .then((response) => response.text())
        .then((result) => console.log(result))
        .catch((error) => console.log('⛔️ error', error))

      /**
       * Trigger CWL workflow
       */
      const response = await fetch('http://localhost:9050/jobs', {
        method: 'POST',
        headers,
        body: JSON.stringify({
          name: this.video.name,
          workflow: 'copy.cwl', // TODO change for the correct CWL
          input: {
            name: 'It is my second',
            workflow: 'copy.cwl',
            input: {
              audio: {
                class: 'File',
                path: this.audioFile,
              },
              transcription: {
                class: 'File',
                path: this.transcriptionFile,
              },
              silence: {
                class: 'File',
                path: this.silencesFile,
              },
              topics: {
                class: 'File',
                path: this.topicsFile,
              },
              gender: this.pitch, // 'man', 'woman'
            },
          },
        }),
      })
      const data = await response.json()

      const statusInterval = setInterval(async () => {
        const statusResponse = await fetch(data.uri, { method: 'GET', headers })
        this.dataStatus = await statusResponse.json()
        this.cwlState = this.dataStatus.state
        if (this.dataStatus.state === 'Success' || this.dataStatus.state === 'SystemError') {
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
pre {
  white-space: pre-wrap; /* Since CSS 2.1 */
  white-space: -moz-pre-wrap; /* Mozilla, since 1999 */
  white-space: -pre-wrap; /* Opera 4-6 */
  white-space: -o-pre-wrap; /* Opera 7 */
  word-wrap: break-word; /* Internet Explorer 5.5+ */
}
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
