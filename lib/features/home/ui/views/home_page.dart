import 'package:flutter/material.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        HomeAppBar(),
        Expanded(
          child: HomeBody(),
        ),
      ],

    );
  }
}
