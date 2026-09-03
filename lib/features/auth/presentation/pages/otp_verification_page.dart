import 'package:bbo_shop_app/app/router/app_routes.dart';
import 'package:bbo_shop_app/core/widgets/app_action_button.dart';
import 'package:bbo_shop_app/core/widgets/app_animated_entrance.dart';
import 'package:bbo_shop_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:bbo_shop_app/features/auth/presentation/widgets/otp_code_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationPage extends ConsumerStatefulWidget {
  const OtpVerificationPage({required this.phoneNumber, super.key});

  final String phoneNumber;

  @override
  ConsumerState<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);
    final canSubmit = _code.length == 6 && !authState.isVerifyingOtp;

    return Scaffold(
      appBar: AppBar(title: const Text('Vérification')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: AppAnimatedEntrance(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: .96, end: 1),
                        duration: const Duration(milliseconds: 520),
                        curve: Curves.easeOutBack,
                        builder: (context, scale, child) {
                          return Transform.scale(scale: scale, child: child);
                        },
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Icon(
                              Icons.mark_chat_read_rounded,
                              size: 42,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Entrez le code reçu',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nous avons envoyé un code à 6 chiffres au ${widget.phoneNumber}.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: .72,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    OtpCodeField(
                      length: 6,
                      enabled: !authState.isVerifyingOtp,
                      errorText: authState.verifyOtpError,
                      onChanged: (value) {
                        ref
                            .read(authControllerProvider.notifier)
                            .clearVerifyError();
                        setState(() => _code = value);
                      },
                    ),
                    const SizedBox(height: 24),
                    AppActionButton(
                      label: 'Valider le code',
                      icon: Icons.verified_rounded,
                      onPressed: canSubmit ? _verifyOtp : null,
                      isLoading: authState.isVerifyingOtp,
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: authState.isRequestingOtp ? null : _resendOtp,
                      icon: const Icon(Icons.restart_alt_rounded),
                      label: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 160),
                        child: authState.isRequestingOtp
                            ? const Text(
                                'Envoi en cours...',
                                key: ValueKey('sending'),
                              )
                            : const Text(
                                'Renvoyer le code',
                                key: ValueKey('resend'),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _verifyOtp() async {
    final verified = await ref
        .read(authControllerProvider.notifier)
        .verifyOtp(phoneNumber: widget.phoneNumber, code: _code);

    if (!mounted || !verified) {
      return;
    }

    final session = ref.read(authControllerProvider).session;
    final message = session?.localStorageError ?? 'Connexion réussie.';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    context.goNamed(AppRouteNames.home);
  }

  Future<void> _resendOtp() async {
    final sent = await ref
        .read(authControllerProvider.notifier)
        .requestOtp(widget.phoneNumber);

    if (!mounted || !sent) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Un nouveau code a été envoyé.')),
    );
  }
}
