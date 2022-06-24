import 'package:flutter/material.dart';
import 'package:mymikano_app/State/CurrencyState.dart';
import 'package:mymikano_app/State/ProductState.dart';
import 'package:mymikano_app/models/StoreModels/ProductModel.dart';
import 'package:mymikano_app/utils/AppColors.dart';
import 'package:mymikano_app/utils/images.dart';
import 'package:mymikano_app/views/screens/ProductDetailsPage.dart';
import 'package:mymikano_app/views/widgets/AppWidget.dart';
import 'package:provider/provider.dart';

class HorizontalItemElement extends StatelessWidget {
  Product product;
  HorizontalItemElement({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
                  product: product,
                )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(color: lightBorderColor, width: 1))),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                decoration: boxDecoration(
                    radius: 0, showShadow: true, bgColor: Colors.white),
                child: commonCacheImageWidget(
                  product.Image,
                  60,
                  width: 80,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.Name,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins",
                      color: mainBlackColorTheme,
                    ),
                    // overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  Text(
                    product.Code,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins",
                      color: mainGreyColorTheme,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${Provider.of<CurrencyState>(context, listen: false).currency!.currencySymbol} ${product.Price}",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins",
                      color: mainBlackColorTheme,
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Consumer<ProductState>(
                    builder: (context, state, child) => GestureDetector(
                        onTap: () {
                          state.addorremoveProductToFavorite(product);
                        },
                        child: commonCacheImageWidget(ic_heart, 30,
                            color: product.liked ? mainColorTheme : null)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
