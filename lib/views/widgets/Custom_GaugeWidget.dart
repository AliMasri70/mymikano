import 'package:flutter/material.dart';
import 'package:mymikano_app/utils/AppColors.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Custom_GaugeWidget extends StatefulWidget {
  final String title;
  final double value;
  final Color needleColor;
  final double min;
  final double max;

  const Custom_GaugeWidget(
      {Key? key,
      required this.title,
      required this.value,
      this.needleColor = mainBlackColorTheme,
      required this.min,
      required this.max})
      : super(key: key);

  @override
  Custom_GaugeWidgetState createState() => Custom_GaugeWidgetState();
}

class Custom_GaugeWidgetState extends State<Custom_GaugeWidget> {
  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      axes: [
        RadialAxis(
          
          minimum: widget.min,
          maximum: widget.max,
          // minorTicksPerInterval: 5,
          startAngle: 149,
          endAngle: 30,
          pointers: [
            NeedlePointer(

              value: widget.value,
              enableAnimation: true,
              needleLength: 0.6,
              needleColor: widget.needleColor,
              needleStartWidth: 1,
              needleEndWidth: 5,
              knobStyle: KnobStyle(
                knobRadius: 0.0,
                sizeUnit: GaugeSizeUnit.factor,
                color: mainGreyColorTheme,
              ),
            ),
          ],
          ranges: [
            GaugeRange(
              startValue: 0,
              endValue: widget.value,
              color: widget.needleColor,
              startWidth: 3,
              endWidth: 3,
            ),
          ],
          annotations: [
            GaugeAnnotation(
              angle: 90,
              positionFactor: 0.7,
              widget: Text("${widget.title} | ${widget.value}",
                  style: TextStyle(
                    color: mainBlackColorTheme,
                    fontSize: 11,
                    fontFamily: PoppinsFamily,
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
