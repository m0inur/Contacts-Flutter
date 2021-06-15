import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/contact.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseContacts {
  CollectionReference contactsCollection = FirebaseFirestore.instance
      .collection('ContactsDB')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Contacts");
  List<Contact> contacts = [];

  // Contact(id, name, companyName, email, mobile, work, avatarImage, isFavourite, [color]) {

  Future addContact(Contact contact) {
    return contactsCollection.add({
      "id": contact.id,
      "name": contact.name,
      "companyName": contact.companyName,
      "email": contact.email,
      "mobile": contact.mobile,
      "work": contact.work,
      "avatarImage": contact.avatarImage.path,
      "isFavourite": contact.isFavourite,
    })
        .then((value) => print("Contact added successfully"))
        .catchError((error) => print("Failed to add contact: $error"));
  }

  Future getContacts() async {
    if(FirebaseAuth.instance.currentUser == null) return;

    await FirebaseFirestore.instance
        .collection('ContactsDB')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Contacts")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((contact) {
        // print("${contact["id"]} ${contact["name"]} ${contact["companyName"]} ${contact["email"]} ${contact["mobile"]} ${contact["work"]} ${contact["avatarImage"]} ${contact["isFavourite"]}");
        contacts.add(
          Contact(contact["id"], contact["name"], contact["companyName"], contact["email"], contact["mobile"], contact["work"], contact["avatarImage"], contact["isFavourite"])
        // ;
        );
        // print(contacts);
      });
    });
  }

  Future<void> updateItem({
    required String title,
    required String description,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
    contactsCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('items').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  deleteContact() async {
    // FirebaseFirestore.instance
    //     .collection('ContactsDB')
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .collection("Contacts")
    //     .
    // await FirebaseFirestore.instance.runTransaction((transaction) => async {
    //   // await contact.delete(snapshot.data.documents[index].reference);
    // });

    await FirebaseFirestore.instance.runTransaction((Transaction myTrans) async {
      print(myTrans);
      // await myTransaction.delete(snapshot.data.documents[index].reference);
    });
  }
}