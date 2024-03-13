import 'package:coffre/transactions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'DatabaseHelpers.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  TextEditingController _montantController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper();
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          accuiel(),
          Statistique(),
        ],
      ),
      bottomNavigationBar: CustomBottomAppBar(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
      floatingActionButton: Container(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: ()  {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Transaction()));
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Icon(Icons.add, color: Colors.white,),
          backgroundColor: Colors.blueAccent,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class accuiel extends StatefulWidget {
  const accuiel({super.key});

  @override
  State<accuiel> createState() => _accuielState();
}

class _accuielState extends State<accuiel> {
  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper();
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height/2.5,
            decoration: BoxDecoration(
              color: Color.fromRGBO(13, 28, 59, 1),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)
              )
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/tirelire.png', height: 80, width: 80,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FutureBuilder<Map<String, dynamic>>(
                            future: dbHelper.getSolde(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Text('0.0 Fcfa');
                              } else if (snapshot.hasError) {
                                return Text('Erreur: ${snapshot.error}');
                              } else {
                                final solde = snapshot.data!['montant'];

                                return Text('$solde Fcfa', style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30
                                ));
                              }
                            },
                          ),
                          Text('Solde actuel', style: TextStyle(
                            color: Colors.white38,
                            fontSize: 20
                          ),),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 7,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            SizedBox(height: 8,),
                            // Récupérer la somme des transactions du jour
                            FutureBuilder<double>(
                              future: dbHelper.getSommeTransactionsDuJour(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Text('0.0', style: TextStyle(fontSize: 18, color: Colors.black));
                                } else if (snapshot.hasError) {
                                  return Text('Erreur: ${snapshot.error}');
                                } else {
                                  final sommeTransactionsDuJour = snapshot.data ?? 0.0;

                                  return Text('$sommeTransactionsDuJour', style: TextStyle(fontSize: 18, color: Colors.black));
                                }
                              },
                            ),
                            Text("Fcfa/jour", style: TextStyle(
                              fontSize: 15,
                              color: Colors.black38
                            ),)
                          ],
                        ),
                      ),
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 7,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            SizedBox(height: 8,),
                            // Récupérer la somme des transactions du mois
                            FutureBuilder<double>(
                              future: dbHelper.getSommeTransactionsDuMois(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Text('0.0', style: TextStyle(fontSize: 18, color: Colors.black));
                                } else if (snapshot.hasError) {
                                  return Text('Erreur: ${snapshot.error}');
                                } else {
                                  final sommeTransactionsDuMois = snapshot.data ?? 0.0;

                                  return Text('$sommeTransactionsDuMois', style: TextStyle(fontSize: 18, color: Colors.black));
                                }
                              },
                            ),
                            Text("Fcfa/mois", style: TextStyle(
                                fontSize: 15,
                                color: Colors.black38
                            ),)
                          ],
                        ),
                      ),
                      Container(
                        width: 170,
                        height: 90,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Récupérer la somme des retraits du mois
                              Row(
                                children: [
                                  FutureBuilder<double>(
                                    future: dbHelper.getSommeRechargesDuMois(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Text('0.0', style: TextStyle(fontSize: 14, color: Colors.red));
                                      } else if (snapshot.hasError) {
                                        return Text('Erreur: ${snapshot.error}');
                                      } else {
                                        final sommeRetraitsDuMois = snapshot.data ?? 0.0;

                                        return Text('$sommeRetraitsDuMois ', style: TextStyle(fontSize: 14, color: Colors.red));
                                      }
                                    },
                                  ),
                                  // Récupérer la somme totale des transactions du mois
                                  FutureBuilder<double>(
                                    future: dbHelper.getTotalSommeTransactionsDuMois(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Text('sur 0.0Fcfa', style: TextStyle(fontSize: 14, color: Colors.red));
                                      } else if (snapshot.hasError) {
                                        return Text('Erreur: ${snapshot.error}');
                                      } else {
                                        final totalSommeTransactionsDuMois = snapshot.data ?? 0.0;

                                        return Container( width: 90,child: Text('sur ${totalSommeTransactionsDuMois}Fcfa', style: TextStyle(fontSize: 14, color: Colors.red), overflow: TextOverflow.ellipsis,));
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Text("Rapport des 30 dernier jours", style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black38
                              ),),
                              SizedBox(height: 12,),
                              FutureBuilder<double>(
                                future: dbHelper.getTotalSommeTransactionsDuMois(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return LinearPercentIndicator(
                                      width: 150.0,
                                      lineHeight: 15.0,
                                      percent: 0,
                                      center: Text('${(0 * 100).toStringAsFixed(2)}%', style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12
                                      ),),
                                      progressColor: Colors.red,
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Erreur: ${snapshot.error}');
                                  } else {
                                    final totalTransactionsDuMois = snapshot.data ?? 0.0;

                                    return FutureBuilder<double>(
                                      future: dbHelper.getSommeRechargesDuMois(),
                                      builder: (context, snapshotRetraits) {
                                        if (snapshotRetraits.connectionState == ConnectionState.waiting) {
                                          return LinearPercentIndicator(
                                            width: 150.0,
                                            lineHeight: 15.0,
                                            percent: 0,
                                            center: Text('${(0 * 100).toStringAsFixed(2)}%', style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12
                                            ),),
                                            progressColor: Colors.red,
                                          );
                                        } else if (snapshotRetraits.hasError) {
                                          return Text('Erreur: ${snapshotRetraits.error}');
                                        } else {
                                          final totalRetraitsDuMois = snapshotRetraits.data ?? 0.0;

                                          final percentage = totalRetraitsDuMois / totalTransactionsDuMois;

                                          return LinearPercentIndicator(
                                            width: 150.0,
                                            lineHeight: 15.0,
                                            percent: percentage,
                                            center: Text('${(percentage * 100).toStringAsFixed(2)}%', style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12
                                            ),),
                                            progressColor: Colors.red,
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: dbHelper.getTransactions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final transactions = snapshot.data!;
                if (transactions.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50,),
                      Lottie.asset('assets/Animation - 1709796510287 (1).json', width: 200, height: 200),
                      Text('Aucune transaction enregistrée.'),
                    ],
                  );
                }
                return Container(
                  height: MediaQuery.of(context).size.height/2.05,
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                              ),
                              child: ListTile(
                                onTap: () {},
                                leading: Image.asset('assets/money.png', width: 30, height: 30,),
                                title: Text('Montant: ${transaction['montant']}'),
                                subtitle: Text('Date: ${transaction['date']}'),
                                trailing: transaction['statut'] == 0
                                    ?const Icon(Icons.arrow_upward_rounded, color: Colors.green,)
                                    :const Icon(Icons.arrow_downward_rounded, color: Colors.red,),
                                // Add other details as needed
                              ),
                            ),
                            const Divider()
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class CustomBottomAppBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  CustomBottomAppBar({required this.currentIndex, required this.onTabTapped});

  final List<Map<IconData, IconData>> iconsList = [
    {Icons.monetization_on: Icons.monetization_on_outlined},
    {Icons.analytics: Icons.analytics_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < iconsList.length; i++)
              buildIconButton(iconsList[i], i),
          ],
        ),
      ),
    );
  }

  IconButton buildIconButton(Map<IconData, IconData> icons, int index) {
    final selectedIcon = currentIndex == index ? icons.keys.first : icons.values.first;

    return IconButton(
      icon: Icon(
        selectedIcon,
        color: currentIndex == index ? Color.fromRGBO(15, 36, 53, 1) : Colors.black,
      ),
      onPressed: () => onTabTapped(index),
    );
  }
}


