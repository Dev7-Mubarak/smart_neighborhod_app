import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/features/statistics/cubits/residential_units_cubit/statistics_cubit.dart';
import 'package:smart_negborhood_app/features/statistics/cubits/residential_units_cubit/statistics_state.dart';
import 'package:smart_negborhood_app/features/statistics/data/models/statistics_model.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  late final StatisticsCubit _statisticsCubit;

  @override
  void initState() {
    super.initState();
    _statisticsCubit = context.read<StatisticsCubit>()..getStatistics();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final int crossAxisCount = context.screenSize.width > 600 ? 3 : 2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Center(
          child: Text(
            locale.Statistics,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            _buildContentBody(crossAxisCount, locale),
          ],
        ),
      ),
    );
  }

  // Widget _buildContentBody(int crossAxisCount, locale) {
  //   return BlocBuilder<StatisticsCubit, StatisticsState>(
  //     buildWhen: (previous, current) =>
  //         current is StatisticsFailure ||
  //         current is StatisticsLoaded ||
  //         current is StatisticsLoading,
  //     builder: (context, state) {
  //       if (state is StatisticsLoading) {
  //         return const Center(child: CircularProgressIndicator());
  //       } else if (state is StatisticsFailure) {
  //         return OnFailureWidget(onRetry: () => _statisticsCubit.getStatistics());
  //       } else if (state is StatisticsLoaded) {
  //         return
  //              } else {
  //         return Container();
  //       }
  //     },
  //   );
  // }

  Widget _buildContentBody(int crossAxisCount, locale) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      buildWhen: (previous, current) =>
          current is StatisticsFailure ||
          current is StatisticsLoaded ||
          current is StatisticsLoading,
      builder: (context, state) {
        if (state is StatisticsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is StatisticsFailure) {
          return OnFailureWidget(
            onRetry: () {
              _statisticsCubit.getStatistics();
            },
          );
        } else if (state is StatisticsLoaded) {
          return Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // قسم مؤشرات الأداء الرئيسية (فرق العمل والصحة)
                  _buildKPISRow(state.statisticsModel),
                  const SizedBox(height: 16),

                  // قسم الحالة الاجتماعية (Grid)
                  _buildSectionHeader(
                    locale.SocialAndFamily ?? "Social & Family",
                  ), // استبدل بالنص المترجم لديك

                  _buildSocialGrid(state.statisticsModel.socialAndFamily),
                  const SizedBox(height: 16),

                  // قسم المشاريع والإسكان (دائري)
                  Row(
                    children: [
                      Expanded(
                        child: _buildCircularCard(
                          locale.projects,
                          state.statisticsModel.projects.completed,
                          state.statisticsModel.projects.incomplete,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // الإسكان (التصميم الجديد المقسم)
                      Expanded(
                        child: _buildHousingCard(
                          locale.Housing ?? "Housing",
                          state.statisticsModel.housing.owned,
                          state.statisticsModel.housing.rented,
                          Colors.orange, // لون المملوك
                        ),
                      ),
                      // Expanded(
                      //   child: _buildCircularCard(
                      //     locale.Housing,
                      //     state.statisticsModel.housing.owned,
                      //     state.statisticsModel.housing.rented,
                      //     Colors.orange,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // قسم الاتفاقيات (خطي)
                  _buildSectionHeader("إحصائيات الإتفاقيات"),
                  _buildAgreementsCard(state.statisticsModel.agreements),
                  const SizedBox(height: 16),

                  // قسم فئات الدخل
                  _buildSectionHeader("فئات الدخل"),
                  _buildIncomeCard(state.statisticsModel.incomeCategories),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  // --- 1. عنوان القسم ---
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4, right: 4),
      child: Row(
        children: [
          Container(
            height: 20,
            width: 4,
            color: Colors.blueAccent,
            margin: const EdgeInsetsDirectional.only(end: 8),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. صف المؤشرات الرئيسية (KPIs) ---
  Widget _buildKPISRow(StatisticsModel data) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: "فرق",
            count: data.teams.teamsCount.toString(),
            icon: Icons.groups,
            color: Colors.purple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: "أشخاص مصابين بإمراض مزمنة",
            count: data.health.individualsWithChronicDiseases.toString(),
            icon: Icons.monitor_heart,
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }

  // --- 3. بطاقة إحصائية بسيطة ---
  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  // --- 4. شبكة الحالة الاجتماعية ---
  Widget _buildSocialGrid(SocialAndFamily social) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildMiniInfoCard("عائلة", social.families, Colors.teal),
        _buildMiniInfoCard("فرد", social.individuals, Colors.blue),
        _buildMiniInfoCard("أرمله", social.widows, Colors.orange),
        _buildMiniInfoCard("مطلقة", social.divorced, Colors.pink),
      ],
    );
  }

  Widget _buildMiniInfoCard(String title, int value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        ],
      ),
    );
  }

  // --- 5. بطاقة دائرية (للمشاريع والإسكان) ---
  Widget _buildCircularCard(
    String title,
    int completed,
    int incomplete,
    Color primaryColor,
  ) {
    int total = completed + incomplete;
    double percent = total == 0 ? 0 : completed / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
              Text(
                "${(percent * 100).toInt()}%",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem("مكتمل", completed.toString(), primaryColor),
              _buildLegendItem("غير مكتمل", incomplete.toString(), Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String val, Color color) {
    return Column(
      children: [
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  // // --- 6. بطاقة الاتفاقيات (مؤشرات خطية) ---
  // Widget _buildAgreementsCard(Agreements agreements) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.1),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         _buildLinearProgress(
  //           "",
  //           agreements.completed,
  //           agreements.notCompleted,
  //           Colors.blue,
  //         ),
  //         const SizedBox(height: 12),
  //         _buildLinearProgress(
  //           "Peace",
  //           agreements.peaceCompleted,
  //           agreements.peaceNotCompleted,
  //           Colors.green,
  //         ),
  //         const SizedBox(height: 12),
  //         _buildLinearProgress(
  //           "Treaties",
  //           agreements.treatiesCompleted,
  //           agreements.treatiesNotCompleted,
  //           Colors.amber,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // --- 6. بطاقة الاتفاقيات (تصميم مفصل ومحسن) ---
  Widget _buildAgreementsCard(Agreements agreements) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. الإجمالي (بناء على completed و notCompleted العام)
          _buildDetailedAgreementRow(
            title: "إجمالي الحالات",
            completed: agreements.completed,
            incomplete: agreements.notCompleted,
            color: Colors.blueAccent,
            icon: Icons.dashboard_customize,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
          ),

          // 2. الصلح (Peace)
          _buildDetailedAgreementRow(
            title: "الصلح",
            completed: agreements.peaceCompleted,
            incomplete: agreements.peaceNotCompleted,
            color: Colors.green,
            icon: Icons.handshake,
          ),

          const SizedBox(height: 20),

          // 3. المعاهدات (Treaties)
          _buildDetailedAgreementRow(
            title: "المعاهدات",
            completed: agreements.treatiesCompleted,
            incomplete: agreements.treatiesNotCompleted,
            color: Colors.orange,
            icon: Icons.history_edu,
          ),

          const SizedBox(height: 20),

          // 4. الاتفاقيات (Agreements - الفئة الفرعية)
          _buildDetailedAgreementRow(
            title: "الإتفاقيات",
            completed: agreements.agreementsCompleted,
            incomplete: agreements.agreementsNotCompleted,
            color: Colors.purple,
            icon: Icons.assignment_turned_in,
          ),
        ],
      ),
    );
  }

  // ودجت فرعية لبناء كل صف بوضوح تام
  Widget _buildDetailedAgreementRow({
    required String title,
    required int completed,
    required int incomplete,
    required Color color,
    required IconData icon,
  }) {
    int total = completed + incomplete;
    double percent = total == 0 ? 0 : completed / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الصف العلوي: الأيقونة + العنوان + النسبة المئوية
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "${(percent * 100).toInt()}%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: color,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // شريط التقدم
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),

        const SizedBox(height: 8),

        // تفاصيل الأرقام (مكتمل vs غير مكتمل)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // جهة المكتمل
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "مكتمل: $completed",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            // جهة غير المكتمل
            Row(
              children: [
                Text(
                  "قيد الإجراء: $incomplete", // أو "غير مكتمل" حسب رغبتك
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLinearProgress(
    String label,
    int done,
    int notDone,
    Color color,
  ) {
    int total = done + notDone;
    double percent = total == 0 ? 0 : done / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(
              "$done / $total",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: percent,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  // // --- 7. بطاقة الدخل ---
  // Widget _buildIncomeCard(IncomeCategories income) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.1),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         _buildVerticalBar("A", income.categoryA, Colors.green),
  //         _buildVerticalBar("B", income.categoryB, Colors.blue),
  //         _buildVerticalBar("C", income.categoryC, Colors.orange),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildVerticalBar(String label, int value, Color color) {
  //   return Column(
  //     children: [
  //       Text(
  //         value.toString(),
  //         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //       ),
  //       const SizedBox(height: 8),
  //       Container(
  //         height: 60,
  //         width: 12,
  //         decoration: BoxDecoration(
  //           color: color.withOpacity(0.2),
  //           borderRadius: BorderRadius.circular(6),
  //         ),
  //         alignment: Alignment.bottomCenter,
  //         child: Container(
  //           height: 60 * 0.7, // يمكنك جعل هذا ديناميكياً بناء على أكبر قيمة
  //           width: 12,
  //           decoration: BoxDecoration(
  //             color: color,
  //             borderRadius: BorderRadius.circular(6),
  //           ),
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       Text(
  //         label,
  //         style: const TextStyle(
  //           fontWeight: FontWeight.bold,
  //           color: Colors.grey,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // --- 7. بطاقة الدخل (معدلة لحساب النسب ديناميكياً) ---
  Widget _buildIncomeCard(IncomeCategories income) {
    // 1. إيجاد أكبر قيمة بين الفئات الثلاث لتكون هي المقياس (100%)
    // نستخدم math.max أو مقارنة بسيطة
    int maxValue = 0;
    if (income.categoryA > maxValue) maxValue = income.categoryA;
    if (income.categoryB > maxValue) maxValue = income.categoryB;
    if (income.categoryC > maxValue) maxValue = income.categoryC;

    // لتجنب القسمة على صفر إذا كانت كل القيم أصفاراً
    if (maxValue == 0) maxValue = 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround, // توزيع المسافات بالتساوي
        crossAxisAlignment: CrossAxisAlignment.end, // محاذاة من الأسفل
        children: [
          _buildVerticalBar("الفئة A", income.categoryA, maxValue, Colors.teal),
          _buildVerticalBar("الفئة B", income.categoryB, maxValue, Colors.blue),
          _buildVerticalBar(
            "الفئة C",
            income.categoryC,
            maxValue,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalBar(String label, int value, int maxValue, Color color) {
    // تحديد أقصى ارتفاع للعمود في التصميم (مثلاً 100 بيكسل)
    const double maxBarHeight = 100.0;

    // حساب النسبة المئوية للقيمة الحالية
    double percentage = value / maxValue;

    // حساب ارتفاع هذا العمود بناءً على النسبة
    double currentHeight = maxBarHeight * percentage;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // عرض الرقم فوق العمود
        Text(
          value.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // الخلفية والعمود الملون
        Stack(
          alignment:
              Alignment.bottomCenter, // لضمان نمو العمود من الأسفل للأعلى
          children: [
            // الخلفية الرمادية (تمثل الطول الكامل المحتمل)
            Container(
              height: maxBarHeight,
              width: 14, // عرض العمود
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // العمود الملون (يمثل القيمة الفعلية)
            Container(
              height: currentHeight, // الارتفاع المحسوب ديناميكياً
              width: 14,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // اسم الفئة أسفل العمود
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // --- بطاقة الإسكان (مقارنة وتوزيع) ---
  Widget _buildHousingCard(
    String title,
    int owned,
    int rented,
    Color primaryColor,
  ) {
    int total = owned + rented;
    // حساب النسب للعرض
    double ownedPercent = total == 0 ? 0 : owned / total;
    double rentedPercent = total == 0 ? 0 : rented / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),

          // عرض الأرقام والأيقونات جنباً إلى جنب
          Row(
            children: [
              // قسم المملوك
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.home, color: primaryColor, size: 28),
                    const SizedBox(height: 4),
                    Text(
                      owned.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "مملوك", // أو locale.owned
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              // خط فاصل عمودي
              Container(height: 40, width: 1, color: Colors.grey[300]),

              // قسم المستأجر
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.vpn_key, color: Colors.blueGrey, size: 28),
                    const SizedBox(height: 4),
                    Text(
                      rented.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "مستأجر", // أو locale.rented
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // شريط التوزيع البصري (Distribution Bar)
          // هذا الشريط يظهر النسبة كقطعة واحدة مقسمة
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  // نسبة المملوك
                  Expanded(
                    flex: (ownedPercent * 100).toInt(),
                    child: Container(color: primaryColor),
                  ),
                  // نسبة المستأجر
                  Expanded(
                    flex: (rentedPercent * 100).toInt(),
                    child: Container(color: Colors.blueGrey.withOpacity(0.3)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          // عرض النسب المئوية نصياً تحت الشريط (اختياري)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${(ownedPercent * 100).toInt()}%",
                style: TextStyle(
                  fontSize: 10,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${(rentedPercent * 100).toInt()}%",
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
