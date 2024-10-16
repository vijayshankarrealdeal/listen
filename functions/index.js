/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const functions = require("firebase-functions");
const {
  RtcTokenBuilder,
  RtcRole,
} = require("agora-token");

exports.generateToken = functions.https.onCall(async (data, context) => {
    const appId = "6a512fec263245de80fcbd260f9d5f64";
    const appCertificate = "0313142ce6a847e0b7cde7fef8870fc2";
    const channelName = data.channelName;
    const uid = data.uid || 0;
    const role = RtcRole.PUBLISHER;
  
    const expirationTimeInSeconds = data.expiryTime;
    const currentTimestamp = Math.floor(Date.now() / 1000);
    const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;
  
    if (channelName === undefined || channelName === null) {
      throw new functions.https.HttpsError(
          "aborted",
          "Channel name is required",
      );
    }
  
    try {
      const token = RtcTokenBuilder.buildTokenWithUid(
          appId,
          appCertificate,
          channelName,
          uid,
          role,
          privilegeExpiredTs,
      );
      return token;
    } catch (err) {
      throw new functions.https.HttpsError(
          "aborted",
          "Could not generate token",
      );
    }
  });