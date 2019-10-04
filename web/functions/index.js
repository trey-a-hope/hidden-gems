const functions = require('firebase-functions');
const admin = require('firebase-admin');
const Algolia = require('./funcs_algolia');
const PayPal = require('./funcs_paypal');
const StripeCard = require('./stripe/cards/functions');
const StripeToken = require('./stripe/tokens/functions');
const StripeCustomer = require('./stripe/customers/functions');
const StripeCharge = require('./stripe/charges/functions');

admin.initializeApp(functions.config().firebase);

exports.AlgoliaSyncHiddenGemsGemsIndex = Algolia.syncHiddenGemsGemsIndex;
// exports.AlgoliaSyncHiddenGemsUsersIndex = Algolia.syncHiddenGemsUsersIndex;

exports.PayPalCreatePayment = PayPal.createPayment;

//Customers
exports.StripeCreateCustomer = StripeCustomer.create;
exports.StripeUpdateCustomer = StripeCustomer.update;
exports.StripeRetrieveCustomer = StripeCustomer.retrieve;
//Tokens
exports.StripeCreateToken = StripeToken.create;
//Charges
exports.StripeCreateCharge = StripeCharge.create;
exports.StripeListAllCharges = StripeCharge.listAll;
exports.StripeRetrieveCharge = StripeCharge.retrieve;
//Cards
exports.StripeCreateCard = StripeCard.create;
exports.StripeDeleteCard = StripeCard.delete;
