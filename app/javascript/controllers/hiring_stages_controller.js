import ChartsController from './charts_controller'

export default class extends ChartsController {
  /*
    update calls Reflex [so server-side] 'HiringStages' method 'update'
      - 'event.target' is the element that triggered the update
      - the serializeForm option, combined with our dummy <form> tag in the markup, allows us to
        easily access the current values of all form inputs in the server-side reflex
  */
  update(event) {
    this.stimulate("HiringStages#update", event.target, { serializeForm: true })
  }

  get chartOptions() {
    return {
      chart: {
        height: "400px",
        type: 'pie'
      },
      series: this.seriesValue,
      labels: this.labelsValue
    }
  }

}
