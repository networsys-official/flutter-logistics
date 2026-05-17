import 'package:logistic_by_strom/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:logistic_by_strom/features/auth/data/models/registration_response.dart';
import 'package:logistic_by_strom/features/auth/data/models/register_request.dart';

part 'register_view_model.g.dart';

@riverpod
class RegisterViewModel extends _$RegisterViewModel {
  @override
  AsyncValue<RegistrationResponse?> build() => const AsyncValue.data(null);

  Future<RegistrationResponse?> register({
    required String name,
    required String email,
    required String phone,
    String? address,
    required String password,
    int? countryId,
    int? locationId,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.register(
      RegisterRequest(
        name: name,
        email: email,
        phone: phone,
        address: address,
        password: password,
        countryId: countryId,
        locationId: locationId,
      ),
    );

    RegistrationResponse? response;
    result.match(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (registrationResponse) {
        response = registrationResponse;
        state = AsyncValue.data(registrationResponse);
      },
    );

    return response;
  }
}
