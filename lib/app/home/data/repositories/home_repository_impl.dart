import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../core/common/enums/enums.dart';
import '../../../../core/common/network/connection_checker.dart';
import '../../../../core/common/network/data_failure.dart';
import '../models/sensor_data_model.dart';

part '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ConnectionChecker _connectionChecker;
  static final _dRef = FirebaseDatabase.instance;
  HomeRepositoryImpl(this._connectionChecker);

  @override
  Future<Either<DataFailure, List<SensorDataModel>>> fetchData(
      {required int startDate,
      required int endDate,
      required String sensorID}) async {
    if (await _connectionChecker.isConnected) {
      try {
        final data = await _dRef
            .ref(sensorID)
            .orderByKey()
            .startAt(startDate.toString())
            .endAt(endDate.toString())
            .get();
        List<SensorDataModel> sensorData = <SensorDataModel>[];
        for (DataSnapshot snap in data.children) {
          sensorData.add(SensorDataModel.fromJson(
              (snap.value as Map).map((k, v) => MapEntry(k.toString(), v)),
              sensorid: sensorID));
        }
        return Right(sensorData);
      } catch (e) {
        return Left(ErrorHandler.handleError(e).failure);
      }
    } else {
      return Left(DataStatus.connectionError.getFailure()!);
    }
  }
}
