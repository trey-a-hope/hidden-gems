const functions = require('firebase-functions');
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');

const ALGOLIA_APP_ID = 'ZWB00DM8S2';
const ALGOLIA_ADMIN_KEY = '5425be19aea3a951b40826e5549c03f1';
const ALGOLIA_INDEX_NAME = 'Gems';

admin.initializeApp(functions.config().firebase);

exports.addFirestoreDataToAlgolia = functions.https.onRequest((req, res) => {

    var arr = [];

    admin.firestore().collection(ALGOLIA_INDEX_NAME).get().then((docs) => {
        docs.forEach((doc) => {
            let gem = doc.data();
            gem.objectID = doc.id

            arr.push(gem)
        })

        var client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
        var index = client.initIndex(ALGOLIA_INDEX_NAME);

        index.saveObjects(arr, function (err, content) {
            res.status(200).send(content);
        })
    })
})