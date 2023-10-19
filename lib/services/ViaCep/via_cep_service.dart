import 'package:cepapp/models/via_cep.dart';
import 'package:cepapp/services/Dio/custom_via_cep_dio.dart';

class ViaCEPService {
  final _customViaCEPDio = CustomViaCEPDio();

  Future<ViaCEP> get(String cep) async {
    try {
      var result = await _customViaCEPDio.dio.get("$cep/json");
      if (result.statusCode == 200) {
        return ViaCEP.fromJson(result.data);
      }
      return ViaCEP();
    } catch (e) {
      return ViaCEP();
    }
  }
}
