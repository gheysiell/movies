import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:movies/core/enums.dart';
import 'package:movies/core/navigation_service.dart';
import 'package:movies/shared/palette.dart';
import 'package:movies/shared/widgets/custom_alert_dialog.dart';
import 'package:photo_view/photo_view.dart';

class Functions {
  static void showNetworkImageDetails(
    String url,
    BuildContext context,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                size: 30,
                color: Palette.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Palette.black,
          ),
          backgroundColor: Palette.black,
          body: Center(
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(url),
              backgroundDecoration: const BoxDecoration(color: Palette.black),
              maxScale: PhotoViewComputedScale.covered * 2.0,
              minScale: PhotoViewComputedScale.contained,
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> showMessageResponseStatus(
    ResponseStatus responseStatus,
    String operation,
    String? vowel,
    String module,
  ) async {
    String messageException = responseStatus == ResponseStatus.success
        ? '${capitalFirstLetter(module)} $operation com sucesso.'
        : responseStatus == ResponseStatus.error
            ? 'Não foi possível $operation $vowel $module, tente novamente.'
            : responseStatus == ResponseStatus.timeout
                ? 'Tempo da consulta excedido, tente novamente.'
                : 'Você não está conectado a internet.';

    await Functions.showGeneralAlertDialog(
      messageException,
      responseStatus == ResponseStatus.success ? TypeMessageDialog.info : TypeMessageDialog.error,
    );
  }

  static Future<void> showGeneralAlertDialog(
    String textBody,
    TypeMessageDialog typeOfMessage,
  ) async {
    BuildContext context = NavigationService.navigatorKey.currentContext!;
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => CustomAlertDialogView(
        title: getTitleMessageDialog(typeOfMessage),
        subTitle: textBody,
        icon: Icon(
          getIconMessageDialog(typeOfMessage),
          size: 30,
          color: getColorMessageDialog(typeOfMessage),
        ),
      ),
    );
  }

  static String getTitleMessageDialog(TypeMessageDialog typeOfMessage) {
    return typeOfMessage == TypeMessageDialog.info
        ? 'Olá'
        : typeOfMessage == TypeMessageDialog.warning
            ? 'Atenção'
            : 'Erro';
  }

  static IconData getIconMessageDialog(TypeMessageDialog typeOfMessage) {
    return typeOfMessage == TypeMessageDialog.info
        ? Icons.info_outline_rounded
        : typeOfMessage == TypeMessageDialog.warning
            ? Icons.warning_amber_rounded
            : Icons.error_outline_rounded;
  }

  static Color getColorMessageDialog(TypeMessageDialog typeOfMessage) {
    return typeOfMessage == TypeMessageDialog.info
        ? Palette.blue
        : typeOfMessage == TypeMessageDialog.warning
            ? Palette.warning
            : Palette.error;
  }

  static Future<bool> checkConn() async {
    List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
        !connectivityResult.contains(ConnectivityResult.wifi) &&
        !connectivityResult.contains(ConnectivityResult.ethernet)) {
      return false;
    }
    return true;
  }

  static String capitalFirstLetter(String value) {
    if (value.isEmpty) return value;
    return value.substring(0, 1).toUpperCase() + value.substring(1, value.length).toLowerCase();
  }

  static String timeFormated(int minutes) {
    double minutesDivided = minutes / 60;
    String hoursFormatted = minutesDivided.floor().toString();
    String minutesFormatted = ((minutesDivided % 1) * 60).toStringAsFixed(0);

    return '${hoursFormatted}h ${minutesFormatted}m';
  }
}
