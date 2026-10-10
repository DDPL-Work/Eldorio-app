import 'package:flutter/material.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

enum ButtonVariant { primary, secondary, outline, ghost }

class MyButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isLoading;
  final bool fullWidth;
  final double? width;
  final Color? color;

  const MyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.fullWidth = true,
    this.width,
    this.color,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
  }

  void _onTapDown(_) {
    if (widget.onPressed == null || widget.isLoading) return;
    setState(() => _isPressed = true);
  }

  void _onTapUp(_) {
    if (!_isPressed) return;
    setState(() => _isPressed = false);
  }

  void _onTapCancel() {
    if (!_isPressed) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null || widget.isLoading;

    final _ButtonStyle style = _resolveStyle(
      variant: widget.variant,
      isDisabled: isDisabled,
      accentColor: widget.color ?? ThemeColors.blue,
      accentDark: widget.color ?? ThemeColors.primaryColor,
    );

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: isDisabled ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: widget.fullWidth ? double.infinity : widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: style.border,
          gradient: style.gradient,
          boxShadow: isDisabled
              ? []
              : _isPressed
              ? []
              : style.shadow,
        ),
        child: _buildContent(style),
      ),
    );
  }

  Widget _buildContent(_ButtonStyle style) {
    if (widget.isLoading) {
      return Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            valueColor: AlwaysStoppedAnimation<Color>(style.foregroundColor),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.prefixIcon != null) ...[
          IconTheme(
            data: IconThemeData(color: style.foregroundColor, size: 18),
            child: widget.prefixIcon!,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          widget.label,
          style: TextStyle(
            color: style.foregroundColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        if (widget.suffixIcon != null) ...[
          const SizedBox(width: 8),
          IconTheme(
            data: IconThemeData(color: style.foregroundColor, size: 18),
            child: widget.suffixIcon!,
          ),
        ],
      ],
    );
  }

  _ButtonStyle _resolveStyle({
    required ButtonVariant variant,
    required bool isDisabled,
    required Color accentColor,
    required Color accentDark,
  }) {
    if (isDisabled) {
      return _ButtonStyle(
        backgroundColor: ThemeColors.darkSurface,
        foregroundColor: ThemeColors.disabledFgDark,
        gradient: null,
        border: null,
        shadow: [],
      );
    }

    switch (variant) {
      case ButtonVariant.primary:
        return _ButtonStyle(
          backgroundColor: null,
          foregroundColor: ThemeColors.white,
          // gradient: LinearGradient(
          //   colors: [accentColor, accentDark],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          gradient: LinearGradient(
            colors: [accentColor, accentColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: null,
          shadow: [
            BoxShadow(
              color: accentDark.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        );

      case ButtonVariant.secondary:
        return _ButtonStyle(
          backgroundColor: ThemeColors.snackSuccessIcon,
          foregroundColor: ThemeColors.white,
          gradient: null,
          border: null,
          shadow: [],
        );

      case ButtonVariant.outline:
        return _ButtonStyle(
          backgroundColor: widget.color?.withValues(alpha: .2),
          foregroundColor: accentColor,
          gradient: null,
          border: Border.all(color: accentColor, width: 1.5),
          shadow: [],
        );

      case ButtonVariant.ghost:
        return const _ButtonStyle(
          backgroundColor: Color(0xFF102038),
          foregroundColor: Color(0xFF9EC2F0),
          gradient: null,
          border: null,
          shadow: [],
        );
    }
  }
}

class _ButtonStyle {
  final Color? backgroundColor;
  final Color foregroundColor;
  final Gradient? gradient;
  final BoxBorder? border;
  final List<BoxShadow> shadow;

  const _ButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.gradient,
    required this.border,
    required this.shadow,
  });
}
