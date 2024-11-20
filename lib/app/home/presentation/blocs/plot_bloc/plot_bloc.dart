import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:niza_coursework/app/home/domain/usecases/fetch_data_usecase.dart';
import 'package:niza_coursework/core/common/form_submission/form_submission.dart';

import '../../../../../core/common/widgets/custom_loader.dart';

part 'plot_events.dart';
part 'plot_state.dart';

class PlotBloc extends Bloc<PlotEvents, PlotState> {
  late final TextEditingController _startDateController =
      TextEditingController();
  late final TextEditingController _endDateController = TextEditingController();
  TextEditingController get startDateController => _startDateController;
  TextEditingController get endDateController => _endDateController;
  final FetchDataUsecase _fetchDataUsecase;

  PlotBloc(this._fetchDataUsecase) : super(const PlotState()) {
    on<PlotUpdateStartDateEvent>(_updateStartDate);
    on<PlotUpdateEndDateEvent>(_updateEndDate);
    on<PlotFetchDataEvent>(_fetchDataEvent);
  }

  _updateStartDate(PlotUpdateStartDateEvent event, Emitter<PlotState> emit) {
    _startDateController.text =
        DateFormat("dd/MM/yyyy hh:mm a").format(event.startDate);
    emit(state.copyWith(startDate: event.startDate));
  }

  _updateEndDate(PlotUpdateEndDateEvent event, Emitter<PlotState> emit) {
    _endDateController.text =
        DateFormat("dd/MM/yyyy hh:mm a").format(event.endDate);
    emit(state.copyWith(endDate: event.endDate));
  }

  _fetchDataEvent(PlotFetchDataEvent event, Emitter<PlotState> emit) async {
    if (state.startDate == null || state.endDate == null) return;
    emit(state.copyWith(status: SubmittingForm()));
    CustomLoader.showLoader();
    final dataState = await _fetchDataUsecase.execute(params: {
      'start_date': state.startDate!.millisecondsSinceEpoch ~/ 1000,
      'end_date': state.endDate!.millisecondsSinceEpoch ~/ 1000,
    });
    CustomLoader.dismissLoader();
    if (dataState.isRight) {
      String timeFormat = 'hh:mm';
      if (dataState.right.length >= 2) {
        final minTime =
            dataState.right.first.time.millisecondsSinceEpoch ~/ 1000;
        final maxTime =
            dataState.right.last.time.millisecondsSinceEpoch ~/ 1000;
        final timeDifference = maxTime - minTime;

        if (timeDifference < 86400) {
          timeFormat = 'hh:mm';
        } else {
          timeFormat = 'dd-MM';
        }
      }
      List<NumericData> temp = [];
      List<NumericData> hum = [];
      for (int i = 0; i < dataState.right.length; i++) {
        String other = DateFormat(timeFormat).format(dataState.right[i].time);
        temp.add(NumericData(
            domain: i, measure: dataState.right[i].temperature, other: other));
        hum.add(NumericData(
            domain: i, measure: dataState.right[i].humidity, other: other));
      }
      _startDateController.clear();
      _endDateController.clear();
      emit(state.copyWith(
        status: SubmissionSuccess(dataState.right),
        temperature: temp,
        humidity: hum,
      ));
    } else {
      emit(state.copyWith(status: SubmissionFailure(dataState.left)));
      emit(state.copyWith(status: const InitialFormStatus()));
    }
  }
}
