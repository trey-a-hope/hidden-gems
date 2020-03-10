const stripe = require('stripe');
const functions = require('firebase-functions');

/*
    CREATE A SUBSCRIPTION
    https://stripe.com/docs/api/subscriptions/create
*/

exports.create = functions.https.onRequest((request, response) => {
    const apiKey = request.body.apiKey;
    const customerID = request.body.customerID;
    const plan = request.body.plan;

    var data = {
        customer: customerID,
        items: [
            {
                plan: plan,
            },
        ],
        billing_cycle_anchor: Math.floor(new Date(Date.now() + 1000 /*sec*/ * 60 /*min*/ * 60 /*hour*/ * 24 /*day*/ * 1) / 1000)
    };

    return stripe(apiKey).subscriptions.create(
        data, (err, subscription) => {
            if (err) {
                response.send(err);
            } else {
                response.send(subscription);
            }
        });

});