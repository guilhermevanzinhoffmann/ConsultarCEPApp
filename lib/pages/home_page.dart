import 'package:cepapp/pages/buscar_cep_page.dart';
import 'package:cepapp/pages/cep_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int posicaoInicial = 0;
  PageController pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Expanded(
              child: PageView(
            controller: pageController,
            onPageChanged: (value) {
              setState(() {
                posicaoInicial = value;
              });
            },
            children: const [CEPPage(), BuscarCEPPage()],
          )),
          BottomNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            type: BottomNavigationBarType.fixed,
            onTap: (value) {
              pageController.jumpToPage(value);
            },
            currentIndex: posicaoInicial,
            items: const [
              BottomNavigationBarItem(
                  label: "Endereços", icon: Icon(Icons.location_on)),
              BottomNavigationBarItem(
                  label: "Buscar Endereço", icon: Icon(Icons.search)),
            ],
          )
        ],
      ),
    ));
  }
}
