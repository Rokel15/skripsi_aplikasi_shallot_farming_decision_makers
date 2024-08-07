import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_aplikasi_shallot_farming_decision_makers/models/location_model.dart';
import 'package:skripsi_aplikasi_shallot_farming_decision_makers/providers/dashboard_provider.dart';
import 'package:skripsi_aplikasi_shallot_farming_decision_makers/widgets/dashboard_screen/land_analytics.dart';
import 'package:skripsi_aplikasi_shallot_farming_decision_makers/widgets/dashboard_screen/preview_map.dart';
import 'package:skripsi_aplikasi_shallot_farming_decision_makers/widgets/dashboard_screen/user_info.dart';
import 'package:skripsi_aplikasi_shallot_farming_decision_makers/widgets/dashboard_screen/weather_widget.dart';
import '../providers/global_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void initState() {
    // Provider.of<DashboardProvider>(context, listen: false).fetchWeatherData();
    Provider.of<DashboardProvider>(context, listen: false).getWeatherData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        double? latitude = dashboardProvider.targetLat;
        double? longitude = dashboardProvider.targetLon;
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop){
            dashboardProvider.logout(context);
          },
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: AppBar(
                backgroundColor: Provider.of<GlobalProvider>(context, listen: false).mainColor,
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                color: Provider.of<GlobalProvider>(context, listen: false).mainColor,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      color: Colors.black
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 28,),

                      UserInfo(
                        profileIcon: dashboardProvider.profileIcon,
                        containerColor: Provider.of<GlobalProvider>(context, listen: false).mainColor,
                        email: dashboardProvider.email,
                        uid: dashboardProvider.uid,
                        emailTextStyle: Provider.of<GlobalProvider>(context, listen: false).roboto16Bold,
                        uidTextStyle: Provider.of<GlobalProvider>(context, listen: false).roboto14Italic,
                        lat: dashboardProvider.latitude.toString(),
                        lon: dashboardProvider.longitude.toString(),
                        latLonTextStyle: Provider.of<GlobalProvider>(context, listen: false).roboto14SemiBold,
                        seeMap: () => dashboardProvider.seeMap(context),
                      ),

                      StreamBuilder<LocationModel>(
                        stream: dashboardProvider.locationService.locationStream,
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            LocationModel locationData = snapshot.data!;
                            dashboardProvider.setLocation(
                              latitude: locationData.latitude,
                              longitude: locationData.longitude,
                            );
                            return Container();
                          } else{
                            return Container();
                          }
                        },
                      ),

                      const SizedBox(height: 24,),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(44),
                            topRight: Radius.circular(44),
                          ),
                          border: Border(
                            top: BorderSide(
                              color: Provider.of<GlobalProvider>(context, listen: false).mainColor,
                              width: 4,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 24,),

                            const WeatherWidget(),

                            const SizedBox(height: 23,),

                            PreviewMap(
                              mapType: MapType.hybrid,
                              zoom: 18,
                              seeFullMap: () => dashboardProvider.seeMap(context),
                            ),

                            const SizedBox(height: 28,),

                            LandAnalytics(
                              landAnalyticHead: dashboardProvider.landAnalyticHead,
                              submitButtonText: dashboardProvider.submitButtonText,
                              soilTypeLabel: dashboardProvider.soilTypeLabel,
                              moistureLevelLabel: dashboardProvider.moistureLevelLabel,
                              pHLevelLabel: dashboardProvider.pHLevelLabel,
                              soilType: dashboardProvider.selectSoilType,
                              moistureLevel: dashboardProvider.selectMoistureLevel,
                              pHLevel: dashboardProvider.selectPHLevel,
                              soilTypeItems: dashboardProvider.soilTypeItems.map((String val){
                               return DropdownMenuItem(
                                 value: val,
                                 child: Row(
                                   children: [
                                     Text(
                                       val,
                                       style: Provider.of<GlobalProvider>(context, listen: false).roboto16SemiBold,
                                     ),
                                     const Icon(Icons.arrow_drop_down),
                                   ],
                                 ),
                               );
                              }).toList(),
                              moistureLevelItems: dashboardProvider.moistureLevelItems.map((String val){
                                return DropdownMenuItem(
                                  value: val,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        val,
                                        style: Provider.of<GlobalProvider>(context, listen: false).roboto16SemiBold,
                                      ),
                                      const Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                );
                              }).toList(),
                              pHLevelItems: dashboardProvider.pHLevelItems.map((String val){
                                return DropdownMenuItem(
                                  value: val,
                                  child: Row(
                                    children: [
                                      Text(
                                        val,
                                        style: Provider.of<GlobalProvider>(context, listen: false).roboto16SemiBold,
                                      ),
                                      const Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChangedSoilType: (String? val) => dashboardProvider.onChangedSoilType(val!),
                              onChangedMoistureLevel: (String? val) => dashboardProvider.onChangedMoistureLevel(val!),
                              onChangedPHLevel: (String? val) => dashboardProvider.onChangedPHLevel(val!),
                              additionalCommentsLabel: dashboardProvider.textFieldLabel,
                              additionalCommentsController: dashboardProvider.additionalCommentsController,
                              additionalCommentsHintText: dashboardProvider.additionalCommentsHintText,
                              analyticResult: dashboardProvider.analyticResult,
                              getResult: (){dashboardProvider.getResultFromGemini();},
                              restartAnalytic: () => dashboardProvider.restartAnalytic(),
                            ),

                            Container(height: 100,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),),
            ),
            backgroundColor: Colors.black,
          ),
        );
      },
    );
  }
}