// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'route_segment_model.dart';

class DeliveryOptionDetails {
  List<RouteSegment> routeSegments;
  DeliveryOptionDetails({
    required this.routeSegments,
  });

  DeliveryOptionDetails copyWith({
    List<RouteSegment>? routeSegments,
  }) {
    return DeliveryOptionDetails(
      routeSegments: routeSegments ?? this.routeSegments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'routeSegments': routeSegments.map((x) => x.toMap()).toList(),
    };
  }

  factory DeliveryOptionDetails.fromMap(Map<String, dynamic> map) {
    return DeliveryOptionDetails(
      routeSegments: List<RouteSegment>.from(
        (map['routeSegments'] as List<dynamic>).map<RouteSegment>(
          (x) => RouteSegment.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryOptionDetails.fromJson(String source) =>
      DeliveryOptionDetails.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DeliveryOptionDetails(routeSegments: $routeSegments)';

  @override
  bool operator ==(covariant DeliveryOptionDetails other) {
    if (identical(this, other)) return true;

    return listEquals(other.routeSegments, routeSegments);
  }

  @override
  int get hashCode => routeSegments.hashCode;
}
