import 'package:flutter/material.dart';
import 'package:flutter_cep/models/ceps_back4app_model.dart';
import 'package:flutter_cep/repositories/back4app/ceps_back4app_repository.dart';

import '../models/viacep_model.dart';
import '../repositories/via_cep_repository.dart';

class CepPage extends StatefulWidget {
  const CepPage({Key? key}) : super(key: key);

  @override
  State<CepPage> createState() => _CepPageState();
}

class _CepPageState extends State<CepPage> {
  var cepController = TextEditingController(text: "");
  bool loading = false;
  var viacepModel = ViaCEPModel();
  var viaCEPRepository = ViaCepRepository();

  var futureCepData = Future.value(CepBack4AppModel([]));
  CepBack4AppRepository cepBack4AppRepository = CepBack4AppRepository();

  var logradouroController = TextEditingController(text: "");
  var cidadeController = TextEditingController(text: "");
  var estadoController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    cepController = TextEditingController();
    logradouroController = TextEditingController();
    cidadeController = TextEditingController();
    estadoController = TextEditingController();
  }

  @override
  void dispose() {
    cepController.dispose();
    logradouroController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    super.dispose();
  }

  _showEditModal(Cep item) {
    // Definir os controladores com os valores atuais do item
    cepController.text = item.cep;
    logradouroController.text = item.logradouro;
    cidadeController.text = item.cidade;
    estadoController.text = item.estado;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Para que o modal seja de altura total
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Editar Item'),
                TextField(
                  controller: cepController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'CEP',
                  ),
                ),
                TextField(
                  controller: logradouroController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(labelText: 'Logradouro'),
                ),
                TextField(
                  controller: cidadeController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(labelText: 'Cidade'),
                ),
                TextField(
                  controller: estadoController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(labelText: 'Estado'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    item.cep = cepController.text;
                    item.logradouro = logradouroController.text;
                    item.cidade = cidadeController.text;
                    item.estado = estadoController.text;

                    // Atualizar o item no banco de dados
                    await cepBack4AppRepository.atualizar(item);

                    setState(() {
                      futureCepData = cepBack4AppRepository.obterCeps("");
                    });

                    // Fechar o modal
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const Text(
                "Consulta de CEP",
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(
                height: 50,
              ),
              TextField(
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.grey,
                    labelText: "CEP",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    )),
                controller: cepController,
                keyboardType: TextInputType.number,
                onChanged: (String value) async {
                  var cep = value.replaceAll(RegExp(r'[^0-9]'), '');
                  if (cep.length == 8) {
                    setState(() {
                      loading = true;
                    });
                    viacepModel = await viaCEPRepository.consultarCEP(cep);
                    var cepBack4App =
                        await cepBack4AppRepository.obterCeps(cep);

                    if (cepBack4App.ceps.isEmpty) {
                      await cepBack4AppRepository.criar(
                          viacepModel.cep!,
                          viacepModel.logradouro!,
                          viacepModel.localidade!,
                          viacepModel.uf!);

                      setState(() {
                        futureCepData = cepBack4AppRepository.obterCeps("");
                      });
                    }
                  }
                  setState(() {
                    loading = false;
                  });
                },
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                viacepModel.logradouro ?? "",
                style: const TextStyle(fontSize: 22),
              ),
              Text(
                "${viacepModel.localidade ?? ""} - ${viacepModel.uf ?? ""}",
                style: const TextStyle(fontSize: 22),
              ),
              Visibility(
                  visible: loading, child: const CircularProgressIndicator()),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: FutureBuilder<CepBack4AppModel>(
                  future: futureCepData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
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
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.amber,
                                            ),
                                            onPressed: () {
                                              // Ação de editar
                                              print('Editar ${item.objectId}');

                                              // Atualizar valor dos controllers
                                              cepController.text = item.cep;
                                              logradouroController.text =
                                                  item.logradouro;
                                              cidadeController.text =
                                                  item.cidade;
                                              estadoController.text =
                                                  item.estado;

                                              print(cepController.text);

                                              _showEditModal(item);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () async {
                                              // Ação de excluir
                                              print('Excluir ${item.objectId}');
                                              await cepBack4AppRepository
                                                  .remover(item.objectId);

                                              setState(() {
                                                futureCepData =
                                                    cepBack4AppRepository
                                                        .obterCeps("");
                                              });
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

                    return const CircularProgressIndicator();
                  },
                ),
              ),
              TextButton(
                  onPressed: () async {
                    setState(() {
                      futureCepData = cepBack4AppRepository.obterCeps("");
                    });
                  },
                  child: const Text("Refresh")),
            ],
          ),
        ),
      ),
    ));
  }
}
