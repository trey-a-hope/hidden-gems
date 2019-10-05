const stripe = require('stripe');
const functions = require('firebase-functions');

/*
    CREATE A PRODUCT
    https://stripe.com/docs/api/service_products/create
*/

exports.create = functions.https.onRequest((request, response) => {
    const apiKey = request.body.apiKey;
    const name = request.body.name;
    const type = request.body.type;

    return stripe(apiKey).products.create(
        {
            name: name,
            type: type,
        }, (err, product) => {
            if (err) {
                response.send(err);
            } else {
                response.send(product);
            }
        });

});