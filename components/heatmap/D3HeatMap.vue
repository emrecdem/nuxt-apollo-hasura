<template>
  <div v-if="activeFeatures" id="heatmapChart"></div>
</template>

<script>
import * as d3 from 'd3'
import { mapGetters } from 'vuex'
import aggregate_features from '~/apollo/aggregate_features'
import data_aggregate from '~/apollo/data_aggregate'
import end_time from '~/apollo/end_time'
import video_id from '~/apollo/video_id'
import get_topics from '~/apollo/get_topics'
export default {
  props: {
    features: { type: Array, default: () => [], required: false },
    normalization: { type: Boolean, default: () => false, required: false },
  },
  data() {
    return {
      svg: null,
      cursorLine: null,
      timeBins: null,
      cells: null,
      defs: null,
      y: null,
      x: null,
      yAxisGroup: null,
      xAxisGroup: null,
      cursorWidth: 10,
      videoId: -1,
      endTime: 0,
      startTime: 0,
      minResolution: 0.1,
      maxResolution: 4.0,
      resolution: 4.0,
      cellClipPath: null,
      currentZoomLevel: null,
      chartData: [],
      aggregateData: [],
      normalizationData: [],
      height: 600,
      width: 1000,
      margins: { top: 0, right: 20, bottom: 20, left: 50 },
      localCursor: 0,
      topics: [],
    }
  },
  computed: {
    ...mapGetters({
      activeFeatures: 'features/getActiveFeatures',
    }),
    cursor() {
      return this.$store.state.cursor.position
    },
    featuresNames() {
      return this.activeFeatures.map((feature) => feature.label)
    },
    video_hash() {
      // Retrieve selected video from vuex store
      return this.$store.state.videos.selectedVideo?.hash
    },
  },
  watch: {
    cursor(newPosition) {
      // Set new data (it must be an integer number)
      this.cursorLine?.data([newPosition]).enter()
      // Update attribute
      this.cursorLine.attr('x', (d) => {
        return this.cursorScale(d)
      })
    },
    normalization(newValue, oldValue) {
      if (oldValue !== newValue) {
        this.initializeChart()
      }
    },
    activeFeatures() {
      this.initializeChart()
      this.$apollo.queries.aggregate_features.refetch()
      this.$apollo.queries.data_aggregate.refetch()
    },
  },
  apollo: {
    video_id: {
      query: video_id,
      variables() {
        return {
          hash: this.video_hash,
        }
      },
      result({ data, loading, networkStatus }) {
        if (data) {
          this.videoId = data.video_id[0].id
        }
      },
      error(error) {
        this.error = JSON.stringify(error.message)
      },
    },

    end_time: {
      query: end_time,
      skip: ({ videoId }) => {
        return videoId === null
      },
      variables() {
        return {
          video: this.videoId,
        }
      },
      result({ data, loading, networkStatus }) {
        if (data) {
          this.endTime = Math.ceil(data.end_time.aggregate.max.timestamp)
        }
      },
      error(error) {
        this.error = JSON.stringify(error.message)
      },
    },

    topics: {
      variables() {
        return {
          video: this.videoId, // todo: select the current video
        }
      },
      skip: ({ videoId }) => {
        return videoId === null
      },
      query: get_topics,
      result({ data }) {
        if (data) {
          this.topics = data
        }
      },
    },

    aggregate_features: {
      // graphql query
      query: aggregate_features,
      skip: ({ endTime }) => {
        return endTime === 0
      },
      variables() {
        return {
          duration: this.endTime,
          hash: this.video_hash,
          resolution: this.resolution,
        }
      },
      result({ data, loading, networkStatus }) {
        if (data?.aggregate_features.length > 0) {
          this.aggregateData = data.aggregate_features
          if (this.chartData.length === 0) {
            this.initializeChart()
          } else {
            this.updateChart()
          }
        }
      },
      error(error) {
        console.error('🚨 Error in query aggregate_features:', error)
      },
    },

    data_aggregate: {
      // graphql query
      query: data_aggregate,
      skip: ({ videoId }) => {
        return videoId === null
      },
      variables() {
        return {
          video: this.videoId,
        }
      },
      result({ data, loading, networkStatus }) {
        if (data) {
          this.normalizationData = this.deUnderscore(data.data_aggregate.aggregate)
          this.initializeChart()
        }
      },
      error(error) {
        console.error('🚨 Error in query normalized_aggregate:', error)
      },
    },
  },
  mounted() {
    this.$nextTick(() => {
      this.width = this.$el.parentElement.clientWidth
      window.addEventListener('resize', this.onResize)
    })
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.onResize)
  },
  methods: {
    onResize() {
      this.$nextTick(() => {
        this.width = this.$el.parentElement.clientWidth
        this.initializeChart()
      })
    },
    initializeChart() {
      if (this.normalization && this.aggregateData?.length > 0 && this.normalizationData) {
        this.chartData = this.normalize(this.aggregateData, this.normalizationData)
      } else if (!this.normalization && this.aggregateData?.length > 0) {
        this.chartData = this.longify(this.aggregateData, this.normalizationData)
      } else {
        return
      }

      this.drawChart()
    },
    updateChart() {
      if (this.normalization && this.aggregateData?.length > 0 && this.normalizationData) {
        this.chartData = this.normalize(this.aggregateData, this.normalizationData)
      } else if (!this.normalization && this.aggregateData?.length > 0) {
        this.chartData = this.longify(this.aggregateData, this.normalizationData)
      } else {
        return
      }

      d3.select('#heatmapChart').selectAll('.tooltip').remove()
      this.cellClipPath?.selectAll('.cell').remove()
      this.drawCells()
    },
    /**
     * Format data for the graph
     */
    longify(rows = [], normalizationData) {
      const extracted = []
      rows.forEach((row) => {
        this.activeFeatures.forEach((feature) => {
          if (feature.label === 'topic') {
            const d = this.topics.topics.find((topic) => topic.index === row[feature.label])

            extracted.push({
              frame: row.min_timestamp,
              variable: feature.label,
              value: d?.description,
            })
          } else {
            const average = normalizationData[feature.label]?.average
            const stddev = normalizationData[feature.label]?.stddev
            extracted.push({
              frame: row.min_timestamp,
              variable: feature.label,
              value: row[feature.label],
              zscore: stddev === 0 ? 0 : (row[feature.label] - average) / stddev,
              description: feature.description,
            })
          }
        })
      })
      return extracted
    },
    deUnderscore(aggregate) {
      const result = []
      const keys = Object.keys(aggregate.avg)
      keys.forEach(function (key) {
        result[key.replace(/_/i, '').toLowerCase()] = {
          average: aggregate.avg[key],
          stddev: aggregate.stddev[key],
        }
      })
      return result
    },
    /**
     * Normalize data for the graph
     */
    normalize(aggregateData = [], normalizationData) {
      const extracted = []
      aggregateData.forEach((row) => {
        this.activeFeatures.forEach((feature) => {
          if (feature.label === 'topic') {
            const d = this.topics.topics.find((topic) => topic.index === row[feature.label])
            extracted.push({
              frame: row.min_timestamp,
              variable: feature.label,
              value: d?.description,
            })
          } else if (feature.label === 'silence' || feature.label === 'success') {
            extracted.push({
              frame: row.min_timestamp,
              variable: feature.label,
              value: row[feature.label],
            })
          } else {
            const average = normalizationData[feature.label]?.average
            const stddev = normalizationData[feature.label]?.stddev
            extracted.push({
              frame: row.min_timestamp,
              variable: feature.label,
              value: row[feature.label],
              zscore: stddev === 0 ? 0 : (row[feature.label] - average) / stddev, // if standard deviation is 0, keep
              description: feature.description,
            })
          }
        })
      })
      return extracted
    },
    formatDuration(d) {
      return new Date(1000 * d).toISOString().substr(14, 5)
    },
    drawChart() {
      // remove old chart if its there
      d3.select('#heatmapChart').selectAll('*').remove()
      this.chartWidth = this.width - this.margins.left - this.margins.right
      this.chartHeight = this.height - this.margins.top - this.margins.bottom

      this.svg = d3.select('#heatmapChart').append('svg').attr('width', this.width).attr('height', this.height)
      const chartGroup = this.svg
        .append('g')
        .attr('class', 'chartGroup')
        .attr('transform', 'translate(' + this.margins.left + ',' + this.margins.top + ')')

      // Clipping
      this.defs = chartGroup.append('defs')
      this.defs
        .append('clipPath')
        .attr('id', 'clip')
        .append('rect')
        .attr('x', 0)
        .attr('y', 0)
        .attr('width', this.chartWidth)
        .attr('height', this.chartHeight)
      this.defs
        .append('clipPath')
        .attr('id', 'clipx')
        .append('rect')
        .attr('x', 0)
        .attr('y', this.chartHeight - this.margins.bottom)
        .attr('width', this.chartWidth)
        .attr('height', this.margins.bottom)
      this.defs
        .append('clipPath')
        .attr('id', 'clipy')
        .append('rect')
        .attr('x', -this.margins.left)
        .attr('y', 0)
        .attr('width', this.margins.left + 1)
        .attr('height', this.chartHeight)

      // Labels for row & column
      this.timeBins = d3.range(this.startTime, this.endTime, this.resolution)
      const tickValues = d3.range(this.startTime, this.endTime, 30)

      const tooltip = this.tooltip()

      // Scale for the cursor alone, so we dont scale it with the xScale while zooming
      this.cursorScale = d3.scaleLinear().range([0, this.chartWidth]).domain([this.startTime, this.endTime])

      // Build X scales and axis:
      this.xScale = d3.scaleBand().range([0, this.chartWidth]).domain(this.timeBins).padding(0.0)
      this.xAxis = d3.axisBottom(this.xScale).tickValues(tickValues).tickFormat(this.formatDuration)
      this.xAxisGroup = chartGroup
        .append('g')
        .attr('clip-path', 'url(#clipx)')
        .append('g')
        .attr('class', 'axis axis--x')
        .attr('transform', 'translate(0,' + (this.chartHeight - this.margins.bottom) + ')')
        .call(this.xAxis)

      // Build Y scales and axis:
      this.yScale = d3
        .scaleBand()
        .range([this.chartHeight - this.margins.bottom - this.margins.top, 0])
        .domain(this.featuresNames)
        .padding(0.01)
      this.yAxis = d3.axisLeft(this.yScale)
      this.yAxisGroup = chartGroup
        .append('g')
        .attr('clip-path', 'url(#clipy)')
        .append('g')
        .attr('class', 'axis axis--y')
        .call(this.yAxis)

      this.yAxisGroup
        .selectAll('.tick')
        .style('cursor', 'pointer')
        .data(this.activeFeatures)
        ._groups[0]?.forEach((d) => {
          d3.select(d)
            .on('mouseover', function (event, data) {
              if (data.description) {
                tooltip.style('display', 'block')
                tooltip.transition().duration(200).style('opacity', 0.9)
                tooltip
                  .html(data.description)
                  .style('left', event.layerX + 30 + 'px')
                  .style('top', event.layerY + 'px')
                  .style('opacity', 1)
              }
            })
            .on('mouseout', function (event, d) {
              tooltip.style('display', 'none')
              d3.select(this).style('stroke', 'none').style('opacity', 0.8)
            })
        })

      this.cellClipPath = chartGroup.append('g').attr('clip-path', 'url(#clip)')
      this.drawCells()

      /**
       * Cursor
       */
      let initialCursorPos, initialX
      function dragHandler(that) {
        function invertOrdinal(scale, x) {
          const eachBand = scale.step()
          const index = Math.round(x / eachBand)
          return scale.domain()[index]
        }

        function dragstarted(event) {
          d3.select(this).raise()

          that.$store.commit('cursor/SEEKING', true)
          initialCursorPos = that.cursor
          initialX = that.cursorLine.attr('x')
        }

        function dragged(event) {
          const cursorDelta = invertOrdinal(that.xScale, event.x) - invertOrdinal(that.xScale, initialX)
          let newCursorPos = initialCursorPos + cursorDelta

          if (newCursorPos < 0) {
            newCursorPos = 0
          } else if (newCursorPos > invertOrdinal(that.xScale, this.chartWidth)) {
            newCursorPos = invertOrdinal(that.xScale, this.chartWidth)
          }

          const newX = that.cursorScale(newCursorPos)

          d3.select(this).attr('x', newX)
          that.$store.commit('cursor/UPDATE_CURSOR_POSITION', newCursorPos)
        }

        function dragended(event) {
          that.$store.commit('cursor/SEEKING', false)
        }
        return d3.drag().on('start', dragstarted).on('drag', dragged).on('end', dragended)
      }

      /**
       * Draw cursor
       */
      this.cursorLine = chartGroup
        .append('g')
        .attr('clip-path', 'url(#clip)')
        .selectAll('.cursorline')
        .data([this.cursor]) // this doesn't give two way data binding
        .enter()
        .append('rect')
        .attr('class', 'cursorline')
        .attr('fill', (d) => (this.normalization ? '#4EC0FF' : '#fff'))
        .attr('opacity', '0.5')
        .attr('stroke', 'black')
        .attr('stroke-width', '1')
        .attr('x', (d) => {
          return this.cursorScale(d)
        })
        .attr('y', 0)
        .attr('width', this.cursorWidth)
        .attr('height', this.chartHeight - this.margins.bottom)
        .call(dragHandler(this))

      this.svg.call(this.zoomHandler(this))
    },
    drawCells() {
      // Build color scales
      const topicColor = d3.scaleOrdinal(d3.schemeCategory10)
      const successColor = d3.scaleSequential().domain([0, 1]).interpolator(d3.interpolateRdYlGn)
      const silenceColor = d3.scaleOrdinal(d3.schemeSet1)

      let myColor = d3.scaleSequential().domain([0, 5]).interpolator(d3.interpolateInferno)
      let myColorC = d3.scaleSequential().domain([0, 1]).interpolator(d3.interpolateInferno)
      let pitchColor = d3.scaleSequential().domain([0, 255]).interpolator(d3.interpolateViridis)
      let intensityColor = d3.scaleSequential().domain([0, 100]).interpolator(d3.interpolatePlasma)

      if (this.normalization) {
        myColor = d3.scaleDiverging().domain([-2.5, 0, 2.5]).interpolator(d3.interpolatePuOr)
        myColorC = d3.scaleDiverging().domain([-2.5, 0, 2.5]).interpolator(d3.interpolatePuOr)
        pitchColor = d3.scaleDiverging().domain([-2.5, 0, 2.5]).interpolator(d3.interpolatePiYG)
        intensityColor = d3.scaleDiverging().domain([-2.5, 0, 2.5]).interpolator(d3.interpolateRdBu)
      }
      const tooltip = this.tooltip()
      const that = this

      // Group for main content
      this.cells = this.cellClipPath
        .selectAll('.cell')
        .data(this.chartData)
        .enter()
        .append('rect')
        .attr('class', 'cell')
        .attr('x', (d) => {
          return this.xScale(d.frame)
        })
        .attr('y', (d) => this.yScale(d.variable))
        .attr('width', this.xScale.bandwidth())
        .attr('height', this.yScale.bandwidth())
        .style('fill', (d) => {
          if (d.variable === 'topic') {
            return topicColor(d.value)
          } else if (d.variable === 'success') {
            return successColor(d.value)
          } else if (d.variable.endsWith('c')) {
            if (that.normalize) {
              return myColorC(d.zscore)
            } else {
              return myColorC(d.value)
            }
          } else if (d.variable === 'pitch') {
            if (that.normalize) {
              return pitchColor(d.zscore)
            } else {
              return pitchColor(d.value)
            }
          } else if (d.variable === 'intensity') {
            if (that.normalize) {
              return intensityColor(d.zscore)
            } else {
              return intensityColor(d.value)
            }
          } else if (d.variable === 'silence') {
            return silenceColor(d.value)
          } else if (that.normalize) {
            return myColor(d.zscore)
          } else {
            return myColor(d.value)
          }
        })
        .on('mouseover', (event, d) => {
          if (d.variable === 'topic') {
            tooltip.style('display', 'block')
            tooltip.transition().duration(200).style('opacity', 0.9)
            tooltip.html(d.value ? d.value : 'Geen beschrijving')
          } else {
            tooltip.style('display', 'block')
            tooltip.transition().duration(200).style('opacity', 0.9)
            tooltip
              .html(
                `<div>
                <div>
                <span>Feature:  </span>
                <span>` +
                  d.variable +
                  (d.description ? '-' + d.description : '') +
                  `</span>
                </div>
                <div>
                <span>Time:  </span><span>` +
                  this.formatDuration(d.frame) +
                  `</span>
                </div>
                 <div>
                <span>Value:  </span><span>` +
                  d.value +
                  `</span>
                </div>
                <div>
                <span>Z-Score:  </span><span>` +
                  d.zscore +
                  `</span>
                </div>
                </div>`
              )
              .style('left', event.layerX + 20 + 'px')
              .style('top', event.layerY + 'px')
              .style('opacity', 1)
          }
        })
        .on('mouseleave', () => tooltip.style('display', 'none'))
      this.cells.exit().remove()
    },
    tooltip() {
      return d3
        .select('#heatmapChart')
        .append('div')
        .style('opacity', 0)
        .attr('class', 'tooltip')
        .style('position', 'absolute')
        .style('background-color', 'white')
        .style('border', 'solid')
        .style('border-width', '2px')
        .style('border-radius', '5px')
        .style('padding', '5px')
        .style('min-width', '300px')
        .style('z-index', '1111')
    },
    zoomHandler(that) {
      const extent = [
        [0, 0],
        [that.chartWidth, that.chartHeight],
      ]

      function zoomed(event) {
        const resolution = (1.0 / event.transform.k) * that.maxResolution
        const newResolution = Math.round(resolution / that.minResolution) * that.minResolution

        that.timeBins = d3.range(that.startTime, that.endTime, newResolution)
        that.xScale
          .range(
            [0, that.chartWidth].map((d) => event.transform.applyX(d)),
            newResolution
          )
          .domain(that.timeBins)
          .padding(0.0)
        that.cells.attr('x', (d) => that.xScale(d.frame)).attr('width', that.xScale.bandwidth())

        // This triggers a new data request, and will therefore call the drawCells() function in a roundabout way
        that.resolution = newResolution

        that.cursorLine.attr('transform', event.transform)

        const ticks = (newResolution / that.maxResolution) * 30
        const tickValues = d3.range(that.startTime, that.endTime, ticks)
        that.xAxis.tickValues(tickValues).tickFormat(that.formatDuration)
        that.xAxisGroup.call(that.xAxis)
      }

      return d3.zoom().scaleExtent([1, 20]).translateExtent(extent).extent(extent).on('zoom', zoomed)
    },
  },
}
</script>

<style>
#heatmapChart {
  position: relative;
  overscroll-behavior: contain;
  max-width: 100%;
  width: 100%;
}
</style>
