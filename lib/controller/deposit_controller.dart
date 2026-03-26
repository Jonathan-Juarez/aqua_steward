import 'dart:convert';
import 'package:aqua_steward/controller/auth_controller.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/entity/deposit.dart';
import 'package:aqua_steward/core/network/global_variable.dart';
import 'package:aqua_steward/core/network/manage_http_response.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DepositController {
  Future<void> createDeposit({
    required BuildContext context,
    required Deposit deposit,
  }) async {
    try {
      final http.Response response = await http
          .post(
            Uri.parse("$uri/api/deposit/createDeposit"),
            body: deposit.depositToJson(),
            headers: <String, String>{
              "Content-Type": "application/json; charset=utf-8",
              //Se le pasa el token como header.
              "x-auth-token": AuthController.currentUser?.token ?? "",
            },
          )
          .timeout(const Duration(seconds: 10)); // Timeout de 10 segundos
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          SnackBarFormat.show(context, "Depósito creado exitosamente");
          Navigator.pushReplacementNamed(context, AppRouter.dashboard);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      SnackBarFormat.show(context, e.toString());
    }
  }

  Future<void> updateDeposit({
    required BuildContext context,
    required Deposit deposit,
  }) async {
    try {
      final http.Response response = await http.put(
        Uri.parse("$uri/api/deposit/update/${deposit.id}"),
        body: deposit.depositToJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": AuthController.currentUser?.token ?? "",
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          SnackBarFormat.show(context, "Depósito actualizado exitosamente");
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      SnackBarFormat.show(context, e.toString());
    }
  }

  Future<void> deleteDeposit({
    required BuildContext context,
    required String depositId,
  }) async {
    try {
      final http.Response response = await http.delete(
        Uri.parse("$uri/api/deposit/deleteDeposit/$depositId"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": AuthController.currentUser?.token ?? "",
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          SnackBarFormat.show(context, "Depósito eliminado exitosamente");
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      SnackBarFormat.show(context, e.toString());
    }
  }

  Future<Deposit?> getDeposit({
    required BuildContext context,
    required String depositId,
  }) async {
    try {
      final http.Response response = await http.get(
        Uri.parse("$uri/api/deposit/get/$depositId"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": AuthController.currentUser?.token ?? "",
        },
      );
      Deposit? deposit;
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          final data = json.decode(response.body);
          deposit = Deposit.fromMap(data);
        },
      );
      return deposit;
    } catch (e) {
      debugPrint(e.toString());
      SnackBarFormat.show(context, e.toString());
      return null;
    }
  }

  Future<List<Deposit>> getDeposits({required BuildContext context}) async {
    try {
      debugPrint("Token enviado: ${AuthController.currentUser?.token}");
      final http.Response response = await http.get(
        Uri.parse("$uri/api/deposit/getDeposits"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": AuthController.currentUser?.token ?? "",
        },
      );
      List<Deposit> deposits = [];
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          final List<dynamic> data = json.decode(response.body);
          deposits = data.map((e) => Deposit.fromMap(e)).toList();
        },
      );
      return deposits;
    } catch (e) {
      debugPrint(e.toString());
      SnackBarFormat.show(context, e.toString());
      return [];
    }
  }
}
