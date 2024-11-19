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

class HomepageUpdateSelectedSensor extends HomepageEvents {
  final String sensor;
  const HomepageUpdateSelectedSensor(this.sensor);
}

class HomepageUpdateTemperatureUnit extends HomepageEvents {
  final bool useCelsius;
  const HomepageUpdateTemperatureUnit(this.useCelsius);
}

class HomepageUpdateHomepageIndex extends HomepageEvents {
  final int index;
  const HomepageUpdateHomepageIndex(this.index);
}

class HomepageUpdateTabIndex extends HomepageEvents {
  final int index;
  const HomepageUpdateTabIndex(this.index);
}

class HomepageUpdateIntervalLabel extends HomepageEvents {
  final String label;
  const HomepageUpdateIntervalLabel(this.label);
}

class HomepageUpdateSamplingIntervalLabel extends HomepageEvents {
  final String label;
  const HomepageUpdateSamplingIntervalLabel(this.label);
}

class HomepageUpdateReportingInterval extends HomepageEvents {
  final int interval;
  const HomepageUpdateReportingInterval(this.interval);
}

class HomepageUpdateSamplingInterval extends HomepageEvents {
  final int interval;
  const HomepageUpdateSamplingInterval(this.interval);
}

class HomepageUpdateMinThreshold extends HomepageEvents {
  final double threshold;
  const HomepageUpdateMinThreshold(this.threshold);
}

class HomepageUpdateMaxThreshold extends HomepageEvents {
  final double threshold;
  const HomepageUpdateMaxThreshold(this.threshold);
}

class HomepageUpdateReportingIntervalInArduino extends HomepageEvents {
  final UpdateType type;
  const HomepageUpdateReportingIntervalInArduino(this.type);
}

class HomepageUpdateTemperatureExceeded extends HomepageEvents {
  final String message;
  const HomepageUpdateTemperatureExceeded(this.message);
}
