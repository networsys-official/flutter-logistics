import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/widgets/app_app_bar.dart';
import 'package:logistic_by_strom/features/accounts/data/models/user_address.dart';
import 'package:logistic_by_strom/features/accounts/ui/view_models/user_address_view_model.dart';
import 'package:logistic_by_strom/features/accounts/ui/widgets/add_address_bottom_button.dart';
import 'package:logistic_by_strom/features/accounts/ui/widgets/address_card.dart';
import 'package:logistic_by_strom/features/accounts/ui/widgets/empty_addresses_view.dart';

class ShipmentAddressPage extends ConsumerWidget {
  const ShipmentAddressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(userAddressViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: Column(
        children: [
          const AppAppBar(
            title: 'Shipment Address',
          ),
          Expanded(
            child: addressState.when(
              data: (addresses) => addresses.isEmpty
                  ? const EmptyAddressesView()
                  : _AddressList(addresses: addresses),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AddAddressBottomButton(),
    );
  }
}

class _AddressList extends StatelessWidget {
  final List<UserAddress> addresses;
  const _AddressList({required this.addresses});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: addresses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => AddressCard(address: addresses[index]),
    );
  }
}
