import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/widgets/app_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';


class PaymentWebViewPage extends StatefulWidget {
  final String url;
  final String title;
  const PaymentWebViewPage({
    super.key,
    required this.url,
    required this.title,
  });
  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasResolved = false; // guard against double-pop

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) async {
            setState(() {
              _isLoading = false;
            });

            if (_hasResolved) return;

            final isReturnPage = url.contains('/payments/paypal/return') ||
                url.contains('/payments/fygaro/return');

            if (!isReturnPage) return;

            // Don't trust the URL alone. Read the explicit status marker
            // rendered by PaypalReturnController: <body data-payment-status="success|failed">
            String status = '';
            try {
              final result = await _controller.runJavaScriptReturningResult(
                "document.body.getAttribute('data-payment-status')",
              );
              status = result.toString().replaceAll('"', '').toLowerCase();
            } catch (_) {
              status = '';
            }

            if (status == 'success') {
              _hasResolved = true;
              if (mounted) Navigator.pop(context, true);
            } else if (status == 'failed') {
              _hasResolved = true;
              if (mounted) Navigator.pop(context, false);
            }
            // If the marker isn't found (unexpected page), stay put rather
            // than guessing — avoids silently reporting false success.
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('cancel')) {
              _hasResolved = true;
              Navigator.pop(context, false);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppAppBar(title: widget.title),
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// class PaymentWebViewPage extends StatefulWidget {
//   final String url;
//   final String title;
//
//   const PaymentWebViewPage({
//     super.key,
//     required this.url,
//     required this.title,
//   });
//
//   @override
//   State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
// }
//
// class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
//   late final WebViewController _controller;
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (String url) {
//             setState(() {
//               _isLoading = true;
//             });
//           },
//           // onPageFinished: (String url) {
//           //   setState(() {
//           //     _isLoading = false;
//           //   });
//           //   if (url.contains('admin.logisticsystemsbs.com/payment/success')) {
//           //     Navigator.pop(context, true); // Return true on success
//           //   }
//           // },
//           // onNavigationRequest: (NavigationRequest request) {
//           //   if (request.url.contains('admin.logisticsystemsbs.com/payment/cancel')) {
//           //     Navigator.pop(context, false); // Return false on cancel
//           //     return NavigationDecision.prevent;
//           //   }
//           //   if (request.url.contains('admin.logisticsystemsbs.com/payment/success')) {
//           //     Navigator.pop(context, true);
//           //     return NavigationDecision.prevent;
//           //   }
//           //   return NavigationDecision.navigate;
//           // },
//
//
//           onPageFinished: (String url) {
//             setState(() {
//               _isLoading = false;
//             });
//             // Once the page loading is finished, check if it's the backend return/success page
//             if (url.contains('/paypal/return') ||
//                 url.contains('/payments/paypal/return') ||
//                 url.contains('/payments/fygaro/return') ||
//                 url.contains('success') ||
//                 url.contains('complete')) {
//               Navigator.pop(context, true); // Return true on success
//             }
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             // Intercept cancel URLs immediately
//             if (request.url.contains('cancel')) {
//               Navigator.pop(context, false); // Return false on cancel
//               return NavigationDecision.prevent;
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.url));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           AppAppBar(title: widget.title),
//           Expanded(
//             child: Stack(
//               children: [
//                 WebViewWidget(controller: _controller),
//                 if (_isLoading)
//                   const Center(
//                     child: CircularProgressIndicator(),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
