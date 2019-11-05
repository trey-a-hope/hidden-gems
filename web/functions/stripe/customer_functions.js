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

    return stripe(apiKey).customers.update(customerID,
        { source: token }, (err, customer) => {
            if (err) {
                response.send(err);
            } else {
                response.send(customer);
            }
        });
});