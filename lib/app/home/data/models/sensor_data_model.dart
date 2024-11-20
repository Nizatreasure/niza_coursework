class SensorDataModel {
  final double temperature;
  final double temperatureInFahrenheit;
  final double humidity;
  final DateTime time;

  const SensorDataModel({
    required this.temperature,
    required this.temperatureInFahrenheit,
    required this.humidity,
    required this.time,
  });

  factory SensorDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    double temp =
        double.parse((json['temp'] ?? json['temperature'] ?? 0).toString());
    double tempInFahrenheit = temp == 0 ? 0 : (temp * 9 / 5) + 32;
    return SensorDataModel(
      temperature: temp,
      temperatureInFahrenheit: tempInFahrenheit,
      humidity: double.parse((json['humidity'] ?? 0).toString()),
      time: DateTime.fromMillisecondsSinceEpoch(
          (json['time'] ?? json['timestamp'] ?? 0) * 1000 ??
              DateTime.now().millisecondsSinceEpoch),
    );
  }
}
