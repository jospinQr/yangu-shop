import 'package:bbo_shop_app/core/widgets/app_action_button.dart';
import 'package:bbo_shop_app/core/widgets/app_animated_entrance.dart';
import 'package:bbo_shop_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginBottomSheet extends ConsumerStatefulWidget {
  const LoginBottomSheet({required this.onOtpRequested, super.key});

  final ValueChanged<String> onOtpRequested;

  @override
  ConsumerState<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends ConsumerState<LoginBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '+243');

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: AppAnimatedEntrance(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),

                              child: Icon(
                                Icons.lock_open_rounded,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Connexion',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Fermer',
                            onPressed: authState.isRequestingOtp
                                ? null
                                : () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Entrez votre numéro de téléphone pour recevoir un code à 6 chiffres.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: .72,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      PhoneNumberField(controller: _phoneController),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: authState.requestOtpError == null
                            ? const SizedBox.shrink()
                            : Padding(
                                key: ValueKey(authState.requestOtpError),
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  authState.requestOtpError!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 22),
                      AppActionButton(
                        label: 'Recevoir le code',
                        icon: Icons.sms_rounded,
                        onPressed: _requestOtp,
                        isLoading: authState.isRequestingOtp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _requestOtp() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    final phoneNumber = _phoneController.text.trim();
    final requested = await ref
        .read(authControllerProvider.notifier)
        .requestOtp(phoneNumber);

    if (!mounted || !requested) {
      return;
    }

    Navigator.of(context).pop();
    widget.onOtpRequested(phoneNumber);
  }
}

class PhoneNumberField extends StatefulWidget {
  const PhoneNumberField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: _focusNode.hasFocus
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: .12),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : const [],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        autofocus: true,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.done,
        autofillHints: const [AutofillHints.telephoneNumber],
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[+0-9]')),
          LengthLimitingTextInputFormatter(16),
        ],
        decoration: const InputDecoration(
          labelText: 'Numéro de téléphone',
          hintText: '+243970000000',
          prefixIcon: Icon(Icons.phone_rounded),
        ),
        validator: (value) {
          final phoneNumber = value?.trim() ?? '';
          if (phoneNumber.isEmpty) {
            return 'Entrez votre numéro de téléphone.';
          }
          if (!RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(phoneNumber)) {
            return 'Utilisez le format international, ex. +243970000000.';
          }
          return null;
        },
        onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }
}
