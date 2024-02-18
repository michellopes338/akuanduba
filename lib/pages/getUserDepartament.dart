import 'package:flutter/material.dart';
import 'package:pausabem/pages/LoadScreen.dart';
import 'package:pausabem/src/stores/departaments_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetUserDepartament extends StatefulWidget {
  const GetUserDepartament({super.key});

  @override
  State<GetUserDepartament> createState() => _GetUserDepartamentState();
}

class _GetUserDepartamentState extends State<GetUserDepartament> {
  int dropdownValue = 1;
  final store = DepartamentStore();

  @override
  void initState() {
    super.initState();
    store.addListener(_listener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.getDepartaments();
    });
  }

  void _listener() {
    setState(() {});
  }

  @override
  void dispose() {
    store.removeListener(_listener);
    super.dispose();
  }

  Future<void> setDepartamentId(int departamentId) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setInt('departamentId', departamentId);
    });
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const LoadScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                scale: 2,
                repeat: ImageRepeat.repeat)),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Qual é o seu setor?',
                  style: TextStyle(
                      fontSize: 40,
                      color: Color.fromARGB(255, 232, 179, 155),
                      letterSpacing: 16)),
              const SizedBox(
                height: 100,
              ),
              DropdownButton(
                  value: dropdownValue,
                  dropdownColor: const Color.fromARGB(255, 13, 43, 56),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 232, 179, 155),
                      letterSpacing: 5),
                  onChanged: (int? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: store.value.departaments
                      .map((departament) => DropdownMenuItem(
                          value: departament.id, child: Text(departament.name)))
                      .toList()),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 232, 179, 155)),
                  onPressed: (() => setDepartamentId(dropdownValue)),
                  child: const Text(
                    'Começar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
