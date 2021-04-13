<template>
  <div>
    <v-dialog v-model="exportDialog" scrollable max-width="800">
      <template v-slot:activator="{ on, attrs }">
        <v-btn color="primary" v-bind="attrs" v-on="on"> {{ title }} </v-btn>
      </template>
      <v-card>
        <v-card-title>
          <span class="headline">Export Features</span>
        </v-card-title>
        <v-card-text>
          <div class="body-1 mt-4">Aggregates to export for each topic (select multiple):</div>
          <div class="d-flex">
            <div v-for="(column, index) in columns" :key="index" class="col">
              <v-checkbox
                v-for="(item, id) in column"
                :key="id"
                v-model="selected"
                :label="item"
                :value="item"
                hide-details
              ></v-checkbox>
            </div>
          </div>
          <div class="body-1 mt-8 mb-4">Options for duration, occurrence and frequency:</div>
          <v-row class="pl-5">
            <v-col sm="4" cols="12">
              <v-text-field v-model="threshold" label="Threshold" clearable placeholder="Enter value here" />
            </v-col>
            <v-col sm="4" cols="12">
              <v-text-field
                v-model="minimumDuration"
                label="Minimum duration"
                clearable
                placeholder="Enter value here"
              />
            </v-col>
          </v-row>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="exportDialog = false"> Close </v-btn>
          <v-btn color="primary" @click="exportToCSV">Export To CSV</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>
<script>
export default {
  name: 'ExportButton',
  props: {
    title: { type: String, default: () => '' },
  },
  data() {
    return {
      exportOptions: [
        'Mean',
        'Standard deviation',
        'Z-score',
        'Duration',
        'Relative duration',
        'Occurrence count',
        'Frequency (relative occurrence)',
      ],
      selected: [],
      exportDialog: false,
      cols: 2,
      minimumDuration: '',
      threshold: '',
    }
  },
  computed: {
    columns() {
      const columns = []
      const mid = Math.ceil(this.exportOptions.length / this.cols)
      for (let col = 0; col < this.cols; col++) {
        columns.push(this.exportOptions.slice(col * mid, col * mid + mid))
      }
      return columns
    },
  },
  methods: {
    exportToCSV() {
      this.exportDialog = false
      // todo
      console.log('Selected Options', this.selected, this.minimumDuration, this.threshold)
    },
  },
}
</script>
