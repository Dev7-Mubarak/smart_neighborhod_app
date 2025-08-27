import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_image.dart';
import 'package:smart_negborhood_app/core/constants/app_size.dart';
import 'package:smart_negborhood_app/core/constants/small_text.dart';
import 'package:smart_negborhood_app/features/confilct/data/models/conflict.dart';
import '../../../../core/common/widgets/custom_navigation_bar.dart';

class ConflictDetiles extends StatefulWidget {
  const ConflictDetiles({super.key, required this.conflict});
  final Conflict conflict;

  @override
  State<ConflictDetiles> createState() => _ConflictDetilesState();
}

class _ConflictDetilesState extends State<ConflictDetiles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          ' إدارة الخلافات',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  widget.conflict.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 20,
                ),
                child: _buildImageWithLoader(),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: AppColor.gray,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SmallText(
                            text:
                                "الطرف الأول :${widget.conflict.firstPartyName}",
                            textAlign: TextAlign.end,
                          ),
                        ),
                        SizedBox(width: 10),
                        const Icon(
                          Icons.person,
                          color: AppColor.primaryColor,
                          size: 30,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SmallText(
                            text:
                                "الطرف الثاني :${widget.conflict.secondPartyName}",
                            textAlign: TextAlign.end,
                          ),
                        ),
                        SizedBox(width: 10),
                        const Icon(
                          Icons.person,
                          color: AppColor.primaryColor,
                          size: 30,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SmallText(
                            text:
                                "المشرف على المعاهدة: ${widget.conflict.managerName}",
                            textAlign: TextAlign.end,
                          ),
                        ),
                        SizedBox(width: 10),
                        const Icon(
                          Icons.person,
                          color: AppColor.primaryColor,
                          size: 30,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SmallText(
                            text:
                                " تاريخ الجلسة : ${DateFormat('yyyy-MM-dd').format(widget.conflict.sessionDate!)}",
                            textAlign: TextAlign.end,
                          ),
                        ),
                        SizedBox(width: 10),
                        const Icon(
                          Icons.calendar_month,
                          color: AppColor.primaryColor,
                          size: 30,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SmallText(
                            text: widget.conflict.isResolved
                                ? "تم إنهاء الخلاف"
                                : "لم يتم إنهاء الخلاف",
                            textAlign: TextAlign.end,
                          ),
                        ),
                        SizedBox(width: 10),
                        Image.asset(AppImage.handshake, width: 30, height: 30),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SmallText(
                            text: "ملاحظات :${widget.conflict.notes}",
                            textAlign: TextAlign.end,
                          ),
                        ),
                        SizedBox(width: 10),
                        Image.asset(AppImage.notes, width: 20, height: 20),
                      ],
                    ),
                    SizedBox(height: AppSize.spasingBetweenInputBloc),
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }

  Widget _buildImageWithLoader() {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Image.network(
        widget.conflict.imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 400,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return
           Container(
            color: Colors.grey[200],
            child: Center(
              child: Icon(
                Icons.image_not_supported,
                size: 60,
                color: Colors.grey[500],
              ),
            ),
          );
        },
      ),
    );
  }
}
