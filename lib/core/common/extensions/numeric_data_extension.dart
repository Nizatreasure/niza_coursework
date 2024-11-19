import 'package:d_chart/d_chart.dart';

extension NumericDataExtension on NumericData {
  NumericData copyWith({num? domain, num? measure, dynamic other}) {
    return NumericData(
      domain: domain ?? this.domain,
      measure: measure ?? this.measure,
      other: other ?? this.other,
      color: color,
      domainLowerBound: domainLowerBound,
      domainUpperBound: domainUpperBound,
      measureLowerBound: measureLowerBound,
      measureUpperBound: measureUpperBound,
    );
  }
}
