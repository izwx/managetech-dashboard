import { getVuetify } from '@core/utils'

export default function useReport() {
  const $vuetify = getVuetify()
  const defaultChartOptions = {
    grid: {
      show: true,
      xaxis: {
        lines: {
          show: true,
        },
      },
      yaxis: {
        lines: {
          show: true,
        },
      },
      padding: {
        left: 0,
        bottom: -10,
      },
    },
    chart: {
      type: 'line',
      toolbar: {
        show: false,
      },
    },
    fill: {
      type: 'gradient',
      gradient: {
        shade: 'light',
        type: 'horizontal',
        shadeIntensity: 0,
        gradientToColors: undefined,
        inverseColors: true,
        opacityFrom: 1,
        opacityTo: 0.4,
        stops: [0, 100, 100],
        colorStops: [],
      },
    },
    stroke: {
      width: 5,
      curve: 'smooth',
      lineCap: 'round',
    },
    // colors: [],
    legend: {
      show: false,
    },
    xaxis: {
      categories: [],
      labels: {
        show: true,
      },
      axisBorder: {
        show: false,
      },
      axisTicks: {
        show: false,
      },
    },
    yaxis: {
      labels: {
        show: false,
      },
      axisBorder: {
        show: false,
      },
      axisTicks: {
        show: false,
        // width: 6,
      },
      min: 0,
    },
  }

  return {
    defaultChartOptions,
    $vuetify
  }
}
