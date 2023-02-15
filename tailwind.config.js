// module.exports = {
//   content: [
//     './app/views/**/*.html.erb',
//     './app/helpers/**/*.rb',
//     './app/assets/stylesheets/**/*.css',
//     './app/javascript/**/*.js'
//   ]
// }
module.exports = {
  mode: 'jit',
  content: [
    "./app/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
  ],
  plugins: [
    require('@tailwindcss/forms')
  ],
}
