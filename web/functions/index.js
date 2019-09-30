const functions = require('firebase-functions');//Default
const admin = require('firebase-admin');//Default
const algoliasearch = require('algoliasearch');//Hidden Gems
const algoliaSync = require('algolia-firestore-sync');//Hidden Gems
const stripe = require('stripe')('sk_test_7VBBm17Ry1fpkpa8u7w1esNA');//Camp Central
const paypal = require('paypal-rest-sdk');//Nanny McTea Sitters

const ALGOLIA_APP_ID = 'ZWB00DM8S2';//Hidden Gems
const ALGOLIA_ADMIN_KEY = '5425be19aea3a951b40826e5549c03f1';//Hidden Gems
const ALGOLIA_INDEX_NAME = 'Gems';//Hidden Gems

const CLIENT_SECRET = 'ELPBoRBNTzm3Lms4Ppb4GWmzXynihrOFKx08SN2RBt8ufUfkquPL10h0MQKPFYnkZ74AEmLOfYJi9ecv';
const CLIENT_ID = 'ARGe9IWt26EnBy9sIp3AYtOOQWLPKhw3_Ar5A9mpgriPZHi6WXrmvTyrUd08E5zDb_nRau_QqOQ_Tzgc';

/*
    Initializations
*/
admin.initializeApp(functions.config().firebase);

paypal.configure({
    'mode': 'sandbox', //sandbox or live
    'client_id': CLIENT_ID,
    'client_secret': CLIENT_SECRET
});

exports.createPayment = functions.https.onRequest((request, response) => {
    var create_payment_json = {
        "intent": "sale",
        "payer": {
            "payment_method": "paypal"
        },
        "redirect_urls": {
            "return_url": "http://return.url",
            "cancel_url": "http://cancel.url"
        },
        "transactions": [{
            "item_list": {
                "items": [{
                    "name": "item",
                    "sku": "item",
                    "price": "1.00",
                    "currency": "USD",
                    "quantity": 1
                }]
            },
            "amount": {
                "currency": "USD",
                "total": "1.00"
            },
            "description": "This is the payment description."
        }]
    };

    paypal.payment.create(create_payment_json, function (err, payment) {
        if (err) {
            response.send(err);
        } else {
            response.send(payment);
        }
    });
    // const token = request.query.type;
    // const email = request.query.email;

    // return stripe.sources.create({
    //     token: token,
    //     currency: 'usd',
    //     owner: {
    //         email: email
    //     }
    // }, (err, charge) => {
    //     if (err) {
    //         response.send(err);
    //     } else {
    //         response.send(charge);
    //     }
    // });

});


/*
    SYNC FIRESTORE WITH ALGOLIA

    Ony create, delete, or update of document in Gem table, data is instally updated
    to the Algolia database.

    PARAMS

    None
*/
exports.updateGem = functions.firestore
    .document('Gems/{id}')
    .onWrite((change, context) => {
        var client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
        var index = client.initIndex(ALGOLIA_INDEX_NAME);
        return algoliaSync.syncAlgoliaWithFirestore(index, change, context);
    });

/*
    RETRIEVE A CHARGE

    Creates a new source object.

    PARAMS

    String chargeId;
*/
exports.retrieveCharge = functions.https.onRequest((request, response) => {
    const chargeId = request.query.chargeId;

    return stripe.charges.retrieve(chargeId, (err, charge) => {
        if (err) {
            response.send(err);
        } else {
            response.send(charge);
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
    const token = request.query.type;
    const email = request.query.email;

    return stripe.sources.create({
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
    const number = request.query.number;
    const exp_month = request.query.exp_month;
    const exp_year = request.query.exp_year;
    const cvc = request.query.cvc;

    return stripe.tokens.create(
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