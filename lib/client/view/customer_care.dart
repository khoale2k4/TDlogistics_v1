import 'package:flutter/material.dart';
import 'package:logistics_app/client/view/not_available.dart';
import '../models/current.dart';
import '../models/language.dart';
import '../widgets/drawer.dart';

class CusCare extends StatefulWidget {
  const CusCare({super.key});

  @override
  State<CusCare> createState() => _CusCareState();
}

class _CusCareState extends State<CusCare> {

  void notAvai() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotAvai()),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 223, 223),
      drawer: const MyDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/client/assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height - 40,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 20, right: 30),
                        height: 100,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Text(
                          greetingCare,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        padding: const EdgeInsets.all(20.0),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              otherProblems,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              problem,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                notAvai();
                              },
                              child: Text(
                                sendHelp,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.cyan),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        padding: const EdgeInsets.all(20.0),
                        height: 352,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              helpCenter,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              prolems,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                notAvai();
                              },
                              child: Text(
                                introduction,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.cyan),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                notAvai();
                              },
                              child: Text(
                                vouchers,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.cyan),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                notAvai();
                              },
                              child: Text(
                                procedure,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.cyan),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                notAvai();
                              },
                              child: Text(
                                price,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.cyan),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                notAvai();
                              },
                              child: Text(
                                policy,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.cyan),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                notAvai();
                              },
                              child: Text(
                                payment,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.cyan),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                notAvai();
                              },
                              child: Text(
                                chanels,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.cyan),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        padding: const EdgeInsets.all(20.0),
                        height: 190,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "lib/client/assets/customer.png",
                              height: 100,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    quickAssist,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Text(
                                      quickAssistForProbs,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    padding: EdgeInsets.zero,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        notAvai();
                                      },
                                      child: Text(
                                        chatNow,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 52,
              right: 25,
              child: Builder(
                builder: (context) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 232, 232, 232),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Builder(
                          builder: (context) {
                            return IconButton(
                              icon: const Icon(Icons.menu, color: Colors.red),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            );
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              en = !en;
                            });
                            if (en) {
                              toEnLanguage();
                            } else {
                              toViLanguage();
                            }
                          },
                          icon: const Icon(
                            Icons.language,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
