import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:simo_v_7_0_1/providers/shopping_cart_provider.dart';
import 'package:simo_v_7_0_1/screens/user-cataloge.dart';
import 'package:simo_v_7_0_1/widgets_utilities/multi_used_widgets.dart';
import 'package:simo_v_7_0_1/widgets_utilities/pop_up_menu_admins.dart';
import 'package:simo_v_7_0_1/widgets_utilities/pop_up_menu_users.dart';
import 'package:simo_v_7_0_1/widgets_utilities/user_app_bar.dart';


class UserCart extends StatefulWidget {
  const UserCart({Key? key}) : super(key: key);
  static const String id = '/ usercart';
  @override
  _UserCartState createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {
  @override
  Widget build(BuildContext context) {

    int mapOfproductslength = context.watch<ShoppingCartProvider>().countMap;
    var mapOfproducts = context.watch<ShoppingCartProvider>().collectionMap;
    var details = new Map();
    details= context.watch<ShoppingCartProvider>().collectionMap;

     print(' details===============${details.isEmpty}');

       for(var entry in details.entries){

         print(' key==========${entry.key} : value =======${entry.value}');
       }

    // print('  mapOfproductslength===============$mapOfproductslength');
    // print('  mapOfproducts======================$mapOfproducts');

    return Scaffold(

      body: SafeArea(


        child: mapOfproducts.isEmpty?

        UsedWidgets().emptyCart( context)

            :Column(
          children: [




            PopUpMenuWidgetUsers(putArrow: true,showcart: true,
              // callbackArrow: (){Navigator.of(context).pushNamedAndRemoveUntil(UserCatalogue.id, (Route<dynamic> route) => false);},
              callbackArrow: (){Navigator.of(context).pop();},
              voidCallbackCart: (){},),
            SizedBox(height: 20,),


            // Text('Total a pagar : '),
            // Text('${context.watch<ShoppingCartProvider>().productPriceTotal} \$'),

            Expanded(
              child: ListView.builder(
                  itemCount: mapOfproducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return cartproductCard(



                      product: mapOfproducts.keys.toList()[index],
                      quantity: mapOfproducts.values.toList()[index],
                      index: index,
                    );
                  }),
            ),
                  UsedWidgets().placeOrderwidget(context),
                  CartTotals()



          ],
        ),
      ),
    );
  }
}
