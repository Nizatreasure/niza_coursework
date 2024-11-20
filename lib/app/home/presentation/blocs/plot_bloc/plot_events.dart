part of 'plot_bloc.dart';

@immutable
abstract class PlotEvents {
  const PlotEvents();
}

class PlotUpdateStartDateEvent extends PlotEvents {
  final DateTime startDate;
  const PlotUpdateStartDateEvent(this.startDate);
}

class PlotUpdateEndDateEvent extends PlotEvents {
  final DateTime endDate;
  const PlotUpdateEndDateEvent(this.endDate);
}

class PlotFetchDataEvent extends PlotEvents {
  const PlotFetchDataEvent();
}
