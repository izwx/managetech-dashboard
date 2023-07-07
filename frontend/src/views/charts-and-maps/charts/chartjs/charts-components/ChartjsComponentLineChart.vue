<script>
import { Line, mixins } from 'vue-chartjs'

export default {
  extends: Line,
  // mixins: [mixins.reactiveData],
  props: {
    data: {
      type: Object,
      default: null,
    },
    options: {
      type: Object,
      default: null,
    },
    plugins: {
      type: Array,
      default: null,
    },
    styles: {
      type: Object,
      default: null,
    },
  },
  mounted() {
    this.renderChart(this.pdata, this.options, this.plugins, this.styles)
  },
  watch: {
    data: function(value, prevValue) {
        this.renderChart(this.data, this.options, this.plugins, this.styles)
      }
  }
}
</script>
