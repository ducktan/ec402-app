const Stripe = require("stripe");
const stripe = new Stripe("sk_test_51Sbhsp3Gd6v4W76iqrC0QAaL0SKCYEpfh0qk2E2L2Wdvkp9bt2jR0midtqRMJ4bVKwH91WkyPVcSBrHVNJShNxez005PnQqth3");

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
