import 'package:cepapp/models/via_cep_model.dart';
import 'package:cepapp/pages/home_page.dart';
import 'package:cepapp/services/back4All/back4all_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnderecoPage extends StatefulWidget {
  final String cep;
  const EnderecoPage({super.key, required this.cep});

  @override
  State<EnderecoPage> createState() => _EnderecoPageState();
}

class _EnderecoPageState extends State<EnderecoPage> {
  var service = Back4AllService();
  var viaCEPModel = ViaCEPModel([]);
  var carregando = false;
  TextEditingController estadoController = TextEditingController(text: "");
  TextEditingController cidadeController = TextEditingController(text: "");
  TextEditingController ruaController = TextEditingController(text: "");
  TextEditingController bairroController = TextEditingController(text: "");
  TextEditingController dddController = TextEditingController(text: "");
  TextEditingController ibgeController = TextEditingController(text: "");
  TextEditingController giaController = TextEditingController(text: "");
  TextEditingController siafiController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<bool> _updateViaCep() async {
    try {
      var viaCep = viaCEPModel.results[0];
      viaCep.uf = estadoController.text;
      viaCep.localidade = cidadeController.text;
      viaCep.logradouro = ruaController.text;
      viaCep.bairro = bairroController.text;
      viaCep.ddd = dddController.text;
      viaCep.ibge = ibgeController.text;
      viaCep.gia = giaController.text;
      viaCep.siafi = siafiController.text;
      await service.put(viaCep);
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          elevation: 8,
          backgroundColor: Colors.red,
        ));
      }
      return false;
    }
  }

  carregarDados() async {
    if (mounted) {
      setState(() {
        carregando = true;
      });
      viaCEPModel = await service.get(widget.cep);
      if (viaCEPModel.results.isNotEmpty) {
        var viaCep = viaCEPModel.results[0];
        estadoController.text = viaCep.uf ?? "";
        cidadeController.text = viaCep.localidade ?? "";
        ruaController.text = viaCep.logradouro ?? "";
        bairroController.text = viaCep.bairro ?? "";
        dddController.text = viaCep.ddd ?? "";
        ibgeController.text = viaCep.ibge ?? "";
        giaController.text = viaCep.gia ?? "";
        siafiController.text = viaCep.siafi ?? "";
      }
      setState(() {
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Editar endereço"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : viaCEPModel.results.isEmpty
              ? const Center(child: Text("Endereço não encontrado"))
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: estadoController,
                            decoration:
                                const InputDecoration(labelText: "Estado"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: cidadeController,
                            decoration:
                                const InputDecoration(labelText: "Cidade"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: ruaController,
                            decoration:
                                const InputDecoration(labelText: "Logradouro"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: bairroController,
                            decoration:
                                const InputDecoration(labelText: "Bairro"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: dddController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d{0,2}')),
                            ],
                            decoration: const InputDecoration(labelText: "DDD"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: ibgeController,
                            decoration:
                                const InputDecoration(labelText: "IBGE"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: giaController,
                            decoration: const InputDecoration(labelText: "GIA"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: siafiController,
                            decoration:
                                const InputDecoration(labelText: "SIAFI"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Theme.of(context)
                                            .colorScheme
                                            .inversePrimary)),
                                onPressed: () async {
                                  var atualizou = await _updateViaCep();

                                  if (atualizou) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "Endereço atualizado com sucesso!"),
                                        elevation: 8,
                                        backgroundColor: Colors.green,
                                      ));
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext bc) =>
                                                  const HomePage()));
                                    }
                                  }
                                },
                                child: const Text("Editar")),
                          )
                        ],
                      )
                    ],
                  ),
                ),
    ));
  }
}
