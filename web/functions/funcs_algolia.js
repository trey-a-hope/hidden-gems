const functions = require('firebase-functions');
const algoliasearch = require('algoliasearch');
const algoliaSync = require('algolia-firestore-sync');

const HIDDEN_GEMS_APP_ID = 'ZWB00DM8S2';
const HIDDEN_GEMS_ADMIN_KEY = '5425be19aea3a951b40826e5549c03f1';

exports.syncHiddenGemsGemsIndex = functions.firestore
    .document('Gems/{id}')
    .onWrite((change, context) => {
        var client = algoliasearch(HIDDEN_GEMS_APP_ID, HIDDEN_GEMS_ADMIN_KEY);
        var index = client.initIndex('Gems');
        return algoliaSync.syncAlgoliaWithFirestore(index, change, context);
    });

exports.syncHiddenGemsUsersIndex = functions.firestore
    .document('Users/{id}')
    .onWrite((change, context) => {
        var client = algoliasearch(HIDDEN_GEMS_APP_ID, HIDDEN_GEMS_ADMIN_KEY);
        var index = client.initIndex('Users');
        return algoliaSync.syncAlgoliaWithFirestore(index, change, context);
    });
