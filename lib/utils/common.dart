import 'package:get/get.dart';

extension StringExtensions on String? {
  bool get isNullOrEmpty => this == null || this?.isEmpty == true;
}

T getOrPut<T>(T Function() factory) {
  if (!Get.isRegistered<T>()) {
    return Get.put(factory());
  }
  return Get.find<T>();
}

/// Generic error toast
// void toastUnexpectedError() {
//   showToast('Something went wrong, please try again later');
// }

Future<dynamic>? navigateTo(
  String page, {
  bool clearPrevious = false,
  bool clearPreviousAll = false,
  dynamic data,
}) {
  if (clearPrevious) {
    return Get.offNamed(page, arguments: data);
  } else if (clearPreviousAll) {
    return Get.offAllNamed(page, arguments: data);
  } else {
    return Get.toNamed(page, arguments: data);
  }
}

void navigateBack({dynamic result}) {
  Get.back(result: result);
}
