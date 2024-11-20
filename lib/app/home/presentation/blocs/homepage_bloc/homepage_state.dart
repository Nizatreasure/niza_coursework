part of 'homepage_bloc.dart';

@immutable
class HomepageState {
  final List<NumericData> temperatureData;
  final List<NumericData> humidityData;
  final bool useCelsius;
  final int selectedTab;

  const HomepageState({
    this.temperatureData = const [],
    this.humidityData = const [],
    this.useCelsius = true,
    this.selectedTab = 0,
  });

  HomepageState copyWith({
    List<NumericData>? temperatureData,
    List<NumericData>? humidityData,
    bool? useCelsius,
    int? selectedTab,
  }) {
    return HomepageState(
      temperatureData: temperatureData ?? this.temperatureData,
      humidityData: humidityData ?? this.humidityData,
      selectedTab: selectedTab ?? this.selectedTab,
      useCelsius: useCelsius ?? this.useCelsius,
    );
  }
}
