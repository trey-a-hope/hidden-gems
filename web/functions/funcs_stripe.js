const stripe = require('stripe');
const functions = require('firebase-functions');

/*
    RETRIEVE A CHARGE
    Creates a new source object.
    PARAMS
    String chargeId;
*/
exports.retrieveCharge = functions.https.onRequest((request, response) => {
    const apiKey = request.query.apiKey;
    const chargeId = request.query.chargeId;

    return stripe(apiKey).charges.retrieve(chargeId, (err, charge) => {
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
exports.createCustomer = functions.https.onRequest((request, response) => {
    const apiKey = request.query.apiKey;
    const email = request.query.email;
    const description = request.query.description;

    return stripe(apiKey).customers.create({
        description: description,
        email: email
    }, (err, customer) => {
        if (err) {
            response.send(err);
        } else {
            response.send(customer);
        }
    });
});

/*
    CREATE A SOURCE

    Retrieves the details of a charge that has previously been created. 
    Supply the unique charge ID that was returned from your previous request, 
    and Stripe will return the corresponding charge information. The same 
    information is returned when creating or refunding the charge.

    PARAMS

    String token, email;
*/

exports.createSource = functions.https.onRequest((request, response) => {
    const apiKey = request.query.apiKey;
    const token = request.query.type;
    const email = request.query.email;

    return stripe(apiKey).sources.create({
        token: token,
        currency: 'usd',
        owner: {
            email: email
        }
    }, (err, charge) => {
        if (err) {
            response.send(err);
        } else {
            response.send(charge);
        }
    });

});

/*
    CREATE A TOKEN

    Creates a single-use token that represents a credit card’s details. 
    This token can be used in place of a credit card object with any API method. 
    These tokens can be used only once: by creating a new Charge object, or by attaching 
    them to a Customer object.

    PARAMS 

    String number, cvc
    Int exp_month, exp_year
*/

exports.createToken = functions.https.onRequest((request, response) => {
    const apiKey = request.query.apiKey;
    const number = request.query.number;
    const exp_month = request.query.exp_month;
    const exp_year = request.query.exp_year;
    const cvc = request.query.cvc;

    return stripe(apiKey).tokens.create(
        {
            card: {
                number: number,
                exp_month: exp_month,
                exp_year: exp_year,
                cvc: cvc
            }
        }, (err, charge) => {
            if (err) {
                response.send(err);
            } else {
                response.send(charge);
            }
        });

});