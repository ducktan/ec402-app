import { readFileSync } from "fs";
import { GoogleAuth } from "google-auth-library";
import pool from "../config/db.js";

const serviceAccount = JSON.parse(
  readFileSync("./src/serviceAccountKey.json", "utf8")
);

const PROJECT_ID = serviceAccount.project_id;
const SCOPE = "https://www.googleapis.com/auth/firebase.messaging";

async function getAccessToken() {
  const auth = new GoogleAuth({
    credentials: serviceAccount,
    scopes: [SCOPE],
  });

  const client = await auth.getClient();
  const token = await client.getAccessToken();
  return token.token;
}

export async function sendNotificationToUser(userId, title, body) {
  // 1) Query FCM token
  const [rows] = await pool.query(
    "SELECT fcm_token FROM users WHERE id = ?",
    [userId]
  );
  if (!rows.length || !rows[0].fcm_token) return;

  const fcmToken = rows[0].fcm_token;

  // 2) Get access token
  const accessToken = await getAccessToken();

  // 3) Call FCM HTTP v1
  const response = await fetch(
    `https://fcm.googleapis.com/v1/projects/${PROJECT_ID}/messages:send`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify({
        message: {
          token: fcmToken,
          notification: {
            title,
            body,
          },
        },
      }),
    }
  );

  const result = await response.json();
  console.log("FCM response:", result);
}
