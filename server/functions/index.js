/**
 * @author Sxribe
 * @description API file, provides method for getting a ban list without listed reasons.
 */

const functions = require('firebase-functions');
const admin = require("firebase-admin");
admin.initializeApp();

exports.getBanList = functions.https.onRequest( async (request, response) => {
  let db = admin.database();
  let ref = await ( db.ref("/bans") ).get();
  let val = ref.val();

  let bansById = Object.keys(val);
  response.json(bansById);
});