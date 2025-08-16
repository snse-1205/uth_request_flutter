const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotification = functions.https.onRequest(async (req, res) => {
  if (req.method !== "POST") {
    return res.status(405).send("Método no permitido");
  }

  const {fcmtoken, title, body} = req.body;

  if (!fcmtoken || !title || !body) {
    // eslint-disable-next-line max-len
    return res.status(400).send("Faltan parámetros: fcmtoken, title y body son requeridos.");
  }

  const message = {
    token: fcmtoken,
    notification: {
      title: title,
      body: body,
    },
    android: {
      priority: "high",
    },
    apns: {
      payload: {
        aps: {
          sound: "default",
        },
      },
    },
  };

  try {
    const response = await admin.messaging().send(message);
    return res.status(200).json({success: true, messageId: response});
  } catch (error) {
    console.error("Error al enviar la notificación:", error);
    return res.status(500).json({success: false, error: error.message});
  }
});
