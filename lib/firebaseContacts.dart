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

  Future deleteContact(Contact targetContact) async {
    print("Deleting contact....");
    if(FirebaseAuth.instance.currentUser == null) return;
    FirebaseFirestore.instance
        .collection('ContactsDB')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Contacts")
        // .where("id", isEqualTo : targetContact.id)
        .get()
        .then((value){
      value.docs.forEach((element) {
        FirebaseFirestore.instance.collection("ContactsDB").doc(element.id).delete().then((value){
          print("Success!");
        });
      });
    });

    // await FirebaseFirestore.instance
    //     .collection('ContactsDB')
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .collection("Contacts")
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((contact) {
    //     // print("${contact["id"]} ${contact["name"]} ${contact["companyName"]} ${contact["email"]} ${contact["mobile"]} ${contact["work"]} ${contact["avatarImage"]} ${contact["isFavourite"]}");
    //     if(targetContact.id.toString() == contact["id"].toString()) {
    //       contact.
    //       print("Target contact found");
    //     }
    //     // contacts.add(
    //     //     Contact(contact["id"], contact["name"], contact["companyName"], contact["email"], contact["mobile"], contact["work"], contact["avatarImage"], contact["isFavourite"])
    //     //   // ;
    //     // );
    //     // print(contacts);
    //   });
    // });
  }
}