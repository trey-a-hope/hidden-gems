const stripe = require('stripe');
const functions = require('firebase-functions');

/*
    CREATE A ORDER
    https://stripe.com/docs/api/orders/create
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
    const itemType = request.body.itemType;
    const itemParent = request.body.itemParent;
    const itemQuantity = request.body.itemQuantity;
    const metadata = request.body.metadata;

    return stripe(apiKey).orders.create(
        {
            currency: 'usd',
            email: email,
            items: [
                {
                    type: itemType,
                    parent: itemParent,
                    quantity: itemQuantity
                }
            ],
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

/*
    LIST ALL ORDERS
    https://stripe.com/docs/api/orders/list
*/

exports.list = functions.https.onRequest((request, response) => {
    const apiKey = request.body.apiKey;
    const customerID = request.body.customerID;
    const status = request.body.status;

    return stripe(apiKey).orders.list(
        // {
        //     customer: customerID,
        //     status: status,
        // },
        { limit: 3 },
        (err, orders) => {
            if (err) {
                response.send(err);
            } else {
                response.send(orders);
            }
        }
    );
});

/*
    UPDATE AN ORDER
    https://stripe.com/docs/api/orders/update
*/

exports.list = functions.https.onRequest((request, response) => {
    const apiKey = request.body.apiKey;
    const orderID = request.body.orderID;
    const status = request.body.status;
    const carrier = request.body.carrier;
    const tracking_number = request.body.tracking_number;
    
    return stripe(apiKey).orders.update(
        orderID,
        {
            status: status,
            shipping: {
                carrier: carrier,
                tracking_number: tracking_number,
            }
        },
        (err, orders) => {
            if (err) {
                response.send(err);
            } else {
                response.send(orders);
            }
        }
    );
});

stripe.orders.update('or_1FhqOZGQvSy9RLmzc9vK4BuL', {
    status: 'fulfilled',
    shipping: {
        carrier: 'USPS',
        tracking_number: 'TRACK123',
    },
});