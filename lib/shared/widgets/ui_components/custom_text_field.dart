import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TextFieldVariant { outlined, filled }

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final TextFieldVariant variant;
  final bool showCounter;
  
  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
    this.validator,
    this.variant = TextFieldVariant.outlined,
    this.showCounter = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  
  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }
  
  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }
  
  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final decoration = InputDecoration(
      labelText: widget.label,
      hintText: widget.hint,
      helperText: widget.helperText,
      helperMaxLines: 2,
      errorText: widget.errorText,
      errorMaxLines: 2,
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon,
      counterText: widget.showCounter ? null : '',
      filled: widget.variant == TextFieldVariant.filled,
      fillColor: widget.variant == TextFieldVariant.filled
          ? theme.colorScheme.surfaceVariant
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: widget.variant == TextFieldVariant.filled
            ? BorderSide.none
            : const BorderSide(),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: widget.variant == TextFieldVariant.filled
            ? BorderSide.none
            : BorderSide(color: theme.colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.error,
          width: 2,
        ),
      ),
    );
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: _isFocused && widget.variant == TextFieldVariant.outlined
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComplete,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        inputFormatters: widget.inputFormatters,
        obscureText: widget.obscureText,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        validator: widget.validator,
        decoration: decoration,
      ),
    );
  }
}