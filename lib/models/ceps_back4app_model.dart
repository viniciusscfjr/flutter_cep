class CepBack4AppModel {
  List<Cep> ceps = [];

  CepBack4AppModel(this.ceps);

  CepBack4AppModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      ceps = <Cep>[];
      json['results'].forEach((v) {
        ceps.add(Cep.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = ceps.map((v) => v.toJson()).toList();
    return data;
  }
}

class Cep {
  String objectId = "";
  String cep = "";
  String logradouro = "";
  String cidade = "";
  String estado = "";
  String createdAt = "";
  String updatedAt = "";

  Cep(this.objectId, this.cep, this.logradouro, this.cidade, this.estado,
      this.createdAt, this.updatedAt);

  Cep.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    cep = json['cep'];
    logradouro = json['logradouro'];
    cidade = json['cidade'];
    estado = json['estado'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['cep'] = cep;
    data['logradouro'] = logradouro;
    data['cidade'] = cidade;
    data['estado'] = estado;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
