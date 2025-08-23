import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/locale_cubit/locale_cubit.dart';
import '../cubits/locale_cubit/locale_state.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return IconButton(
          icon: Text(
            localeState.locale.languageCode == 'ar' ? 'EN' : 'ع',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            context.read<LocaleCubit>().toggleLocale();
          },
          tooltip: localeState.locale.languageCode == 'ar' 
              ? 'Switch to English' 
              : 'التبديل إلى العربية',
        );
      },
    );
  }
}