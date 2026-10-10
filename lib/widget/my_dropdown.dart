import 'package:flutter/material.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class MyDropdown<T> extends StatefulWidget {
  final T? value;
  final String hintText;
  final String? labelText;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;

  const MyDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.value,
    this.labelText,
    this.validator,
    this.prefixIcon,
  });

  @override
  State<MyDropdown<T>> createState() => _MyDropdownState<T>();
}

class _MyDropdownState<T> extends State<MyDropdown<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _borderAnim;

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _borderAnim = Tween<double>(begin: 0, end: 1).animate(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onDropdownOpen() {
    setState(() => _isOpen = true);
    _animController.forward();
  }

  void _onDropdownClose() {
    setState(() => _isOpen = false);
    _animController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    const Color baseColor = Color(0xFF091424);
    const Color borderIdleColor = Color(0xFF27395A);
    const Color borderFocusColor = Color(0xFF2C5EA3);
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
              Text(
                widget.labelText!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: ThemeColors.greyColor,
                ),
              ),
              const SizedBox(height: 8),
            ],

            Container(
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: animatedBorder, width: 1.5),
                boxShadow: _isOpen
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
              child: DropdownButtonFormField<T>(
                isExpanded: true,
                // value: widget.value,
                initialValue: widget.value,
                items: widget.items,
                onChanged: widget.onChanged,
                validator: widget.validator,
                dropdownColor: baseColor,
                borderRadius: BorderRadius.circular(14),

                onTap: () {
                  if (!_isOpen) {
                    _onDropdownOpen();
                  } else {
                    _onDropdownClose();
                  }
                },

                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),

                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: iconColor,
                  size: 22,
                ),

                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: ThemeColors.greyColor,
                    fontSize: 15,
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

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),

                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
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
