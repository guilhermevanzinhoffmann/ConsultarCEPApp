import 'package:cepapp/models/via_cep_model.dart';
import 'package:cepapp/pages/endereco_page.dart';
import 'package:cepapp/services/back4All/back4all_service.dart';
import 'package:flutter/material.dart';

class CEPPage extends StatefulWidget {
  const CEPPage({super.key});

  @override
  State<CEPPage> createState() => _CEPPageState();
}

class _CEPPageState extends State<CEPPage> {
  var carregando = false;
  var viaCEPModel = ViaCEPModel([]);
  var service = Back4AllService();

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  carregarDados() async {
    if (mounted) {
      setState(() {
        carregando = true;
      });

      viaCEPModel = await service.get(null);

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
        title: const Text("Endereços"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : viaCEPModel.results.isEmpty
              ? const Center(child: Text("Nenhum endereço encontrado"))
              : ListView.builder(
                  itemCount: viaCEPModel.results.length,
                  itemBuilder: (_, int index) {
                    return Dismissible(
                      direction: DismissDirection.startToEnd,
                      onDismissed: (DismissDirection dismissDirection) async {
                        if (dismissDirection == DismissDirection.startToEnd) {
                          try {
                            await service
                                .delete(viaCEPModel.results[index].objectId!);
                            carregarDados();
                            if (mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Endereço excluído com sucesso!'),
                                elevation: 8,
                                backgroundColor: Colors.green,
                              ));
                            }
                          } catch (e) {
                            if (mounted) {
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
                      key: Key(viaCEPModel.results[index].objectId!),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext bc) => EnderecoPage(
                                        cep: viaCEPModel.results[index].cep!)));
                          },
                          child: Card(
                            elevation: 10,
                            shadowColor: Colors.red,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                            "Estado: ${viaCEPModel.results[index].uf ?? ""}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                            "Cidade: ${viaCEPModel.results[index].localidade ?? ""}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                            viaCEPModel.results[index]
                                                    .logradouro ??
                                                "",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                            "Bairro: ${viaCEPModel.results[index].bairro ?? ""}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    ));
  }
}
