const functions = require('firebase-functions');
const admin = require('firebase-admin');
const algolia_search = require('algoliasearch');
const algolia_firestore_sync = require('algolia-firestore-sync');

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

        var client = algolia_search(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
        var index = client.initIndex(ALGOLIA_INDEX_NAME);

        index.saveObjects(arr, function (err, content) {
            res.status(200).send(content);
        })
    })
})

// Takes an the Algolia index and key of document to be deleted
// const removeObject = (index, key) => {
//     // then it deletes the document
//     return index.deleteObject(key, (err) => {
//       if (err) throw err
//       console.log( 'Key Removed from Algolia Index', key )
//     })
//   }

// Takes an the Algolia index and data to be added or updated to
//   const upsertObject = ( index, data ) => {
//     // then it adds or updates it
//     return index.saveObject(data, (err, content) => {
//       if (err) throw err
//       console.log(`Document ${data.objectID} Updated in Algolia Index `)
//     })
//   }

// Takes an Algolia index and a Firestore event and uses event data to keep them in sync
//   exports.syncAlgoliaWithFirestore = (index, change, context) => {
//     const data = change.after.exists ? change.after.data() : null; // extract data from Firestore event
//     const key = context.params.id;      // gets the id of the document changed
//     // If no data then it was a delete event
//     if (!data) {
//       // so delete the document from Algolia index
//       return removeObject(index, key );
//     }
//     // add objectId param to data object and set it to key of Firestore document
//     data['objectID'] = key;
//     // upsert the data to the Algolia index
//     return upsertObject( index, data );
//   };

// exports.syncIngredients = functions.firestore.document('/<CollectionName>/{id}').onWrite(
//     (change, context) => {
//       return algoliaSync.syncAlgoliaWithFirestore(index, change, context)
//     }
//   );