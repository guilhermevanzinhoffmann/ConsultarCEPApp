import 'package:cepapp/models/via_cep.dart';
import 'package:cepapp/models/via_cep_model.dart';
import 'package:cepapp/pages/home_page.dart';
import 'package:cepapp/services/ViaCep/via_cep_service.dart';
import 'package:cepapp/services/back4All/back4all_service.dart';
import 'package:flutter/material.dart';

class BuscarCEPPage extends StatefulWidget {
  const BuscarCEPPage({super.key});

  @override
  State<BuscarCEPPage> createState() => _BuscarCEPPageState();
}

class _BuscarCEPPageState extends State<BuscarCEPPage> {
  var service = ViaCEPService();
  var back4AllService = Back4AllService();
  TextEditingController cepController = TextEditingController(text: "");
  String cep = "";
  bool loading = false;
  var viaCep = ViaCEP();

  Future<bool> _enderecoExiste(String cep) async {
    var cepFormatado = '${cep.substring(0, 5)}-${cep.substring(5)}';
    var viaCepModel = await back4AllService.get(cepFormatado);

    if (viaCepModel.results.isEmpty) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Buscar Endereço"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
        child: Column(
          children: [
            const Text("Consultar CEP"),
            TextField(
              controller: cepController,
              keyboardType: TextInputType.number,
              onChanged: (String value) async {
                cep = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (cep.length == 8) {
                  setState(() {
                    loading = true;
                  });
                  viaCep = await service.get(cep);
                }
                setState(() {
                  loading = false;
                });
              },
            ),
            const SizedBox(
              height: 50,
            ),
            Text(viaCep.logradouro ?? ""),
            Text("${viaCep.localidade ?? ""} - ${viaCep.uf ?? ""}"),
            Visibility(
                visible: (viaCep.localidade ?? "").isNotEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext bc) =>
                                      const HomePage()));
                        },
                        child: const Text("Cancelar")),
                    TextButton(
                        onPressed: () async {
                          var enderecoExistente = await _enderecoExiste(cep);
                          if (enderecoExistente) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Endereço já existe'),
                                elevation: 8,
                                backgroundColor: Colors.red,
                              ));
                            }
                          } else {
                            try {
                              var viaCepBack4All =
                                  ViaCEPBack4All.fromJson(viaCep.toJson());
                              await back4AllService.post(viaCepBack4All);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Endereço salvo com sucesso!'),
                                  elevation: 8,
                                  backgroundColor: Colors.green,
                                ));
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext bc) =>
                                            const HomePage()));
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(e.toString()),
                                  elevation: 8,
                                  backgroundColor: Colors.red,
                                ));
                              }
                            }
                          }
                        },
                        child: const Text("Salvar"))
                  ],
                )),
            Visibility(
                visible: loading, child: const CircularProgressIndicator()),
          ],
        ),
      ),
    ));
  }
}
