import 'package:flutter/material.dart'; // Only one import needed

class PaymentOptionsSheet extends StatelessWidget {
  final double amountToPay;
  final VoidCallback onPaymentSuccess;

  const PaymentOptionsSheet({
    Key? key,
    required this.amountToPay,
    required this.onPaymentSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Select Payment Method',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Amount to Pay: LKR ${amountToPay.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildPaymentOption(
            context,
            'Card Payment',
            Icons.credit_card,
            () {
              Navigator.pop(context); // Close the sheet
              _showThankYouPopup(context);
            },
          ),
          const SizedBox(height: 15),
          _buildPaymentOption(
            context,
            'PayPal',
            Icons.paypal, // Placeholder icon
            () {
              Navigator.pop(context);
              _showThankYouPopup(context);
            },
          ),
          const SizedBox(height: 15),
          _buildPaymentOption(
            context,
            'iPay',
            Icons.payment, // Placeholder icon
            () {
              Navigator.pop(context);
              _showThankYouPopup(context);
            },
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showThankYouPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap OK to dismiss
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            'Thank You!',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.green.shade700, fontWeight: FontWeight.bold),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
              SizedBox(height: 15),
              Text(
                'Your payment was successful.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(); // Dismiss the thank you popup
                onPaymentSuccess(); // Trigger the callback to update points
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentOption(BuildContext context, String title, IconData icon,
      VoidCallback onPressed) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap:
            onPressed, // This will now correctly trigger the provided onPressed callback
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Row(
            children: [
              Icon(icon, size: 30, color: Theme.of(context).primaryColor),
              const SizedBox(width: 15),
              Expanded(
                // Using Expanded to make the text take available space
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
