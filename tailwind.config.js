// tailwind.config.js
module.exports = {
  content: [
    "./app/views/**/*.{html,erb}",      // pega todos os templates ERB, incluindo Devise
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.{js,ts}"
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'), // deixa inputs e selects bonitos
  ],
}
