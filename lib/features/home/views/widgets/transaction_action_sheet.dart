import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:finance_track/features/home/views/widgets/transaction_methods_item.dart';
import 'package:finance_track/core/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class TransactionActionSheet extends StatelessWidget {
  final VoidCallback onVoice;
  const TransactionActionSheet({super.key, required this.onVoice});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.modify(colorCode: AppColors.mainAppColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TransactionMethodsItem(
              text: 'Voice',
              icon: FontAwesomeIcons.microphone,
              onTap: () {
                context.pop();
                onVoice();
              },
            ),
            TransactionMethodsItem(
              text: 'Add Manual',
              icon: FontAwesomeIcons.plus,
              onTap: () => context.pushNamed(RoutesName.addTransactionScreen),
            ),
            TransactionMethodsItem(
              text: 'Scan Receipt',
              icon: FontAwesomeIcons.qrcode,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
