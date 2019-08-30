const functions = require('firebase-functions');
const admin = require('firebase-admin');
const algolia_search = require('algoliasearch');
const algolia_firestore_sync = require('algolia-firestore-sync');

const ALGOLIA_APP_ID = 'ZWB00DM8S2';
const ALGOLIA_ADMIN_KEY = '5425be19aea3a951b40826e5549c03f1';
const ALGOLIA_INDEX_NAME = 'Gems';

admin.initializeApp(functions.config().firebase);

//Adds all documents to the Algolia database.
exports.addFirestoreDataToAlgolia = functions.https.onRequest((req, res) => {
    var arr = [];
    admin.firestore().collection(ALGOLIA_INDEX_NAME).get().then((docs) => {
        docs.forEach((doc) => {
            let gem = doc.data();
            gem.objectID = doc.id
            arr.push(gem)
        })
        var client = algolia_search(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
        var index = client.initIndex(ALGOLIA_INDEX_NAME);
        index.saveObjects(arr, function (err, content) {
            res.status(200).send(content);
        })
    })
})

//Add a single document to the Algolia database.
exports.addSingleDoctoAlgolia = functions.https.onRequest((req, res) => {
    var docID = 'DAob2XGAOJyIhVCZ0zok';
    admin.firestore().collection(ALGOLIA_INDEX_NAME).doc(docID).get().then((doc) => {
        let gem = doc.data();
        gem.objectID = doc.id
        var client = algolia_search(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
        var index = client.initIndex(ALGOLIA_INDEX_NAME);
        index.saveObject(gem, function (err, content) {
            res.status(200).send(content);
        })
    })
})
