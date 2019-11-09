const stripe = require('stripe');
const functions = require('firebase-functions');

/*
    RETRIEVE A CUSTOMER
    Retrieves the details of an existing customer. You need only supply the unique customer identifier that was returned upon customer creation.
    PARAMS
    String customerID;
*/
exports.retrieve = functions.https.onRequest((request, response) => {
    const apiKey = request.body.apiKey;
    const customerID = request.body.customerID;

    return stripe(apiKey).customers.retrieve(customerID, (err, charge) => {
        if (err) {
            response.send(err);
        } else {
            response.send(charge);
        }
    });
});

/*
    CREATE A CUSTOMER
    Creates a new customer.
    PARAMS
    String email, String description.
*/
exports.create = functions.https.onRequest((request, response) => {
    const apiKey = request.body.apiKey;
    const email = request.body.email;
    const description = request.body.description;
    const name = request.body.name;

    return stripe(apiKey).customers.create({
        description: description,
        email: email,
        name: name
    }, (err, customer) => {
        if (err) {
            response.send(err);
        } else {
            response.send(customer);
        }
    });
});

/*
    UPDATE A CUSTOMER
    Update a customer.
    PARAMS
    ?
*/
exports.update = functions.https.onRequest((request, response) => {
    const apiKey = request.body.apiKey;
    const customerID = request.body.customerID;
    const token = request.body.token;
    const line1 = request.body.line1;
    const city = request.body.city;
    const country = request.body.country;
    const postal_code = request.body.postal_code;
    const state = request.body.state;
    const name = request.body.name;
    const email = request.body.email;
    const default_source = request.body.default_source;

    return stripe(apiKey).customers.update(customerID,
        {
            source: token,
            email: email,
            name: name,
            default_source: default_source,
            address: {
                line1: line1,
                city: city,
                country: country,
                postal_code: postal_code,
                state: state
            }
        }, (err, customer) => {
            if (err) {
                response.send(err);
            } else {
                response.send(customer);
            }
        });
});

/*
    DELETE A CUSTOMER
    Permanently deletes a customer. It cannot be undone. Also immediately cancels any active subscriptions on the customer.
    PARAMS
    String customerID;
*/
exports.delete = functions.https.onRequest((request, response) => {
    const apiKey = request.body.apiKey;
    const customerID = request.body.customerID;

    return stripe(apiKey).customers.del(customerID, (err, confirmation) => {
        if (err) {
            response.send(err);
        } else {
            response.send(confirmation);
        }
    });
});