import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';

class DeepLinkService {
  DeepLinkService(this.router);

  final GoRouter router;
  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _sub;

  Future<void> init() async {
    final initial = await _appLinks.getInitialLink();

    if (initial != null) {
      router.go(initial.toString());
    }

    _sub = _appLinks.uriLinkStream.listen((uri) {
      router.go(uri.toString());
    });
  }

  // void _handleUri(Uri uri) {
  //   debugPrint("========== DEEP LINK ==========");
  //   debugPrint("URI : $uri");
  //
  //   if (uri.scheme != "stromapp") return;
  //
  //   if (uri.host == "reset-password") {
  //     final email = uri.queryParameters["email"] ?? "";
  //     final token = uri.queryParameters["token"] ?? "";
  //
  //     debugPrint("Navigating to reset password");
  //
  //     router.go(
  //       Uri(
  //         path: AppRoutes.resetPassword,
  //         queryParameters: {
  //           if (email.isNotEmpty) "email": email,
  //           if (token.isNotEmpty) "token": token,
  //         },
  //       ).toString(),
  //     );
  //   }
  // }

  void dispose() {
    _sub?.cancel();
  }
  // void _handleUri(Uri uri) {
  //   debugPrint("========== DEEP LINK ==========");
  //   debugPrint(uri.toString());
  //
  //   if (uri.scheme != "stromapp") return;
  //
  //   final email = uri.queryParameters["email"] ?? "";
  //   final token = uri.queryParameters["token"] ?? "";
  //
  //   debugPrint("Navigating to reset password");
  //
  //   router.go(
  //     "${AppRoutes.resetPassword}?email=$email&token=$token",
  //   );
  // }


}