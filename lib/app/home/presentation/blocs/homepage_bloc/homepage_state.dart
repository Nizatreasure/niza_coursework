part of 'homepage_bloc.dart';

@immutable
class HomepageState {
  final List<String> sensors;
  final List<List<SensorDataModel>> sensorReadings;
  final List<List<NumericData>> temperatureData;
  final List<List<NumericData>> humidityData;
  final bool useCelsius;

  final int homePageIndex;
  final int tabIndex;

  final int selectedIndex;

  final String intervalLabel;
  final String samplingIntervalLabel;
  final int reportingInterval;
  final int samplingInterval;
  final double minThreshold;
  final double maxThreshold;

  final String tempExceededMessage;

  const HomepageState({
    this.sensors = const [],
    this.sensorReadings = const [],
    this.temperatureData = const [],
    this.humidityData = const [],
    this.selectedIndex = 0,
    this.useCelsius = true,
    this.homePageIndex = 0,
    this.intervalLabel = '',
    this.samplingIntervalLabel = '',
    this.reportingInterval = 0,
    this.tabIndex = 0,
    this.maxThreshold = 0,
    this.minThreshold = 0,
    this.samplingInterval = 0,
    this.tempExceededMessage = "",
  });

  HomepageState copyWith({
    List<List<SensorDataModel>>? sensorReadings,
    List<String>? sensors,
    List<List<NumericData>>? temperatureData,
    List<List<NumericData>>? humidityData,
    int? selectedIndex,
    bool? useCelsius,
    int? homePageIndex,
    String? intervalLabel,
    String? samplingIntervalLabel,
    int? reportingInterval,
    int? tabIndex,
    int? samplingInterval,
    double? minThreshold,
    double? maxThreshold,
    String? tempExceededMessage,
  }) {
    return HomepageState(
      sensors: sensors ?? this.sensors,
      sensorReadings: sensorReadings ?? this.sensorReadings,
      temperatureData: temperatureData ?? this.temperatureData,
      humidityData: humidityData ?? this.humidityData,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      useCelsius: useCelsius ?? this.useCelsius,
      homePageIndex: homePageIndex ?? this.homePageIndex,
      intervalLabel: intervalLabel ?? this.intervalLabel,
      reportingInterval: reportingInterval ?? this.reportingInterval,
      tabIndex: tabIndex ?? this.tabIndex,
      maxThreshold: maxThreshold ?? this.maxThreshold,
      minThreshold: minThreshold ?? this.minThreshold,
      samplingInterval: samplingInterval ?? this.samplingInterval,
      samplingIntervalLabel:
          samplingIntervalLabel ?? this.samplingIntervalLabel,
      tempExceededMessage: tempExceededMessage ?? this.tempExceededMessage,
    );
  }
}
