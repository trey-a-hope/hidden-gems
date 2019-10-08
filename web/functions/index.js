const functions = require('firebase-functions');
const admin = require('firebase-admin');
const Algolia = require('./funcs_algolia');
const PayPal = require('./funcs_paypal');
const StripeCard = require('./stripe/card_functions');
const StripeToken = require('./stripe/token_functions');
const StripeCustomer = require('./stripe/customer_functions');
const StripeCharge = require('./stripe/charge_functions');
const StripeSubscription = require('./stripe/subscription_functions');
const StripeProduct = require('./stripe/product_functions');

admin.initializeApp(functions.config().firebase);

exports.AlgoliaSyncHiddenGemsGemsIndex = Algolia.syncHiddenGemsGemsIndex;
exports.AlgoliaSyncHiddenGemsUsersIndex = Algolia.syncHiddenGemsUsersIndex;

exports.PayPalCreatePayment = PayPal.createPayment;

//Cards
exports.StripeCreateCard = StripeCard.create;
exports.StripeDeleteCard = StripeCard.delete;

//Charges
exports.StripeCreateCharge = StripeCharge.create;
exports.StripeListAllCharges = StripeCharge.listAll;
exports.StripeRetrieveCharge = StripeCharge.retrieve;

//Customers
exports.StripeCreateCustomer = StripeCustomer.create;
exports.StripeUpdateCustomer = StripeCustomer.update;
exports.StripeRetrieveCustomer = StripeCustomer.retrieve;

//Products
exports.StripeCreateProduct = StripeProduct.create;

//Subscriptions
exports.StripeCreateSubscription = StripeSubscription.create;

//Tokens
exports.StripeCreateToken = StripeToken.create;


