import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

Future<CepBack4AppModel> fetchCepData() async {
  final response = await http.get(Uri.parse('https://your.api.endpoint/here'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    return CepBack4AppModel.fromJson(jsonData);
  } else {
    throw Exception('Falha ao buscar os dados');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<CepBack4AppModel> futureCepData;

  @override
  void initState() {
    super.initState();
    futureCepData = fetchCepData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tabela de Dados'),
        ),
        body: Center(
          child: FutureBuilder<CepBack4AppModel>(
            future: futureCepData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('CEP')),
                      DataColumn(label: Text('Logradouro')),
                      DataColumn(label: Text('Cidade')),
                      DataColumn(label: Text('Estado')),
                      DataColumn(label: Text('Ações')),
                    ],
                    rows: snapshot.data!.ceps
                        .map(
                          (item) => DataRow(
                            cells: [
                              DataCell(Text(item.cep)),
                              DataCell(Text(item.logradouro)),
                              DataCell(Text(item.cidade)),
                              DataCell(Text(item.estado)),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        // Ação de editar
                                        print('Editar ${item.objectId}');
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        // Ação de excluir
                                        print('Excluir ${item.objectId}');
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
