# 12. Frontend

## What exists now

One page, `/`, that says **שלום**. It is small on purpose: it proves the whole chain works
(server rendering, Hebrew, right to left, build, CI) before we add design and content.

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

| File                    | Job                                                                                       |
| ----------------------- | ----------------------------------------------------------------------------------------- |
| `vite.config.ts`        | Build tool. The Start plugin must come before the React plugin                            |
| `src/router.tsx`        | Creates the router. Start calls it once per request on the server and once in the browser |
| `src/routes/__root.tsx` | The HTML shell of every page: `<html lang="he" dir="rtl">`, `<head>`, scripts             |
| `src/routes/index.tsx`  | The home page                                                                             |
| `src/routeTree.gen.ts`  | **Generated** from the files in `src/routes`. Committed so typecheck works; never edit it |

## Routes are files

A file in `src/routes` is a page. `index.tsx` is `/`; later `projects.tsx` will be `/projects`,
and `projects.$slug.tsx` will be `/projects/:slug`. The dev server rebuilds `routeTree.gen.ts` when you add a file.

## Hebrew and RTL

`lang="he"` tells browsers, screen readers and Google the language. `dir="rtl"` flips the layout.
Both are set once in `__root.tsx`, so every page gets them.

## Check it is really server-rendered

```bash
curl -s http://localhost:3000/ | grep -o '<h1>.*</h1>'   # → <h1>שלום</h1>
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

## Next (planned, issue #8)

Mantine with RTL, CSS Modules, a Hebrew font, the layout (header, footer, WhatsApp button)
and a typed API client generated from `api-spec/openapi.yaml`.
