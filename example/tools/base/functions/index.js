const admin = require("firebase-admin");

admin.initializeApp();

const userAdmin = require("./src/admin/user");

exports.createUser = userAdmin.createUser;
