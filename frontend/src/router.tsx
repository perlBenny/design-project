import { createRouter } from "@tanstack/react-router";
import { routeTree } from "./routeTree.gen";

// TanStack Start calls this once per request on the server, and once in the browser.
// The router type is registered for TypeScript in routeTree.gen.ts (generated).
export function getRouter() {
  return createRouter({
    routeTree,
    scrollRestoration: true,
  });
}
