/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/**/*.{html.erb,js}",
    "./app/helpers/**/*.rb"  // Add this line to include helper files
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('flowbite/plugin')
  ],
}