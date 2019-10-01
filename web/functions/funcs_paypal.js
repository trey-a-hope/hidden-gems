//Nanny McTea Sitters
const functions = require('firebase-functions');
const paypal = require('paypal-rest-sdk');
const CLIENT_SECRET = 'ELPBoRBNTzm3Lms4Ppb4GWmzXynihrOFKx08SN2RBt8ufUfkquPL10h0MQKPFYnkZ74AEmLOfYJi9ecv';
const CLIENT_ID = 'ARGe9IWt26EnBy9sIp3AYtOOQWLPKhw3_Ar5A9mpgriPZHi6WXrmvTyrUd08E5zDb_nRau_QqOQ_Tzgc';

paypal.configure({
    'mode': 'sandbox', //sandbox or live
    'client_id': CLIENT_ID,
    'client_secret': CLIENT_SECRET
});

exports.createPayment = functions.https.onRequest((request, response) => {
    const name = request.body.name;
    const sku = request.body.sku;
    const price = request.body.price;
    const description = request.body.description;
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
                    "name": name,
                    "sku": sku,
                    "price": price,
                    "currency": "USD",
                    "quantity": 1
                }]
            },
            "amount": {
                "currency": "USD",
                "total": price
            },
            "description": description
        }]
    };

    return paypal.payment.create(create_payment_json, function (err, payment) {
        if (err) {
            response.send(err);
        } else {
            response.send(payment);
        }
    });
});