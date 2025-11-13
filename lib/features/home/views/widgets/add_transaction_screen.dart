import 'package:finance_track/core/models/category_model.dart';
import 'package:finance_track/core/models/transactions_model.dart';
import 'package:finance_track/core/utils/customs/custom_buttons/custom_button.dart';
import 'package:finance_track/core/utils/customs/textformfield/custom_textfomfield.dart';
import 'package:finance_track/core/utils/helper/category/category_list.dart';
import 'package:finance_track/core/utils/popups/toast.dart';
import 'package:finance_track/features/auth/logic/user/user_cubit.dart';
import 'package:finance_track/features/home/logic/homecubit/home_cubit.dart';
import 'package:finance_track/features/home/logic/transactions/transaction_cubit.dart';
import 'package:finance_track/features/home/logic/transactions/transaction_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatelessWidget {
  const AddTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionCubit(),
      child: BlocProvider(
        create: (context) => HomeCubit(),
        child: AddTransactionScreen(),
      ),
    );
  }
}

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isExpense = false;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _amountController = TextEditingController();
    _noteController = TextEditingController();
  }

  DateTime? _selectedDate;
  CategoryModel? _selectedCategory;

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year, 1, 1),
      lastDate: DateTime(2100, 12, 31),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: isExpense ? Colors.redAccent : Colors.green,
            onPrimary: isExpense ? Colors.redAccent : Colors.white,
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
                    crossAxisCount: 3,
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
      final text = _amountController.text.trim();

      final amount = double.tryParse(text.replaceAll(',', '.'));
      if (amount == null) {
        ToastNotifier.showError("Please enter a valid amount");
        return;
      }

      if (_selectedCategory == null) {
        ToastNotifier.showError("Please select a category");
        return;
      }

      try {
        final transaction = TransactionModel(
          userId: context.read<UserCubit>().user?.id ?? '',
          title: _titleController.text.trim(),
          categoryName: _selectedCategory!.name,
          amount: amount,
          type: isExpense ? 'expense' : 'income',
          date: _selectedDate ?? DateTime.now(),
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
          createdAt: DateTime.now(),
        );
        await context.read<TransactionCubit>().addTransaction(transaction);
      } catch (e) {
        ToastNotifier.showError("Failed to add transaction: $e");
      }
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
          Navigator.pop(context);
        }
        if (state.status.isError) {
          print(state.message);
          ToastNotifier.showError(state.message.toString());
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            leading: const BackButton(color: Colors.white),
            backgroundColor: accentColor,
            title: Text(
              isExpense ? 'Add Expense' : 'Add Income',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
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
                              onTap: () => setState(() => isExpense = false),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: !isExpense
                                      ? Colors.green
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.r),
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
                              onTap: () => setState(() => isExpense = true),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: isExpense
                                      ? Colors.redAccent
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.r),
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
                      controller: _titleController,
                      hintText: isExpense
                          ? 'What did you spend on?'
                          : 'What did you get?',
                      labelText: "Description",
                      keyboardType: TextInputType.text,
                      validator: (v) => v!.isEmpty ? 'Enter title' : null,
                    ),
                    SizedBox(height: 16.h),

                    CustomTextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      hintText: 'Amount',
                      labelText: "Amount",
                      validator: (v) => v!.isEmpty ? 'Enter amount' : null,
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
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedCategory?.name ?? 'Select Category',
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
                              ? DateFormat('MMM yyyy').format(DateTime.now())
                              : DateFormat('MMM yyyy').format(_selectedDate!),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    CustomTextFormField(
                      controller: _noteController,
                      keyboardType: TextInputType.text,
                      maxLines: 3,
                      hintText: 'Note',
                    ),

                    SizedBox(height: 30.h),

                    state.status.isLoading
                        ? CircularProgressIndicator(color: Colors.green)
                        : CustomButton(
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
