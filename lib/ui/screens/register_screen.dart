import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:questionnaire_app/constants/ui_constants.dart';
import 'package:questionnaire_app/controllers/auth_controller.dart';
import 'package:questionnaire_app/ui/widgets/ui_button.dart';
import 'package:questionnaire_app/utils/ui.dart';

import '../../routes/app_routes.dart';
import '../../utils/common.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final authController = getOrPut(AuthController.new);

  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;

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
                    "Register",
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

                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: paddingLarge),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadiusLarge),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Confirm your password";
                      }

                      if (value != passwordController.text) {
                        return "Passwords do not match";
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: paddingLarge),
                  UiButton(
                    isLoading: isLoading.value,
                    onPressed: () async {
                      if (_formKey.currentState?.validate() == true) {
                        final phone = phoneController.text.trim();
                        final password = passwordController.text.trim();

                        isLoading.value = true;
                        final result = await authController.register(
                          phone,
                          password,
                        );
                        isLoading.value = false;

                        if (result.success) {
                          snackBar(
                            "Account registered successfully",
                            "Login to continue",
                          );
                          navigateTo(
                            AppRoutes.login,
                            data: {'phone': phone},
                            clearPreviousAll: true,
                          );
                        } else {
                          snackBar(
                            'Registration Failed',
                            result.message,
                            type: .error,
                          );
                        }
                      }
                    },
                    text: "Register",
                  ),

                  const SizedBox(height: paddingXLarge),
                  RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: "Login",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              navigateTo(AppRoutes.login, clearPrevious: true);
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
