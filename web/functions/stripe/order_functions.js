const stripe = require('stripe');
const functions = require('firebase-functions');

/*
    CREATE A ORDER
    https://stripe.com/docs/api/orders/create
*/

exports.create = functions.https.onRequest((request, response) => {
    const apiKey = request.body.apiKey;
    const customerID = request.body.customerID;
    const itemType = request.body.itemType;
    const itemParent = request.body.itemParent;
    const itemQuantity = request.body.itemQuantity;
    const metadata = request.body.metadata;

    var data = {
        currency: 'usd',
        customer: customerID,
        items: [
            {
                type: itemType,
                parent: itemParent,
                quantity: itemQuantity
            }
        ],
        metadata: metadata
    };

    return stripe(apiKey).orders.create(
        data,
        (err, order) => {
            if (err) {
                response.send(err);
            } else {
                response.send(order);
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

    var data = {};

    if (customerID !== undefined) {
        data['customer'] = customerID;
    }

    if (status !== undefined) {
        data['status'] = status;
    }

    return stripe(apiKey).orders.list(
        data,
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

exports.update = functions.https.onRequest((request, response) => {
    const apiKey = request.body.apiKey;
    const orderID = request.body.orderID;
    const status = request.body.status;
    const carrier = request.body.carrier;
    const tracking_number = request.body.tracking_number;

    var data = {};

    if (status !== undefined) {
        data['status'] = status;
    }

    var shippingData = {};

    if (carrier !== undefined) {
        shippingData['carrier'] = carrier;
    }

    if (tracking_number !== undefined) {
        shippingData['tracking_number'] = tracking_number;
    }

    data['shipping'] = shippingData;

    return stripe(apiKey).orders.update(
        orderID,
        {
            status: status,
            shipping: {
                carrier: carrier,
                tracking_number: tracking_number,
            }
        },
        (err, order) => {
            if (err) {
                response.send(err);
            } else {
                response.send(order);
            }
        }
    );
});

/*
    PAY AN ORDER
    https://stripe.com/docs/api/orders/pay
*/

exports.pay = functions.https.onRequest((request, response) => {
    const apiKey = request.body.apiKey;
    const orderID = request.body.orderID;
    const source = request.body.source;
    const customerID = request.body.customerID;

    var data = {
        source: source,
        customer: customerID
    };

    return stripe(apiKey).orders.pay(
        orderID,
        data,
        (err, order) => {
            if (err) {
                response.send(err);
            } else {
                response.send(order);
            }
        }
    );
});