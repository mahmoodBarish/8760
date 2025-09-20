import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart'; // Add go_router import

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _selectedDeliveryType = 0; // 0 for Deliver, 1 for Pick Up
  int _itemQuantity = 1;

  final Color _primaryColor = const Color(0xFFC67C4E);
  final Color _darkTextColor = const Color(0xFF242424);
  final Color _mediumDarkTextColor = const Color(0xFF313131);
  final Color _greyTextColor = const Color(0xFFA2A2A2);
  final Color _lightGreyColor = const Color(0xFFEDEDED);
  final Color _veryLightBrown = const Color(0xFFF9F2ED);
  final Color _lightLineColor = const Color(0xFFE3E3E3);

  // Define the fixed height of the bottom order button section
  // Container padding: 16 (top) + 16 (bottom) = 32
  // ElevatedButton height: 56
  // Total fixed height = 32 + 56 = 88
  static const double _bottomOrderButtonSectionHeight = 88.0;


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: _darkTextColor),
          onPressed: () {
            context.pop(); // Use go_router for back navigation
          },
        ),
        title: Text(
          'Order',
          style: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _darkTextColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column( // Removed redundant SafeArea from body, AppBar handles top. Bottom SafeArea handled around _buildOrderButton.
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(
                bottom: _bottomOrderButtonSectionHeight, // Add padding to make space for the fixed bottom button
              ),
              children: [
                const SizedBox(height: 16),
                _buildDeliveryTypeToggle(screenWidth),
                const SizedBox(height: 24),
                _buildDeliveryAddressSection(),
                const SizedBox(height: 16),
                Divider(color: _veryLightBrown, thickness: 4),
                const SizedBox(height: 16),
                _buildCheckoutProduct(),
                const SizedBox(height: 16),
                Divider(color: _lightLineColor, thickness: 1),
                const SizedBox(height: 16),
                _buildDiscountSection(),
                const SizedBox(height: 24),
                _buildPaymentSummarySection(),
                const SizedBox(height: 24),
                _buildPaymentMethodSection(),
                const SizedBox(height: 24), // Ensure content above button always has some spacing, even if button is minimal
              ],
            ),
          ),
          // This SafeArea will correctly apply padding for the home indicator only to the bottom of the order button container
          SafeArea(
            top: false, // Only care about the bottom safe area
            child: _buildOrderButton(), // Pass no bottomPadding here, SafeArea handles it
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTypeToggle(double screenWidth) {
    return Container(
      width: screenWidth,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: _lightGreyColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDeliveryType = 0;
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                decoration: BoxDecoration(
                  color: _selectedDeliveryType == 0 ? _primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Deliver',
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _selectedDeliveryType == 0 ? Colors.white : _darkTextColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDeliveryType = 1;
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                decoration: BoxDecoration(
                  color: _selectedDeliveryType == 1 ? _primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Pick Up',
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: _selectedDeliveryType == 1 ? Colors.white : _darkTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Address',
          style: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _darkTextColor,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jl. Kpg Sutoyo',
              style: GoogleFonts.sora(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _mediumDarkTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Kpg. Sutoyo No. 620, Bilzen, Tanjungbalai.',
              style: GoogleFonts.sora(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: _greyTextColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildSmallActionButton(
              icon: Icons.edit_outlined,
              text: 'Edit Address',
              onPressed: () {
                context.push('/edit_address'); // Use go_router
              },
            ),
            const SizedBox(width: 8),
            _buildSmallActionButton(
              icon: Icons.note_add_outlined,
              text: 'Add Note',
              onPressed: () {
                context.push('/add_note'); // Use go_router
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: _mediumDarkTextColor,
        side: BorderSide(color: _greyTextColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Icon(icon, size: 14, color: _mediumDarkTextColor),
      label: Text(
        text,
        style: GoogleFonts.sora(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _mediumDarkTextColor,
        ),
      ),
    );
  }

  Widget _buildCheckoutProduct() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/I189_285_417_715.png',
            width: 54,
            height: 54,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Caffe Mocha',
                style: GoogleFonts.sora(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _darkTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Deep Foam',
                style: GoogleFonts.sora(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: _greyTextColor,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _lightGreyColor),
              ),
              child: IconButton(
                iconSize: 16,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(Icons.remove, color: _greyTextColor),
                onPressed: () {
                  setState(() {
                    if (_itemQuantity > 1) {
                      _itemQuantity--;
                    }
                  });
                },
              ),
            ),
            const SizedBox(width: 18),
            Text(
              '$_itemQuantity',
              style: GoogleFonts.sora(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _mediumDarkTextColor,
              ),
            ),
            const SizedBox(width: 18),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _lightGreyColor),
              ),
              child: IconButton(
                iconSize: 16,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(Icons.add, color: _mediumDarkTextColor),
                onPressed: () {
                  setState(() {
                    _itemQuantity++;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDiscountSection() {
    return GestureDetector(
      onTap: () {
        context.push('/discounts'); // Use go_router
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _lightGreyColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.local_offer_outlined, color: _primaryColor),
                const SizedBox(width: 16),
                Text(
                  '1 Discount is Applies',
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _mediumDarkTextColor,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: _mediumDarkTextColor),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Summary',
          style: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _darkTextColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Price',
              style: GoogleFonts.sora(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _mediumDarkTextColor,
              ),
            ),
            Text(
              '\$ 4.53',
              style: GoogleFonts.sora(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _darkTextColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Delivery Fee',
              style: GoogleFonts.sora(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _mediumDarkTextColor,
              ),
            ),
            Row(
              children: [
                Text(
                  '\$ 2.0',
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: _mediumDarkTextColor,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '\$ 1.0',
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _darkTextColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return GestureDetector(
      onTap: () {
        context.push('/payment_methods'); // Use go_router
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined, color: _primaryColor),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cash/Wallet',
                    style: GoogleFonts.sora(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _darkTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$ 5.53',
                    style: GoogleFonts.sora(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Icon(Icons.keyboard_arrow_down, color: _mediumDarkTextColor),
        ],
      ),
    );
  }

  Widget _buildOrderButton() { // Removed bottomPadding parameter as SafeArea handles it
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16), // Fixed padding for content, SafeArea will add system padding below
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -5), // changes position of shadow
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          context.push('/order_success'); // Navigate to order success screen using go_router
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          minimumSize: const Size(double.infinity, 56), // Ensure full width
        ),
        child: Text(
          'Order',
          style: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}