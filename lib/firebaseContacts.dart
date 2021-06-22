import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/contact.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

class FirebaseContacts {
  CollectionReference contactsCollection = FirebaseFirestore.instance
      .collection('ContactsDB')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Contacts");

  List<Contact> contacts = [];

  Future deleteContact(String uId) async {
    if(FirebaseAuth.instance.currentUser == null) return;
    return await FirebaseFirestore.instance
        .collection('ContactsDB')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Contacts")
        .doc(uId)
        .delete();
  }

  void updateContact(Contact contact) async {
    if(FirebaseAuth.instance.currentUser == null) return;
    print(contact);
    await FirebaseFirestore.instance
        .collection('ContactsDB')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Contacts")
        .doc(contact.uId)
        .update({
          "id": contact.id,
          "name": contact.name,
          "companyName": contact.companyName,
          "email": contact.email,
          "mobile": contact.mobile,
          "work": contact.work,
          "avatarImage": contact.avatarImage.path,
          "isFavourite": contact.isFavourite,
        });
  }

  Future addContact(Contact contact) {
    return contactsCollection.add({
      // contacts
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
          Contact(contact.id, contact["id"], contact["name"], contact["companyName"], contact["email"], contact["mobile"], contact["work"], contact["avatarImage"], contact["isFavourite"])
        // ;
        );
      // print(contacts);
      });
    });
  }

  Future setContacts(List<Contact> sqfliteContacts) async {
    await FirebaseFirestore.instance
        .collection('ContactsDB')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Contacts")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((contact) {
        deleteContact(contact.id);
      });
    });

    for(var i = 0; i < sqfliteContacts.length; i++) {
      var hasMatched = false;
      // print("Check if ${sqfliteContacts[i].name} exists");
      for(var j = 0; j < contacts.length; j++) {
        // print("${sqfliteContacts[i].name} == ${contacts[j].name}");
        if(sqfliteContacts[i].name == contacts[j].name) {
          hasMatched = true;
          break;
        }
      }

      if(!hasMatched) {
        addContact(sqfliteContacts[i]);
      }
    }
  }
}