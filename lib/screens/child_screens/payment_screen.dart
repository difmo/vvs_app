import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final double horizontalPadding = width * 0.05;
    final double cardRadius = width * 0.035;
    final double fontScale = width / 390;

    const Color iconColor = Color(0xFFFF8F00);
    const Color buttonColor = Color(0xFFFF6F00);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAmountCard(fontScale, cardRadius, iconColor),
              SizedBox(height: height * 0.03),

              Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 18 * fontScale,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: height * 0.015),

              _buildPaymentMethod(
                icon: FontAwesomeIcons.creditCard,
                title: 'Credit / Debit Card',
                fontScale: fontScale,
                radius: cardRadius,
                iconColor: iconColor,
              ),
              _buildPaymentMethod(
                icon: FontAwesomeIcons.moneyBillTransfer,
                title: 'UPI',
                fontScale: fontScale,
                radius: cardRadius,
                iconColor: iconColor,
              ),
              _buildPaymentMethod(
                icon: FontAwesomeIcons.buildingColumns,
                title: 'Net Banking',
                fontScale: fontScale,
                radius: cardRadius,
                iconColor: iconColor,
              ),
              _buildPaymentMethod(
                icon: FontAwesomeIcons.wallet,
                title: 'Wallets',
                fontScale: fontScale,
                radius: cardRadius,
                iconColor: iconColor,
              ),

              SizedBox(height: height * 0.03),
              _buildCardDetailsForm(fontScale, cardRadius, iconColor),
              SizedBox(height: height * 0.04),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(cardRadius),
                    ),
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    elevation: 5,
                    shadowColor: buttonColor.withOpacity(0.3),
                  ),
                  child: Text(
                    'Pay ₹1,299',
                    style: TextStyle(
                      fontSize: 17 * fontScale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.025),
              Center(
                child: Text(
                  '🔒 100% Secure Payment',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14 * fontScale,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountCard(double fontScale, double radius, Color iconColor) {
    return Container(
      padding: EdgeInsets.all(16 * fontScale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10 * fontScale),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              FontAwesomeIcons.receipt,
              color: iconColor,
            ),
          ),
          SizedBox(width: 12 * fontScale),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 15 * fontScale,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 5 * fontScale),
              Text(
                '₹1,299',
                style: TextStyle(
                  fontSize: 26 * fontScale,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPaymentMethod({
    required IconData icon,
    required String title,
    required double fontScale,
    required double radius,
    required Color iconColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      margin: EdgeInsets.symmetric(vertical: 6 * fontScale),
      elevation: 0.5,
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 20 * fontScale),
        title: Text(
          title,
          style: TextStyle(fontSize: 15 * fontScale, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14 * fontScale, color: Colors.grey),
        onTap: () {},
      ),
    );
  }

  Widget _buildCardDetailsForm(double fontScale, double radius, Color iconColor) {
    return Container(
      padding: EdgeInsets.all(16 * fontScale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card Details',
            style: TextStyle(
              fontSize: 18 * fontScale,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16 * fontScale),
          _buildInputField(
            hint: 'Card Number',
            icon: Icons.credit_card,
            fontScale: fontScale,
            iconColor: iconColor,
          ),
          SizedBox(height: 12 * fontScale),
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  hint: 'MM/YY',
                  fontScale: fontScale,
                  iconColor: iconColor,
                ),
              ),
              SizedBox(width: 12 * fontScale),
              Expanded(
                child: _buildInputField(
                  hint: 'CVV',
                  fontScale: fontScale,
                  obscure: true,
                  iconColor: iconColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12 * fontScale),
          _buildInputField(
            hint: 'Cardholder Name',
            fontScale: fontScale,
            iconColor: iconColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    double fontScale = 1,
    IconData? icon,
    bool obscure = false,
    required Color iconColor,
  }) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: icon != null
            ? Icon(icon, color: iconColor, size: 20 * fontScale)
            : null,
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14 * fontScale, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16 * fontScale,
          vertical: 14 * fontScale,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10 * fontScale),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
