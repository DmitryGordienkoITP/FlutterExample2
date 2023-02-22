import 'package:flutter/material.dart';

import '../../themes/palette.dart';

const _iconSize = 24.0;

enum WidgetStatusType {
  active,
  disabled,
  empty,
}

class ExternalSourceInput extends StatefulWidget {
  final Widget? label;
  final Function? onTap;
  final bool clearable;
  final void Function()? onAction;
  final void Function()? onReset;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;

  late final TextEditingController? _controller;

  WidgetStatusType get widgetStatus {
    if (!enabled) {
      return WidgetStatusType.disabled;
    } else if (_controller == null || _controller!.text.isEmpty) {
      return WidgetStatusType.empty;
    } else {
      return WidgetStatusType.active;
    }
  }

  ExternalSourceInput({
    super.key,
    this.label,
    this.onAction,
    this.onReset,
    this.onSaved,
    this.onChanged,
    this.onTap,
    controller,
    this.clearable = false,
    this.validator,
    this.enabled = true,
  }) {
    _controller = controller ?? TextEditingController();
  }

  @override
  State<ExternalSourceInput> createState() => _ExternalSourceInputState();
}

class _ExternalSourceInputState extends State<ExternalSourceInput> {
  bool isValid = true;
  @override
  Widget build(BuildContext context) {
    final actionElementColor = widget.widgetStatus == WidgetStatusType.active
        ? AppPalette.accentGreen
        : widget.widgetStatus == WidgetStatusType.empty
            ? AppPalette.accentGreen
            : AppPalette.gray2;

    final controllerHasValue =
        widget._controller != null && widget._controller!.text.isNotEmpty;
    final inputDecoration = InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      border: InputBorder.none,
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.clearable && controllerHasValue
              ? _ClearButton(
                  onPressed: widget.onReset,
                  color: actionElementColor,
                )
              : _ActionButton(
                  onPressed: widget.onAction,
                  color: actionElementColor,
                ),
        ],
      ),
      label: widget.label,
    );

    final lines = widget._controller?.text.split('\n').length;

    return Opacity(
      opacity: widget.widgetStatus == WidgetStatusType.disabled ? 0.5 : 1,
      child: TextFormField(
        minLines: 1,
        maxLines: (lines ?? 1) + 1,
        enabled: widget.enabled,
        readOnly: true,
        showCursor: false,
        controller: widget._controller,
        decoration: inputDecoration,
        validator: (value) {
          if (widget.validator == null) return null;
          final validationResult = widget.validator!(value);
          isValid = validationResult == null;
          setState(() {});
          return validationResult;
        },
        onChanged: (value) {
          if (widget.onChanged == null) return;
          widget.onChanged!(value);
        },
        onTap: () {
          if (widget.onTap == null) return;
          widget.onTap!();
        },
        onSaved: (value) {
          if (widget.onSaved == null) return;
          widget.onSaved!(value);
        },
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  final Function? onPressed;
  final Color? color;
  const _ClearButton({
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      alignment: Alignment.bottomCenter,
      onPressed: () {
        FocusScope.of(context).unfocus();
        onPressed!();
      },
      icon: const Icon(Icons.close),
      color: color,
      iconSize: _iconSize,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final Function? onPressed;
  final Color? color;
  const _ActionButton({
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      icon: const Icon(Icons.chevron_right),
      color: color,
      iconSize: _iconSize,
    );
  }
}
