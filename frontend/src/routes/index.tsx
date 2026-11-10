import { createFileRoute } from "@tanstack/react-router";
import { Button, Container, Group, Text, Title } from "@mantine/core";
import classes from "./index.module.css";

// The home page: "/".
export const Route = createFileRoute("/")({
  component: Home,
});

function Home() {
  return (
    <Container component="main" size="md">
      <div className={classes.hero}>
        <Title order={1}>שלום</Title>
        <Text c="dimmed" mt="sm">
          סטודיו לעיצוב פנים. האתר בבנייה.
        </Text>
        <Group mt="lg">
          <Button>לפרויקטים</Button>
          <Button variant="default">צור קשר</Button>
        </Group>
      </div>
    </Container>
  );
}
