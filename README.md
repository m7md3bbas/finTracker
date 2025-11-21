# MoneyTalk
[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/m7md3bbas/MoneyTalk)

MoneyTalk is an intelligent personal finance management application built with Flutter. It helps you track your income and expenses effortlessly using smart input methods, visualize your spending patterns, and manage your monthly budgets.

## Features

-   **Intelligent Transaction Entry**:
    -   **Voice Input**: Add transactions by simply speaking. Powered by Google's Gemini AI for natural language processing.
    -   **Receipt Scanning**: Capture a photo of your receipt, and the app automatically extracts details using Gemini's vision capabilities and Google ML Kit for text recognition.
    -   **Manual Entry**: A traditional and flexible way to input transaction details.

-   **Comprehensive Financial Overview**:
    -   **Dashboard**: View your total balance, monthly income, expenses, and budget status at a glance.
    -   **Transaction History**: A clear and searchable list of all your financial activities, with options to edit or delete entries.

-   **Insightful Analysis**:
    -   **Visual Charts**: Understand your financial health with interactive monthly overview (income vs. expense) and expense-by-category charts.
    -   **Date Range Filtering**: Analyze your finances over custom periods.

-   **Smart Budgeting**:
    -   Set and update monthly budgets to stay on top of your spending.
    -   Track your progress with a visual budget usage indicator.

-   **User Management**:
    -   Secure authentication using email/password and Google Sign-In.
    -   Personalize your profile with a custom photo.

-   **Notifications**:
    -   Stay informed with Push Notifications for important updates and reminders.

## Technology Stack

-   **Framework**: Flutter
-   **Backend & Database**: Supabase (Authentication, Database, Storage)
-   **AI & ML**:
    -   Google Gemini API (for text and image-based transaction parsing)
    -   Google ML Kit (Text Recognition)
    -   Flutter `speech_to_text`
-   **State Management**: BLoC (Flutter BLoC)
-   **Routing**: GoRouter
-   **Data Visualization**: FL Chart
-   **Dependency Injection**: GetIt
-   **Notifications**: Firebase Cloud Messaging (FCM), Flutter Local Notifications
-   **Monitoring**: Firebase Crashlytics & Analytics

## Project Architecture

The project follows a **Feature-First** architecture, separating concerns into distinct features like `auth`, `home`, `analysis`, and `profile`.

-   `lib/core/`: Contains shared components, utilities, models, and services used across different features, promoting code reuse and maintainability.
-   `lib/feature/`: Encapsulates individual feature modules, each with its own data, logic (BLoC), and view layers.

State management is handled using the **BLoC pattern**, ensuring a predictable and scalable state flow throughout the application.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

-   Flutter SDK: [Installation Guide](https://docs.flutter.dev/get-started/install)

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/m7md3bbas/MoneyTalk.git
    cd MoneyTalk
    ```

2.  **Set up Environment Variables:**
    Create a `.env` file in the root of the project and add your credentials for Supabase and Google Gemini.
    ```env
    SUPABASE_URL=YOUR_SUPABASE_PROJECT_URL
    SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
    GEMINI_API_KEY=YOUR_GOOGLE_GEMINI_API_KEY
    GoogleClintID=YOUR_GOOGLE_SIGN_IN_WEB_CLIENT_ID
    ```

3.  **Configure Firebase:**
    Replace the placeholder `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` (if applicable) with your own Firebase project configuration files.

4.  **Install Dependencies:**
    ```sh
    flutter pub get
    ```

5.  **Run the application:**
    ```sh
    flutter run
    ```

## Project Structure

```
lib/
├── app.dart                  # Root widget of the application
├── main.dart                 # Application entry point
├── core/                     # Shared utilities, models, services
│   ├── di/                   # Dependency injection setup (GetIt)
│   ├── models/               # Data models (TransactionModel, BudgetModel, etc.)
│   ├── routes/               # Routing logic (GoRouter)
│   ├── services/             # Business logic (GeminiService)
│   └── utils/                # Helpers, theme, shared preferences
└── feature/                  # Feature modules
    ├── auth/                 # Authentication logic and UI
    ├── home/                 # Main dashboard, transaction and budget management
    ├── analysis/             # Data visualization and financial analysis
    └── profile/              # User profile and settings
