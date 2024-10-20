import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/components/core/app_assets.dart';
import 'package:pet_store_app/src/components/core/app_colors.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:pet_store_app/src/components/textfield/customTextField.dart';
import 'package:pet_store_app/src/components/widgets/petBuyAndSellContainer.dart';
import 'package:pet_store_app/src/components/widgets/shopPetFoodcontainer.dart';
import 'package:pet_store_app/src/components/widgets/topHeadingContainer.dart';
import 'package:pet_store_app/src/screens/chat/size_box_ex.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PetStoreScreen extends StatefulWidget {
  const PetStoreScreen({super.key});

  @override
  State<PetStoreScreen> createState() => _PetStoreScreenState();
}

class _PetStoreScreenState extends State<PetStoreScreen> {
  TextEditingController searchController = TextEditingController();
late Future<QuerySnapshot> petStream;
late Future<QuerySnapshot> foodStream;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
 petStream =  FirebaseFirestore.instance.collection('pets').get();
 foodStream = FirebaseFirestore.instance.collection('petsFood').get();
  }
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopHeadingContainer(text: "PET STORE"),
          SizedBox(
            height: 2.h,
          ),
          CustomTextFormField(
            onChanged: (val){
              setState(() {

              });
            },
              hintText: "Search Item",
              labelText: "Search Item",
              suffixIcon: Icons.search,
              fillColor: AppColors.lightGrey,
              controller: searchController,

          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2.h,
                ),
                CustomText(
                  text: "Pets Near You",
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                ),
                 SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: FutureBuilder<QuerySnapshot>(
                      future:petStream,
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
                      // dynamic pets=snapshot.data!.docs;
                      dynamic pets = snapshot.data!.docs.where((doc) {
                        String searchText = searchController.text.toLowerCase();
                        return doc['petname'].toString().toLowerCase().contains(searchText);
                      }).toList();
                      if (pets.isEmpty) {
                        return  Container(
                          width: Get.width,
                          alignment: Alignment.center,
                          // color: Colors.red,
                          child: Center(child: CustomText(text: "No Pet Search Found",textColor: Colors.grey,)),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:  List.generate(pets.length, (index){
                       return PetBuyAndSellContainer(
                            petName:pets[index]['petname'],
                            petImage: pets[index]['image'],
                            petAge: pets[index]['age'],
                            petDescription: pets[index]['description'],
                            petPrice: pets[index]['price'],
                         docId: pets[index]['docId'],
                          );
                        })

                          // PetBuyAndSellContainer(
                          //   petName: "Canine Dog",
                          //   petImage: AppAssets.dog1,
                          //   petAge: "11 months",
                          //   petDescription:
                          //       "Meet our charming dog, Max! He has a shiny, golden coat that's easy to groom and a pair of expressive brown eyes that show his loving nature. Max is energetic and loves outdoor activities, making him an excellent companion for walks, runs, and playtime. He is intelligent, quick to learn commands, and well-behaved around both children and other pets. Max is also incredibly loyal and enjoys spending quality time with his family, whether it’s playing fetch or relaxing together. Bring Max home, and you’ll have a faithful friend who fills your life with joy and companionship.",
                          //   petPrice: "25000",
                          // ),
                          // PetBuyAndSellContainer(
                          //   petName: "Domestic Cat",
                          //   petImage: AppAssets.cat1,
                          //   petAge: "3 months",
                          //   petDescription:
                          //       "Meet our adorable cat, Luna! She has a beautiful, silky coat with a mix of grey and white fur that’s soft to the touch. Luna is known for her striking blue eyes that sparkle with curiosity. She's playful and loves to chase after toys, making her a perfect companion for active families. Despite her playful nature, Luna is also incredibly affectionate and enjoys curling up on laps for a cozy nap. She’s well-behaved, litter-trained, and gets along well with other pets. Luna is the perfect addition to any loving home, bringing joy and warmth wherever she goes",
                          //   petPrice: "20000",
                          // ),
                          // PetBuyAndSellContainer(
                          //   petName: "Canine Dog",
                          //   petImage: AppAssets.dog1,
                          //   petAge: "10 months",
                          //   petDescription:
                          //       "Meet our charming dog, Max! He has a shiny, golden coat that's easy to groom and a pair of expressive brown eyes that show his loving nature. Max is energetic and loves outdoor activities, making him an excellent companion for walks, runs, and playtime. He is intelligent, quick to learn commands, and well-behaved around both children and other pets. Max is also incredibly loyal and enjoys spending quality time with his family, whether it’s playing fetch or relaxing together. Bring Max home, and you’ll have a faithful friend who fills your life with joy and companionship.",
                          //   petPrice: "25000",
                          // )
                        // ],
                      );
                    }
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                CustomText(
                  text: "Pets Food",
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                ),
                FutureBuilder<QuerySnapshot>(
                  future: foodStream,
                  builder: (context, petfoodsnapshot) {
                    if(petfoodsnapshot.connectionState==ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator());
                    }
                    else if(petfoodsnapshot.hasError || !petfoodsnapshot.hasData){
                      return SizedBox.shrink();
                    }
                    else if(petfoodsnapshot.data!.docs.isEmpty){
                      return Center(child: CustomText(text: "No Pet Food Available"));
                    }
                    // dynamic foodData=petfoodsnapshot.data!.docs;
                    dynamic foodData = petfoodsnapshot.data!.docs.where((doc) {
                      String searchText = searchController.text.toLowerCase();
                      return doc['name'].toString().toLowerCase().contains(searchText);
                    }).toList();
                    if (foodData.isEmpty) {
                      return  Center(child: CustomText(text: "No Food Search Found",textColor: Colors.grey,));
                    }
                    return   Wrap(
                      alignment: WrapAlignment.start,
                        spacing: 10,runSpacing: 5,
                      children: List.generate(foodData.length,(index)=> ShopPetFoodContainer(
                        image: foodData[index]['image'].toString(),
                        productName: foodData[index]['name'].toString().toUpperCase(),
                        price: foodData[index]['price'].toString(),
                        productDescription: foodData[index]['description'].toString(),
                        productId: foodData[index]['docId'],
                      ),)
                    );
                  }
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Column(
                //       children: [
                //         const ShopPetFoodContainer(
                //           image: AppAssets.petFood1,
                //           productName: "PEACHES",
                //           price: "4000",
                //           productDescription:
                //               "Turkey and salmon are packed with amazing flavour that satisfies even the pickiest of cats. Boost the immune system and promote healthy digestion. Helps reduce stool odour. Supports kidney and urinary tract health. The low content of magnesium and L-methionine helps maintain an optimal urine pH of 6.0–6.5.",
                //         ),
                //         SizedBox(
                //           height: 2.h,
                //         ),
                //         const ShopPetFoodContainer(
                //           image: AppAssets.petFood2,
                //           productName: "PEDIGREE 400G",
                //           price: "3000",
                //           productDescription:
                //               "For healthy teeth and bones. In cats an essential nutrient for excellent vision and a healthy heart. Help maintain gastrointestinal tract and immune system health. Promote longevity and good health.",
                //         )
                //       ],
                //     ),
                //     Column(
                //       children: [
                //         const ShopPetFoodContainer(
                //           image: AppAssets.petFood3,
                //           productName: "MOCHI",
                //           price: "2000",
                //           productDescription:
                //               "Turkey and salmon are packed with amazing flavour that satisfies even the pickiest of cats. Boost the immune system and promote healthy digestion. Helps reduce stool odour. Supports kidney and urinary tract health. The low content of magnesium and L-methionine helps maintain an optimal urine pH of 6.0–6.5.",
                //         ),
                //         SizedBox(
                //           height: 2.h,
                //         ),
                //         const ShopPetFoodContainer(
                //           image: AppAssets.petFood4,
                //           productName: "BEAN",
                //           price: "5000",
                //           productDescription:
                //               "For healthy teeth and bones. In cats an essential nutrient for excellent vision and a healthy heart. Help maintain gastrointestinal tract and immune system health. Promote longevity and good health.",
                //         )
                //       ],
                //     ),
                //     Column(
                //       children: [
                //         const ShopPetFoodContainer(
                //           image: AppAssets.petFood5,
                //           productName: "BISCUIT",
                //           price: "4000",
                //           productDescription:
                //               "Turkey and salmon are packed with amazing flavour that satisfies even the pickiest of cats. Boost the immune system and promote healthy digestion. Helps reduce stool odour. Supports kidney and urinary tract health. The low content of magnesium and L-methionine helps maintain an optimal urine pH of 6.0–6.5.",
                //         ),
                //         SizedBox(
                //           height: 2.h,
                //         ),
                //         const ShopPetFoodContainer(
                //           image: AppAssets.petFood6,
                //           productName: "PEDIGREE 400G",
                //           price: "2000",
                //           productDescription:
                //               "For healthy teeth and bones. In cats an essential nutrient for excellent vision and a healthy heart. Help maintain gastrointestinal tract and immune system health. Promote longevity and good health.",
                //         )
                //       ],
                //     )
                //   ],
                // )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
