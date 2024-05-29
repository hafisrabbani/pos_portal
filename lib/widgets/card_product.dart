import 'package:flutter/material.dart';
import 'package:pos_portal/utils/colors.dart';
import '../model/product.dart';
import '../routes/route_name.dart';
import '../utils/helpers.dart';
import '../view_model/product_view_model.dart';

class CardProducts extends StatefulWidget {
  final Product product;
  const CardProducts({super.key, required this.product});

  @override
  State<CardProducts> createState() => _CardProductsState();
}

class _CardProductsState extends State<CardProducts> {
  late Product product;
  late ProductViewModel productViewModel;

  @override
  void initState() {
    super.initState();
    product = widget.product;
    productViewModel = ProductViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: MyColors.secondaryDisabled,
        child: InkWell(
          onTap: () async {
            productViewModel.saveSelectedProductId(product.id ?? 0);
            Navigator.pushNamed(context, RoutesName.productAction);
          },
          child: ListTile(
            title: Text(
              product.name,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              formatRupiah(product.price.toInt()),
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: MyColors.primary,
              ),
            ),
            trailing: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Stock : ',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: getColorByStock(product.stockType == 0 ? null : product.stock),
                    ),
                  ),
                  Text(
                    (product.stockType == 0) ? 'ထ' : product.stock.toString(),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: getColorByStock(product.stockType == 0 ? null : product.stock),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
