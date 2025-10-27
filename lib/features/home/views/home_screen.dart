import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:finance_track/core/routes/routes_name.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:finance_track/core/utils/helper/analysis_text/analysis.dart';
import 'package:finance_track/core/utils/helper/greatings/greating_function.dart';
import 'package:finance_track/core/utils/helper/ui/customcurvecliper.dart';
import 'package:finance_track/core/utils/popups/toast.dart';
import 'package:finance_track/features/auth/logic/login/login_cubit.dart';
import 'package:finance_track/features/home/logic/homecubit/home_cubit.dart';
import 'package:finance_track/features/home/logic/homecubit/home_states.dart';
import 'package:finance_track/features/home/logic/transactions/transaction_cubit.dart';
import 'package:finance_track/features/home/views/widgets/cardexpensesandincome.dart';
import 'package:finance_track/features/home/views/widgets/shimmer_card.dart';
import 'package:finance_track/features/home/views/widgets/transaction_methods_item.dart';
import 'package:finance_track/features/home/views/widgets/transaction_shimmer_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()
        ..getHomeData(
          userId: context.read<LoginCubit>().user?.id ?? '',
          selectedMonth: DateTime.now(),
        ),

      child: const HomeScreen(),
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
  bool isArrowDown = false;
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
            await _stopListening(); // ← هنا ننادي stop اللي فيها التحليل والتنقل
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
      _hasNavigatedToEdit = true; // ← فلاغ لمنع push مرتين
      final transactionModel = parseTransactionFromText(
        _lastWords,
        context.read<LoginCubit>().user?.id ?? '',
      );

      if ((transactionModel?.title.isNotEmpty ?? false) && mounted) {
        context.pushNamed(
          RoutesName.editTransactionScreen,
          extra: transactionModel,
        );
      }
    }

    setState(() => isVoice = false);
  }

  void _startListening() async {
    if (!_speechEnabled) return;

    _hasNavigatedToEdit = false; // ← reset هنا

    await _speechToText.listen(
      localeId: 'ar_EG',
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
        context.read<LoginCubit>().user?.userMetadata?['name'] ?? '';

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.status.isError) {
          ToastNotifier.showError(state.message.toString());
        }
      },
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();

        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.grey[100],
          body: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  await cubit.getHomeData(
                    userId: context.read<LoginCubit>().user?.id ?? '',
                    selectedMonth: selectedDate,
                  );
                },
                child: CustomScrollView(
                  slivers: [
                    // Header & Balance
                    SliverToBoxAdapter(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipPath(
                            clipper: BottomCurveClipper(),
                            child: Container(
                              width: double.infinity,
                              height: 230.h,
                              decoration: BoxDecoration(
                                color: Colors.white.modify(
                                  colorCode: AppColors.mainAppColor,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 32.h,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "${getGreetingMessage()}, ",
                                            style: GoogleFonts.inter(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "\n$userName",
                                            style: GoogleFonts.inter(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    color: Colors.white.modify(
                                      colorCode: AppColors.mainCardColor,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.notifications,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -80.h,
                            left: 20.w,
                            right: 20.w,
                            child: state.status.isLoading
                                ? BalanceCardShimmer()
                                : BalanceCard(
                                    totalBalance: state.summary.totalBalance,
                                    income: state.summary.totalIncome,
                                    expenses: state.summary.totalExpense,
                                  ),
                          ),
                        ],
                      ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: 90.h)),
                    // Month selector
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
                            SizedBox(
                              height: 90.h,
                              child: ListView.builder(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: 36,
                                itemBuilder: (context, index) {
                                  final now = DateTime.now();
                                  final startMonth = now.month - 18;
                                  final date = DateTime(
                                    now.year,
                                    startMonth + index,
                                    1,
                                  );
                                  final isSelected =
                                      date.month == selectedDate.month &&
                                      date.year == selectedDate.year;

                                  return GestureDetector(
                                    onTap: () async {
                                      setState(() => selectedDate = date);
                                      await cubit.getHomeData(
                                        userId:
                                            context
                                                .read<LoginCubit>()
                                                .user
                                                ?.id ??
                                            '',
                                        selectedMonth: selectedDate,
                                      );
                                    },
                                    child: Container(
                                      width: 120.w,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white.modify(
                                                colorCode:
                                                    AppColors.mainCardColor,
                                              )
                                            : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          DateFormat('MMM\nyyyy').format(date),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.sp,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: ListTile(
                          leading: Text(
                            "Recent Transactions",
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {},
                            child: Text(
                              "See All",
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (state.status.isLoading)
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        sliver: SliverList.builder(
                          itemCount: 6,
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
                      SlidableAutoCloseBehavior(
                        child: SliverList.builder(
                          itemCount: state.transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = state.transactions[index];
                            return Slidable(
                              key: ValueKey(transaction.id),
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                extentRatio: 0.4,
                                children: [
                                  SlidableAction(
                                    onPressed: (context) => context.pushNamed(
                                      RoutesName.editTransactionScreen,
                                      extra: transaction,
                                    ),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).cardColor,
                                    foregroundColor: Colors.blue,
                                    icon: Icons.edit,
                                    borderRadius: BorderRadius.circular(12.r),
                                    label: 'Edit',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {},
                                    backgroundColor: Theme.of(
                                      context,
                                    ).cardColor,
                                    foregroundColor: Colors.red,
                                    icon: Icons.delete,
                                    borderRadius: BorderRadius.circular(12.r),
                                    label: 'Delete',
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
                                    DateFormat(
                                      'dd MMM yyyy',
                                    ).format(transaction.date),
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
                      ),
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
                      Icons.mic,
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
                  child: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    showModalBottomSheet(
                      barrierLabel: 'Transaction Type',
                      isDismissible: true,
                      backgroundColor: Colors.white.modify(
                        colorCode: AppColors.mainAppColor,
                      ),
                      context: context,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TransactionMethodsItem(
                              text: 'Voice',
                              icon: Icons.mic,
                              onTap: () {
                                setState(() {
                                  context.pop();
                                  _startListening();
                                });
                              },
                            ),
                            TransactionMethodsItem(
                              text: 'Add Manual',
                              icon: Icons.add,
                              onTap: () => context.pushNamed(
                                RoutesName.addTransactionScreen,
                              ),
                            ),
                            TransactionMethodsItem(
                              text: 'Scan Receipt',
                              icon: Icons.qr_code_scanner,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
