import 'package:flutter/material.dart';

import '../theme/astralia_colors.dart';
import '../theme/astralia_theme.dart';

class AstraliaTextField extends StatefulWidget {
  const AstraliaTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.obscure = false,
    this.autofillHints,
    this.textInputAction,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscure;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AstraliaTextField> createState() => _AstraliaTextFieldState();
}

class _AstraliaTextFieldState extends State<AstraliaTextField> {
  late bool _hidden = widget.obscure;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: BorderSide(color: color),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 4),
          child: Text(
            widget.label.toUpperCase(),
            style: AstraliaType.sans(size: 11, color: AstraliaColors.lilac),
          ),
        ),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          obscureText: _hidden,
          autofillHints: widget.autofillHints,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onSubmitted,
          style: AstraliaType.sans(size: 14),
          cursorColor: AstraliaColors.gold,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0x0FFFFFFF),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            border: _border(const Color(0x33FFFFFF)),
            enabledBorder: _border(const Color(0x33FFFFFF)),
            focusedBorder: _border(AstraliaColors.gold),
            errorBorder: _border(AstraliaColors.alert),
            focusedErrorBorder: _border(AstraliaColors.alert),
            errorStyle: AstraliaType.sans(
              size: 11,
              color: AstraliaColors.alert,
            ),
            suffixIcon: widget.obscure
                ? IconButton(
                    icon: Icon(
                      _hidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                    ),
                    color: AstraliaColors.lilac,
                    onPressed: () => setState(() => _hidden = !_hidden),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
