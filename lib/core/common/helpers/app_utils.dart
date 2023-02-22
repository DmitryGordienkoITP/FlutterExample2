abstract class AppUtils {
  static bool doesPropertyExist(dynamic obj, String name) {
    var result = false;
    try {
      var prop = obj[name];
      if (prop != null) result = true;
    } catch (err) {
      /// Ignore error
    }
    return result;
  }

  static dynamic tryGetDynamicProp(dynamic obj, String name) {
    try {
      return obj[name];
    } catch (err) {
      /// Ignore error
    }
    return null;
  }
}
