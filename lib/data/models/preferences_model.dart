// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PreferencesModel {
  bool pushNotificationsEnabled;
  PreferencesModel({
    this.pushNotificationsEnabled = false,
  });

  PreferencesModel copyWith({
    bool? pushNotificationsEnabled,
  }) {
    return PreferencesModel(
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pushNotificationsEnabled': pushNotificationsEnabled,
    };
  }

  factory PreferencesModel.fromMap(Map<String, dynamic> map) {
    return PreferencesModel(
      pushNotificationsEnabled: map['pushNotificationsEnabled'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PreferencesModel.fromJson(String source) =>
      PreferencesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PreferencesModel(pushNotificationsEnabled: $pushNotificationsEnabled)';

  @override
  bool operator ==(covariant PreferencesModel other) {
    if (identical(this, other)) return true;

    return other.pushNotificationsEnabled == pushNotificationsEnabled;
  }

  @override
  int get hashCode => pushNotificationsEnabled.hashCode;
}
