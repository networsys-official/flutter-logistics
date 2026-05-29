import 'package:logistic_by_strom/features/shipments/data/models/user_shipment_model.dart';
import 'package:logistic_by_strom/features/shipments/data/repositories/shipment_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';

part 'orders_view_model.g.dart';

class OrdersState {
  final List<UserShipmentModel> orders;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  const OrdersState({
    required this.orders,
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  OrdersState copyWith({
    List<UserShipmentModel>? orders,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

@riverpod
class OrdersViewModel extends _$OrdersViewModel {
  @override
  Future<OrdersState> build({String? status}) async {
    final repository = ref.read(shipmentRepositoryProvider);
    final result = await repository.getMyOrdersPaginated(page: 1, status: status);

    return switch (result) {
      Left(value: final failure) => throw failure.message,
      Right(value: (final orders, final hasMore)) => OrdersState(
          orders: orders,
          page: 1,
          hasMore: hasMore,
        ),
    };
  }

  Future<void> fetchNextPage() async {
    final currentState = state.value;
    if (currentState == null || !currentState.hasMore || currentState.isLoadingMore) {
      return;
    }

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.page + 1;
    final repository = ref.read(shipmentRepositoryProvider);
    final result = await repository.getMyOrdersPaginated(page: nextPage, status: status);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (data) {
        final (orders, hasMore) = data;
        return AsyncValue.data(
          currentState.copyWith(
            orders: [...currentState.orders, ...orders],
            page: nextPage,
            hasMore: hasMore,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }
}
