import 'package:circuit4driver/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Impostazioni extends StatelessWidget {
  const Impostazioni({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Impostazioni"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 15,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title("Veicolo"),
              tile("Tipo veiocolo", "auto"),
              SizedBox(
                height: 10,
              ),
              Divider(),
              title("Unita"),
              tile("Unita distanza", "Chilometri"),
              SizedBox(
                height: 10,
              ),
              Divider(),
              title("Preferenze mappa"),
              SizedBox(
                height: 10,
              ),
              tile("Tipo mappa", "Predefinito"),
              SizedBox(
                height: 10,
              ),
              tile("App di navigazione", "App preferita per la navigazione"),
              SizedBox(
                height: 10,
              ),
              tile("Lato fermata", "Entrambi i lati del furgone"),
              SizedBox(
                height: 10,
              ),
              Divider(),
              title("Preferenze generali"),
              tile("Tema", "Segui sistema"),
              SizedBox(
                height: 10,
              ),
              tile("Lato fermata", "Entrambi i lati del furgone"),
              SizedBox(
                height: 10,
              ),
              tile("App di navigazione", "App preferita per la navigazione"),
            ],
          ),
        ),
      ),
    );
  }

  Widget tile(title, sub) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title",
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            // fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "$sub",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            // fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget title(value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Text(
        "$value",
        style: TextStyle(
          color: orangeColor,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
