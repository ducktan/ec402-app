const Stripe = require("stripe");
const stripe = new Stripe("");

const createPaymentIntent = async (req, res) => {
  try {
    const { amount } = req.body; // amount = USD * 100

    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(amount * 100),
      currency: "usd",
      automatic_payment_methods: { enabled: true },
    });

    res.status(200).json({
      success: true,
      clientSecret: paymentIntent.client_secret,
    });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};

module.exports = { createPaymentIntent };
