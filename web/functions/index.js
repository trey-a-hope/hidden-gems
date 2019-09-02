const functions = require('firebase-functions');
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');
const algoliaSync = require('algolia-firestore-sync');
const stripe = require("stripe")("sk_test_7VBBm17Ry1fpkpa8u7w1esNA");

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

/*
    RETRIEVE A CHARGE

    Retrieves the details of a charge that has previously been created. 
    Supply the unique charge ID that was returned from your previous request, 
    and Stripe will return the corresponding charge information. The same 
    information is returned when creating or refunding the charge.

    PARAMS

    String chargeId;
*/
exports.retrieveCard = functions.https.onRequest((request, response) => {
    const chargeId = request.query.chargeId;

    return stripe.charges.retrieve(chargeId, (err, charge) => {
        if (err) throw err;
        response.status(200).send(charge);
    });
});
