const express = require("express");
const mysql = require("mysql2");
const getSecrets = require("./secrets");

const app = express();

async function startServer() {
  try {

    const secrets = await getSecrets();

    console.log("Fetched Secrets:", secrets);

    const connection = mysql.createConnection({
      host: "webapp-db-instance.ct5xo0ovwdss.ap-southeast-2.rds.amazonaws.com",
      user: secrets.username,
      password: secrets.password,
      database: "webapp",
      port: 3306,
    });

    connection.connect((err) => {
      if (err) {
        console.error("DB connection failed:", err);
        process.exit(1);
      }

      console.log("DB connected");
    });

    app.get("/health", (req, res) => {
      res.status(200).send("OK");
    });

    app.get("/", (req, res) => {
      res.send("Application running successfully 🚀");
    });

    app.listen(3000, "0.0.0.0", () => {
      console.log("Server running on port 3000");
    });

  } catch (error) {
    console.error("Application startup failed:", error);
    process.exit(1);
  }
}

startServer();
