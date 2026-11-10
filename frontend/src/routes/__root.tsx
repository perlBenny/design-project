import type { ReactNode } from "react";
import { createRootRoute, HeadContent, Outlet, Scripts } from "@tanstack/react-router";
import {
  ColorSchemeScript,
  DirectionProvider,
  MantineProvider,
  mantineHtmlProps,
} from "@mantine/core";
// "?url" gives the file's URL, so the CSS is a <link> in <head>: styled on the first paint, no flash.
import mantineStyles from "@mantine/core/styles.css?url";
import { theme } from "../theme";

// The HTML shell of every page. Rendered on the server (SSR), so search engines get full HTML.
export const Route = createRootRoute({
  head: () => ({
    meta: [
      { charSet: "utf-8" },
      { name: "viewport", content: "width=device-width, initial-scale=1" },
      { title: "סטודיו לעיצוב פנים" },
    ],
    // Mantine styles must come first, before our own styles.
    links: [{ rel: "stylesheet", href: mantineStyles }],
  }),
  component: RootComponent,
});

function RootComponent() {
  return (
    <RootDocument>
      <Outlet />
    </RootDocument>
  );
}

function RootDocument({ children }: Readonly<{ children: ReactNode }>) {
  return (
    // Hebrew, right to left: set once here, every page inherits it.
    // mantineHtmlProps: the color-scheme attribute Mantine needs, same on server and browser.
    <html lang="he" dir="rtl" {...mantineHtmlProps}>
      <head>
        <ColorSchemeScript defaultColorScheme="light" />
        <HeadContent />
      </head>
      <body>
        {/* rtl from the first server render, so Mantine components are not flipped after load */}
        <DirectionProvider initialDirection="rtl" detectDirection={false}>
          <MantineProvider theme={theme} defaultColorScheme="light">
            {children}
          </MantineProvider>
        </DirectionProvider>
        <Scripts />
      </body>
    </html>
  );
}
