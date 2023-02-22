abstract class AppValidators {
  static String? username(String? value) {
    if (value == null || value.isEmpty) return 'Обязательное поле';
    if (value.length > 60) {
      return 'Слишком длинное имя. Макс. 60 символов';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите ваш логин';
    }
    RegExp exp = RegExp('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}\$');
    if (exp.firstMatch(value) == null) {
      return 'Неверный E-mail.\nШаблон: "мойЛогин@mail.com"';
    }
    if (value.length > 60) {
      return 'Слишком длинный адрес';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < 6) {
      return 'Слишком короткий пароль';
    }
    if (value.length > 60) {
      return 'Слишком длинный пароль';
    }
    RegExp charactersValidator = RegExp(r"(?=.*[A-Z])");
    if (!charactersValidator.hasMatch(value)) {
      return 'Пароль должен содержать хотя бы одну заглавную букву';
    }
    return null;
  }

  static String? mandatoryPassword(String? value) {
    if (value == null || value.isEmpty) return 'Введите ваш пароль';
    if (value.length > 60) {
      return 'Слишком длинный пароль';
    }
    return null;
  }

  static String? mandatoryStringField(String? value) {
    if (value == null || value.isEmpty) return 'Обязательное поле';
    return null;
  }

  static String? mandatoryGenericField<T>(T? value) {
    if (value == null) return 'Обязательное поле';
    if (value is String && value.isEmpty) return 'Обязательное поле';
    return null;
  }
}
