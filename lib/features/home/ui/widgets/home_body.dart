import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/constants/strings/home_strings.dart';
import 'package:logistic_by_strom/features/home/ui/widgets/home_action_grid.dart';
import 'package:logistic_by_strom/features/home/ui/widgets/home_banner_carousel.dart';
import 'package:logistic_by_strom/features/home/ui/widgets/home_section_header.dart';
import 'package:logistic_by_strom/features/home/ui/widgets/shipment_card.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20,),
      physics: const BouncingScrollPhysics(),
      children: [
        // Quick-action grid
        const HomeActionGrid(),

        const SizedBox(height: 24),

        // Promotional banner carousel
        const HomeBannerCarousel(),

        const SizedBox(height: 24),

        const SizedBox(height: 24),

        // Current shipment section
        HomeSectionHeader(
          title: HomeStrings.currentShipment,
          onViewAll: () {},
        ),
        const ShipmentCard(
          title: 'Current',
          id: '#HWDSF776567DS',
          status: HomeStrings.onTheWay,
          date: '30 March',
          showTimeline: true,
        ),

        // const SizedBox(height: 8),
        //
        // // Recent shipments section
        // HomeSectionHeader(
        //   title: HomeStrings.recentShipments,
        //   onViewAll: () {},
        // ),
        // const ShipmentCard(
        //   title: 'Recent',
        //   id: '#BAH99228834XL',
        //   status: HomeStrings.delivered,
        //   date: '28 March',
        // ),

        // Extra bottom padding so FAB doesn't obscure content
        const SizedBox(height: 110),
      ],
    );
  }
}
