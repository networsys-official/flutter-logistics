import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/app/theme/app_colors.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_logo_header.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_shell.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/otp_input.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/otp_timer.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String _otpCode = '';

  void _onVerify() {
    if (_otpCode.length == 4) {

      debugPrint('Verifying OTP: $_otpCode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthLogoHeader(
            title: 'OTP Verification',
            subtitle: 'OTP has been sent to email id verification',
          ),
          const SizedBox(height: 48),
          OtpInput(
            onChanged: (code) => setState(() => _otpCode = code),
          ),
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
            onPressed: _otpCode.length == 4 ? _onVerify : null,
            child: const Text('Verify OTP'),
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
