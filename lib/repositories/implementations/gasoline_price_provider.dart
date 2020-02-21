import 'package:benzin_penge/repositories/interfaces/interface_provider.dart';
import 'package:dio/dio.dart';

class GasolinePricesProvider implements AsyncProvider<double> {

  double gasPrice;
  @override
  Future<double> provide({args}) async {
    if (gasPrice == null) {
      String url = 'https://europe-west1-nash-equil.cloudfunctions.net/function-1';

      Response response = await Dio().get(url);
      gasPrice = double.parse(
          response.data['q8'].toString().replaceAll(",", "."));
    }
    return gasPrice;
  }

}