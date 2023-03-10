import ApplicationController from './application_controller'
import ApexCharts from "apexcharts"

/* This is the custom StimulusReflex controller for the ApplicantsChart Reflex.
 * Learn more at: https://docs.stimulusreflex.com
 */
export default class extends ApplicationController {
  static targets = ["chart"]

  static values = {
    labels: Array,
    series: Array
  }

  /*
    - 'this.chartTarget' attaches the chart to the DOM
    -  the data for the chart comes from the DOM and is given by values:  'labels' and 'series'
  */
  initialize() {
    this.chart = new ApexCharts(this.chartTarget, this.chartOptions);
    this.chart.render();
  }

  afterUpdate() {
    this.chart.updateOptions(this.chartOptions);
  }

  /*
  Remove the chart from the DOM when the user navigates away from teh page displaying it.
    - 'disconnect()' is a built-in Stimulus lifecycle method that is called when the Stimulus
       controller leaves the DOM.
    - the 'destroy' method comes from ApexCharts and it removes the chart element and associated
      listeners from the DOM
  */
  disconnect () {
    this.chart.destroy();
  }

}
