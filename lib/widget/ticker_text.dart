import 'dart:async';
import 'package:flutter/material.dart';

class TickerText extends StatefulWidget {
  final List<String> items;
  final TextStyle? style;
  final Duration interval;

  const TickerText({
    super.key,
    required this.items,
    this.style,
    this.interval = const Duration(milliseconds: 3200),
  });

  @override
  State<TickerText> createState() => _TickerTextState();
}

class _TickerTextState extends State<TickerText> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.items.length > 1) {
      _timer = Timer.periodic(widget.interval, (t) {
        if (mounted) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % widget.items.length;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.25),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        widget.items[_currentIndex],
        key: ValueKey<int>(_currentIndex),
        style: widget.style,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
