const { test } = require("node:test");
const assert = require("node:assert/strict");
const app = require("../src/server");

const server = app.listen(0, "127.0.0.1");

test("GET / returns application information", async () => {
  const response = await fetch(`http://127.0.0.1:${server.address().port}/`);
  const data = await response.json();

  assert.equal(response.status, 200);
  assert.equal(data.application, "Acme Equipment Monitoring");
  assert.equal(data.status, "online");
  assert.equal(data.version, "1.2.0");
});

test("GET /health returns healthy status", async () => {
  const response = await fetch(`http://127.0.0.1:${server.address().port}/health`);
  const data = await response.json();

  assert.equal(response.status, 200);
  assert.equal(data.status, "healthy");
});

test("GET /api/equipment returns three equipment records", async () => {
  const response = await fetch(`http://127.0.0.1:${server.address().port}/api/equipment`);
  const data = await response.json();

  assert.equal(response.status, 200);
  assert.equal(data.length, 3);
  assert.equal(data[0].name, "Excavator-01");
  assert.equal(data[2].status, "maintenance");
});

test("Unknown routes return 404", async () => {
  const response = await fetch(`http://127.0.0.1:${server.address().port}/unknown`);

  assert.equal(response.status, 404);
});

test("Close test server", async () => {
  await new Promise((resolve, reject) => {
    server.close((error) => {
      if (error) reject(error);
      else resolve();
    });
  });
});

test("Intentional failure to verify CI/CD protection", () => {
  assert.equal(1, 2);
});
