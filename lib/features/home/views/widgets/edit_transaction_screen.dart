import 'package:finance_track/core/models/category_model.dart';
import 'package:finance_track/core/models/transactions_model.dart';
import 'package:finance_track/core/utils/customs/custom_buttons/custom_button.dart';
import 'package:finance_track/core/utils/customs/textformfield/custom_textfomfield.dart';
import 'package:finance_track/core/utils/helper/category/category_list.dart';
import 'package:finance_track/core/utils/popups/toast.dart';
import 'package:finance_track/features/home/logic/transactions/transaction_cubit.dart';
import 'package:finance_track/features/home/logic/transactions/transaction_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EditTransaction extends StatelessWidget {
  const EditTransaction({super.key, required this.transaction});
  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionCubit(),
      child: EditTransactionScreen(transaction: transaction),
    );
  }
}

class EditTransactionScreen extends StatefulWidget {
  final TransactionModel transaction;
  const EditTransactionScreen({super.key, required this.transaction});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  bool isExpense = false;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  DateTime? _selectedDate;
  CategoryModel? _selectedCategory;

  double? _parseAmount(String raw) {
    const arabicIndic = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
    };
    String normalized = raw.trim();
    arabicIndic.forEach((k, v) {
      normalized = normalized.replaceAll(k, v);
    });
    normalized = normalized
        .replaceAll('٬', '') // Arabic thousands separator
        .replaceAll(',', '') // Common thousands separator
        .replaceAll('٫', '.') // Arabic decimal separator
        .replaceAll(' ', '');
    return double.tryParse(normalized);
  }

  @override
  void initState() {
    super.initState();
    final t = widget.transaction;
    isExpense = t.type == 'expense' ? true : false;
    _titleController = TextEditingController(text: t.title);
    _amountController = TextEditingController(text: t.amount.toString());
    _noteController = TextEditingController(text: t.note);
    _selectedDate = t.date;
    if (t.categoryName != null) {
      _selectedCategory = categories.firstWhere(
        (c) => c.name == t.categoryName,
        orElse: () => CategoryModel(name: t.categoryName ?? ""),
      );
    }
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 3 ~/ 2)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3 ~/ 2)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: isExpense ? Colors.redAccent : Colors.green,
            onPrimary: Colors.white,
            onSurface: isExpense ? Colors.redAccent : Colors.green,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _showCategoryPicker() {
    final incomeCategories = categories
        .where((c) => c.type == 'Income')
        .toList();
    final expenseCategories = categories
        .where((c) => c.type == 'Expense')
        .toList();

    final filtered = isExpense ? expenseCategories : incomeCategories;

    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 40,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Text(
                'Select Category',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: filtered.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final category = filtered[index];
                    final isSelected = _selectedCategory?.name == category.name;

                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedCategory = category);
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: isSelected
                                ? Colors.blue.withOpacity(0.2)
                                : Colors.grey.shade200,
                            child: Text(
                              category.icon ?? '',
                              style: TextStyle(
                                fontSize: 22,
                                color: isSelected ? Colors.blue : Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            category.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      final amount = _parseAmount(_amountController.text);
      if (amount == null) {
        ToastNotifier.showError("Please enter a valid amount");
        return;
      }

      final resolvedCategoryName =
          _selectedCategory?.name ?? widget.transaction.categoryName;
      if (resolvedCategoryName == null || resolvedCategoryName.isEmpty) {
        ToastNotifier.showError("Please select a category");
        return;
      }

      final updatedTransaction = widget.transaction.copyWith(
        title: _titleController.text.trim(),
        amount: amount,
        note: _noteController.text.trim(),
        date: _selectedDate ?? widget.transaction.date,
        categoryName: resolvedCategoryName,
        type: isExpense ? 'expense' : 'income',
      );

      context.read<TransactionCubit>().updateTransaction(updatedTransaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = isExpense ? Colors.redAccent : Colors.green;
    final bgColor = isExpense ? Colors.red.shade50 : Colors.green.shade50;

    return BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          ToastNotifier.showSuccess(state.message.toString());
          context.pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            leading: BackButton(
              color: Colors.white,
              onPressed: () => context.pop(),
            ),
            backgroundColor: accentColor,
            title: Text(
              isExpense ? 'Edit Expense' : 'Edit Income',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.white,
                onPressed: () => context
                    .read<TransactionCubit>()
                    .deleteTransaction(widget.transaction.id ?? ''),
              ),
            ],
            centerTitle: true,
          ),
          body: state.status.isLoading
              ? Center(child: CircularProgressIndicator(color: accentColor))
              : Padding(
                  padding: EdgeInsets.all(16.w),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => isExpense = false),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: !isExpense
                                            ? Colors.green
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Income',
                                          style: TextStyle(
                                            color: !isExpense
                                                ? Colors.white
                                                : Colors.grey.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => isExpense = true),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isExpense
                                            ? Colors.redAccent
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Expense',
                                          style: TextStyle(
                                            color: isExpense
                                                ? Colors.white
                                                : Colors.grey.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          CustomTextFormField(
                            labelText: 'Title',
                            controller: _titleController,
                            hintText: 'Title',
                            keyboardType: TextInputType.text,
                            validator: (v) => v!.isEmpty ? 'Enter title' : null,
                          ),
                          SizedBox(height: 16.h),
                          CustomTextFormField(
                            labelText: 'Amount',
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            hintText: 'Amount',
                            validator: (v) =>
                                v!.isEmpty ? 'Enter amount' : null,
                          ),
                          SizedBox(height: 16.h),
                          InkWell(
                            onTap: _showCategoryPicker,
                            borderRadius: BorderRadius.circular(12.r),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                prefixIcon: Icon(Icons.category),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedCategory?.name ??
                                        'Select Category',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: _selectedCategory == null
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  if (_selectedCategory != null)
                                    Text(
                                      _selectedCategory?.icon ?? '',
                                      style: const TextStyle(fontSize: 22),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          InkWell(
                            onTap: _pickDate,
                            borderRadius: BorderRadius.circular(12.r),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Date',
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              child: Text(
                                _selectedDate == null
                                    ? DateFormat(
                                        'MMM yyyy',
                                      ).format(DateTime.now())
                                    : DateFormat(
                                        'MMM yyyy',
                                      ).format(_selectedDate!),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          CustomTextFormField(
                            labelText: 'Note',
                            controller: _noteController,
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            hintText: 'Note',
                          ),
                          SizedBox(height: 30.h),
                          CustomButton(
                            onPressed: _saveTransaction,
                            text: 'Save',
                            color: accentColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
