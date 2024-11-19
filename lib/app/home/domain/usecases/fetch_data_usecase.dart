import 'package:either_dart/either.dart';
import 'package:niza_coursework/app/home/data/models/sensor_data_model.dart';

import '../../../../core/common/network/data_failure.dart';
import '../../../../core/common/usecase/usecase.dart';
import '../../data/repositories/home_repository_impl.dart';

class FetchDataUsecase
    implements BaseUseCase<Map<String, dynamic>, List<SensorDataModel>> {
  final HomeRepository _homeRepository;
  FetchDataUsecase(this._homeRepository);
  @override
  Future<Either<DataFailure, List<SensorDataModel>>> execute(
      {required Map<String, dynamic> params}) {
    return _homeRepository.fetchData(
        endDate: params['end_date'],
        startDate: params['start_date'],
        sensorID: params['sensor_id']);
  }
}
