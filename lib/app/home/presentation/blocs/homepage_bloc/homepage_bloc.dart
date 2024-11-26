import 'dart:convert';

import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:niza_coursework/app/home/data/models/sensor_data_model.dart';
import 'package:niza_coursework/core/common/extensions/numeric_data_extension.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/constants/constants.dart';

part 'homepage_events.dart';
part 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvents, HomepageState> {
  late MqttServerClient mqttClient;

  HomepageBloc() : super(const HomepageState()) {
    on<HomepageConfigureMqttClientEvent>(_configureMqttEventHandler);
    on<HomepageUpdateSensorDataEvent>(_updateSensorDataEventHandler);
    on<HomepageUpdateSelectedTab>(_updateSelectedTab);

    on<HomepageUpdateTemperatureUnit>(_updateTemperatureUnit);
  }

  _configureMqttEventHandler(HomepageConfigureMqttClientEvent event,
      Emitter<HomepageState> emit) async {
    String id = const Uuid().v4();
    mqttClient = MqttServerClient('mqtt.eclipseprojects.io', id);
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
      });
    }
  }

  _updateSensorDataEventHandler(
      HomepageUpdateSensorDataEvent event, Emitter<HomepageState> emit) async {
    SensorDataModel data = event.data;
    List<NumericData> temperatureData = List.from(state.temperatureData);
    List<NumericData> humidityData = List.from(state.humidityData);

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
      temperatureData: modifiedTemperatureData
        ..add(NumericData(
            domain: modifiedTemperatureData.length,
            measure: data.temperature,
            other: data.time)),
      humidityData: modifiedHumidityData
        ..add(NumericData(
            domain: modifiedHumidityData.length,
            measure: data.humidity,
            other: data.time)),
      energyData: List.from(state.energyData)
        ..add(NumericData(
          domain: state.energyData.length,
          measure: data.energyConsumed,
          other: data.time,
        )),
    ));
  }

  _updateTemperatureUnit(
      HomepageUpdateTemperatureUnit event, Emitter<HomepageState> emit) {
    emit(state.copyWith(useCelsius: event.useCelsius));
  }

  _updateSelectedTab(
      HomepageUpdateSelectedTab event, Emitter<HomepageState> emit) {
    emit(state.copyWith(selectedTab: event.index));
  }
}
