const functions = require('firebase-functions');
const admin = require('firebase-admin');
const Algolia = require('./funcs_algolia');
const PayPal = require('./funcs_paypal');
const StripeCard = require('./stripe/card_functions');
const StripeToken = require('./stripe/token_functions');
const StripeCustomer = require('./stripe/customer_functions');
const StripeCoupon = require('./stripe/coupon_functions');
const StripeCharge = require('./stripe/charge_functions');
const StripeSubscription = require('./stripe/subscription_functions');
const StripeOrder = require('./stripe/order_functions');
const StripeProduct = require('./stripe/product_functions');
const StripeSku = require('./stripe/sku_functions');
const Email = require('./email/email_functions');

admin.initializeApp(functions.config().firebase);

//Algolia
exports.AlgoliaSyncHiddenGemsGemsIndex = Algolia.syncHiddenGemsGemsIndex;
exports.AlgoliaSyncHiddenGemsUsersIndex = Algolia.syncHiddenGemsUsersIndex;

//Paypal
exports.PayPalCreatePayment = PayPal.createPayment;

//Email
exports.SendEmail = Email.send;

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
exports.StripeDeleteCustomer = StripeCustomer.delete;

//Coupons
exports.StripeRetrieveCoupon = StripeCoupon.retrieve;

//Orders
exports.StripeCreateOrder = StripeOrder.create;
exports.StripeListOrders = StripeOrder.list;
exports.StripeUpdateOrder = StripeOrder.update;
exports.StripePayOrder = StripeOrder.pay;

//Products
exports.StripeCreateProduct = StripeProduct.create;

//Skus
exports.StripeRetrieveSku = StripeSku.retrieve;

//Subscriptions
exports.StripeCreateSubscription = StripeSubscription.create;

//Tokens
exports.StripeCreateToken = StripeToken.create;


