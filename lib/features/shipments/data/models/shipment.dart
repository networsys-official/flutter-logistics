enum ShipmentStatus {
  scheduled,
  readyForDispatch,
  inTransit,
  delayed,
  delivered,
}

class Shipment {
  const Shipment({
    required this.id,
    required this.clientName,
    required this.routeLabel,
    required this.priorityLabel,
    required this.etaLabel,
    required this.status,
    required this.progress,
  });

  final String id;
  final String clientName;
  final String routeLabel;
  final String priorityLabel;
  final String etaLabel;
  final ShipmentStatus status;
  final double progress;

  bool get isDelayed => status == ShipmentStatus.delayed;
  bool get isCompleted => status == ShipmentStatus.delivered;

  String get statusLabel {
    switch (status) {
      case ShipmentStatus.scheduled:
        return 'Scheduled';
      case ShipmentStatus.readyForDispatch:
        return 'Ready';
      case ShipmentStatus.inTransit:
        return 'In Transit';
      case ShipmentStatus.delayed:
        return 'Delayed';
      case ShipmentStatus.delivered:
        return 'Delivered';
    }
  }
}
