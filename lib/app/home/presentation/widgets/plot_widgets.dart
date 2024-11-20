part of '../pages/plot.dart';

Future<DateTime?> _getDateTime(BuildContext context) async {
  DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(2024, 11, 1),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
            data: ThemeData.dark().copyWith(
              datePickerTheme: const DatePickerThemeData().copyWith(
                backgroundColor: ColorManager.darkBlue,
                surfaceTintColor: ColorManager.transparent,
              ),
            ),
            child: child!);
      });
  if (date == null || !context.mounted) return null;

  TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
      builder: (context, child) {
        return Theme(
            data: ThemeData.dark().copyWith(
              timePickerTheme: const TimePickerThemeData().copyWith(
                backgroundColor: ColorManager.darkBlue,
              ),
            ),
            child: child!);
      });
  if (time == null) return null;
  DateTime dateTime =
      DateTime(date.year, date.month, date.day, time.hour, time.minute);
  return dateTime;
}

Widget _buildLargeScreenHistoryPlot(ThemeData themeData) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return _buildHistoryPlot(themeData, constraints.maxWidth, true);
    },
  );
}

Widget _buildHistoryPlot(ThemeData themeData, double width, bool largeScreen) {
  int maxX = ((width - 70.r) / 40.r).toInt();

  return BlocBuilder<PlotBloc, PlotState>(builder: (context, state) {
    return state.startDate != null &&
            state.endDate != null &&
            state.status is SubmissionSuccess
        ? Column(
            children: [
              Gap(20.r),
              Row(
                children: [
                  Text(
                      "From: ${DateFormat('dd/MM/yyyy hh:mm a').format(state.startDate!)}",
                      style: themeData.textTheme.bodyMedium!
                          .copyWith(fontSize: FontSizeManager.f10)),
                  const Spacer(),
                  SizedBox(
                    width: largeScreen ? 210.r : 180.r,
                    child: Row(
                      children: [
                        Container(
                          height: 3.r,
                          width: 80.r,
                          color: ColorManager.blue,
                        ),
                        Gap(5.r),
                        Text(
                          StringManager.temperature,
                          style: themeData.textTheme.bodyMedium,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Gap(5.r),
              Row(
                children: [
                  Text(
                      "To: ${DateFormat('dd/MM/yyyy hh:mm a').format(state.endDate!)}",
                      style: themeData.textTheme.bodyMedium!
                          .copyWith(fontSize: FontSizeManager.f10)),
                  const Spacer(),
                  SizedBox(
                    width: largeScreen ? 210.r : 180.r,
                    child: Row(
                      children: [
                        Container(
                          height: 3.r,
                          width: 80.r,
                          color: ColorManager.mediumGrey,
                        ),
                        Gap(5.r),
                        Text(
                          StringManager.humidity,
                          style: themeData.textTheme.bodyMedium,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Gap(40.r),
              SizedBox(
                width: largeScreen ? width : width - 70.r,
                height: 400.r,
                child: DChartLineN(
                  allowSliding: true,
                  configRenderLine: const ConfigRenderLine(strokeWidthPx: 2.5),
                  layoutMargin: LayoutMargin(20, 10, 20, 10),
                  domainAxis: DomainAxis(
                    gapAxisToLabel: 15.r.toInt(),
                    tickLabelFormatterN: (domain) {
                      final inputData = state.temperature
                          .where((e) => e.domain == domain)
                          .firstOrNull;
                      return inputData?.other ?? '';
                    },
                    labelStyle: LabelStyle(
                      color: ColorManager.vibrantBlue.withOpacity(0.62),
                      fontSize: FontSizeManager.f10.toInt(),
                      lineHeight: 1,
                      fontWeight: FontWeight.normal,
                    ),
                    numericTickProvider: NumericTickProvider(
                        desiredMaxTickCount: maxX, desiredMinTickCount: 4),
                  ),
                  measureAxis: MeasureAxis(
                    numericViewport: const NumericViewport(-20, 100),
                    gapAxisToLabel: 15.r.toInt(),
                    labelStyle: LabelStyle(
                      color: ColorManager.vibrantBlue.withOpacity(0.62),
                    ),
                    numericTickProvider:
                        const NumericTickProvider(desiredMaxTickCount: 11),
                    showLine: true,
                    lineStyle: LineStyle(
                      color: ColorManager.blue.withOpacity(0.79),
                    ),
                    gridLineStyle: const LineStyle(
                      color: ColorManager.darkGreenishBlue,
                      dashPattern: [10, 10],
                    ),
                    useGridLine: true,
                  ),
                  groupList: [
                    NumericGroup(
                      id: 'temp-history',
                      data: state.temperature,
                      color: ColorManager.blue,
                    ),
                    NumericGroup(
                      id: 'humidity-history',
                      data: state.humidity,
                      color: ColorManager.mediumGrey,
                    ),
                  ],
                ),
              ),
              Gap(70.r),
            ],
          )
        : const SizedBox.shrink();
  });
}
