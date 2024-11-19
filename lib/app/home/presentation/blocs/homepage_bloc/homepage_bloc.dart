import 'dart:convert';

import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:niza_coursework/app/home/data/models/sensor_data_model.dart';
import 'package:niza_coursework/core/common/extensions/numeric_data_extension.dart';
import 'package:niza_coursework/main.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/common/enums/enums.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/values/color_manager.dart';
import '../../../../../core/values/string_manager.dart';

part 'homepage_events.dart';
part 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvents, HomepageState> {
  late MqttServerClient mqttClient;
  late final PageController _pageController = PageController();
  PageController get pageController => _pageController;
  late final PageController _pageController2 = PageController();
  PageController get pageController2 => _pageController2;

  late final TextEditingController _reportingIntervalController =
      TextEditingController();
  TextEditingController get reportingIntervalController =>
      _reportingIntervalController;

  late final TextEditingController _samplingIntervalController =
      TextEditingController();
  TextEditingController get samplingIntervalController =>
      _samplingIntervalController;

  late final TextEditingController _minThresholdController =
      TextEditingController();
  TextEditingController get minThresholdController => _minThresholdController;

  late final TextEditingController _maxThresholdController =
      TextEditingController();
  TextEditingController get maxThresholdController => _maxThresholdController;

  HomepageBloc()
      : super(HomepageState(
            intervalLabel: AppConstants.durationType.first,
            samplingIntervalLabel: AppConstants.durationType.first)) {
    on<HomepageConfigureMqttClientEvent>(_configureMqttEventHandler);
    on<HomepageUpdateSensorDataEvent>(_updateSensorDataEventHandler);
    on<HomepageUpdateSelectedSensor>(_updateSelectedIndex);
    on<HomepageUpdateTemperatureUnit>(_updateTemperatureUnit);
    on<HomepageUpdateHomepageIndex>(_updatePageIndex);
    on<HomepageUpdateIntervalLabel>(_updateIntervalLabel);
    on<HomepageUpdateReportingInterval>(_updateInterval);
    on<HomepageUpdateReportingIntervalInArduino>(_updateIntervalInArduino);
    on<HomepageUpdateTabIndex>(_updateTabIndex);
    on<HomepageUpdateMaxThreshold>(_updateMaxThreshold);
    on<HomepageUpdateMinThreshold>(_updateMinThreshold);
    on<HomepageUpdateSamplingInterval>(_updateSamplingInterval);
    on<HomepageUpdateSamplingIntervalLabel>(_updateSamplingIntervalLabel);
    on<HomepageUpdateTemperatureExceeded>(_updateTempExceededMessage);
  }

  _configureMqttEventHandler(HomepageConfigureMqttClientEvent event,
      Emitter<HomepageState> emit) async {
    String id = const Uuid().v4();
    mqttClient = MqttServerClient('test.mosquitto.org', id);
    mqttClient.keepAlivePeriod = 120;
    mqttClient.autoReconnect = true;
    final connMess =
        MqttConnectMessage().startClean().withWillQos(MqttQos.atLeastOnce);
    mqttClient.connectionMessage = connMess;
    try {
      await mqttClient.connect();
    } on Exception catch (_) {}

    if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint('EXAMPLE:: client connected');
      mqttClient.subscribe(AppConstants.statusTopic, MqttQos.atMostOnce);
      mqttClient.subscribe(
          AppConstants.topicThresholdExceeded, MqttQos.atMostOnce);

      mqttClient.updates!.listen((messageList) {
        final recMess = messageList[0];
        if (recMess.payload is! MqttPublishMessage) return;
        final pubMess = recMess.payload as MqttPublishMessage;
        final data =
            MqttPublishPayload.bytesToStringAsString(pubMess.payload.message);

        if (recMess.topic == AppConstants.statusTopic) {
          add(HomepageUpdateSensorDataEvent(
              SensorDataModel.fromJson(jsonDecode(data))));
        }
        if (recMess.topic == AppConstants.topicThresholdExceeded) {
          Map<String, dynamic> decodedData = jsonDecode(data);
          add(HomepageUpdateTemperatureExceeded(
              "${decodedData["message"]} for ${decodedData["sensor_name"]}. Current temperature is ${decodedData["temperature"]} °C"));
        }
      });
    }
  }

  _updateSensorDataEventHandler(
      HomepageUpdateSensorDataEvent event, Emitter<HomepageState> emit) async {
    SensorDataModel data = event.data;
    int sensorIndex = state.sensors.indexOf(data.sensorID);
    if (sensorIndex < 0) {
      sensorIndex = state.sensors.length;
      emit(state.copyWith(
        sensors: List.from(state.sensors)..add(data.sensorID),
        humidityData: List.from(state.humidityData)..add([]),
        sensorReadings: List.from(state.sensorReadings)..add([]),
        temperatureData: List.from(state.temperatureData)..add([]),
      ));
    }
    List<NumericData> temperatureData =
        List.from(state.temperatureData[sensorIndex]);
    List<NumericData> humidityData = List.from(state.humidityData[sensorIndex]);
    List<SensorDataModel> sensorData =
        List.from(state.sensorReadings[sensorIndex]);
    humidityData.removeWhere((element) =>
        DateTime.now().difference(element.other as DateTime).inMinutes >
        AppConstants.graphTimeInMinutes);
    temperatureData.removeWhere((element) =>
        DateTime.now().difference(element.other as DateTime).inMinutes >
        AppConstants.graphTimeInMinutes);

    List<NumericData> modifiedHumidityData = [];
    List<NumericData> modifiedTemperatureData = [];
    for (int i = 0; i < humidityData.length; i++) {
      modifiedHumidityData.add(humidityData[i].copyWith(domain: i));
    }
    for (int i = 0; i < temperatureData.length; i++) {
      modifiedTemperatureData.add(temperatureData[i].copyWith(domain: i));
    }

    emit(state.copyWith(
      sensorReadings: List.from(state.sensorReadings)
        ..[sensorIndex] = (sensorData..add(data)),
      temperatureData: List.from(state.temperatureData)
        ..[sensorIndex] = (modifiedTemperatureData
          ..add(NumericData(
              domain: modifiedTemperatureData.length,
              measure: data.temperature,
              other: data.time))),
      humidityData: List.from(state.humidityData)
        ..[sensorIndex] = (modifiedHumidityData
          ..add(NumericData(
              domain: modifiedHumidityData.length,
              measure: data.humidity,
              other: data.time))),
    ));
  }

  _updateSelectedIndex(
      HomepageUpdateSelectedSensor event, Emitter<HomepageState> emit) async {
    int index = state.sensors.indexWhere(
        (element) => element.toLowerCase() == event.sensor.toLowerCase());
    if (index < 0) index = 0;
    emit(state.copyWith(selectedIndex: index));
  }

  _updateTemperatureUnit(
      HomepageUpdateTemperatureUnit event, Emitter<HomepageState> emit) {
    emit(state.copyWith(useCelsius: event.useCelsius));
  }

  _updatePageIndex(
      HomepageUpdateHomepageIndex event, Emitter<HomepageState> emit) {
    emit(state.copyWith(homePageIndex: event.index));
  }

  _updateTabIndex(HomepageUpdateTabIndex event, Emitter<HomepageState> emit) {
    emit(state.copyWith(tabIndex: event.index));
  }

  _updateIntervalLabel(
      HomepageUpdateIntervalLabel event, Emitter<HomepageState> emit) {
    emit(state.copyWith(intervalLabel: event.label));
  }

  _updateSamplingIntervalLabel(
      HomepageUpdateSamplingIntervalLabel event, Emitter<HomepageState> emit) {
    emit(state.copyWith(samplingIntervalLabel: event.label));
  }

  _updateIntervalInArduino(HomepageUpdateReportingIntervalInArduino event,
      Emitter<HomepageState> emit) async {
    BuildContext context = NizaCoursework.navigatorKey.currentContext!;
    String sensor = state.sensors[state.selectedIndex];
    final builder = MqttClientPayloadBuilder();
    String topic = AppConstants.topicPrefix;
    String data = "";
    switch (event.type) {
      case UpdateType.reporting:
        topic += "$sensor/interval/reporting";
        data = jsonEncode({
          "interval": state.reportingInterval *
              (state.intervalLabel.toLowerCase() == 'secs' ? 1 : 60)
        });
        break;
      case UpdateType.sampling:
        topic += "$sensor/interval/sampling";
        data = jsonEncode({
          "interval": state.samplingInterval *
              (state.samplingIntervalLabel.toLowerCase() == 'secs' ? 1 : 60)
        });
        break;
      case UpdateType.max:
        topic += "$sensor/threshold/max";
        data = jsonEncode({"threshold": state.maxThreshold});
        break;
      case UpdateType.min:
        topic += "$sensor/threshold/min";
        data = jsonEncode({"threshold": state.minThreshold});
        break;
    }
    builder.addString(data);
    mqttClient.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    switch (event.type) {
      case UpdateType.reporting:
        _reportingIntervalController.clear();
        emit(state.copyWith(reportingInterval: 0));
        break;
      case UpdateType.sampling:
        _samplingIntervalController.clear();
        emit(state.copyWith(samplingInterval: 0));
        break;
      case UpdateType.max:
        _maxThresholdController.clear();
        emit(state.copyWith(maxThreshold: 0));
        break;
      case UpdateType.min:
        minThresholdController.clear();
        emit(state.copyWith(minThreshold: 0));
        break;
    }
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text('${sensor.toUpperCase()} ${StringManager.dataPublished}',
            style: Theme.of(context).textTheme.bodyMedium),
        backgroundColor: ColorManager.blue.withOpacity(0.1),
        overflowAlignment: OverflowBarAlignment.end,
        actions: [SizedBox(height: 20.r)],
      ),
    );
    await Future.delayed(const Duration(seconds: 5));
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    }
  }

  _updateInterval(
      HomepageUpdateReportingInterval event, Emitter<HomepageState> emit) {
    emit(state.copyWith(reportingInterval: event.interval));
  }

  _updateSamplingInterval(
      HomepageUpdateSamplingInterval event, Emitter<HomepageState> emit) {
    emit(state.copyWith(samplingInterval: event.interval));
  }

  _updateMinThreshold(
      HomepageUpdateMinThreshold event, Emitter<HomepageState> emit) {
    emit(state.copyWith(minThreshold: event.threshold));
  }

  _updateMaxThreshold(
      HomepageUpdateMaxThreshold event, Emitter<HomepageState> emit) {
    emit(state.copyWith(maxThreshold: event.threshold));
  }

  _updateTempExceededMessage(
      HomepageUpdateTemperatureExceeded event, Emitter<HomepageState> emit) {
    emit(state.copyWith(tempExceededMessage: event.message));
    emit(state.copyWith(tempExceededMessage: ""));
  }
}
