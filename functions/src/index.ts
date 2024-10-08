import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

// Function to send notification on new message
exports.sendChatNotification = functions.firestore
  .document("chatroom/{chatId}/")
  .onCreate(async (snapshot, context) => {
    const mdata = snapshot.data();c

    if (!mdata) {
      console.log("No message data found");
      return;
    }
    const sId = mdata.uids.find((uid: string) => uid != mdata.uid_send_to);
    const rId = mdata.uid_send_to;
    const mcon = mdata.lastMessage;

    // Get receiver's FCM token from Firestore
    const userDoc = await admin.firestore().collection("users").doc(rId).get();
    const userData = userDoc.data();

    if (!userData || !userData.fcmToken) {
      console.log("User does not have an FCM token");
      return;
    }

    const fcmToken = userData.fcmToken;

    // Create the notification payload
    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: `New message from ${sId}`,
        body: mcon.length > 50 ? `${mcon.substring(0, 50)}...` : mcon,
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    // Send the notification
    try {
      await admin.messaging().sendToDevice(fcmToken, payload);
      console.log(`Notification sent to ${rId}`);
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  });
