import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/app/router/app_routes.dart';
import 'package:logistic_by_strom/app/theme/app_colors.dart';
import 'package:logistic_by_strom/features/auth/ui/view_models/auth_view_model.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_logo_header.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_shell.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/otp_input.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/otp_timer.dart';

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({required this.userId, this.email, this.phone, super.key});

  final String userId;
  final String? email;
  final String? phone;

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  String _otpCode = '';

  Future<void> _onVerify() async {
    if (_otpCode.length == 4) {
      await ref
          .read(authViewModelProvider.notifier)
          .verifyOtp(userId: widget.userId, otp: _otpCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen(authViewModelProvider, (previous, next) {
      next.when(
        data: (state) {
          if (state.isLoggedIn) {
            context.go(AppRoutes.home);
          }
        },
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('OTP Verification Failed: $e')),
          );
        },
        loading: () {},
      );
    });

    final subtitle = widget.email != null && widget.email!.isNotEmpty
        ? 'OTP has been sent to ${widget.email}'
        : widget.phone != null && widget.phone!.isNotEmpty
        ? 'OTP has been sent to ${widget.phone}'
        : 'Enter the OTP sent to your registered account';

    return AuthShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthLogoHeader(title: 'OTP Verification', subtitle: subtitle),
          const SizedBox(height: 48),
          OtpInput(onChanged: (code) => setState(() => _otpCode = code)),
          const SizedBox(height: 32),
          Center(
            child: OtpTimer(
              onResend: () {
                debugPrint('Resending OTP');
              },
            ),
          ),
          const SizedBox(height: 64),
          ElevatedButton(
            onPressed: _otpCode.length == 4 && !authState.isLoading
                ? _onVerify
                : null,
            child: authState.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Verify OTP'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(
              'Cancel',
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
