import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_admin/Models/orderItems.dart';
import 'package:shop_admin/Models/unit.dart';
import 'package:shop_admin/Reusables/constants.dart';
import 'package:share/share.dart';
import 'package:screenshot/screenshot.dart';

import '../Services/database.dart';
import '../Services/database.dart';

class OrderDetails extends StatefulWidget {
  final OrderItem orderItem;
  OrderDetails({this.orderItem});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  ScreenshotController screenshotController;
  @override
  Widget build(BuildContext context) {
    List<String> products = [];
    String deliverTo = widget.orderItem.name +
        "\n" +
        widget.orderItem.address +
        "\n" +
        widget.orderItem.phone +
        "\n" +
        widget.orderItem.alternatePhone;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(products);
          Share.share("Order Details:\nDeliver To-\n$deliverTo \n$products",
              subject: "Order Details");
        },
        child: Icon(Icons.share),
      ),
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        elevation: 0,
        backgroundColor: kbackgroundColor,
        title: Text(
          "Receipt",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              widget.orderItem.status == "Not Delivered"
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                              color: Colors.red,
                              onPressed: () async {
                                if (widget.orderItem.status == "Not Delivered")
                                  await Firestore.instance
                                      .collection("Orders")
                                      .document(widget.orderItem.orderID)
                                      .updateData({
                                    "status": "Cancelled",
                                    "statusUpdatedOn":
                                        FieldValue.serverTimestamp()
                                  });
                              },
                              child: Text("Cancel Order",
                                  style: TextStyle(color: Colors.white))),
                          RaisedButton(
                            color: Colors.green,
                            onPressed: () async {
                              if (widget.orderItem.status == "Not Delivered")
                                await Firestore.instance
                                    .collection("Orders")
                                    .document(widget.orderItem.orderID)
                                    .updateData({
                                  "status": "Delivered",
                                  "statusUpdatedOn":
                                      FieldValue.serverTimestamp()
                                });
                            },
                            child: Text("Mark as Delivered",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                          "Status : ${widget.orderItem.status} on ${widget.orderItem.statusUpdatedOn.toDate()}" ??
                              " ",
                          style: TextStyle(fontSize: 20)),
                    ),
              Container(
                  decoration: kSoftShadowDecoration.copyWith(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                        child: RichText(
                          text: TextSpan(
                            text: 'OrderID:  ',
                            style: GoogleFonts.questrial(
                                color: Colors.black54, fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text: widget.orderItem.orderID,
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black54,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Placed on :",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  "${widget.orderItem.orderDate.toDate().day}-${widget.orderItem.orderDate.toDate().month}-${widget.orderItem.orderDate.toDate().year}",
                                  style: TextStyle(fontSize: 17),
                                )
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Delivered on :",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  "Yet to be delivered",
                                  style: TextStyle(fontSize: 17),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black54,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Items",
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                      Flexible(
                        child: ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.orderItem.items.length,
                          itemBuilder: (BuildContext context, int index) {
                            String key =
                                widget.orderItem.items.keys.elementAt(index);
                            Firestore.instance
                                .collection("Shop")
                                .document(key)
                                .get()
                                .then((value) {
                              products.add(
                                  "\n$key - ${widget.orderItem.items[key]} - ${value['description']}\n");
                            });
                            return StreamBuilder(
                                stream: DatabaseServices().getUnit(key),
                                builder: (context, snap) {
                                  Unit unit = snap.data;
                                  if (snap.hasData) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, top: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            // crossAxisAlignment:
                                            //     CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "$key ",
                                                style: GoogleFonts.questrial(
                                                    color: Colors.black,
                                                    fontSize: 20),
                                              ),
                                              Container(
                                                  height: 20,
                                                  width: 1,
                                                  color: Colors.black26),
                                              VerticalDivider(),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20.0),
                                                  child: Text(unit.unit,
                                                      style: GoogleFonts.lato(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black54,
                                                          fontSize: 16)),
                                                ),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20.0),
                                                child: Text(
                                                    " ${widget.orderItem.items[key]}",
                                                    style: GoogleFonts.lato(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black54,
                                                        fontSize: 16)),
                                              ),
                                            ],
                                          ),
                                          Divider()
                                        ],
                                      ),
                                    );
                                  } else {
                                    return LinearProgressIndicator();
                                  }
                                });
                          },
                        ),
                      ),
                      Divider(
                        color: Colors.black54,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Delivery Address",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                              Text(
                                widget.orderItem.name ?? "",
                                style: TextStyle(fontSize: 17),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(widget.orderItem.address ?? ""),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(widget.orderItem.phone ?? ""),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child:
                                    Text(widget.orderItem.alternatePhone ?? ""),
                              ),
                            ],
                          ),
                          StreamBuilder(
                              stream: Firestore.instance
                                  .collection("Users")
                                  .document(widget.orderItem.userid)
                                  .snapshots(),
                              builder: (context, snap) {
                                dynamic data = snap.data;
                                if (data != null) {
                                  return Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Customer Details",
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ),
                                      Text(
                                        snap.data['name'] ?? " ",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(snap.data['address'] ?? ""),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                            snap.data['phoneNumber'] ?? ""),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                            snap.data['alternatePhoneNumber'] ??
                                                ""),
                                      ),
                                    ],
                                  );
                                }
                                return CircularProgressIndicator();
                              }),
                        ],
                      ),
                      Divider(
                        color: Colors.black54,
                      ),
                      // BarcodeWidget(
                      //   drawText: false,
                      //   width: 230,
                      //   height: 50,
                      //   barcode: Barcode.code128(),
                      //   data: widget.orderItem.orderID,
                      // ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, top: 10),
                        child: Container(
                          decoration: kSoftShadowDecoration,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20),
                            child: RichText(
                              text: TextSpan(
                                text: 'Order Total: ₹  ',
                                style: GoogleFonts.questrial(
                                    color: Colors.green, fontSize: 20),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: widget.orderItem.totalCartCost,
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontSize: 22)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
