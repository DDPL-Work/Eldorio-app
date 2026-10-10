import 'package:flutter/material.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _borderAnim;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _borderAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
      if (_focusNode.hasFocus) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color baseColor = Color(0xFF091424);
    const Color borderIdleColor = Color(0xFF27395A);
    const Color borderFocusColor = Color(0xFF2C5EA3);
    const Color hintColor = Color(0xFFA6B3C7);
    const Color textColor = Color(0xFFE8EEF7);
    const Color iconColor = Color(0xFF9EC2F0);
    const Color errorColor = Color(0xFFF2A0A0);

    return AnimatedBuilder(
      animation: _borderAnim,
      builder: (context, child) {
        final Color animatedBorder = Color.lerp(
          borderIdleColor,
          borderFocusColor,
          _borderAnim.value,
        )!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText != null) ...[
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  // color: _isFocused ? borderFocusColor : hintColor,
                  color: ThemeColors.greyColor,
                ),
                child: Text(" ${widget.labelText!}"),
              ),
              const SizedBox(height: 8),
            ],
            Container(
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: animatedBorder, width: 1.5),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: borderFocusColor.withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: ThemeColors.shadowWithAlpha(context, 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                keyboardType: widget.keyboardType,
                obscureText: widget.obscureText,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                validator: widget.validator,
                onChanged: widget.onChanged,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: hintColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? IconTheme(
                          data: IconThemeData(
                            color: ThemeColors.greyColor,
                            size: 20,
                          ),
                          child: widget.prefixIcon!,
                        )
                      : null,
                  suffixIcon: widget.suffixIcon != null
                      ? IconTheme(
                          data: IconThemeData(color: iconColor, size: 20),
                          child: widget.suffixIcon!,
                        )
                      : null,
                  counterText: "",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  errorStyle: TextStyle(
                    color: errorColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget buildTextField({
  required TextEditingController controller,
  required String hintText,
  TextInputType keyboardType = TextInputType.text,
  IconData? prefixIcon,
  Widget? suffixIcon,
  Function(String)? onChanged,
  Function(String)? onSubmitted,
}) {
  return Center(
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: ThemeColors.defaultTextColor,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 3.w,
          color: ThemeColors.textPrimaryColor.withValues(alpha: 0.7),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 4.5.w, color: ThemeColors.primaryColor)
            : null,
        suffixIcon: suffixIcon,
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),

        enabledBorder: outlineInputStyle(),
        disabledBorder: outlineInputStyle(),
        focusedBorder: outlineInputStyle(),
      ),
    ),
  );
}

OutlineInputBorder outlineInputStyle() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: ThemeColors.grey300.withValues(alpha: 0.6)),
  );
}

Widget buildCheckboxRow({
  required String label,
  required bool value,
  required ValueChanged<bool?> onChanged,
}) {
  return InkWell(
    onTap: () => onChanged(!value),
    borderRadius: BorderRadius.circular(6),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          SizedBox(
            width: 5.w,
            height: 5.w,
            child: Checkbox(
              value: value,
              activeColor: ThemeColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: onChanged,
            ),
          ),
          2.5.w.hs,
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 3.w,
                fontWeight: value ? FontWeight.w700 : FontWeight.w500,
                color: ThemeColors.defaultTextColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
