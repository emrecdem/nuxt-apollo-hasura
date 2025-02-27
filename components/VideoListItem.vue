<template>
  <v-row v-if="video.name">
    <v-col cols="3">
      <transition name="fade">
        <video v-if="video.src" :src="video.src" width="100%" height="140" controls></video>
      </transition>
    </v-col>
    <v-col cols="8">
      <div class="font-weight-bold">{{ video.name }}</div>
      <!--              There is no data on the server about this video:-->
      <v-btn v-if="videoHashes.includes(video.hash)" class="mt-4" color="primary" @click="setVideo()"
        >Explore video</v-btn
      >
      <v-dialog v-else v-model="dialog" persistent max-width="600px">
        <template v-slot:activator="{ on, attrs }">
          <v-btn class="mt-4" v-bind="attrs" color="warning" :loading="isProcessing" v-on="on">
            <v-icon left>mdi-movie-filter-outline</v-icon>
            Select additional files and analyze
          </v-btn>
        </template>
        <v-card>
          <v-card-title>
            <span class="headline">Additional files and parameters</span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <div class="font-weight-bold">
                {{ video.name }}
              </div>

              
              <v-form ref="form" v-model="valid" lazy-validation>
                <v-select
                  v-model="language"
                  item-text="name"
                  item-value="value"
                  class="mt-6 ml-8"
                  dense
                  :items="[
                    { name: 'English', value: 'en' },
                    { name: 'Dutch', value: 'nl' },
                  ]"
                  label="Language"
                  :rules="[(v) => !!v || 'Item is required']"
                  outlined
                  required
                ></v-select>
                
                <v-select
                  v-model="pitch"
                  item-text="name"
                  item-value="value"
                  class="mt-6 ml-8"
                  dense
                  :items="[
                    { name: 'High pitch voice', value: 'vrouw' },
                    { name: 'Low pitch voice', value: 'man' },
                  ]"
                  label="Voice pitch"
                  :rules="[(v) => !!v || 'Item is required']"
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
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue darken-1" text @click="resetValidation"> Cancel </v-btn>
            <v-btn color="primary" depressed @click="validateForm"> Analyze </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
      <!--      <v-btn text @click="triggerCWL"> Trigger CWL</v-btn>-->
      <div>{{ cwlState }}</div>

      <div v-if="cwlState === 'SystemError' || cwlState === 'PermanentFailure'" @click="openLogFile">
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
        The video is processing, which might take up to 30 minutes.
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
    videoHashes: { type: Array, default: () => [] },
  },
  data() {
    return {
      valid: true,
      dialog: false,
      audioFile: null,
      transcriptionFile: null,
      silencesFile: null,
      topicsFile: null,
      language: '',
      pitch: '',
      cwlState: null,
      dataStatus: null,
      logDialog: false,
      logText: '',
      jobID: '',
    }
  },
  computed: {
    headers() {
      return {
        'Content-Type': 'application/json',
        'api-key': this.$config.xenonAPIKey,
      }
    },
    isProcessing() {
      return this.cwlState === 'Running' || this.cwlState === 'Waiting' || this.cwlState === 'Uploading'
    },
  },
  methods: {
    async openLogFile() {
      const response = await fetch(`/jobs/${this.jobID}/log`, {
        method: 'GET',
        headers: this.headers,
      })
      this.logText = await response.text()
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
      this.cwlState = 'Uploading' // not really a cwl state, but we already want to show something is happening during upload
      this.$forceUpdate();        // refresh the ui before we start uploading 

      const formdata = new FormData()
      const videoBlob = await fetch(this.video.src).then((r) => r.blob())
      formdata.append(this.video.name, videoBlob, this.video.name)
      formdata.append(this.audioFile.name, this.audioFile, this.audioFile.name)
      formdata.append(this.transcriptionFile.name, this.transcriptionFile, this.transcriptionFile.name)
      formdata.append(this.silencesFile.name, this.silencesFile, this.silencesFile.name)
      formdata.append(this.topicsFile.name, this.topicsFile, this.topicsFile.name)
      formdata.append('hash', this.video.hash)

      const requestOptions = {
        method: 'POST',
        body: formdata,
        redirect: 'follow',
      }
      await fetch('/upload', requestOptions)
        .then((response) => response.text())
        .then((result) => console.log(result))
        .catch((error) => console.log('⛔️ error', error))
      /**
       * Trigger CWL workflow
       */
      const response = await fetch('/jobs', {
        method: 'POST',
        headers: this.headers,
        body: JSON.stringify({
          name: 'job',
          workflow: 'workflow_single.cwl',
          input: {
            video: {
              class: 'File',
              path: this.video.hash + '/' + this.video.name,
            },
            audio: {
              class: 'File',
              path: this.video.hash + '/' + this.audioFile.name,
            },
            transcription: {
              class: 'File',
              path: this.video.hash + '/' + this.transcriptionFile.name,
            },
            silences: {
              class: 'File',
              path: this.video.hash + '/' + this.silencesFile.name,
            },
            topics: {
              class: 'File',
              path: this.video.hash + '/' + this.topicsFile.name,
            },
            gender: this.pitch, // 'man', 'vrouw'
            language: this.language, // en|nl
          },
        }),
      })
      const data = await response.json()

      this.jobID = data.uri.split('/').at(-1)

      const statusInterval = setInterval(async () => {
        const statusResponse = await fetch(`/jobs/${this.jobID}`, { method: 'GET', headers: this.headers })
        this.dataStatus = await statusResponse.json()
        this.cwlState = this.dataStatus.state
        if (
          this.dataStatus.state === 'Success' ||
          this.dataStatus.state === 'SystemError' ||
          this.dataStatus.state === 'Cancelled' ||
          this.dataStatus.state === 'PermanentFailure'
        ) {
          this.$emit('fetchVideoHashes')
          clearInterval(statusInterval)
        }
      }, 1000)
    },
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
