import 'package:aviation_met_nepal/widgets/custom_error_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../constant/colors_properties.dart';
import '../model/airport_list.dart';
import '../provider/metar_data_provider.dart';
import '../utils/get_device_size.dart';
import '../widgets/custom_build_row.dart';
import '../widgets/custom_raw_card.dart';
import '../widgets/filter_bottom_sheet.dart';

class MetarsTab extends StatefulWidget {
  const MetarsTab({required this.metarData, Key? key}) : super(key: key);
  final Data? metarData;

  @override
  State<MetarsTab> createState() => _MetarsTabState();
}

class _MetarsTabState extends State<MetarsTab> {
  @override
  void initState() {
    _future = metarDataRawDecoded("");
    super.initState();
  }

  //

  metarDataRawDecoded(String filteredData, {bool shouldReload = false}) async {
    try {
      await Provider.of<MetarDataProvider>(context, listen: false)
          .fetchMetarDataRaw(
              ident: widget.metarData!.ident,
              filteredData: filteredData,
              shouldLoadRaw: shouldReload);
      await Provider.of<MetarDataProvider>(context, listen: false)
          .fetchMetarDataDecoded(
              ident: widget.metarData!.ident,
              filteredData: filteredData,
              shouldLoadDecoded: shouldReload);
      setState(() {
        isLoadingIndicator = true;
      });
    } catch (ex) {
      Provider.of<MetarDataProvider>(context, listen: false).resetMetarData();
    }
    //
  }

  bool isLoadingIndicator = false;
  var filteredValue = "";
  setValue(value) {
    setState(() {
      filteredValue = value;
    });
  }

  late Future _future;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, AsyncSnapshot snapshot) {
        if (isLoadingIndicator == false) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        }
        if (Provider.of<MetarDataProvider>(context, listen: false)
                    .metarDataRaw !=
                null &&
            Provider.of<MetarDataProvider>(context, listen: false)
                    .metarDataDecoded !=
                null) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<MetarDataProvider>(builder: (context, value, _) {
                        return Text(
                            value.metarDataRaw!.data!.date![0]
                                .toString()
                                .substring(8),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontWeight: FontWeight.normal));
                      }),
                      StatefulBuilder(builder: (context, setState) {
                        return GestureDetector(
                          onTap: () async {
                            final value =
                                await ShowFilterSheet.showFilterSheet(context);
                            setState(() {
                              if (value != null) {
                                _future = metarDataRawDecoded(
                                  value,
                                  shouldReload: true,
                                );
                              }
                            });
                            /*  if (value != null) {l
                                _future = metarDataRawDecoded(
                                  value,
                                  shouldReload: true,
                                );
                                setState(() {});
                              } */
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 8.w),
                            height: DeviceUtil.isMobile ? 36.h : 46.h,
                            width: 72.w,
                            decoration: BoxDecoration(
                                color: const Color(colorPrimary),
                                borderRadius: BorderRadius.circular(6.w)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Filter",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            color: const Color(colorWhite))),
                                Icon(Icons.arrow_drop_down,
                                    size: 25.w, color: const Color(colorWhite))
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Consumer<MetarDataProvider>(builder: (context, value, _) {
                    return CustomRawCard(
                      rawHeaderText: "Raw",
                      rawBodyText: value.metarDataRaw!.data!.raw!,
                    );
                  }),
                  SizedBox(
                    height: 10.h,
                  ),
                  Consumer<MetarDataProvider>(builder: (context, value, _) {
                    return Column(
                      children: [
                        buildRow(
                          "Metar For",
                          value.metarDataDecoded!.data!.decoded!.metarFor.first,
                          isMetarFor: true,
                          isDecoded: true,
                        ),
                        ListView.builder(
                            itemCount: value
                                .metarDataDecoded!.data!.decoded!.text.length,
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  if (value.metarDataDecoded!.data!.decoded!
                                          .text.length >
                                      index)
                                    buildRow(
                                      "Text",
                                      value.metarDataDecoded!.data!.decoded!
                                          .text[index],
                                      isText: true,
                                    ),
                                  if (value.metarDataDecoded!.data!.decoded!
                                          .temperature.length >
                                      index)
                                    buildRow(
                                        "Temp.",
                                        value.metarDataDecoded!.data!.decoded!
                                            .temperature[index]
                                            .replaceAll("&deg;C", "\u2103")
                                            .replaceAll("&deg;F", "\u2109")),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  if (value.metarDataDecoded!.data!.decoded!
                                          .dewpoint.length >
                                      index)
                                    buildRow(
                                        "Dew Point",
                                        value.metarDataDecoded!.data!.decoded!
                                            .dewpoint[index]
                                            .replaceAll("&deg;C", "\u2103")
                                            .replaceAll("&deg;F", "\u2109")),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  if (value.metarDataDecoded!.data!.decoded!
                                          .pressureAltimeter.length >
                                      index)
                                    buildRow(
                                        "Pressure(altimeter)",
                                        value.metarDataDecoded!.data!.decoded!
                                            .pressureAltimeter[index]),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  if (value.metarDataDecoded!.data!.decoded!
                                          .winds.length >
                                      index)
                                    buildRow(
                                        "Winds",
                                        value.metarDataDecoded!.data!.decoded!
                                            .winds[index]),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  if (value.metarDataDecoded!.data!.decoded!
                                          .visibility.length >
                                      index)
                                    buildRow(
                                        "Visibility",
                                        value.metarDataDecoded!.data!.decoded!
                                            .visibility[index]),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  if (value.metarDataDecoded!.data!.decoded!
                                          .ceiling.length >
                                      index)
                                    buildRow(
                                        "Ceiling",
                                        value.metarDataDecoded!.data!.decoded!
                                            .ceiling[index]),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  if (value.metarDataDecoded!.data!.decoded!
                                          .clouds.length >
                                      index)
                                    buildRow(
                                        "Clouds",
                                        value.metarDataDecoded!.data!.decoded!
                                            .clouds[index],
                                        isClouds: true),
                                ],
                              );
                            })
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        } else {
          return CustomErrorTab(
            margin:
                EdgeInsets.only(bottom: DeviceUtil.isMobile ? 430.h : 350.h),
          );
        }
      },
    );
  }
}
