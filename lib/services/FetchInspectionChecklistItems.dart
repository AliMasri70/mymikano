import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mymikano_app/services/DioClass.dart';
import 'package:mymikano_app/models/InspectionChecklistItem.dart';
import 'package:mymikano_app/models/PredefinedChecklistModel.dart';
import 'dart:convert';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:path_provider/path_provider.dart';

class ChecklistItemsService {
  late Dio dio;

  Future<void> PrepareCall() async {
    dio = await DioClass.getDio();
  }

  Future<List<PredefinedChecklistModel>> fetchItems(int idMainCat) async {
    final url = (GetPredefinedCheckListByCategURL + idMainCat.toString());

    await PrepareCall();
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.data) as List<dynamic>;
      final listresult =
          json.map((e) => PredefinedChecklistModel.fromJson(e)).toList();

      return listresult;
    } else {
      throw Exception('Error fetching');
    }
  }

  Future<List<InspectionChecklistItem>> fetchAllItems(int inspId) async {
    final url = (GetCustomCheckListByInspectionURL + inspId.toString());

    await PrepareCall();
    dynamic response = await dio.get(url);
    // print(response.data);

    if (response.statusCode == 200) {
      List<InspectionChecklistItem> listresult = [];

      for (var item in response.data) {
        InspectionChecklistItem temp = InspectionChecklistItem.fromJson(item);

        listresult.add(temp);
      }
      return listresult;
    } else {
      throw Exception('Error fetching');
    }
  }
}
