import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_admin/Models/orderItems.dart';
import 'package:shop_admin/Pages/customersPage.dart';
import 'package:shop_admin/Pages/orderReceipt.dart';
import 'package:shop_admin/Reusables/constants.dart';
import 'package:shop_admin/Services/database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String type = "Not Delivered";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Welcome',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 30),
              ),
            ),
            ListTile(
              title: Text('All Orders'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Customers'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => CustomersPage()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Orders"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                      child: Text("Delivered"),
                      onPressed: () {
                        setState(() {
                          type = "Delivered";
                        });
                      }),
                  RaisedButton(
                      child: Text("Not Delivered"),
                      onPressed: () {
                        setState(() {
                          type = "Not Delivered";
                        });
                      }),
                ],
              ),
            ),
            Flexible(
              child: StreamBuilder(
                stream: DatabaseServices().getOrderItem(type),
                builder: (context, snap) {
                  // print(snap.data);
                  if (snap.hasData) {
                    List<OrderItem> orderItems = snap.data;
                    // print(orderItems.length);
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: _buildOrderedList(orderItems),
                    );
                  } else
                    return Center(child: Text("No Orders"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildOrderedList(List<OrderItem> orderItems) {
  return ListView(
    children: orderItems.map((order) => _buildEachOrder(order)).toList(),
  );
}

Widget _buildEachOrder(OrderItem order) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
    child: Container(
      decoration: kSoftShadowDecoration.copyWith(
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: RichText(
                  text: TextSpan(
                    text: 'OrderID:  ',
                    style: GoogleFonts.questrial(
                        color: Colors.black54, fontSize: 12),
                    children: <TextSpan>[
                      TextSpan(
                          text: order.orderID,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 10)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Customer: ',
                    style: GoogleFonts.questrial(
                        color: Colors.black54, fontSize: 12),
                    children: <TextSpan>[
                      TextSpan(
                          text: order.name ?? "N/A",
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                order.status ?? "N/A",
                style: TextStyle(
                    color: order.status == 'Delivered'
                        ? Colors.green
                        : order.status == 'Cancelled'
                            ? Colors.red
                            : Color(0xFF0013A8)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 13.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Order Date:  ',
                          style: GoogleFonts.questrial(color: Colors.black54),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    "${order.orderDate.toDate().day}-${order.orderDate.toDate().month}-${order.orderDate.toDate().year}",
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Order Total: ₹ ',
                          style: GoogleFonts.questrial(color: Colors.black54),
                          children: <TextSpan>[
                            TextSpan(
                                text: order.totalCartCost,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: RichText(
                        text: TextSpan(
                          text: 'Item Count: ',
                          style: GoogleFonts.questrial(color: Colors.black54),
                          children: <TextSpan>[
                            TextSpan(
                              text: order.items.length.toString(),
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: kSoftShadowDecoration,
                child: Provider<OrderItem>.value(
                  value: order,
                  child: Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => OrderDetails(
                                orderItem: order,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          CupertinoIcons.forward,
                          color: Colors.green,
                        ),
                        // onPressed: () {
                        //   Navigator.push(
                        //       context,
                        //       CupertinoPageRoute(
                        //           builder: (context) => OrderDetails(
                        //                 orderItem: order,
                        //               )));
                        // },
                      );
                    },
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}
