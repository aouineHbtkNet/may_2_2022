import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/src/provider.dart';
import 'package:simo_v_7_0_1/apis/getProduct.dart';
import 'package:simo_v_7_0_1/constant_strings/constant_strings.dart';
import 'package:simo_v_7_0_1/modals/cart_model.dart';
import 'package:simo_v_7_0_1/modals/category_model.dart';
import 'package:simo_v_7_0_1/modals/json_products_plus_categories.dart';
import 'package:simo_v_7_0_1/modals/product_and_categories_paginated.dart';
import 'package:simo_v_7_0_1/modals/product_model.dart';
import 'package:simo_v_7_0_1/modals/product_pgianted_model.dart';
import 'package:simo_v_7_0_1/providers/provider_two.dart';
import 'package:flutter/material.dart';
import 'package:simo_v_7_0_1/providers/shopping_cart_provider.dart';
import 'package:simo_v_7_0_1/screens/cart_screen.dart';
import 'package:simo_v_7_0_1/screens/selected_product_details.dart';
import 'package:simo_v_7_0_1/screens/start_channel_screen.dart';
import 'package:simo_v_7_0_1/screens/user_orders_screen.dart';
import 'package:simo_v_7_0_1/widgets_utilities/multi_used_widgets.dart';
import 'package:simo_v_7_0_1/widgets_utilities/pop_up_menu_admins.dart';
import 'package:simo_v_7_0_1/widgets_utilities/pop_up_menu_users.dart';
import 'package:simo_v_7_0_1/widgets_utilities/spalsh_screen_widget.dart';
import 'package:simo_v_7_0_1/widgets_utilities/user_app_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'catalogue_widget.dart';


class UserCatalogue extends StatefulWidget {
  const UserCatalogue({Key? key}) : super(key: key);
  static const String id = '/ userpage';
  @override
  State<UserCatalogue> createState() => _UserCatalogueState();
}

class _UserCatalogueState extends State<UserCatalogue> {






  Future  <ProductsAndCategoriesPaginated> getProductsWithCategorySearch({String? category,String? name} ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? spToken = await prefs.getString('spToken');
    print ('spToken==================${spToken}');
    final Map<String, String> _userprofileHeader = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $spToken',};
    Uri _tokenUrl = Uri.parse('https://hbtknet.com/client/bringproductos');
    Map<String, dynamic> body = {
      'category':category ,
      'name': name,};
    http.Response response = await http.post(_tokenUrl, headers: _userprofileHeader,body: jsonEncode(body));
    var  data = jsonDecode(response.body);
    print ('raw_data"""""""=========${data}');
    // ProductsAndCategories productsAndCategories =ProductsAndCategories();
    ProductsAndCategoriesPaginated productsAndCategoriesPaginated =ProductsAndCategoriesPaginated();
    productsAndCategoriesPaginated= await  ProductsAndCategoriesPaginated.fromjson( data );
    return  productsAndCategoriesPaginated;
  }











  Future  <ProductsAndCategoriesPaginated> getProductsWithCategory({String? category,String? name} ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? spToken = await prefs.getString('spToken');
    print ('spToken==================${spToken}');
    final Map<String, String> _userprofileHeader = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $spToken',};
    Uri _tokenUrl = Uri.parse('https://hbtknet.com/client/bringproductos?page=$page');
    Map<String, dynamic> body = {
      'category':category ,
      'name': name,};
    http.Response response = await http.post(_tokenUrl, headers: _userprofileHeader,body: jsonEncode(body));
    var  data = jsonDecode(response.body);
    print ('data"""""""=========${data['productos']['data']}');
    print ('total""""""=========${data['productos']['total']}');
   // ProductsAndCategories productsAndCategories =ProductsAndCategories();
    ProductsAndCategoriesPaginated productsAndCategoriesPaginated =ProductsAndCategoriesPaginated();

    productsAndCategoriesPaginated= await ProductsAndCategoriesPaginated.fromjson( data );




    return  productsAndCategoriesPaginated;
  }

  void showstuff(context, var myString) {
    showDialog(context: context, builder: (context) {return AlertDialog(
            content: myString == null ? ClipRect(child: Image.asset(Constants.ASSET_PLACE_HOLDER_IMAGE),) : ClipRect(child: Image.network('https://hbtknet.com/storage/notes/$myString'),),
            actions: [ElevatedButton(onPressed: () async {Navigator.of(context).pop();}, child: Center(child: Text('Ok')))],);});}







  int page =1;
  ProductsAndCategoriesPaginated dataFromApi=ProductsAndCategoriesPaginated();
  List<ProductPaginated>  productList = [];

  List<Category> categoryList = [];
  String nameToBeSearched ='';
  String?  categoryToBeSearched;
  ScrollController _scrollController =ScrollController();
  bool hasMore=true;
  bool isLoadingMore=false;
  String? selectedCategory;
  TextEditingController _nameController = TextEditingController(text: '');
  int totalFromApi =0;

  bool isDownloading=false;
  bool isSearching=false;
  bool  filteredList=false;





