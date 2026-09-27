import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapDeposit extends StatelessWidget {
  final MapController mapController;
  final LatLng depositLocation;
  final String? depositName;
  final bool interactive;
  final VoidCallback? mapReady;
  final bool showUserLocation;

  const MapDeposit({
    super.key,
    required this.mapController,
    required this.depositLocation,
    this.depositName,
    this.interactive = true,
    this.mapReady,
    this.showUserLocation = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: AppBorder.all8,
      child: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: depositLocation,
              initialZoom: 15,
              minZoom: 3,
              maxZoom: 19,
              onMapReady: mapReady,
              interactionOptions: InteractionOptions(
                flags: interactive ? InteractiveFlag.all : InteractiveFlag.none,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.aquasteward.app',
                tileBuilder: isDark ? darkModeTileBuilder : null,
              ),

              // Marcador del depósito
              MarkerLayer(
                markers: [
                  Marker(
                    point: depositLocation,
                    width: 140,
                    height: 60,
                    alignment: Alignment.topCenter,
                    child: _DepositPin(depositName: depositName),
                  ),
                ],
              ),

              RichAttributionWidget(
                alignment: AttributionAlignment.bottomLeft,
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(
                      Uri.parse('https://openstreetmap.org/copyright'),
                    ),
                  ),
                ],
              ),

              if (showUserLocation)
                const CurrentLocationLayer(
                  style: LocationMarkerStyle(
                    marker: DefaultLocationMarker(
                      child: Icon(Icons.navigation, size: 14, color: Colors.white),
                    ),
                    markerSize: Size(22, 22),
                    markerDirection: MarkerDirection.heading,
                  ),
                ),
            ],
          ),

          // Botón flotante para re-centrar en el depósito
          if (interactive)
            Positioned(
              right: 12,
              bottom: 12,
              child: FloatingActionButton.small(
                heroTag: "recenter_deposit_${depositLocation.latitude}_${depositLocation.longitude}",
                backgroundColor: isDark ? AppColor.container : AppColor.white,
                foregroundColor: AppColor.parameterAqua,
                elevation: 3,
                onPressed: () {
                  mapController.move(depositLocation, 15);
                },
                child: const Icon(Icons.my_location_rounded, size: 20),
              ),
            ),
        ],
      ),
    );
  }
}

class _DepositPin extends StatelessWidget {
  final String? depositName;

  const _DepositPin({this.depositName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (depositName != null && depositName!.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            margin: const EdgeInsets.only(bottom: 2),
            decoration: const BoxDecoration(
              color: AppColor.containerContrast,
              borderRadius: AppBorder.all8,
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              depositName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColor.parameterAqua,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.water_drop_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ],
    );
  }
}

void centerOnDeposit(MapController mapController, LatLng location, {double zoom = 15}) {
  mapController.move(location, zoom);
}
