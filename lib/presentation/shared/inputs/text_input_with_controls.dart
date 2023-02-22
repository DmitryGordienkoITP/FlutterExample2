import 'package:flutter/material.dart';

import '../../themes/palette.dart';

const _iconSize = 20.0;

class TextInputWithControls extends StatefulWidget {
  final Widget? label;
  final TextInputType? textInputType;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final bool clearable;
  final bool obscure;
  final String? helperText;
  final String? Function(String?)? validator;

  TextEditingController? controller;

  bool _isObscured = false;
  bool _isVisible = true;

  TextInputWithControls({
    super.key,
    this.label,
    required this.onSaved,
    this.onChanged,
    this.controller,
    this.textInputType,
    this.clearable = false,
    this.obscure = false,
    this.helperText,
    this.validator,
  }) {
    controller = controller ?? TextEditingController();
    _isObscured = obscure;
    _isVisible = !obscure;
  }

  @override
  State<TextInputWithControls> createState() => _TextInputWithControlsState();
}

class _TextInputWithControlsState extends State<TextInputWithControls> {
  bool isValid = true;
  final _focus = FocusNode();
  final _dataKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      labelStyle: const TextStyle(letterSpacing: 0.0),
      helperText: _focus.hasFocus ? widget.helperText : null,
      helperStyle: const TextStyle(fontSize: 15),
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Alert indicator is turned off
          //if(!widget._isValid) const _AlertIndicator(),
          if (widget.obscure && widget.controller!.text.isNotEmpty)
            _VisibilityButton(
              isVisible: widget._isVisible,
              onPressed: () {
                widget._isObscured = !widget._isObscured;
                widget._isVisible = !widget._isVisible;
                setState(() {});
              },
            ),
          if (widget.clearable && widget.controller!.text.isNotEmpty)
            _ClearButton(onPressed: () {
              widget.controller!.clear();
              setState(() {});
            }),
        ],
      ),
      label: widget.label,
    );

    final double letterSpacing = widget._isObscured ? 2.5 : 0.0;

    return TextFormField(
      key: _dataKey,
      style: TextStyle(letterSpacing: letterSpacing),
      focusNode: _focus,
      controller: widget.controller,
      obscureText: widget._isObscured,
      decoration: inputDecoration,
      keyboardType: widget.textInputType,
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
        setState(() {});
      },
      onSaved: (value) {
        if (widget.onSaved == null) return;
        widget.onSaved!(value);
      },
      onTap: () => Scrollable.ensureVisible(_dataKey.currentContext!),
    );
  }
}

class _ClearButton extends StatelessWidget {
  final Function onPressed;
  const _ClearButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      alignment: Alignment.bottomCenter,
      onPressed: () => onPressed(),
      icon: const Icon(Icons.cancel_outlined),
      color: AppPalette.gray1,
      iconSize: _iconSize,
    );
  }
}

class _VisibilityButton extends StatelessWidget {
  final bool isVisible;
  final Function onPressed;
  const _VisibilityButton({required this.onPressed, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      alignment: Alignment.bottomCenter,
      onPressed: () => onPressed(),
      icon: isVisible
          ? const Icon(Icons.visibility_off_outlined)
          : const Icon(Icons.visibility_outlined),
      color: AppPalette.gray1,
      iconSize: _iconSize,
    );
  }
}

// ignore: unused_element
class _AlertIndicator extends StatelessWidget {
  const _AlertIndicator();

  @override
  Widget build(BuildContext context) {
    return const IconButton(
      alignment: Alignment.bottomCenter,
      onPressed: null,
      icon: Icon(
        Icons.error_outline,
        color: AppPalette.red,
      ),
      iconSize: _iconSize,
    );
  }
}
