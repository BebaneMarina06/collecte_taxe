/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,ts}",
  ],
  theme: {
    extend: {
      screens: {
        // Breakpoints personnalisés alignés avec le ResponsiveService
        'xs': '0px',
        'sm': '480px',
        'md': '768px',
        'lg': '1024px',
        'xl': '1280px',
        '2xl': '1536px',
        '3xl': '1920px',
        '4xl': '2560px',
      },
      spacing: {
        // Spacing adapté aux différents écrans
        'responsive-xs': 'clamp(0.25rem, 2vw, 0.5rem)',
        'responsive-sm': 'clamp(0.5rem, 3vw, 1rem)',
        'responsive-md': 'clamp(1rem, 4vw, 1.5rem)',
        'responsive-lg': 'clamp(1.5rem, 5vw, 2rem)',
      },
      fontSize: {
        // Font sizes adaptatifs
        'responsive-xs': 'clamp(0.65rem, 2vw, 0.75rem)',
        'responsive-sm': 'clamp(0.75rem, 2.5vw, 0.875rem)',
        'responsive-base': 'clamp(0.875rem, 3vw, 1rem)',
        'responsive-lg': 'clamp(1rem, 3.5vw, 1.125rem)',
        'responsive-xl': 'clamp(1.125rem, 4vw, 1.25rem)',
        'responsive-2xl': 'clamp(1.5rem, 5vw, 1.875rem)',
      },
      gridTemplateColumns: {
        // Grilles responsives
        'responsive': 'repeat(auto-fit, minmax(250px, 1fr))',
        'responsive-sm': 'repeat(auto-fit, minmax(150px, 1fr))',
        'responsive-lg': 'repeat(auto-fit, minmax(300px, 1fr))',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ],
  corePlugins: {
    preflight: true,
  },
};
