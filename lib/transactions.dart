import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'DatabaseHelpers.dart';
import 'accueil.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  TextEditingController _montantController = TextEditingController();
  int selectedValue = 0; // Valeur par défaut pour le menu déroulant
  @override
  Widget build(BuildContext context) {
    String transaction = "Recharge";
    if (selectedValue == 0) {
      transaction = "Recharge";
    } else {
      transaction = "Retrait";
    }
    final dbHelper = DatabaseHelper();
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions - $transaction'),
      ),
      bottomNavigationBar: Container(
        color: Colors.black12,
        height: 70,
        child: FutureBuilder<Map<String, dynamic>>(
          future: dbHelper.getSolde(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ElevatedButton(
                onPressed: () async {

                },
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width/1.2, 45),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    side: BorderSide(
                      color: Colors.blue,
                    )
                ),
                child: Text(
                  'Confirmer',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            } else {
              final solde = snapshot.data!['montant'];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_montantController.text == "") {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.redAccent,
                          content:Text('Veuillez entrer un montant svp',style: TextStyle(
                              color: Colors.white
                          ),),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }else{
                        if (solde < double.parse(_montantController.text) && selectedValue == 1) {
                          final snackBar = SnackBar(
                            backgroundColor: Colors.redAccent,
                            content:Text('Solde insuffisant pour effectuer cette transaction',style: TextStyle(
                                color: Colors.white
                            ),),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          _montantController.text ="";
                        } else {
                          await dbHelper.makeTransaction(double.parse(_montantController.text), selectedValue); // Recharge
                          setState(() {});
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyHomePage()));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width/1.2, 45),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        side: BorderSide(
                          color: Colors.blue,
                        )
                    ),
                    child: Text(
                      'Confirmer',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width/1.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: DropdownButton<int>(
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                    items: const [
                      DropdownMenuItem<int>(
                        value: 0,
                        child: Text('Recharge'),
                      ),
                      DropdownMenuItem<int>(
                        value: 1,
                        child: Text('Retrait'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width/1.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue),
                ),
                child: TextField(
                  controller: _montantController,
                  decoration: InputDecoration(
                    hintText: 'Montant',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
          ),
          Lottie.asset('assets/cochon.json', width: 300, height: 300),
          FutureBuilder<Map<String, dynamic>>(
            future: dbHelper.getSolde(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              } else {
                final solde = snapshot.data!['montant'];

                return Text(' Solde actuel $solde Fcfa', style: TextStyle(
                    color: Colors.black38,
                    fontSize: 18
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
