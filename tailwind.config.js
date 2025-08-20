module.exports = {
  // This is the most important part for Tailwind v2
  purge: [
    // This path tells Tailwind to look inside your 'src/templates' folder
    // and scan any .html file it finds for CSS classes.
    './src/templates/**/*.html',
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
