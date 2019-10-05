const stripe = require('stripe');
const functions = require('firebase-functions');

/*
    RETRIEVE A CHARGE
    Retreives a charge.
    PARAMS
    String chargeId;
*/
exports.retrieve = functions.https.onRequest((request, response) => {
    const apiKey = request.body.apiKey;
    const chargeId = request.body.chargeId;

    return stripe(apiKey).charges.retrieve(chargeId, (err, charge) => {
        if (err) {
            response.send(err);
        } else {
            response.send(charge);
        }
    });

});

/*
    CREATE A CHARGE
    Creates a new charge.
    PARAMS
    String chargeId;
*/
exports.create = functions.https.onRequest((request, response) => {
    const apiKey = request.body.apiKey;
    const amount = request.body.amount;
    const description = request.body.description;
    const customerId = request.body.customerId;

    return stripe(apiKey).charges.create({
        amount: amount,
        currency: "usd",
        customer: customerId,
        description: description
    }, (err, charge) => {
        if (err) {
            response.send(err);
        } else {
            response.send(charge);
        }
    });

});

/*
    LIST CHARGES
    List all charges to a customer.
    PARAMS
    String chargeId;
*/
exports.listAll = functions.https.onRequest((request, response) => {
    const apiKey = request.body.apiKey;
    const customerId = request.body.customerId;

    return stripe(apiKey).charges.list({ customer: customerId }, (err, charge) => {
        if (err) {
            response.send(err);
        } else {
            response.send(charge);
        }
    });

});
