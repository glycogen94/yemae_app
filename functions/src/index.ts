/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import * as admin from "firebase-admin";
import {onRequest} from "firebase-functions/v2/https";
import {onCall, HttpsError} from "firebase-functions/v1/https"; // Using v1 for callable for now as requested
import * as logger from "firebase-functions/logger";

// Initialize Firebase Admin SDK
admin.initializeApp();

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// Simple HTTP test function
export const helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

// Basic structure for a callable function for booking requests
export const requestBooking = onCall((data, context) => {
  // Check if the user is authenticated.
  if (!context.auth) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new HttpsError("unauthenticated", "The function must be called " +
                         "while authenticated.");
  }

  logger.info("Authenticated user requesting booking:", {uid: context.auth.uid, data: data});

  // TODO: Implement booking logic here (Phase 4/5)
  // - Validate input data (eventId, seatId, etc.)
  // - Check event status and seat availability
  // - Atomically update seat status and create booking document
  // - Handle potential errors (e.g., seat already booked)

  // Placeholder response for now
  return {
    status: "success",
    message: "Booking request received, processing not yet implemented.",
    receivedData: data,
  };
});
