import 'package:finance_track/core/models/transactions_model.dart';
import 'package:finance_track/core/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransactionsList extends StatelessWidget {
  final List<TransactionModel> transactions;
  const TransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      child: SliverList.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Slidable(
            key: ValueKey(transaction.id),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.4,
              children: [
                SlidableAction(
                  onPressed: (context) {
                    context.pushNamed(
                      RoutesName.editTransactionScreen,
                      extra: transaction,
                    );
                  },
                  backgroundColor: Theme.of(context).cardColor,
                  foregroundColor: Colors.blue,
                  icon: Icons.edit,
                  borderRadius: BorderRadius.circular(12.r),
                  label: 'Edit',
                ),
              ],
            ),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ListTile(
                title: Text(transaction.title),
                subtitle: Text(
                  DateFormat('dd MMM yyyy').format(transaction.date),
                ),
                trailing: Text(
                  '${transaction.type == "income" ? '+' : '-'} \$${transaction.amount}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: transaction.type == "income"
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
