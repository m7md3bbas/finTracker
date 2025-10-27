import 'package:finance_track/core/models/category_model.dart';

final List<CategoryModel> categories = [
  // 💰 Income
  CategoryModel(name: 'Salary', icon: '💼', type: "Income"),
  CategoryModel(name: 'Freelance', icon: '🧑‍💻', type: "Income"),
  CategoryModel(name: 'Investments', icon: '📈', type: "Income"),
  CategoryModel(name: 'Gifts', icon: '🎁', type: "Income"),
  CategoryModel(name: 'Rental Income', icon: '🏠', type: "Income"),
  CategoryModel(name: 'Refunds', icon: '💳', type: "Income"),
  CategoryModel(name: 'Other', icon: '🔖', type: "Income"),
  // 💸 Expense
  CategoryModel(name: 'Food', icon: '🍔', type: "Expense"),
  CategoryModel(name: 'Transport', icon: '🚗', type: "Expense"),
  CategoryModel(name: 'Groceries', icon: '🛒', type: "Expense"),
  CategoryModel(name: 'Entertainment', icon: '🎮', type: "Expense"),
  CategoryModel(name: 'Shopping', icon: '🛍️', type: "Expense"),
  CategoryModel(name: 'Health', icon: '💊', type: "Expense"),
  CategoryModel(name: 'Education', icon: '📚', type: "Expense"),
  CategoryModel(name: 'Bills & Utilities', icon: '💡', type: "Expense"),
  CategoryModel(name: 'Subscriptions', icon: '📺', type: "Expense"),
  CategoryModel(name: 'Travel', icon: '✈️', type: "Expense"),
  CategoryModel(name: 'Insurance', icon: '🛡️', type: "Expense"),
  CategoryModel(name: 'Taxes', icon: '💵', type: "Expense"),
  CategoryModel(name: 'Donations', icon: '🙏', type: "Expense"),
  CategoryModel(name: 'Pets', icon: '🐶', type: "Expense"),
  CategoryModel(name: 'Gadgets', icon: '📱', type: "Expense"),
  CategoryModel(name: 'Beauty & Care', icon: '💅', type: "Expense"),
  CategoryModel(name: 'Home', icon: '🏡', type: "Expense"),
  CategoryModel(name: 'Clothing', icon: '👕', type: "Expense"),
  CategoryModel(name: 'Other', icon: '🔖', type: "Expense"),
];
