import { createFileRoute } from "@tanstack/react-router";

// The home page: "/".
export const Route = createFileRoute("/")({
  component: Home,
});

function Home() {
  return (
    <main>
      <h1>שלום</h1>
    </main>
  );
}
