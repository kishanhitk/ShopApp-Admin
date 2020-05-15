import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_admin/Models/customer.dart';
import 'package:shop_admin/Pages/customerDetails.dart';
import 'package:shop_admin/Reusables/constants.dart';
import 'package:shop_admin/Services/database.dart';

class CustomersPage extends StatefulWidget {
  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customers"),
      ),
      body: Container(
        child: StreamBuilder(
          stream: DatabaseServices().getUsers(),
          builder: (context, snap) {
            if (snap.hasData) {
              List<Customer> customer = snap.data;
              // print(orderItems.length);
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: _buildCustomerList(customer, context),
              );
            } else
              return Center(child: Text("No Orders"));
          },
        ),
      ),
    );
  }
}

Widget _buildCustomerList(List<Customer> customers, BuildContext context) {
  return ListView(
    children: customers
        .map((customer) => _buildEachCustomer(customer, context))
        .toList(),
  );
}

Widget _buildEachCustomer(Customer customer, BuildContext context) {
  return Column(children: <Widget>[
        ListTile(
          trailing: Icon(CupertinoIcons.forward),
          subtitle: Text(customer.phone),
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => CustomerDetailsPage(
                          customer: customer,
                        )));
          },
          title: Text(customer.name),
        ),
        Divider()
      ]) ??
      Padding(
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
                              text: customer.name,
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
                        text: 'User ',
                        style: GoogleFonts.questrial(
                            color: Colors.black54, fontSize: 12),
                        children: <TextSpan>[
                          TextSpan(
                              text: customer.name,
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
                    customer.name ?? "N/A",
                    style: TextStyle(
                        color: customer.name == 'Delivered'
                            ? Colors.green
                            : customer.name == 'Cancelled'
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
                              style:
                                  GoogleFonts.questrial(color: Colors.black54),
                              children: <TextSpan>[
                                // TextSpan(
                                //     text:
                                //         "${order.orderDate.toDate().day}-${order.orderDate.toDate().month}-${order.orderDate.toDate().year}",
                                //     style: GoogleFonts.lato(
                                //         fontWeight: FontWeight.w400,
                                //         color: Colors.black,
                                //         fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: RichText(
                            text: TextSpan(
                              text: 'Order Total: ₹ ',
                              style:
                                  GoogleFonts.questrial(color: Colors.black54),
                              children: <TextSpan>[
                                TextSpan(
                                    text: customer.name,
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
                              style:
                                  GoogleFonts.questrial(color: Colors.black54),
                              children: <TextSpan>[
                                // TextSpan(
                                //   text: order.items.length.toString(),
                                //   style: GoogleFonts.lato(
                                //       fontWeight: FontWeight.w400,
                                //       color: Colors.black,
                                //       fontSize: 16),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: kSoftShadowDecoration,
                    child: Builder(
                      builder: (context) {
                        return IconButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   CupertinoPageRoute(
                            //     builder: (context) => OrderDetails(
                            //       orderItem: order,
                            //     ),
                            //   ),
                            // );
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
                  )
                ],
              )
            ],
          ),
        ),
      );
}
