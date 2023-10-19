import 'package:cepapp/models/via_cep_model.dart';
import 'package:cepapp/services/Dio/back4all/custom_dio_back4app.dart';

class Back4AllService {
  final CustomDioBack4App _customDioBack4App = CustomDioBack4App();
  final _url = "ViaCep";

  Future<ViaCEPModel> get(String? cep) async {
    try {
      var viaCepModel = ViaCEPModel([]);
      var url = _url;
      if (cep != null && cep.isNotEmpty) {
        url = "$url?where={\"cep\":\"$cep\"}";
      }
      var result = await _customDioBack4App.dio.get(url);

      if (result.statusCode == 200) {
        viaCepModel = ViaCEPModel.fromJson(result.data);
      }

      return viaCepModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> post(ViaCEPBack4All viaCEPBack4All) async {
    try {
      var body = viaCEPBack4All.toJsonCreate();
      await _customDioBack4App.dio.post(_url, data: body);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> put(ViaCEPBack4All viaCEPBack4All) async {
    try {
      var url = "$_url/${viaCEPBack4All.objectId}";
      var body = viaCEPBack4All.toJsonCreate();
      await _customDioBack4App.dio.put(url, data: body);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      var url = "$_url/$id";
      await _customDioBack4App.dio.delete(url);
    } catch (e) {
      rethrow;
    }
  }
}
