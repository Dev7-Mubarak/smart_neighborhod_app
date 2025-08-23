import 'package:flutter/material.dart';

class AdCard extends StatelessWidget {
  final String content;
  final String date;
  final String author;
  final String iconUrl;
  final Color iconBgColor;
  final bool hasLeftPadding;
  final bool hasMultipleLines;

  const AdCard({
    super.key,
    required this.content,
    required this.date,
    required this.author,
    required this.iconUrl,
    required this.iconBgColor,
    this.hasLeftPadding = false,
    this.hasMultipleLines = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      width: 358,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content section
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: hasLeftPadding ? 19 : 0,
                right: 0,
                top: 9,
                bottom: 4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasMultipleLines)
                    _buildMultiLineContent()
                  else
                    _buildSingleLineContent(),

                  // Date and author info
                  Row(
                    children: [
                      Image.network(
                        'https://cdn.builder.io/api/v1/image/assets/TEMP/ff954db9cb31af4477050eb265b3eef1a15e6909934060e00afdc9cec4dfb666?placeholderIfAbsent=true&apiKey=0262cfa684aa499ea4a95da1ec981c73',
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    date,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 9,
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.w400,
                                      height: 26 / 9, // lineHeight / fontSize
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 9),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  author,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 9,
                                    fontFamily: 'Tajawal',
                                    fontWeight: FontWeight.w400,
                                    height: 26 / 9, // lineHeight / fontSize
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Icon section with colored background
          Container(
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.fromLTRB(15, 37, 15, 7),
            child: Image.network(
              iconUrl,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleLineContent() {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Text(
        content,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 11,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.w400,
          height: 26 / 11, // lineHeight / fontSize
        ),
      ),
    );
  }

  Widget _buildMultiLineContent() {
    // Split content into lines for the multi-line case
    final lines = [
      'نعلن عن فعالية خيرية لجمع التبرعات والمساعدات للفئات ',
      'المحتاجة في الحارة بتاريخ 2025/1/13 الساعه 4 عصرا بجانب ',
      'مسجد الحارة يرجى التبرع بالمال او الملاابس او المواد الغذائية ',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        return Container(
          margin: const EdgeInsets.only(left: 11, bottom: 0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Text(
            line,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 11,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w400,
              height: 26 / 11, // lineHeight / fontSize
            ),
          ),
        );
      }).toList(),
    );
  }
}
