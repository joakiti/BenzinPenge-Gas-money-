import 'package:benzin_penge/repositories/interfaces/interface_provider.dart';
import 'package:dio/dio.dart';

class GasolinePricesProvider implements AsyncProvider<double> {
  @override
  Future<double> provide({args}) async {
    String url = 'https://europe-west1-nash-equil.cloudfunctions.net/function-1';

    Response response = await Dio().get(url);
    double gas = double.parse(response.data['q8'].toString().replaceAll(",", "."));
    return gas;
  }

}