import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/button/customButton.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/components/textfield/customTextField.dart';
import 'package:pet_store_app/src/controllers/shelter_controller.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/bottomNavBar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreenColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.sp,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  text: "My Orders",
                  fontWeight: FontWeight.bold,
                  textColor: AppColors.primaryWhite,
                  fontSize: 22.sp,
                ),
              ),
              SizedBox(
                height: 10.sp,
              ),
              Expanded(
                child: FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection('orders').where("orderBy",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
                  builder: (context, ordersnapshot) {
                    if(ordersnapshot.connectionState==ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    else if(ordersnapshot.hasError || !ordersnapshot.hasData){
                      return SizedBox.shrink();
                    }
                    else if(ordersnapshot.data!.docs.isEmpty){
                      return Center(child: Text("No Orders",style: TextStyle(color: Colors.white),),);
                    }
                    return ListView.builder(
                        itemCount: ordersnapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context,index){
                          final order = ordersnapshot.data!.docs[index];
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            leading: Container(
                              height: 60,
                              width: 60,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                image: DecorationImage(image: NetworkImage(order['image']),fit: BoxFit.contain)
                              ),
                            ),
                            title:Text("${order['name']}",style: TextStyle(fontWeight: FontWeight.w600,),),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                               mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("${order['orderStatus'].toString().toUpperCase()}",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.red),),
                                Text("Quantity: ${order['quantity']}",style: TextStyle(fontWeight: FontWeight.w500),),
                              ],
                            ),
                            subtitle: Text("\$ ${order['price'].toString()}"),
                          ),
                        );
                    });
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
