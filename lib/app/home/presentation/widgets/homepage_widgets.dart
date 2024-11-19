part of '../pages/homepage.dart';

Widget _buildTemperatureAndHumidityReadings() {
  return BlocBuilder<HomepageBloc, HomepageState>(builder: (context, state) {
    return Row(
      children: [
        Expanded(
          child: CustomFields(
            title: StringManager.currentTemperature,
            otherTitle: StringManager.currentHumidity,
            value:
                '${state.temperatureData.isEmpty ? '--' : getTempValue(state.temperatureData[state.selectedIndex].last.measure, state.useCelsius)}${state.useCelsius ? StringManager.degreeCelsius : StringManager.degreeFahrenheit}',
          ),
        ),
        Gap(20.r),
        Expanded(
          child: CustomFields(
            title: StringManager.currentHumidity,
            otherTitle: StringManager.currentTemperature,
            value:
                '${state.temperatureData.isEmpty ? '--' : state.humidityData[state.selectedIndex].last.measure}%',
          ),
        ),
      ],
    );
  });
}

Widget _buildTempBarDisplay(ThemeData themeData) {
  return BlocBuilder<HomepageBloc, HomepageState>(builder: (context, state) {
    return CustomPaint(
      size: Size(300.r, 300.r),
      painter: CustomCirclePainter(
        text:
            '${state.temperatureData.isEmpty ? '--' : getTempValue(state.temperatureData[state.selectedIndex].last.measure, state.useCelsius)}${state.useCelsius ? StringManager.degreeCelsius : StringManager.degreeFahrenheit}',
        textStyle: themeData.textTheme.bodyMedium!
            .copyWith(fontSize: FontSizeManager.f48),
        dashColor: ColorManager.blue.withOpacity(0.45),
        thickCircleColor: ColorManager.blue.withOpacity(0.31),
      ),
    );
  });
}

Widget _buildTemperatureUnitToggle(ThemeData themeData) {
  return BlocBuilder<HomepageBloc, HomepageState>(builder: (context, state) {
    HomepageBloc bloc = context.read<HomepageBloc>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 150.r,
          child: CustomDropDown<String>(
            items: state.sensors
                .map((val) => DropdownMenuItem(
                    value: val,
                    child: Text(
                      val.toUpperCase(),
                      style: themeData.textTheme.bodyMedium,
                    )))
                .toList(),
            value: state.sensors.isEmpty
                ? null
                : state.sensors[state.selectedIndex],
            onChanged: (val) {
              if (val != null) {
                bloc.add(HomepageUpdateSelectedSensor(val));
              }
            },
            hintText: StringManager.loading,
          ),
        ),
        if (state.homePageIndex != 1)
          CustomToggleButton(
            tab1Text: StringManager.degreeCelsius,
            tab2Text: StringManager.degreeFahrenheit,
            selectedTab: state.useCelsius
                ? StringManager.degreeCelsius
                : StringManager.degreeFahrenheit,
            onTapTab1: () {
              bloc.add(const HomepageUpdateTemperatureUnit(true));
            },
            onTapTab2: () {
              bloc.add(const HomepageUpdateTemperatureUnit(false));
            },
          ),
      ],
    );
  });
}

Widget _buildLargeScreenTemperaturePlot(ThemeData themeData) {
  return Column(
    children: [
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          StringManager.last10Minutes,
          style: themeData.textTheme.bodyLarge!
              .copyWith(fontSize: FontSizeManager.f16),
        ),
      ),
      Gap(15.r),
      Expanded(
        child: _buildTemperatureChart(themeData),
      ),
      Gap(40.r),
      Expanded(
        child: _buildHumidityChart(themeData),
      ),
    ],
  );
}

Widget _buildHumidityChart(ThemeData themeData) {
  return BlocBuilder<HomepageBloc, HomepageState>(builder: (context, state) {
    return Column(
      children: [
        Text(
          '${StringManager.humidity} (%) ${state.sensors.isEmpty ? '' : state.sensors[state.selectedIndex].toUpperCase()} ',
          style: themeData.textTheme.bodyMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: LayoutBuilder(builder: (context, constriant) {
            return Column(
              children: [
                CustomChart(
                  data: state.humidityData.isNotEmpty
                      ? state.humidityData[state.selectedIndex]
                      : [],
                  yAxisMax: 100,
                  yAxisMin: 0,
                  dataID: StringManager.humidity,
                  yDesiredMaxTick: 10,
                  chartAreaHeight: constriant.maxHeight - 50.r,
                ),
              ],
            );
          }),
        ),
      ],
    );
  });
}

Widget _buildTemperatureChart(ThemeData themeData) {
  return BlocBuilder<HomepageBloc, HomepageState>(builder: (context, state) {
    return Column(
      children: [
        Text(
          '${StringManager.temperature} (${StringManager.degreeCelsius}) ${state.sensors.isEmpty ? '' : state.sensors[state.selectedIndex].toUpperCase()} ',
          style: themeData.textTheme.bodyMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: LayoutBuilder(builder: (context, constriant) {
            return Column(
              children: [
                CustomChart(
                  data: state.temperatureData.isNotEmpty
                      ? state.temperatureData[state.selectedIndex]
                      : [],
                  yAxisMax: 50,
                  yAxisMin: -15,
                  dataID: StringManager.temperature,
                  yDesiredMaxTick: 10,
                  chartAreaHeight: constriant.maxHeight - 50.r,
                ),
              ],
            );
          }),
        ),
      ],
    );
  });
}

Widget _buildSmallScreenGraph(ThemeData themeData) {
  return BlocBuilder<HomepageBloc, HomepageState>(builder: (context, state) {
    return Column(
      children: [
        Gap(30.r),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            StringManager.last10Minutes,
            style: themeData.textTheme.bodyLarge!
                .copyWith(fontSize: FontSizeManager.f16),
          ),
        ),
        Gap(20.r),
        Text(
          '${StringManager.temperature} (${StringManager.degreeCelsius}) ${state.sensors.isEmpty ? '' : state.sensors[state.selectedIndex].toUpperCase()} ',
          style: themeData.textTheme.bodyMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        Gap(20.r),
        CustomChart(
          data: state.temperatureData.isNotEmpty
              ? state.temperatureData[state.selectedIndex]
              : [],
          yAxisMax: 50,
          yAxisMin: -15,
          chartAreaWidth: MediaQuery.of(context).size.width - 70.r,
          dataID: StringManager.temperature,
          yDesiredMaxTick: 10,
          chartAreaHeight: 250.r,
        ),
        Gap(50.r),
        Text(
          '${StringManager.humidity} (%) ${state.sensors.isEmpty ? '' : state.sensors[state.selectedIndex].toUpperCase()} ',
          style: themeData.textTheme.bodyMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        Gap(20.r),
        CustomChart(
          data: state.humidityData.isNotEmpty
              ? state.humidityData[state.selectedIndex]
              : [],
          yAxisMax: 100,
          yAxisMin: 0,
          dataID: StringManager.humidity,
          chartAreaWidth: MediaQuery.of(context).size.width - 70.r,
          yDesiredMaxTick: 10,
          chartAreaHeight: 250.r,
        ),
      ],
    );
  });
}
