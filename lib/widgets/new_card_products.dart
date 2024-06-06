import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_portal/utils/colors.dart';
import '../data/query/product_query.dart';
import '../model/product.dart';
import '../routes/route_name.dart';
import '../utils/helpers.dart';

class NewCardProducts extends StatefulWidget {
  final Product product;
  final bool isBestSeller; // Added parameter for Best Seller tab
  final int index; // Added parameter for item index
  const NewCardProducts({super.key, required this.product, required this.isBestSeller, required this.index});

  @override
  State<NewCardProducts> createState() => _NewCardProductsState();
}

class _NewCardProductsState extends State<NewCardProducts> {
  late Product product;
  late bool isBestSeller;
  late int index;

  int totalTransactions = 0;

  @override
  void initState() {
    super.initState();
    loadTotalTransactions();
    product = widget.product;
    isBestSeller = widget.isBestSeller;
    index = widget.index;

  }

  void loadTotalTransactions() async {
    final productQuery = ProductQuery();
    final total = await productQuery.getTotalTrx();
    setState(() {
      totalTransactions = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0), // Adjust the value as needed
          child: InkWell(
            onTap: () async {
              Navigator.pushNamed(context, RoutesName.productAction, arguments: {
                'productId': product.id,
              });
            },
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 10), // Adjust the height value as needed
                  Text(
                    'Rp ' + formatRupiah(product.price.toInt()),
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: MyColors.primary,
                    ),
                  ),
                ],
              ),
              trailing: isBestSeller
                  ? buildBestSellerTrailing(index)
                  : buildDefaultTrailing(),
            ),
          ),
        ),
        SizedBox(height: 5,),
        Divider(), // Add Divider as separator
      ],
    );
  }


  Widget buildBestSellerTrailing(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (index == 0) SvgPicture.asset('assets/svg/fire_1.svg', height: 30, width: 30),
        if (index == 1) SvgPicture.asset('assets/svg/fire_2.svg', height: 30, width: 30),
        if (index == 2) SvgPicture.asset('assets/svg/fire_3.svg', height: 30, width: 30),
        if (index >= 3)
          Text(
            ' ${index + 1}',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Terjual $totalTransactions',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget buildDefaultTrailing() {
    return SizedBox(
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SvgPicture.asset(
            'assets/svg/icon_cart.svg',
            color: getColorByStock(product.stockType == 0 ? null : product.stock),
            height: 25,
            width: 25,
          ),
          SizedBox(width: 5),
          Text(
            (product.stockType == 0) ? 'Unlimited' : 'Stock : '+ product.stock.toString(),
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: getColorByStock(product.stockType == 0 ? null : product.stock),
            ),
          ),
        ],
      ),
    );
  }
}

