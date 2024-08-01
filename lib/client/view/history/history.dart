import 'package:flutter/material.dart';
import 'package:logistics_app/client/view/history/historyCard.dart';
import '../../models/language.dart';
import '../../widgets/drawer.dart';
import '../../models/current.dart';
import '../../models/order.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Order> filteredOrders = [];
  bool isDeleting = false;
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    filteredOrders.addAll(orders);
  }

  void filterSearchResults(String query) {
    List<Order> searchResults = [];
    searchResults.addAll(orders);
    if (query.isNotEmpty) {
      searchResults.retainWhere((item) => item.orderId!.contains(query));
    }
    setState(() {
      filteredOrders.clear();
      filteredOrders.addAll(searchResults);
      currentPage = 1; // Reset to first page after search
    });
  }

  void cancelOrder(Order ord) {
    if (mounted)
      setState(() {
        orders.remove(ord);
        filteredOrders.remove(ord);
      });
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (filteredOrders.length / itemsPerPage).ceil();
    List<Order> currentOrders = filteredOrders.skip((currentPage - 1) * itemsPerPage).take(itemsPerPage).toList();
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 55),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          history,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                          height: BorderSide.strokeAlignCenter,
                          color: Colors.black,
                          indent: 10,
                          endIndent: 10,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          width: MediaQuery.of(context).size.width - 68,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              filterSearchResults(value);
                            },
                            decoration: InputDecoration(
                              hintText: searchForId,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width - 68,
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height - 350,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: filteredOrders.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(noResult),
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: currentOrders.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          CardHistory(
                                              isDeleting: isDeleting,
                                              order: currentOrders[index],cancel: cancelOrder,),
                                          index != currentOrders.length - 1
                                              ? const Divider(
                                                  height: 1,
                                                )
                                              : Container(),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Container(
                          height: 50,
                          width: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: TextButton(
                            child: Text(isDeleting ? doneDelete : deteleOrders,
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              setState(() {
                                isDeleting = !isDeleting;
                              });
                            },
                          ),
                        ),
                            ElevatedButton(
                              onPressed: currentPage > 1
                                  ? () {
                                      setState(() {
                                        currentPage--;
                                      });
                                    }
                                  : null,
                              child: Icon(Icons.arrow_back),
                              style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.blue, 
                                          backgroundColor: Colors.white, 
                                          minimumSize: Size(60, 60), 
                                          shape: CircleBorder(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                '$currentPage / $totalPages',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: currentPage < totalPages
                                  ? () {
                                      setState(() {
                                        currentPage++;
                                      });
                                    }
                                  : null,
                              child: Icon(Icons.arrow_forward),
                              style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.blue, 
                                          backgroundColor: Colors.white, 
                                          minimumSize: Size(60, 60), 
                                          shape: CircleBorder(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 55,
              right: 20,
              child: Builder(
                builder: (context) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              en = !en;
                            });
                            print(en);
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
