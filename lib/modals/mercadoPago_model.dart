import 'cart_model.dart';

class MercadoPagoModelPlaceOrder{


  String? valueSataus='';
  String? manera_entrega='';
  String? manera_pago='';
  List<CartModel>  listOfCartModel;
  double grandTotalVar=0.0;
  double grandTotalBaseVar=0.0;
  double grandTotalTaxesVar =0.0;
  double grandTotalDiscountVar=0.0;

  MercadoPagoModelPlaceOrder({
    required this.valueSataus,
    required this.manera_entrega,
    required this.manera_pago,
     required this.listOfCartModel,
    required this.grandTotalVar,
    required this.grandTotalBaseVar,
    required this.grandTotalTaxesVar,
    required this.grandTotalDiscountVar,


  });
}
