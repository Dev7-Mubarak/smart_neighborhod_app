import 'package:flutter/material.dart';

import '../../../../../core/common/widgets/custom_text_input_filed.dart';

class ChangeBlockNameWidget extends StatefulWidget {
  const ChangeBlockNameWidget({super.key});
  @override
  State<ChangeBlockNameWidget> createState() => _ChangeBlockNameWidgetState();
}

class _ChangeBlockNameWidgetState extends State<ChangeBlockNameWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  late final TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 14),
          Text('اسم المربع الجديد'),
          const SizedBox(height: 15),
          CustomTextFormField(
            controller: _reasonController,
            hintText: 'سبب الرفض',
            onChanged: (value) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'هذا الحقل مطلوب';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                },
                child: const Text('إرسال'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.reset();
                },
                child: const Text('إلغاء'),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
