import 'dart:convert';

import 'package:bbo_shop_app/core/widgets/app_action_button.dart';
import 'package:bbo_shop_app/core/widgets/app_animated_entrance.dart';
import 'package:bbo_shop_app/features/auth/domain/entities/auth_session.dart';
import 'package:bbo_shop_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:bbo_shop_app/features/main/presentation/controllers/main_navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final session = authState.session;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: AppAnimatedEntrance(
              child: authState.isRestoringSession
                  ? const _RestoringProfileView()
                  : session == null
                  ? const _SignedOutProfileView()
                  : _SignedInProfileView(session: session),
            ),
          ),
        ),
      ),
    );
  }
}

class _RestoringProfileView extends StatelessWidget {
  const _RestoringProfileView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          'Vérification de la session...',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _SignedOutProfileView extends ConsumerWidget {
  const _SignedOutProfileView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.login_rounded, size: 48, color: theme.colorScheme.primary),
        const SizedBox(height: 14),
        Text(
          'Connexion',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Connectez-vous pour retrouver votre profil et vos informations.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: .72),
          ),
        ),
        const SizedBox(height: 24),
        AppActionButton(
          label: 'Se connecter',
          icon: Icons.sms_rounded,
          onPressed: () {
            ref
                .read(mainNavigationControllerProvider.notifier)
                .requestLoginSheet();
          },
        ),
      ],
    );
  }
}

class _SignedInProfileView extends ConsumerWidget {
  const _SignedInProfileView({required this.session});

  final AuthSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final claims = session.tokenClaims;
    final entries = claims.values.entries.toList()
      ..sort((first, second) => first.key.compareTo(second.key));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_rounded,
                size: 44,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profil',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      session.phoneNumber ?? 'Session restaurée',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: .72,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _InfoSection(
            title: 'Session',
            children: [
              _InfoRow(label: 'Statut', value: 'Connecté'),
              _InfoRow(
                label: 'Conservation locale',
                value: session.isStoredLocally ? 'Sécurisée' : 'Indisponible',
                isError: !session.isStoredLocally,
              ),
              if (session.localStorageError != null)
                _InfoRow(
                  label: 'Avertissement',
                  value: session.localStorageError!,
                  isError: true,
                ),
              if (claims.subject != null)
                _InfoRow(label: 'Identifiant', value: claims.subject!),
              if (claims.phoneNumber != null)
                _InfoRow(label: 'Téléphone', value: claims.phoneNumber!),
              if (claims.issuer != null)
                _InfoRow(label: 'Émetteur', value: claims.issuer!),
              if (claims.issuedAt != null)
                _InfoRow(
                  label: 'Émis le',
                  value: _formatDate(claims.issuedAt!),
                ),
              if (claims.expiresAt != null)
                _InfoRow(
                  label: 'Expire le',
                  value: _formatDate(claims.expiresAt!),
                ),
              if (claims.roles.isNotEmpty)
                _InfoRow(label: 'Rôles', value: claims.roles.join(', ')),
            ],
          ),
          const SizedBox(height: 18),
          _InfoSection(
            title: 'Token décodé',
            children: [
              if (!claims.isDecoded)
                _InfoRow(
                  label: 'Décodage',
                  value: claims.decodeError!,
                  isError: true,
                )
              else if (entries.isEmpty)
                const _InfoRow(label: 'Claims', value: 'Aucune information.')
              else
                for (final entry in entries)
                  _InfoRow(
                    label: entry.key,
                    value: _formatClaimValue(entry.key, entry.value),
                  ),
            ],
          ),
          const SizedBox(height: 22),
          OutlinedButton.icon(
            onPressed: () => _signOut(context, ref),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final signedOut = await ref.read(authControllerProvider.notifier).signOut();
    if (!context.mounted || !signedOut) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Session fermée.')));
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isError = false,
  });

  final String label;
  final String value;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: .64),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          SelectableText(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isError ? theme.colorScheme.error : null,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatClaimValue(String key, Object? value) {
  if ((key == 'exp' || key == 'iat' || key == 'nbf') && value is num) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      value.toInt() * 1000,
      isUtc: true,
    );
    return '${_formatDate(date)} ($value)';
  }

  if (value is Map || value is List) {
    return const JsonEncoder.withIndent('  ').convert(value);
  }

  return value?.toString() ?? 'null';
}

String _formatDate(DateTime date) {
  final local = date.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final year = local.year.toString();
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day/$month/$year $hour:$minute';
}
