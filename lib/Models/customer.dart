class Customer {
  String id;
  String phone;
  String address;
  String alternatePhoneNumber;
  String cartID;
  String name;
  String imageUrl;
  Map<dynamic, dynamic> orders;

  Customer({this.id, this.phone});

  factory Customer.fromfirebase(dynamic doc) {
    Customer customer =  Customer(id: doc.documentID, phone: doc.data['phoneNumber']);
    customer.name = doc.data["name"];
    customer.address = doc.data["address"];
    customer.cartID = doc.data['cartID'];
    customer.alternatePhoneNumber = doc.data['alternatePhoneNumber'];
    customer.imageUrl = doc.data['imageUrl'];
    customer.orders = doc.data["orders"];
    return customer;
  }
}
