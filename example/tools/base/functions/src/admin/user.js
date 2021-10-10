const functions = require("firebase-functions");

const admin = require("firebase-admin");
const { Timestamp } = require("@google-cloud/firestore");
const auth = admin.auth();
const db = admin.firestore();

exports.createUser = functions.https.onCall(async (data) => {
  try {
    const userRecord = await auth.createUser({
      email: data.email,
      password: data.password
    });

    return db.collection("users").doc(userRecord.uid).set({
      name: data.name,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    }).then(() => {
      console.log(`${userRecord.uid} | User created successfully!`);
      return JSON.stringify({ "uid": userRecord.uid });
    });
  } catch (e) {
    return Promise.reject(
      console.log(`${data.email} | ${e}`),
    );
  }
});

exports.disableUser = functions.https.onCall(async (data) => {
  try {
    const userRecord = await auth.updateUser(data.uid, { disabled: true });
    console.log(`${userRecord.uid} | User disabled successfully!`);
  } catch (e) {
    return Promise.reject(console.log(`${data.uid} | ${e}`));
  }
});
