import express from "express";
import dotenv from "dotenv";
import cors from "cors";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static("public"));

app.post("/chat", async (req, res) => {
  try {
    const { AZURE_ENDPOINT, AZURE_API_KEY, AZURE_DEPLOYMENT_NAME } = process.env;

    if (!AZURE_ENDPOINT || !AZURE_API_KEY || !AZURE_DEPLOYMENT_NAME) {
      return res.status(500).json({
        error: "Missing AZURE_ENDPOINT, AZURE_API_KEY or AZURE_DEPLOYMENT_NAME in .env",
      });
    }

    const url = `${AZURE_ENDPOINT}/openai/deployments/${AZURE_DEPLOYMENT_NAME}/chat/completions?api-version=2025-01-01-preview`;

    const response = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "api-key": AZURE_API_KEY,
      },
      body: JSON.stringify({
        messages: [
          { role: "system", content: "You are a helpful assistant." },
          { role: "user", content: req.body.message },
        ],
        temperature: 0.7,
      }),
    });

    const data = await response.json();
    console.log("Azure response:", data);

    if (!response.ok) {
      return res.status(response.status).json(data);
    }

    if (!data.choices || data.choices.length === 0) {
      return res.status(500).json({
        error: "No choices returned from Azure",
        raw: data,
      });
    }

    res.json({ content: data.choices[0].message.content });

  } catch (err) {
    console.error("Server error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.listen(3000, () =>
  console.log("Server running on http://localhost:3000")
);