class Statistique extends StatefulWidget {
  const Statistique({super.key});

  @override
  State<Statistique> createState() => _State();
}

class _State extends State<Statistique> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper();
    final ItemScrollController itemScrollController = ItemScrollController();
    final PageController pageController = PageController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(13, 28, 59, 1),
        title: Text('Statisques', style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height/3.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Color.fromRGBO(13, 28, 59, 1),
            ),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: dbHelper.getSoldeHistorique(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Erreur: ${snapshot.error}');
                } else {
                  final historiqueList = snapshot.data ?? [];

                  if (historiqueList.isEmpty) {
                    return Column(
                      children: [
                        Lottie.asset('assets/piggywait.json', width: 150, height: 150),
                        Text('Le cochon attend vos epargnes', style: TextStyle(
                          color: Colors.white
                        ),),
                      ],
                    );
                  }
                  return Container(
                    height: 230, // Ajustez la hauteur selon vos besoins
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: historiqueList.length,
                      itemBuilder: (context, index) {
                        final historique = historiqueList[index];
                        final montant = historique['montant'] as double;
                        final date = DateTime.parse(historique['date'] as String);

                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width/1.1, // Ajustez la largeur selon vos besoins
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Historique de solde ', style: TextStyle(
                                        color: Color.fromRGBO(13, 28, 59, 1),
                                        fontSize: 30
                                      ),),
                                      Text('du ${date.day}/${date.month}/${date.year}', style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 15
                                      ),),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.red,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('$montant Fcfa', style: TextStyle(fontSize: 30)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height/9.2,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(27, 55, 92, 1)
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width/1.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Solde actuel', style: TextStyle(
                              color: Colors.white38,
                              fontSize: 16
                          ),),
                          FutureBuilder<Map<String, dynamic>>(
                            future: dbHelper.getSolde(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Text('0.0 Fcfa');
                              } else if (snapshot.hasError) {
                                return Text('Erreur: ${snapshot.error}');
                              } else {
                                final solde = snapshot.data!['montant'];

                                return Text('$solde Fcfa', style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                ));
                              }
                            },
                          ),
                          Text('Pour plus de details appuie sur le bouton +', style: TextStyle(
                              color: Colors.white,
                              fontSize: 12
                          ),),
                        ],
                      ),
                    ),
                  ),
                  // Diviseur vertical
                  Container(
                    height: double.infinity,
                    width: 1.0,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10,),
                  IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.add_circled_solid, color: Colors.white, size: 35,))
                ],
              ),
            ),
          ),
          Container(
            height: 50, // Ajustez la hauteur de l'onglet selon vos besoins
            child: ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              itemCount: 8,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      // Lorsque l'onglet est sélectionné, faites défiler la page correspondante
                      pageController.animateToPage(index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                      // Mettez à jour l'index de l'onglet actuellement sélectionné
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          getOptionName(index),
                          style: TextStyle(
                            color: selectedIndex == index
                                ? Colors.red // Couleur de l'onglet actif
                                : Colors.black38, // Couleur des autres onglets
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(
            color: Colors.black38,
            height: 10,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height/3.5,
            child: PageView.builder(
              controller: pageController,
              itemCount: 2,
              itemBuilder: (context, index) {
                return getContentWidget(index, dbHelper);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getContentWidget(int index, dbHelper) {
    switch (index) {
      case 0:
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: dbHelper.getToutesLesRecharges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final transactions = snapshot.data!;
              if (transactions.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30,),
                    Lottie.asset('assets/Animation - 1709796510287 (1).json', width: 150, height: 150),
                    Text('Aucune transaction enregistrée.'),
                  ],
                );
              }
              return Container(
                height: MediaQuery.of(context).size.height/2.05,
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                            ),
                            child: ListTile(
                              onTap: () {},
                              leading: Image.asset('assets/money.png', width: 30, height: 30,),
                              title: Text('Montant: ${transaction['montant']}'),
                              subtitle: Text('Date: ${transaction['date']}'),
                              trailing: transaction['statut'] == 0
                                  ?const Icon(Icons.arrow_upward_rounded, color: Colors.green,)
                                  :const Icon(Icons.arrow_downward_rounded, color: Colors.red,),
                              // Add other details as needed
                            ),
                          ),
                          const Divider()
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          },
        );
      case 1:
        return Container(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: dbHelper.getTousLesRetraits(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final transactions = snapshot.data!;
                if (transactions.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 30,),
                      Lottie.asset('assets/Animation - 1709796510287 (1).json', width: 150, height: 150),
                      Text('Aucune transaction enregistrée.'),
                    ],
                  );
                }
                return Container(
                  height: MediaQuery.of(context).size.height/2.05,
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                              ),
                              child: ListTile(
                                onTap: () {},
                                leading: Image.asset('assets/money.png', width: 30, height: 30,),
                                title: Text('Montant: ${transaction['montant']}'),
                                subtitle: Text('Date: ${transaction['date']}'),
                                trailing: transaction['statut'] == 0
                                    ?const Icon(Icons.arrow_upward_rounded, color: Colors.green,)
                                    :const Icon(Icons.arrow_downward_rounded, color: Colors.red,),
                                // Add other details as needed
                              ),
                            ),
                            const Divider()
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        );
    // Ajoutez des cas pour d'autres pages
      default:
        return Container();
    }
  }

  String getOptionName(int index) {
    switch (index) {
      case 0:
        return 'Recharges';
      case 1:
        return 'Retraits';
      default:
        return '';
    }
  }
}