  //categoryToBeSearched name:nameToBeSearched

bool onFetchingProcess =false;

  initFetchData() async{
    setState(() {
        onFetchingProcess =true;
        page=1;
      totalFromApi=0;
      productList.clear();
      categoryList.clear();
      });
   dataFromApi = await getProductsWithCategory(category: categoryToBeSearched,name:nameToBeSearched);
      setState(() {
      totalFromApi =dataFromApi.total;
      productList=dataFromApi.listOfProducts;
      categoryList=dataFromApi.listOfCategories;
      page++;

      onFetchingProcess =false;
      });

  }



  loadMoreData() async{
    onFetchingProcess =true;
    if(isLoadingMore){ return;}
    setState(() {
      isLoadingMore=true;
    });
    ProductsAndCategoriesPaginated  newData =
    await getProductsWithCategory(category: categoryToBeSearched,name:nameToBeSearched);
    setState(() {
        productList.addAll(newData.listOfProducts);
        page++;
        isLoadingMore=false;
        onFetchingProcess =false;
      });
  }

  @override
  void initState()
  {
    super.initState();
    initFetchData();


    _scrollController.addListener(() async{
      if(_scrollController.position.pixels ==_scrollController.position.maxScrollExtent) {
        if (productList.length  >= totalFromApi  ){
          setState(() { hasMore=false;});
        } else{
          hasMore=true;
          loadMoreData();

        }

      }
    });

  }
  @override void  dispose(){_scrollController.dispose();super.dispose();}



  @override
 Widget build(BuildContext context) {



    return Scaffold(body: SafeArea(
         child: Column(
          children: [
          PopUpMenuWidgetUsers(putArrow: false, showcart:true,voidCallbackCart: () {Navigator.of(context).pushNamed(UserCart.id);},),
            SizedBox(height: 10,),


            Card(
                child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                   child: Column(
                      children: [


                        buildDropDownSearch(conditionVar:categoryToBeSearched, label:'Escoger una categoria', valueParam: categoryToBeSearched,
                            onChanged: (value) {setState(() {categoryToBeSearched=value!;});}, list: categoryList), SizedBox(height: 10,),


                                      TextField(controller: _nameController,
                                      onChanged: (value) {
                                      nameToBeSearched  = value;
                                      }, decoration: InputDecoration(
                                        hintText: 'Buscar un producto', label:Text('Buscar un producto') ,
                                        suffixIcon: IconButton(
                                          onPressed:(){
                                            setState(() {

                                              _nameController = TextEditingController(text: '');
                                               nameToBeSearched='';
                                            });

                                             },
                                          icon: Icon(Icons.clear),
                                        ), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),),),

                        TextButton(onPressed:(){
                          initFetchData();
                        },
                          child: Container(margin: EdgeInsets.only(top: 10), width: double.infinity,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.0), color: Colors.blueGrey), child: Padding(padding: const EdgeInsets.all(8.0),
                                child: Center(child: Text('Buscar',style: TextStyle(fontSize: 20),)),)),)]))),



















                  productList.isEmpty && onFetchingProcess==true ? SpinKitWave(color: Colors.green, size: 50.0,)
                  :productList.isEmpty && onFetchingProcess==false? Container( decoration:
                  BoxDecoration(color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No hay productos',style: TextStyle(fontSize: 20,color: Colors.white),),
                      )):



            Expanded(
                     child: Scrollbar(
                       thickness: 10,
                       child: GridView.builder(

                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                             crossAxisCount: 2,
                             childAspectRatio: 1.0,
                             crossAxisSpacing: 0.0,
                             mainAxisSpacing: 5,
                             mainAxisExtent: 250,
                           ),
                           controller: _scrollController,
                           itemCount: productList.length +1  ,
                           itemBuilder: (BuildContext ctx, index) {


                             if(index < productList.length){  SelectedProductDetails;
                                return catalogue( index:index,context:context,product: productList);}


                                      else{

                                        return   hasMore ? SpinKitWave(color: Colors.green, size: 50.0,): SizedBox(height: 0,);

                                      }
                                              }
                                             ),
                                         ),
                                           ) ,



          ],
        ),
      ),
    );
  }


  Widget buildDropDownSearch(
      {
        String ? conditionVar,
        required String? valueParam,
        required String? Function(String? value) onChanged,
        final List? list,
        final String? label


      }) {
    return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          prefixIcon:
          conditionVar==null?
          IconButton(icon: Icon(Icons.category_rounded,color: Colors.green,size: 30,),
            onPressed: () { print('testing '); },)
              :
          IconButton(icon: Icon(Icons.clear,color: Colors.red,size: 30,),
            onPressed: () {
              categoryToBeSearched=null;
              print('testing ');
              setState(() {});
            },),


          label: Text(
            label ?? '',
            style: TextStyle(fontSize: 18, color: Colors.blue),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),

        value: valueParam ,
        onChanged: onChanged,
        validator: (value) => value == null ? 'Este campo es obligatorio' : null,
        items: list?.map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
          value: value.id.toString(),
          child: Text(value.nombre_categoria.toString()),)).toList());
  }

}

