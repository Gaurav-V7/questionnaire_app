import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:questionnaire_app/constants/ui_constants.dart';
import 'package:questionnaire_app/controllers/auth_controller.dart';
import 'package:questionnaire_app/routes/app_routes.dart';
import 'package:questionnaire_app/ui/widgets/ui_button.dart';
import 'package:questionnaire_app/utils/common.dart';
import 'package:questionnaire_app/utils/ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authController = getOrPut(AuthController.new);

  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;

  late final StreamSubscription<bool> _loginSubscription;

  @override
  void initState() {
    super.initState();

    _loginSubscription = authController.isLoggedIn.listen((loggedIn) {
      if (loggedIn) {
        navigateTo(AppRoutes.home, clearPreviousAll: true);
      }
    });

    final args = Get.arguments;

    if (args != null && args.containsKey('phone')) {
      phoneController.text = args?['phone'] ?? "";
    }
  }

  @override
  void dispose() {
    _loginSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(paddingLarge),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: .min,
                children: [
                  Text(
                    "Login",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: paddingLarge),
                  TextFormField(
                    controller: phoneController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: .number,
                    decoration: InputDecoration(
                      hintText: "Phone",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadiusLarge),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone number required";
                      }

                      if (value.length != 10) {
                        return "Enter valid 10 digit phone";
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: paddingLarge),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadiusLarge),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password required";
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: paddingLarge),
                  UiButton(
                    isLoading: isLoading.value,
                    onPressed: () async {
                      if (_formKey.currentState?.validate() == true) {
                        debugPrint(
                          "Logging in with phone: ${phoneController.text}, password: ${passwordController.text}",
                        );
                        final phone = phoneController.text.trim();
                        final password = passwordController.text.trim();
                        isLoading.value = true;
                        final result = await authController.login(
                          phone,
                          password,
                        );
                        isLoading.value = false;

                        if (result.success) {
                          showToast(
                            "You are now logged in",
                            type: ToastType.success,
                          );
                        } else {
                          snackBar(
                            'Login Failed',
                            result.message,
                            type: .error,
                          );
                        }
                      }
                    },
                    text: "Login",
                  ),

                  const SizedBox(height: paddingXLarge),
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: "Register",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              navigateTo(
                                AppRoutes.register,
                                clearPrevious: true,
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
