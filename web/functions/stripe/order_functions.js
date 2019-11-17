const stripe = require('stripe');
const functions = require('firebase-functions');

/*
    CREATE A PRODUCT
    https://stripe.com/docs/api/service_products/create
*/

exports.create = functions.https.onRequest((request, response) => {
    const apiKey = request.body.apiKey;
    const email = request.body.email;
    const name = request.body.name;
    const line1 = request.body.line1;
    const city = request.body.city;
    const state = request.body.state;
    const country = request.body.country;
    const postal_code = request.body.postal_code;
    const items = request.body.items;
    const metadata = request.body.metadata;

    return stripe(apiKey).orders.create(
        {
            currency: 'usd',
            email: email,
            items: items,
            shipping: {
                name: name,
                address: {
                    line1: line1,
                    city: city,
                    state: state,
                    country: country,
                    postal_code: postal_code,
                },
            },
            metadata: metadata
        },
        (err, product) => {
            if (err) {
                response.send(err);
            } else {
                response.send(product);
            }
        }
    );
});