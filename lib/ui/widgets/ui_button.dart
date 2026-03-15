import 'package:flutter/material.dart';
import 'package:questionnaire_app/constants/ui_constants.dart';

class UiButton extends StatefulWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final bool isLoading;

  const UiButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  State<UiButton> createState() => _UiButtonState();
}

class _UiButtonState extends State<UiButton> {
  @override
  void initState() {
    super.initState();
    if (widget.child != null && widget.text != null) {
      throw ArgumentError("Cannot provide both text and child to UiButton");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusLarge),
          ),
        ),
        minimumSize: WidgetStatePropertyAll(Size(double.infinity, 48)),
      ),
      child: widget.isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 1.2,
              ),
            )
          : widget.child ?? Text(widget.text ?? ""),
    );
  }
}
