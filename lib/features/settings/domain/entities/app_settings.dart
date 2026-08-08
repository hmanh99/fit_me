import 'package:equatable/equatable.dart';


class AppSettings extends Equatable {
  final String languageCode;

  const AppSettings({
    required this.languageCode,
  });

  AppSettings copyWith({
    String? languageCode,
  }) {
    return AppSettings(
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [languageCode];
}
