import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/core/constants/strings/app_strings.dart';
import 'package:logistic_by_strom/core/constants/strings/auth_strings.dart';
import 'package:logistic_by_strom/core/constants/strings/error_strings.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/utils/error_message.dart';

import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/features/auth/ui/view_models/verify_otp_view_model.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_logo_header.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_shell.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/otp_input.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/otp_timer.dart';

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({required this.identifier, required this.type, super.key});

  final String identifier;
  final String type;

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  String _otpCode = '';

  Future<void> _onVerify() async {
    if (_otpCode.length == 4) {
      await ref
          .read(verifyOtpViewModelProvider.notifier)
          .verifyOtp(
            identifier: widget.identifier,
            type: widget.type,
            otp: _otpCode,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final verifyState = ref.watch(verifyOtpViewModelProvider);

    ref.listen(verifyOtpViewModelProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (widget.type == 'forgot_password') {
            context.push(
              AppRoutes.resetPassword,
              extra: {'email': widget.identifier, 'otp': _otpCode},
            );
          }
        },
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMessageFrom(e, fallback: ErrorStrings.somethingWentWrong),
              ),
            ),
          );
        },
      );
    });

    return AuthShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          const AuthLogoHeader(
            title: AuthStrings.otpVerification,
            subtitle: AuthStrings.otpSubtitle,
          ),
          const SizedBox(height: 48),
          OtpInput(
            fieldHeight: 120,
            onChanged: (code) => setState(() => _otpCode = code),
          ),
          const SizedBox(height: 32),
          Center(
            child: OtpTimer(
              onResend: () async {
                final messenger = ScaffoldMessenger.of(context);
                await ref
                    .read(verifyOtpViewModelProvider.notifier)
                    .resendOtp(
                      identifier: widget.identifier,
                      type: widget.type,
                    );
                if (mounted) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text(AuthStrings.otpResentSuccess)),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 64),
          ElevatedButton(
            onPressed: _otpCode.length == 4 && !verifyState.isLoading
                ? _onVerify
                : null,
            child: verifyState.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(AuthStrings.verifyOtp),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(
              AppStrings.cancel,
              style: TextStyle(
                color: AppColors.neutral900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
