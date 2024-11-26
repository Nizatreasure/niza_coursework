import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:niza_coursework/app/home/presentation/blocs/homepage_bloc/homepage_bloc.dart';
import 'package:niza_coursework/core/functions/functions.dart';
import 'package:niza_coursework/core/values/color_manager.dart';
import 'package:niza_coursework/core/values/font_size_manager.dart';
import 'package:niza_coursework/core/values/string_manager.dart';

import '../widgets/side_tabs.dart';

class EnergyPage extends StatefulWidget {
  final HomepageBloc homepageBloc;
  const EnergyPage({super.key, required this.homepageBloc});

  @override
  State<EnergyPage> createState() => _EnergyPageState();
}

class _EnergyPageState extends State<EnergyPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    widget.homepageBloc.add(const HomepageUpdateSelectedTab(0));
    return false;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.scaffoldBackgroundColor,
      key: _scaffoldKey,
      drawer: AppDrawer(homepageBloc: widget.homepageBloc),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(24.r, 30.r, 24.r, 20.r),
          child: _buildBody(context, themeData),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData themeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: Container(
                padding: EdgeInsetsDirectional.only(
                    end: 20.r, top: 10.r, bottom: 10.r),
                child: const Icon(Icons.menu, color: ColorManager.white),
              ),
            ),
            Text(StringManager.energyConsumption,
                style: themeData.textTheme.bodyLarge),
          ],
        ),
        Gap(20.r),
        Expanded(
          child: _buildEnergyConsumption(themeData),
        ),
      ],
    );
  }

  Widget _buildEnergyConsumption(ThemeData themeData) {
    return BlocBuilder<HomepageBloc, HomepageState>(
        bloc: widget.homepageBloc,
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(15.r),
                Text(
                  '${StringManager.totalEnergyConsumption}: ${state.energyData.isEmpty ? 'N/A' : state.totalConsumption < 1000 ? state.totalConsumption.toStringAsFixed(2) : (state.totalConsumption / 1000).toStringAsFixed(2)}${state.totalConsumption < 1000 ? 'mA' : 'A'}',
                  style: themeData.textTheme.bodyMedium!.copyWith(),
                ),
                Gap(10.r),
                Text(
                  '${StringManager.period}: ${state.energyData.isEmpty ? 'N/A' : formatDuration(state.period)}',
                  style: themeData.textTheme.bodyMedium!.copyWith(),
                ),
                Gap(10.r),
                Text(
                  '${StringManager.averageConsumption}: ${state.energyData.isEmpty ? 'N/A' : state.averageConsumption < 1000 ? state.averageConsumption.toStringAsFixed(2) : (state.averageConsumption / 1000).toStringAsFixed(2)}${state.averageConsumption < 1000 ? 'mA' : 'A'}',
                  style: themeData.textTheme.bodyMedium!.copyWith(),
                ),
                Gap(30.r),
                _buildEnergyPlot(themeData, MediaQuery.of(context).size.width),
              ],
            ),
          );
        });
  }

  Widget _buildEnergyPlot(ThemeData themeData, double width) {
    int maxX = ((width - 70.r) / 40.r).toInt();
    return BlocBuilder<HomepageBloc, HomepageState>(
      bloc: widget.homepageBloc,
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              width: width - 70.r,
              height: 400.r,
              child: DChartLineN(
                allowSliding: true,
                configRenderLine: const ConfigRenderLine(strokeWidthPx: 2.5),
                layoutMargin: LayoutMargin(25, 10, 0, 10),
                domainAxis: DomainAxis(
                  gapAxisToLabel: 15.r.toInt(),
                  lineStyle: LineStyle(
                    color: ColorManager.blue.withOpacity(0.79),
                  ),
                  tickLabelFormatterN: (domain) {
                    final inputData = state.energyData
                        .where((e) => e.domain == domain)
                        .firstOrNull;
                    if (inputData?.other is DateTime) {
                      return DateFormat('hh:mm').format(inputData!.other);
                    }
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
                  // numericViewport: const NumericViewport(-20, 100),
                  tickLabelFormatter: (measure) => '${measure?.toInt()}mA',
                  gapAxisToLabel: 10.r.toInt(),
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
                    id: 'energy-history',
                    data: state.energyData,
                    color: const Color.fromARGB(255, 70, 80, 107),
                  ),
                ],
              ),
            ),
            Gap(70.r),
          ],
        );
      },
    );
  }
}
