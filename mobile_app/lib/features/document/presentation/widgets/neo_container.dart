import 'package:corp_doc_ai/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class NeoContainer extends StatefulWidget {
  final double height;
  final double width;
  final Widget child;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;

  const NeoContainer({
    super.key,
    this.height = 55,
    this.width = 55,
    this.backgroundColor = AppColors.secondary,
    this.foregroundColor = AppColors.black,
    this.borderRadius = 10,
    required this.child,
    required this.onTap,
  });

  @override
  State<NeoContainer> createState() => _NeoContainerState();
}

class _NeoContainerState extends State<NeoContainer> {
  bool _isPressed = false;
  final GlobalKey _key = GlobalKey();

  bool _isPointerInsideBounds(Offset globalPosition) {
    final RenderBox? box =
        _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return false;

    final Offset localPosition = box.globalToLocal(globalPosition);
    final Size size = box.size;

    return localPosition.dx >= 0 &&
        localPosition.dx <= size.width &&
        localPosition.dy >= 0 &&
        localPosition.dy <= size.height;
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = _isPressed
        ? widget.backgroundColor
        : widget.foregroundColor;

    return Listener(
      onPointerDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onPointerUp: (event) {
        final wasPressed = _isPressed;
        setState(() {
          _isPressed = false;
        });
        if (wasPressed && _isPointerInsideBounds(event.position)) {
          widget.onTap();
        }
      },
      child: AnimatedContainer(
        key: _key,
        duration: const Duration(milliseconds: 100),
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: _isPressed ? AppColors.black : widget.backgroundColor,
          border: Border.all(color: AppColors.black),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.black,
              offset: _isPressed ? const Offset(0, 0) : const Offset(5, 5),
            ),
          ],
        ),
        child: Center(
          child: IconTheme(
            data: IconThemeData(color: currentColor),
            child: DefaultTextStyle(
              style: TextStyle(color: currentColor, fontSize: 20),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
