// PostCSS runs on every CSS file (Vite picks this file up by itself).
// postcss-preset-mantine adds Mantine mixins, e.g. @mixin rtl, @mixin hover, rem().
// postcss-simple-vars lets CSS Modules use the same breakpoints as Mantine: $mantine-breakpoint-sm.
export default {
  plugins: {
    "postcss-preset-mantine": {},
    "postcss-simple-vars": {
      variables: {
        "mantine-breakpoint-xs": "36em",
        "mantine-breakpoint-sm": "48em",
        "mantine-breakpoint-md": "62em",
        "mantine-breakpoint-lg": "75em",
        "mantine-breakpoint-xl": "88em",
      },
    },
  },
};
