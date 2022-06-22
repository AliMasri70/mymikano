import 'package:dio/dio.dart';
import 'package:mymikano_app/models/Currency.dart';
import 'package:mymikano_app/utils/appsettings.dart';

import 'DioClass.dart';

class CurrencyService {
  late Dio dio;

  Future<void> PrepareCall() async {
    dio = await DioClass.getDio();
  }

  Future<Currency?> getPrimaryCurrency() async {
    await PrepareCall();
    Response response;
    Currency? currency;
    try {
      response = await dio.get(MikanoShopPrimaryCurrency);
      currency = Currency.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return currency;
  }
}
