const fs = require("fs");
const path = require("path");
const { GoogleAuth } = require("google-auth-library");
const pool = require("../config/db");

let serviceAccount = null;

try {
  const serviceAccountPath = path.join(__dirname, "../serviceAccountKey.json");
  serviceAccount = JSON.parse(fs.readFileSync(serviceAccountPath, "utf8"));
} catch (e) {
  console.warn("⚠️ Missing serviceAccountKey.json, notifications disabled.");
}

async function sendNotificationToUser(userId, title, body) {
  if (!serviceAccount) return; // không có key thì skip

  const PROJECT_ID = serviceAccount.project_id;
  const SCOPE = "https://www.googleapis.com/auth/firebase.messaging";

  const auth = new GoogleAuth({
    credentials: serviceAccount,
    scopes: [SCOPE],
  });

  const client = await auth.getClient();
  const token = await client.getAccessToken();
  const accessToken = token.token;

  const [rows] = await pool.query("SELECT fcm_token FROM users WHERE id = ?", [
    userId,
  ]);
  if (!rows.length || !rows[0].fcm_token) return;

  await fetch(
    `https://fcm.googleapis.com/v1/projects/${PROJECT_ID}/messages:send`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify({
        message: {
          token: rows[0].fcm_token,
          notification: { title, body },
        },
      }),
    }
  );
}

module.exports = { sendNotificationToUser };
