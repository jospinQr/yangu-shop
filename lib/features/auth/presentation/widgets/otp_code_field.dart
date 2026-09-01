import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpCodeField extends StatefulWidget {
  const OtpCodeField({
    required this.length,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
    super.key,
  });

  final int length;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final bool enabled;

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final code = _controller.text;
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: 'Code de vérification',
          textField: true,
          child: GestureDetector(
            onTap: widget.enabled ? _focusNode.requestFocus : null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: List.generate(widget.length, (index) {
                    final digit = index < code.length ? code[index] : '';
                    final isCurrent = index == code.length && widget.enabled;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: index == widget.length - 1 ? 0 : 8,
                        ),
                        child: _OtpDigitBox(
                          digit: digit,
                          isFocused: isCurrent && _focusNode.hasFocus,
                          hasError: hasError,
                        ),
                      ),
                    );
                  }),
                ),
                Positioned.fill(
                  child: Opacity(
                    opacity: .01,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      enabled: widget.enabled,
                      keyboardType: TextInputType.number,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(widget.length),
                      ],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      maxLength: widget.length,
                      onChanged: (value) {
                        setState(() {});
                        widget.onChanged(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Padding(
              key: ValueKey(widget.errorText),
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                widget.errorText!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _OtpDigitBox extends StatelessWidget {
  const _OtpDigitBox({
    required this.digit,
    required this.isFocused,
    required this.hasError,
  });

  final String digit;
  final bool isFocused;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isFilled = digit.isNotEmpty;
    final borderColor = hasError
        ? colorScheme.error
        : isFocused
        ? colorScheme.primary
        : isFilled
        ? colorScheme.primary.withValues(alpha: .45)
        : colorScheme.outlineVariant;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: hasError
            ? colorScheme.error.withValues(alpha: .05)
            : isFilled
            ? colorScheme.primaryContainer.withValues(alpha: .56)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: isFocused ? 1 : .6),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: .12),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ]
            : const [],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 140),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Text(
          digit,
          key: ValueKey(digit),
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
