import themeConfig from '@themeConfig'

const $themeColors = themeConfig.themes.light

// colors
const chartColors = {
  primaryColorShade: '#836AF9',
  yellowColor: '#ffe800',
  successColorShade: '#28dac6',
  warningColorShade: '#ffe802',
  warningLightColor: '#FDAC34',
  infoColorShade: '#299AFF',
  greyColor: '#4F5D70',
  blueColor: '#2c9aff',
  blueLightColor: '#84D0FF',
  greyLightColor: '#EDF1F4',
  tooltipShadow: 'rgba(0, 0, 0, 0.25)',
  lineChartPrimary: '#666ee8',
  lineChartDanger: '#ff4961',
  labelColor: '#6e6b7b',
  grid_line_color: 'rgba(200, 200, 200, 0.2)',
}

export default {
  latestBarChart: {
    data: {
      // labels: ['7/12', '8/12', '9/12', '10/12', '11/12', '12/12', '13/12', '14/12', '15/12', '', ''],
      datasets: [
        {
          // data: [275, 90, 190, 205, 125, 85, 55, 87, 127],
          // backgroundColor: '#ffcf5c',
          backgroundColor: chartColors.primaryColorShade,
          borderColor: 'transparent',
          barThickness: 5,
        },
      ],
    },
    options: {
      elements: {
        rectangle: {
          borderWidth: 2,
          borderSkipped: 'bottom',
        },
      },
      responsive: true,
      maintainAspectRatio: false,
      responsiveAnimationDuration: 500,
      legend: {
        display: false,
      },
      tooltips: {
        mode: 'index',
        intersect: false,
        // Updated default tooltip UI
        shadowOffsetX: 1,
        shadowOffsetY: 1,
        shadowBlur: 8,
        shadowColor: chartColors.tooltipShadow,
      },
      scales: {
        xAxes: [
          {
            display: true,
            gridLines: {
              display: true,
              color: chartColors.grid_line_color,
              zeroLineColor: chartColors.grid_line_color,
            },
            scaleLabel: {
              display: false,
            },
            ticks: {
              fontColor: chartColors.labelColor,
            },
          },
        ],
        yAxes: [
          {
            display: true,
            gridLines: {
              color: chartColors.grid_line_color,
              zeroLineColor: chartColors.grid_line_color,
            },
            ticks: {
              // stepSize: 100,
              // min: 0,
              // max: 400,
              fontColor: chartColors.labelColor,
            },
          },
        ],
      },
    },
  },
  lineChart: {
    options: {
      responsive: true,
      maintainAspectRatio: false,
      backgroundColor: false,
      legend: {
        display: false,
      },
      hover: {
        mode: 'label',
        intersect: false,
      },
      tooltips: {
        mode: 'index',
        intersect: false,
        // Updated default tooltip UI
        shadowOffsetX: 1,
        shadowOffsetY: 1,
        shadowBlur: 8,
        shadowColor: chartColors.tooltipShadow,
      },
      layout: {
        padding: {
          top: -15,
          bottom: -25,
          left: -15,
        },
      },
      scales: {
        xAxes: [
          {
            display: true,
            scaleLabel: {
              display: true,
            },
            gridLines: {
              display: true,
              color: chartColors.grid_line_color,
              zeroLineColor: chartColors.grid_line_color,
            },
            ticks: {
              fontColor: chartColors.labelColor,
            },
          },
        ],
        yAxes: [
          {
            display: true,
            scaleLabel: {
              display: true,
            },
            ticks: {
              // stepSize: 5,
              // min: 0,
              // max: 50,
              fontColor: chartColors.labelColor,
            },
            gridLines: {
              display: true,
              color: chartColors.grid_line_color,
              zeroLineColor: chartColors.grid_line_color,
            },
          },
        ],
      },
    },
    data: {
      // labels: [],
      datasets: [
        {
          // data: [],
          // label: 'バックログ数遷移グラフ',
          borderColor: $themeColors.warning,
          lineTension: 0,
          pointStyle: 'circle',
          backgroundColor: $themeColors.warning,
          fill: false,
          pointRadius: 1,
          pointHoverRadius: 5,
          pointHoverBorderWidth: 5,
          pointBorderColor: 'transparent',
          pointHoverBackgroundColor: $themeColors.warning,
          pointShadowOffsetX: 1,
          pointShadowOffsetY: 1,
          pointShadowBlur: 5,
          pointShadowColor: chartColors.tooltipShadow,
        },
      ],
    },
  },
}
