import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:finance_track/core/models/category_model.dart';
import 'package:finance_track/core/models/transactions_model.dart';
import 'package:finance_track/core/routes/routes_name.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:finance_track/core/utils/helper/analysis_text/analysis.dart';
import 'package:finance_track/core/utils/helper/ui/customcurvecliper.dart';
import 'package:finance_track/core/utils/popups/toast.dart';
import 'package:finance_track/features/auth/logic/login/login_cubit.dart';
import 'package:finance_track/features/auth/logic/user/user_cubit.dart';
import 'package:finance_track/features/home/logic/homecubit/home_cubit.dart';
import 'package:finance_track/features/home/logic/homecubit/home_states.dart';
import 'package:finance_track/features/home/logic/transactions/transaction_cubit.dart';
import 'package:finance_track/features/home/views/widgets/cardexpensesandincome.dart';
import 'package:finance_track/features/home/views/widgets/shimmer_card.dart';
import 'package:finance_track/features/home/views/widgets/transaction_shimmer_item.dart';
import 'package:finance_track/features/home/views/widgets/home_header.dart';
import 'package:finance_track/features/home/views/widgets/month_selector.dart';
import 'package:finance_track/features/home/views/widgets/category_filter_chips.dart';
import 'package:finance_track/features/home/views/widgets/recent_transactions_header.dart';
import 'package:finance_track/features/home/views/widgets/transactions_list.dart';
import 'package:finance_track/features/home/views/widgets/transaction_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeCubit()..getHomeData(selectedMonth: DateTime.now()),

      child: BlocProvider(
        create: (context) => TransactionCubit(),
        child: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;
  bool isArrowDown = true;
  CategoryModel? selectedCategory;
  List<TransactionModel> filteredTransactions = [];

  bool isVoice = false;
  DateTime selectedDate = DateTime.now();

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  double _soundLevel = 0.0;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(18 * 132.w);
    });
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) async {
        debugPrint('Speech status: $status');
        if (status == 'done' || status == 'notListening') {
          if (mounted) {
            setState(() => isVoice = false);
            await _stopListening();
          }
        }
      },
      onError: (error) {
        debugPrint('Speech error: $error');
        if (mounted) setState(() => isVoice = false);
      },
    );
    if (mounted) setState(() {});
  }

  bool _hasNavigatedToEdit = false;

  Future<void> _stopListening() async {
    await _speechToText.stop();

    if (!_hasNavigatedToEdit && _lastWords.isNotEmpty) {
      _hasNavigatedToEdit = true;
      final transactionModel = parseTransactionFromText(
        _lastWords,
        context.read<UserCubit>().user?.id ?? '',
      );

      if ((transactionModel?.title.isNotEmpty ?? false) && mounted) {
        await context.read<TransactionCubit>().addTransaction(
          transactionModel!,
        );
        await context.read<HomeCubit>().getHomeData(
          selectedMonth: DateTime.now(),
        );
      }
    }

    setState(() => isVoice = false);
  }

  void _startListening() async {
    if (!_speechEnabled) return;

    _hasNavigatedToEdit = false;

    await _speechToText.listen(
      localeId:
          context.read<UserCubit>().user?.userMetadata?['lang'] ?? 'en-US',
      onResult: _onSpeechResult,
      onSoundLevelChange: (level) {
        setState(() => _soundLevel = level);
      },
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 3),
      listenOptions: SpeechListenOptions(
        cancelOnError: true,
        listenMode: ListenMode.dictation,
        partialResults: true,
      ),
    );

    setState(() => isVoice = true);
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() => _lastWords = result.recognizedWords);
  }

  @override
  Widget build(BuildContext context) {
    final userName =
        context.read<UserCubit>().user?.userMetadata?['name'] ?? '';

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.status.isError) {
          ToastNotifier.showError(state.message.toString());
        }
      },
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        final List<TransactionModel> transactionsToShow =
            filteredTransactions.isNotEmpty
            ? filteredTransactions
            : selectedCategory == null
            ? state.transactions
            : [];

        return Scaffold(
          backgroundColor: Colors.grey[100],

          body: Stack(
            children: [
              RefreshIndicator(
                backgroundColor: Colors.white.modify(
                  colorCode: AppColors.mainAppColor,
                ),
                color: Colors.white,
                onRefresh: () async {
                  return await cubit.getHomeData(selectedMonth: selectedDate);
                },
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      actionsPadding: EdgeInsets.zero,

                      backgroundColor: Colors.white.modify(
                        colorCode: AppColors.mainAppColor,
                      ),

                      actions: [
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.chartLine,
                            color: Colors.white,
                          ),
                          onPressed: () =>
                              context.pushNamed(RoutesName.analyticsScreen),
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.gear,
                            color: Colors.white,
                          ),
                          onPressed: () =>
                              context.pushNamed(RoutesName.settingsScreen),
                        ),
                      ],
                    ),

                    SliverToBoxAdapter(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipPath(
                            clipper: BottomCurveClipper(),
                            child: HomeHeader(userName: userName),
                          ),
                          Positioned(
                            bottom: -110.h,
                            left: 20.w,
                            right: 20.w,
                            child: state.status.isLoading
                                ? const BalanceCardShimmer()
                                : BalanceCard(
                                    totalBalance: state.summary.totalBalance,
                                    income: state.summary.totalIncome,
                                    expenses: state.summary.totalExpense,
                                    remainingBudget:
                                        state.summary.remainingBudget ?? 0,
                                    monthlyBudget:
                                        state.summary.monthlyBudget ?? 0,
                                    selectedDate: selectedDate,
                                  ),
                          ),
                        ],
                      ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: 110.h)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.calendar_month,
                                color: Colors.white.modify(
                                  colorCode: AppColors.mainAppColor,
                                ),
                              ),
                              title: Text(
                                "Select Month",
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              trailing: Container(
                                padding: EdgeInsets.all(1.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.modify(
                                    colorCode: AppColors.mainCardColor,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    isArrowDown
                                        ? Icons.keyboard_arrow_down
                                        : Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                  onPressed: () => setState(
                                    () => isArrowDown = !isArrowDown,
                                  ),
                                ),
                              ),
                              titleAlignment: ListTileTitleAlignment.center,
                            ),
                            SizedBox(height: 8.h),
                            MonthSelector(
                              controller: _scrollController,
                              selectedDate: selectedDate,
                              onSelect: (date) async {
                                setState(() => selectedDate = date);
                                await cubit.getHomeData(selectedMonth: date);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    isArrowDown
                        ? SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 8.h,
                              ),
                              child: CategoryFilterChips(
                                transactions: state.transactions,
                                selectedCategory: selectedCategory,
                                onSelectionChanged: (category) {
                                  setState(() {
                                    selectedCategory = category;
                                    if (category == null) {
                                      filteredTransactions = [];
                                    } else {
                                      filteredTransactions = state.transactions
                                          .where(
                                            (t) =>
                                                t.categoryName == category.name,
                                          )
                                          .toList();
                                    }
                                  });
                                },
                              ),
                            ),
                          )
                        : const SliverToBoxAdapter(child: SizedBox.shrink()),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: const RecentTransactionsHeader(),
                      ),
                    ),

                    if (state.status.isLoading)
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        sliver: SliverList.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) =>
                              const TransactionItemShimmer(),
                        ),
                      )
                    else if (state.transactions.isEmpty)
                      const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 50.0),
                            child: Text("No transactions found for this month"),
                          ),
                        ),
                      )
                    else
                      TransactionsList(transactions: transactionsToShow),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: isVoice
              ? GestureDetector(
                  onTap: _stopListening,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: 60.w + _soundLevel / 2,
                    height: 60.w + _soundLevel / 2,
                    decoration: BoxDecoration(
                      color: Colors.white.modify(
                        colorCode: AppColors.mainAppColor,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.modify(
                            colorCode: AppColors.mainAppColor,
                          ),
                          blurRadius: 24.r,
                          spreadRadius: 4.r,
                        ),
                      ],
                    ),
                    child: Icon(
                      FontAwesomeIcons.microphone,
                      color: Colors.white,
                      size: 20.w + _soundLevel,
                    ),
                  ),
                )
              : FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white.modify(
                    colorCode: AppColors.mainAppColor,
                  ),
                  child: Icon(FontAwesomeIcons.plus, color: Colors.white),
                  onPressed: () {
                    showModalBottomSheet(
                      barrierLabel: 'Transaction Type',
                      isDismissible: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => TransactionActionSheet(
                        onVoice: () => _startListening(),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
