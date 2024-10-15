import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/core/cubit/parent_cubit.dart';
import 'package:mobile_app/dashboard/modules/Cart/Controller/cart_cubit.dart';
import 'package:mobile_app/dashboard/modules/Cart/Controller/cart_state.dart';
import 'package:mobile_app/dashboard/modules/Cart/Model/cart_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/dashboard/modules/Cart/View/constantCart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit()..getData(),
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: _buildCartList(state.cart),
                ),
              ],
            ),
            bottomNavigationBar: InkWell(
              onTap: () {
                Fluttertoast.showToast(
                  msg: "Payment Successful",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Color.fromARGB(255, 26, 63, 144),
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              },
              child: Container(
                color: Color.fromARGB(255, 45, 93, 171),
                alignment: Alignment.center,
                height: 50.0,
                child: const Text(
                  'Proceed to Pay',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCartList(List<Cart> cart) {
    if (cart.isEmpty) {
      return Center(
        child: BlocProvider(
          create: (context) => ParentCubit(),
          child: BlocBuilder<ParentCubit, ParentState>(
            builder: (context, state) {
              return Text(
                'Your Cart is Empty',
                style: Theme.of(context).textTheme.bodyLarge,
              );
            },
          ),
        ),
      );
    } else {
      return my_cart.isEmpty
          ? Center(
              child: Text("NO items Found"),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: my_cart.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5.0,
                  color: Colors.white,
                  // padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          my_cart[index].image.toString(),
                          height: 130,
                          width: 100,
                        ),
                      ),
                      // const SizedBox(width: 8.0),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '${my_cart[index].brand}\n',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.kadwa(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${my_cart[index].model}\n',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                              Text(
                                '${my_cart[index].price} EGP',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: GoogleFonts.kadwa(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      BlocListener<CartCubit, CartState>(
                        listener: (context, state) {},
                        child: Builder(
                          builder: (context) {
                            return PlusMinusButtons(
                              addQuantity: () {
                                context
                                    .read<CartCubit>()
                                    .addQuantity(cart[index].id!);
                              },
                              deleteQuantity: () {
                                context
                                    .read<CartCubit>()
                                    .deleteQuantity(cart[index].id!);
                              },
                              text: cart[index].quantity.toString(),
                            );
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          my_cart.remove(my_cart[index]);
                          // context.read<CartCubit>().removeItem(my_cart[index].id!);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 32, 77, 155),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
    }
  }
}

class PlusMinusButtons extends StatelessWidget {
  final VoidCallback deleteQuantity;
  final VoidCallback addQuantity;
  final String text;
  const PlusMinusButtons({
    Key? key,
    required this.addQuantity,
    required this.deleteQuantity,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: deleteQuantity,
          icon: const Icon(
            CupertinoIcons.minus_circle,
            size: 25,
            color: Colors.black,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: addQuantity,
          icon: Icon(
            CupertinoIcons.plus_circle,
            color: Colors.black,
            size: 25,
          ),
        ),
      ],
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
