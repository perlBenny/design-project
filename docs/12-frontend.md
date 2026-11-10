# 12. Frontend

## What exists now

One page, `/`, with a title (**שלום**), a line of text and two buttons, built with Mantine.
It is small on purpose: it proves the whole chain works (server rendering, Hebrew, right to left,
the component library, CSS Modules, build, CI) before we add the real design and content.

```bash
pnpm --filter frontend dev     # http://localhost:3000
pnpm --filter frontend build   # production build into frontend/dist
pnpm --filter frontend start   # serve the build, http://localhost:3000
```

## Why TanStack Start

[TanStack Start](https://tanstack.com/start) renders every page on the server (SSR) and then makes it
interactive in the browser. Google gets full HTML on the first request, which is what SEO needs.
Routing is type-safe: a wrong link is a TypeScript error, not a 404.

## The files

| File                          | Job                                                                                       |
| ----------------------------- | ----------------------------------------------------------------------------------------- |
| `vite.config.ts`              | Build tool. The Start plugin must come before the React plugin                            |
| `src/router.tsx`              | Creates the router. Start calls it once per request on the server and once in the browser |
| `src/routes/__root.tsx`       | The HTML shell of every page: `<html lang="he" dir="rtl">`, `<head>`, scripts             |
| `src/routes/index.tsx`        | The home page                                                                             |
| `src/routes/index.module.css` | Styles for the home page only (CSS Module)                                                |
| `src/theme.ts`                | Mantine theme: colors, font, radius. Placeholder until the design                         |
| `postcss.config.mjs`          | CSS tooling: Mantine mixins and breakpoint variables                                      |
| `src/routeTree.gen.ts`        | **Generated** from the files in `src/routes`. Committed so typecheck works; never edit it |

## Routes are files

A file in `src/routes` is a page. `index.tsx` is `/`; later `projects.tsx` will be `/projects`,
and `projects.$slug.tsx` will be `/projects/:slug`. The dev server rebuilds `routeTree.gen.ts` when you add a file.

## Hebrew and RTL

`lang="he"` tells browsers, screen readers and Google the language. `dir="rtl"` flips the layout.
Both are set once in `__root.tsx`, so every page gets them.

## Check it is really server-rendered

```bash
curl -s http://localhost:3000/ | grep -o '<h1[^>]*>[^<]*</h1>'   # → <h1 ... class="... mantine-Title-root">שלום</h1>
```

If the text is in the raw HTML, the server rendered it. A client-only app would send an empty `<body>`.

## SSR yes, RSC no

- **SSR (we use it):** the server runs the whole page once and sends HTML. Then the same components
  run again in the browser (hydration). Every component runs in both places.
- **RSC (React Server Components, we don't use it):** some components run only on the server and send no
  JavaScript. We have no `"use client"` / `"use server"` markers. The site is small, and SSR plus route
  `loader`s already give SEO what it needs; RSC would add a server/client boundary to think about.

**Who decides SSR?** Not the page code: the same `index.tsx` would work in a plain SPA. The `tanstackStart()`
plugin in `vite.config.ts` builds a server that renders every request, and SSR is its default. A single route
can opt out with `ssr: false` (maybe parts of `/admin` later).

`declare module ... interface Register { ... }` blocks (in `routeTree.gen.ts`) are **types only**: they tell
TypeScript which router and routes exist, so a link to a missing page is a compile error. They do not run.

## Mantine (components) and CSS Modules (our styles)

[Mantine](https://mantine.dev) gives us ready, accessible components: `Button`, `Title`, `Container`, inputs,
modals. Every component supports right to left. We write our own styles in **CSS Modules**: a file
`name.module.css` next to the component. Class names become unique (`hero` → `_hero_1xs0i_2`), so two pages
can both have a `.hero` without clashing.

How it is wired in `__root.tsx`, and why:

| Piece                                      | Why                                                                                                               |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------- |
| `styles.css?url` in `head.links`           | The CSS is a `<link>` in the server HTML, so the page is styled on the first paint (no flash of unstyled content) |
| `MantineProvider theme={theme}`            | Gives every component our theme                                                                                   |
| `DirectionProvider initialDirection="rtl"` | Mantine renders RTL already on the server. Without it, it would render LTR and flip after load                    |
| `ColorSchemeScript` + `mantineHtmlProps`   | Sets the light color scheme before paint, with the same attribute on server and browser                           |

Rules for our CSS:

- Use Mantine variables, not raw values: `var(--mantine-spacing-md)`, `var(--mantine-color-dark-6)`.
- Use logical properties: `padding-inline-start`, not `padding-left`. "Start" is the right side in Hebrew.
  Only when that is not enough, use `@mixin rtl { ... }`.
- Breakpoints: `@media (max-width: $mantine-breakpoint-sm)`, the same values as Mantine's.
  (VS Code's plain-CSS checker reports `$` variables as "term expected". `.vscode/settings.json` opens `.css`
  files as PostCSS instead; install the recommended **PostCSS Language Support** extension when VS Code asks.)

## Next (planned, issue #8)

A Hebrew font, the layout (header, footer, WhatsApp button), a 404 page,
and a typed API client generated from `api-spec/openapi.yaml`.
