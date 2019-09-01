const functions = require('firebase-functions');
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');
const algoliaSync = require('algolia-firestore-sync');

const ALGOLIA_APP_ID = 'ZWB00DM8S2';
const ALGOLIA_ADMIN_KEY = '5425be19aea3a951b40826e5549c03f1';
const ALGOLIA_INDEX_NAME = 'Gems';

admin.initializeApp(functions.config().firebase);

exports.updateGem = functions.firestore
    .document('Gems/{id}')
    .onWrite((change, context) => {
        var client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
        var index = client.initIndex(ALGOLIA_INDEX_NAME);
        return algoliaSync.syncAlgoliaWithFirestore(index, change, context);
    });