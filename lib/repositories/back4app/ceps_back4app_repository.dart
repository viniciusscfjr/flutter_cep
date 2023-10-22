import 'package:dio/dio.dart';
import 'package:flutter_cep/models/ceps_back4app_model.dart';

class CepBack4AppRepository {
  CepBack4AppRepository();

  Future<CepBack4AppModel> obterCeps(String cep) async {
    var url = "https://parseapi.back4app.com/classes/ceps";
    if (cep != "") {
      url = "$url?where={\"cep\":$cep}";
    }

    var dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.headers["X-Parse-Application-Id"] =
        "8T9hAf2gDSWVAMRHylEdVYV9gXjOvliBWD6DtOrr";
    dio.options.headers["X-Parse-REST-API-Key"] =
        "6zHKL0NQpRLQjNNIytzBJY6CStEjYX8WVIAo2pxA";

    var result = await dio.get(url);
    return CepBack4AppModel.fromJson(result.data);
  }

  Future<void> criar(
      String cep, String logradouro, String cidade, String estado) async {
    var dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.headers["X-Parse-Application-Id"] =
        "8T9hAf2gDSWVAMRHylEdVYV9gXjOvliBWD6DtOrr";
    dio.options.headers["X-Parse-REST-API-Key"] =
        "6zHKL0NQpRLQjNNIytzBJY6CStEjYX8WVIAo2pxA";

    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['cep'] = cep;
      data['logradouro'] = logradouro;
      data['cidade'] = cidade;
      data['estado'] = estado;

      await dio.post("https://parseapi.back4app.com/classes/ceps", data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> atualizar(Cep cep) async {
    var dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.headers["X-Parse-Application-Id"] =
        "8T9hAf2gDSWVAMRHylEdVYV9gXjOvliBWD6DtOrr";
    dio.options.headers["X-Parse-REST-API-Key"] =
        "6zHKL0NQpRLQjNNIytzBJY6CStEjYX8WVIAo2pxA";

    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['cep'] = cep.cep;
      data['logradouro'] = cep.logradouro;
      data['cidade'] = cep.cidade;
      data['estado'] = cep.estado;

      await dio.put(
          "https://parseapi.back4app.com/classes/ceps/${cep.objectId}",
          data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remover(String objectId) async {
    var dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.headers["X-Parse-Application-Id"] =
        "8T9hAf2gDSWVAMRHylEdVYV9gXjOvliBWD6DtOrr";
    dio.options.headers["X-Parse-REST-API-Key"] =
        "6zHKL0NQpRLQjNNIytzBJY6CStEjYX8WVIAo2pxA";

    try {
      var response = await dio.delete(
        "https://parseapi.back4app.com/classes/ceps/$objectId",
      );
    } catch (e) {
      rethrow;
    }
  }
}
