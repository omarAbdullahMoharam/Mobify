import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/dashboard/modules/Cart/Controller/cart_cubit.dart';
import 'package:mobile_app/dashboard/modules/Cart/Controller/cart_state.dart';
import 'package:mobile_app/dashboard/modules/Cart/View/cart_page.dart';
import 'package:mobile_app/dashboard/modules/Cart/View/constantCart.dart';
import 'package:mobile_app/dashboard/modules/users/controller/Mobile_cubit.dart';
import 'package:mobile_app/dashboard/modules/users/model/Entity_model/Product_model.dart';

class ProductItemWidget extends StatelessWidget {
  final ProductModel productModel;
  final ProductCubit controller;
  final List<ProductModel> products;

  ProductItemWidget({
    Key? key,
    required this.productModel,
    required this.controller,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(),
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          final cartCubit = context.read<CartCubit>();

          return Stack(
            children: [
              Card(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Product information
                        Row(
                          children: [
                            if (productModel.image.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.asset(
                                  productModel.image,
                                  height: 180,
                                  width: 100,
                                  fit: BoxFit.fitWidth,
                                ),
                              )
                            else
                              Image.asset(
                                "assets/phone-image/samsungZfold.jpg",
                                height: 130,
                                width: 100,
                                fit: BoxFit.fill,
                              ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  productModel.brand ?? '',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  productModel.model ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  productModel.color ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${productModel.price} EGP',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                const SizedBox(height: 10),
                                PlusMinusButtons(
                                  addQuantity: () {
                                    ;
                                  },
                                  deleteQuantity: () {},
                                  text: '1',
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(thickness: 0.5),
                        // Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Favorite
                            InkWell(
                              child: Icon(
                                productModel.favorite == 1
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                color: Colors.red,
                                size: 35,
                              ),
                              onTap: () {
                                final newState =
                                    productModel.favorite == 1 ? 0 : 1;
                                controller.addToFavourite(
                                    productModel.id, newState);
                              },
                            ),
                            // Separator
                            Container(
                              height: 30,
                              width: 0.5,
                              color: Colors.grey,
                            ),
                            // Cart
                            InkWell(
                              child: Icon(
                                productModel.cart == 1
                                    ? CupertinoIcons.cart_fill
                                    : CupertinoIcons.cart,
                                color: Colors.blue,
                                size: 35,
                              ),
                              onTap: () {
                                if (productModel.cart == 1) {
                                  controller.addToCart(productModel.id, 0);
                                  cartCubit.removeItem(productModel.id);
                                  my_cart.removeWhere((element) =>
                                      element.id == productModel.id);
                                  log("deleted with id ${productModel.id}");
                                } else {
                                  controller.addToCart(productModel.id, 1);
                                  cartCubit.saveData(
                                      products, productModel.id - 1);
                                  my_cart.add(productModel);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 30,
                right: 20,
                child: Container(
                  alignment: Alignment.center,
                  width: 110,
                  height: 25,
                  decoration: BoxDecoration(
                    color: productModel.availabilityState == 1
                        ? Colors.green
                        : Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    productModel.availabilityState == 1
                        ? "In Stock"
                        : "Out of Stock",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
