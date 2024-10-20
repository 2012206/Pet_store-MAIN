import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../components/core/app_colors.dart';

class PetHistory extends StatelessWidget {
  const PetHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreenColor,
      appBar: AppBar(
        title: Text("Pet Orders",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),

      ),
      body: Padding(
        padding: EdgeInsets.all(12.sp),
        child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('pets').get(),
            builder: (context, snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
              else if(snapshot.hasError || !snapshot.hasData){
                return SizedBox.shrink();
              }
              else if(snapshot.data!.docs.isEmpty){
                return Center(child: CustomText(text: "No Pet Available"));
              }

              dynamic pets=snapshot.data!.docs;
              return GridView.builder(
                  itemCount: pets.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                  mainAxisExtent: 250
                  ),
                  itemBuilder: (context,index){
                  dynamic pet = pets[index];
                    return Card(
                      elevation: 2,
                      child:
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                height: 100,
                                width: 100,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image: NetworkImage(pet['image']),
                                        fit: BoxFit.contain)
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Name", style: TextStyle(
                                  fontWeight: FontWeight.w600,),),
                                Expanded(
                                  child: Text("${pet['petname']}", style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 12,),textAlign: TextAlign.end,),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text("Price", style: TextStyle(
                                    fontWeight: FontWeight.w600,),),
                                ),
                                // Spacer(),
                                Text("\$${pet['price']}", style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text("Age", style: TextStyle(
                                    fontWeight: FontWeight.w600,),),
                                ),
                                // Spacer(),
                                Text("${pet['age']}", style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Gender", style: TextStyle(
                                  fontWeight: FontWeight.w600,),),
                                Spacer(),
                                Text("${pet['gender']}", style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Vaccinated", style: TextStyle(
                                  fontWeight: FontWeight.w600,),),
                                Spacer(),
                                Text("${pet['vaccinated']==true?'Yes':'No'}", style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),),
                              ],
                            ),
                            SizedBox(height: 10,),



                          ],


                        ),
                      ),
                    );
                  });
            }
        ),
      ),

    );
  }
}
