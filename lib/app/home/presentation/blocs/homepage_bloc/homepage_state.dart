part of 'homepage_bloc.dart';

@immutable
class HomepageState {
  final List<NumericData> temperatureData;
  final List<NumericData> humidityData;
  final List<NumericData> energyData;
  final bool useCelsius;
  final int selectedTab;

  double get totalConsumption =>
      energyData.isEmpty ? 0 : energyData.fold(0, (a, b) => a + b.measure);

  Duration get period => energyData.isEmpty
      ? Duration.zero
      : energyData.length == 1
          ? const Duration(seconds: 15)
          : (energyData.last.other as DateTime)
                  .difference((energyData.first.other as DateTime)) +
              const Duration(seconds: 15);

  double get averageConsumption =>
      energyData.isEmpty ? 0 : totalConsumption / energyData.length;

  const HomepageState({
    this.temperatureData = const [],
    this.humidityData = const [],
    this.energyData = const [],
    this.useCelsius = true,
    this.selectedTab = 0,
  });

  HomepageState copyWith({
    List<NumericData>? temperatureData,
    List<NumericData>? humidityData,
    List<NumericData>? energyData,
    bool? useCelsius,
    int? selectedTab,
  }) {
    return HomepageState(
      temperatureData: temperatureData ?? this.temperatureData,
      humidityData: humidityData ?? this.humidityData,
      energyData: energyData ?? this.energyData,
      selectedTab: selectedTab ?? this.selectedTab,
      useCelsius: useCelsius ?? this.useCelsius,
    );
  }
}
