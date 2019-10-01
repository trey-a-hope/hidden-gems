const functions = require('firebase-functions');
const admin = require('firebase-admin');
const Algolia = require('./funcs_algolia');
const PayPal = require('./funcs_paypal');
const Stripe = require('./funcs_stripe');

admin.initializeApp(functions.config().firebase);

exports.AlgoliaSyncHiddenGemsGemsIndex = Algolia.syncHiddenGemsGemsIndex;
// exports.AlgoliaSyncHiddenGemsUsersIndex = Algolia.syncHiddenGemsUsersIndex;

exports.PayPalCreatePayment = PayPal.createPayment;

exports.StripeCreateCustomer = Stripe.createCustomer;
exports.StripeCreateSource = Stripe.createSource;
exports.StripeCreateToken = Stripe.createToken;
exports.StripeRetrieveCharge = Stripe.retrieveCharge;
exports.StripeRetrieveCharge = Stripe.retrieveCharge;
