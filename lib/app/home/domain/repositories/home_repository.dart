part of '../../data/repositories/home_repository_impl.dart';

abstract class HomeRepository {
  Future<Either<DataFailure, List<SensorDataModel>>> fetchData(
      {required int startDate, required int endDate, required String sensorID});
}
