const express = require("express");

const app = express();
const PORT = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.json({
    application: "Acme Equipment Monitoring",
    status: "online",
    version: "1.0.0"
  });
});

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "healthy"
  });
});

app.get("/api/equipment", (req, res) => {
  res.json([
    {
      id: 1,
      name: "Excavator-01",
      status: "running"
    },
    {
      id: 2,
      name: "Generator-01",
      status: "running"
    },
    {
      id: 3,
      name: "Pump-01",
      status: "maintenance"
    }
  ]);
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Acme Equipment application running on port ${PORT}`);
});
