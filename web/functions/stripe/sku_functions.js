const stripe = require('stripe');
const functions = require('firebase-functions');

/*
    RETRIEVE A SKU
    https://stripe.com/docs/api/coupons/retrieve
*/

exports.retrieve = functions.https.onRequest((request, response) => {
    const apiKey = request.body.apiKey;
    const skuID = request.body.skuID;

    return stripe(apiKey).skus.retrieve(
        skuID,
        (err, sku) => {
            if (err) {
                response.send(err);
            } else {
                response.send(sku);
            }
        }
    );
});