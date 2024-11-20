part of 'homepage_bloc.dart';

@immutable
abstract class HomepageEvents {
  const HomepageEvents();
}

class HomepageUpdateSensorDataEvent extends HomepageEvents {
  final SensorDataModel data;
  const HomepageUpdateSensorDataEvent(this.data);
}

class HomepageConfigureMqttClientEvent extends HomepageEvents {
  const HomepageConfigureMqttClientEvent();
}

class HomepageUpdateTemperatureUnit extends HomepageEvents {
  final bool useCelsius;
  const HomepageUpdateTemperatureUnit(this.useCelsius);
}

class HomepageUpdateSelectedTab extends HomepageEvents {
  final int index;
  const HomepageUpdateSelectedTab(this.index);
}
