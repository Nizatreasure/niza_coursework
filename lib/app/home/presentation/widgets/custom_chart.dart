import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/values/color_manager.dart';
import '../../../../core/values/font_size_manager.dart';

class CustomChart extends StatelessWidget {
  final List<NumericData> data;
  final num yAxisMin;
  final num yAxisMax;
  final String dataID;
  final Color? dataColor;
  final double? chartAreaHeight;
  final int? yDesiredMaxTick;
  final double? chartAreaWidth;
  const CustomChart({
    super.key,
    required this.data,
    required this.yAxisMax,
    required this.yAxisMin,
    required this.dataID,
    this.dataColor,
    this.yDesiredMaxTick,
    this.chartAreaHeight,
    this.chartAreaWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: chartAreaHeight ?? 300.r,
      width: chartAreaWidth,
      child: LayoutBuilder(builder: (context, constraint) {
        int fontsize = FontSizeManager.f10.toInt();
        double width = constraint.maxWidth - 70.r;
        int maxX = (width / 40.r).toInt();
        return DChartLineN(
          allowSliding: true,
          configRenderLine: const ConfigRenderLine(strokeWidthPx: 2.5),
          layoutMargin: LayoutMargin(20, 10, 20, 10),
          domainAxis: DomainAxis(
            gapAxisToLabel: 15.r.toInt(),
            tickLabelFormatterN: (domain) {
              final inputData =
                  data.where((e) => e.domain == domain).firstOrNull;
              if (inputData?.other is DateTime) {
                return DateFormat('hh:mm').format(inputData!.other);
              }
              return inputData?.other ?? '';
            },
            labelStyle: LabelStyle(
              color: ColorManager.vibrantBlue.withOpacity(0.62),
              fontSize: fontsize,
              lineHeight: 1,
              fontWeight: FontWeight.normal,
            ),
            numericTickProvider: NumericTickProvider(
                desiredMaxTickCount: maxX, desiredMinTickCount: 4),
          ),
          measureAxis: MeasureAxis(
            numericViewport: NumericViewport(yAxisMin, yAxisMax),
            gapAxisToLabel: 15.r.toInt(),
            labelStyle: LabelStyle(
              color: ColorManager.vibrantBlue.withOpacity(0.62),
            ),
            numericTickProvider:
                NumericTickProvider(desiredMaxTickCount: yDesiredMaxTick),
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
              id: dataID,
              data: data,
              color: dataColor ?? ColorManager.blue,
            ),
          ],
        );
      }),
    );
  }
}
