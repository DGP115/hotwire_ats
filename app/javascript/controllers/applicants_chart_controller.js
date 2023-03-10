import ChartsController from './charts_controller'

export default class extends ChartsController {

  /*
    update calls Reflex [so server-side] 'ApplicantsChart' method 'update'
      - 'event.target' is the element that triggered the update
      - the serializeForm option, combined with our dummy <form> tag in the markup, allows us to
        easily access the current values of all form inputs in the server-side reflex
  */
  update() {
    this.stimulate('ApplicantsChart#update', event.target, { serializeForm: true })
  }

  get chartOptions() {
    return {
      chart: {
        height: "400px",
        type: 'line'
      },
      series: [{
        name: 'Applicants',
        data: this.seriesValue
      }],
      xaxis: {
        categories: this.labelsValue,
        type: 'datetime'
      },
      stroke: {
        curve: "smooth"
      }
    }
  }

}
