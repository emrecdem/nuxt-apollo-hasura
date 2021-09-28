<template>
  <div id="topicsLegendChart" ref="topicsLegendChart"></div>
</template>

<script>
import * as d3 from 'd3'
import get_topics from '~/apollo/get_topics'
import video_id from '~/apollo/video_id'

export default {
  props: {},
  data() {
    return {
      svg: null,
      defs: null,
      y: null,
      x: null,
      yAxis: null,
      xAxis: null,
      videoId: null,
      height: 200,
      width: 300,
      margins: { top: 0, right: 0, bottom: 0, left: 0 },
    }
  },
  computed: {
    video_hash() {
      // Retrieve selected video from vuex store
      return this.$store.state.videos.selectedVideo?.hash
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
    topics: {
      query: get_topics,
      variables() {
        return {
          video: this.videoId,
        }
      },
      skip: ({ videoId }) => {
        return videoId === null
      },
      result({ data, loading, networkStatus }) {
        if (data) {
          console.log(data)
          this.topics = [{ index: 0, description: 'Geen beschrijving' }, ...data.topics]
          this.updateChart()
        }
      },
      error(error) {
        console.log('get_topics query errored')
        this.error = JSON.stringify(error.message)
      },
    },
  },
  mounted() {
    this.$nextTick(() => {
      // this.width = this.$el.parentElement.clientWidth
      // window.addEventListener('resize', this.onResize)
      this.updateChart()
    })
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.onResize)
  },
  methods: {
    updateChart() {
      if (this.topics && this.topics.length > 0) {
        this.drawChart()
      }
    },
    onResize() {
      this.$nextTick(() => {
        this.width = this.$el.parentElement.clientWidth
        this.updateChart()
      })
    },
    drawChart() {
      // remove old chart if its there
      d3.select('#topicsLegendChart').selectAll('*').remove()

      this.chartWidth = this.width - this.margins.left - this.margins.right
      this.chartHeight = this.height - this.margins.top - this.margins.bottom

      this.svg = d3.select('#topicsLegendChart').append('svg').attr('width', this.width).attr('height', this.height)

      const chartGroup = this.svg
        .append('g')
        .attr('transform', 'translate(' + this.margins.left + ',' + this.margins.top + ')')

      this.topicsLegend = chartGroup.append('g').attr('class', 'topicGroup').attr('transform', 'translate(0, 20)')

      this.drawTopicsLegend(this.topicsLegend, this.topics)
    },
    drawTopicsLegend(d3Group, data) {
      const topicColor = d3.scaleOrdinal(d3.schemeCategory10)
      const ordinal_size = 10
      const x_offset = 10
      const y_offset = 20

      d3Group
        .append('text')
        .attr('class', 'topicsLegendHeader')
        .attr('x', 0)
        .attr('y', 0)
        .text('Topics discussed in the video')
        .attr('text-anchor', 'left')
        .attr('font-size', '10px')
        .style('alignment-baseline', 'middle')

      d3Group
        .selectAll('topicSymbol')
        .data(data)
        .enter()
        .append('circle')
        .attr('class', 'topicSymbol')
        .attr('r', ordinal_size / 2)
        .attr('cx', x_offset)
        .attr('cy', function (d, i) {
          return y_offset + i * (ordinal_size + 5)
        })
        .style('fill', function (d) {
          return topicColor(d.index)
        })
        .exit()
        .remove()

      d3Group
        .selectAll('topicDescription')
        .data(data)
        .enter()
        .append('text')
        .attr('class', 'topicDescription')
        .attr('x', x_offset + ordinal_size)
        .attr('y', function (d, i) {
          return y_offset + i * (ordinal_size + 5)
        })
        .text(function (d) {
          return d.description
        })
        .attr('text-anchor', 'left')
        .attr('font-size', '10px')
        .style('alignment-baseline', 'middle')
        .exit()
        .remove()
    },
  },
}
</script>

<style></style>
