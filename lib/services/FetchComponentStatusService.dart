import 'package:dio/dio.dart';
import 'package:mymikano_app/services/DioClass.dart';
import 'package:mymikano_app/models/ComponentStatusModel.dart';
import 'package:mymikano_app/utils/appsettings.dart';

class ComponentStatusService {
  late Dio dio;

  Future<void> PrepareCall() async {
    dio = await DioClass.getDio();
  }

  Future<List<ComponentStatus>> fetchComponentStatus() async {
    final url = (ComponentsStatusURL);
    await PrepareCall();
    final response = await dio.get(url);
    print(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<ComponentStatus> listresult = [];
      for (var item in response.data) {
        listresult.add(ComponentStatus.fromJson(item));
      }
      return listresult;
    } else
      throw Exception('Error fetching');
  }
}
