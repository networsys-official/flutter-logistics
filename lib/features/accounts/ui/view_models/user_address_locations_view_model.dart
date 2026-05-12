import 'package:logistic_by_strom/features/accounts/ui/view_models/user_address_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_address_locations_view_model.g.dart';

@riverpod
class UserAddressLocations extends _$UserAddressLocations {
  @override
  FutureOr<List<Map<String, dynamic>>> build() async {
    final repository = ref.read(userAddressRepositoryProvider);
    final result = await repository.getLocations();

    return result.fold((failure) => throw failure, (locations) => locations);
  }
}
