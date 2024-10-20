import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class OrderController extends GetxController{
  Future<void> storeorderdata(String price,String itemId,String name,String quantity,String image,String address, String postCode,String phoneNumber,String orderType,String age) async{
try{
  DocumentReference docRef =  await FirebaseFirestore.instance.collection('orders').add({
    'orderBy':FirebaseAuth.instance.currentUser!.uid,
    'price':price,
    'itemId': itemId,
    'name':name,
    'quantity':quantity,
    'orderStatus':"pending",
    'image':image,
    'address':address,
    'postCode':postCode,
    'phoneNumber':phoneNumber,
    'type':orderType,
    'time':DateTime.now()

  });
  await FirebaseFirestore.instance.collection('orders').doc(docRef.id).set({
    'orderId':docRef.id
  },SetOptions(merge: true));

  if(orderType=='petAdopt'){
    await FirebaseFirestore.instance.collection('orders').doc(docRef.id).set({
      'age':age
    },SetOptions(merge: true));
  }
  print('order data stored');
}catch(e){
  print('errror $e');
}
  }
}