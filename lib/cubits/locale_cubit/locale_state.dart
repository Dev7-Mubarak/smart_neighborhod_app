import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class LocaleState extends Equatable {
  const LocaleState({required this.locale});
  
  final Locale locale;

  @override
  List<Object> get props => [locale];
}