part of 'plot_bloc.dart';

@immutable
class PlotState {
  final DateTime? startDate;
  final DateTime? endDate;
  final FormSubmissionStatus status;
  final List<NumericData> temperature;
  final List<NumericData> humidity;

  const PlotState({
    this.startDate,
    this.endDate,
    this.status = const InitialFormStatus(),
    this.temperature = const [],
    this.humidity = const [],
  });

  PlotState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    FormSubmissionStatus? status,
    List<NumericData>? temperature,
    List<NumericData>? humidity,
  }) {
    return PlotState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
    );
  }
}
