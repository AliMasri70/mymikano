import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mymikano_app/models/RFQModel.dart';
import 'package:mymikano_app/models/StoreModels/AddressModel.dart';
import 'package:mymikano_app/models/StoreModels/OrderModel.dart';
import 'package:mymikano_app/models/StoreModels/ProductCartModel.dart';
import 'package:mymikano_app/models/StoreModels/ProductFavoriteModel.dart';
import 'package:mymikano_app/models/StoreModels/ProductModel.dart';
import 'package:mymikano_app/services/DioClass.dart';
import 'package:mymikano_app/utils/appsettings.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomerService {
  Dio dio = new Dio();

  Future<bool> addShippingAddress(Address address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response response = await dio.post(
          MikanoShopAddShippingAddress.replaceAll(
              "{customerId}", prefs.getString("StoreCustomerId").toString()),
          options: Options(headers: {
            "Authorization": "Bearer ${prefs.getString("StoreToken")}"
          }),
          data: {
            "city": address.city,
            "address1": address.address1,
            "first_name": address.firstName,
            "last_name": address.lastName,
            "email": address.email,
            "country_id": 2,
            "state_province_id": 2,
            "zip_postal_code": "1001",
            "phone_number": address.phoneNumber,
          });

      Response response2 = await dio.post(
          MikanoShopAddBillingAddress.replaceAll(
              "{customerId}", prefs.getString("StoreCustomerId").toString()),
          options: Options(headers: {
            "Authorization": "Bearer ${prefs.getString("StoreToken")}"
          }),
          data: {
            "city": address.city,
            "address1": address.address1,
            "first_name": address.firstName,
            "last_name": address.lastName,
            "email": address.email,
            "country_id": 2,
            "state_province_id": 2,
            "zip_postal_code": "1001",
            "phone_number": address.phoneNumber,
          });

      if (response.statusCode == 200 && response2.statusCode == 200) {
        toast("Address Added Successfully");
        return true;
      } else {
        toast("Address Not Added");
        throw Exception('Failed to add shipping address');
      }
    } catch (e) {
      toast(e.toString());
      return false;
    }
  }

  Future<Address> GetShippingAddresseForLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var chosenAddress;
    Response response = await dio.get(
      MikanoShopGetLoggedInUser,
      options: Options(headers: {
        "Authorization": "Bearer ${prefs.getString("StoreToken")}"
      }),
    );
    if (response.statusCode == 200) {
      try {
        chosenAddress =
            Address.fromJson(response.data['customers'][0]['shipping_address']);
        return chosenAddress;
      } catch (e) {
        debugPrint(e.toString());
        return Address();
      }
    } else {
      throw Exception('Failed to get shipping addresses');
    }
  }

  Future<List<Address>> GetShippingAddressesForLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response = await dio.get(
      MikanoShopGetLoggedInUser,
      options: Options(headers: {
        "Authorization": "Bearer ${prefs.getString("StoreToken")}"
      }),
    );
    if (response.statusCode == 200) {
      List<Address> addresses = [];
      try {
        Address chosenAddress =
            Address.fromJson(response.data['customers'][0]['shipping_address']);
        var addressesdata = response.data['customers'][0]['addresses'];
        for (var item in addressesdata) {
          Address temp = Address.fromJson(item);
          if (chosenAddress.id != temp.id) {
            addresses.add(temp);
          } else {
            temp.chosen = true;
            addresses.add(temp);
          }
        }
        return addresses;
      } catch (e) {
        debugPrint(e.toString());
        return addresses;
      }
    } else {
      throw Exception('Failed to get shipping addresses');
    }
  }

  Future<List<FavoriteProduct>> getAllFavoriteItemsforLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response response = await dio.get(
        MikanoFavoritAndCartItems,
        queryParameters: {
          "ShoppingCartType": "Wishlist",
          "CustomerId": prefs.getString("StoreCustomerId").toString()
        },
        options: Options(headers: {
          "Authorization": "Bearer ${prefs.getString("StoreToken")}"
        }),
      );
      if (response.statusCode == 200) {
        List<FavoriteProduct> products = [];
        try {
          var productsdata = response.data["shopping_carts"];
          for (var item in productsdata) {
            Product temp = Product.fromJson(item["product"]);
            temp.liked = true;
            FavoriteProduct t = FavoriteProduct(product: temp, id: item["id"]);
            products.add(t);
          }
          return products;
        } catch (e) {
          debugPrint(e.toString());
          return products;
        }
      } else {
        throw Exception('Failed to get shipping addresses');
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<bool> deleteFavoriteItemsforLoggedInUser(List<int?> arr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response response = await dio.delete(
        MikanoDeleteFavoritAndCartItems,
        queryParameters: {
          "Ids": arr,
          "ShoppingCartType": "Wishlist",
          "CustomerId": prefs.getString("StoreCustomerId").toString()
        },
        options: Options(headers: {
          "Authorization": "Bearer ${prefs.getString("StoreToken")}"
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete item from favorites');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to delete item from favorites');
    }
  }

  Future<void> deleteCartItemsforLoggedInUser(List<int?> arr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response = await dio.delete(
      MikanoDeleteFavoritAndCartItems,
      queryParameters: {
        "Ids": arr,
        "ShoppingCartType": "ShoppingCart",
        "CustomerId": prefs.getString("StoreCustomerId").toString()
      },
      options: Options(headers: {
        "Authorization": "Bearer ${prefs.getString("StoreToken")}"
      }),
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete item from Cart');
    }
  }

  Future<List<CartProduct>> getAllCartItemsforLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response response = await dio.get(
        MikanoFavoritAndCartItems,
        queryParameters: {
          "ShoppingCartType": "ShoppingCart",
          "CustomerId": prefs.getString("StoreCustomerId").toInt()
        },
        options: Options(headers: {
          "Authorization": "Bearer ${prefs.getString("StoreToken")}"
        }),
      );
      if (response.statusCode == 200) {
        List<CartProduct> products = [];
        try {
          var productsdata = response.data["shopping_carts"];
          for (var item in productsdata) {
            CartProduct temp = CartProduct.fromJson(item);
            products.add(temp);
          }
          return products;
        } catch (e) {
          debugPrint(e.toString());
          return products;
        }
      } else {
        throw Exception('Failed to get cart Items');
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<CartProduct> addCartItemsforLoggedInUser(CartProduct product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response response = await dio.post(
        MikanoFavoritAndCartItems,
        data: {
          "shopping_cart_item": {
            "quantity": product.quantity,
            "shopping_cart_type": "ShoppingCart",
            "product_id": product.product.id,
            "customer_id": prefs.getString("StoreCustomerId").toInt(),
          }
        },
        options: Options(headers: {
          "Authorization": "Bearer ${prefs.getString("StoreToken")}"
        }),
      );
      if (response.statusCode == 200) {
        var data = response.data["shopping_carts"]
            [response.data["shopping_carts"].length - 1];
        CartProduct result = CartProduct(
            product: Product.fromJson(data["product"]),
            quantity: data["quantity"],
            id: data["id"]);
        return result;
      } else {
        throw Exception('Failed to add to cart');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to add to cart');
    }
  }

  Future<FavoriteProduct> addFavoriteItemsforLoggedInUser(
      Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response = await dio.post(
      MikanoFavoritAndCartItems,
      data: {
        "shopping_cart_item": {
          "quantity": 1,
          "shopping_cart_type": "Wishlist",
          "product_id": product.id,
          "customer_id": prefs.getString("StoreCustomerId").toInt(),
        }
      },
      options: Options(headers: {
        "Authorization": "Bearer ${prefs.getString("StoreToken")}"
      }),
    );
    if (response.statusCode == 200) {
      var data = response.data["shopping_carts"]
          [response.data["shopping_carts"].length - 1];
      FavoriteProduct result = FavoriteProduct(
          product: Product.fromJson(data["product"]), id: data["id"]);
      return result;
    } else {
      throw Exception('Failed to add to cart');
    }
  }

  Future<void> ChangeQuantityCartProductforLoggedInUser(
      CartProduct product, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response response = await dio.post(
        MikanoChangeQuantityCartItem,
        queryParameters: {
          "Ids": [product.id],
          "ShoppingCartType": "ShoppingCart",
          "CustomerId": prefs.getString("StoreCustomerId").toInt()
        },
        data: quantity,
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${prefs.getString("StoreToken")}"
        }),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to Change Quantity');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to Change Quantity');
    }
  }


  Future<bool> checkLocationServicesEnabled() async {
    LocationPermission permission;
    bool serviceEnabled = false;

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Location permission is permanently denied, handle accordingly
      serviceEnabled = false;
      return serviceEnabled;
    }

    // Request location permission if it is not granted
    if (permission == LocationPermission.denied) {
      // Location permission is denied, handle accordingly
      serviceEnabled = false;
      return serviceEnabled;
    }

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled, handle accordingly
      serviceEnabled = true;
      return serviceEnabled;
    }

    return serviceEnabled;
    // return serviceEnabled;;
    // Location services are enabled, proceed with your logic
    // ...
  }

  Future<bool> getNotificationsState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = await DioClass.getDio();
    Response response = await dio.get(
      MikanoShopGetNotificationsState.replaceAll(
          "{id}", prefs.getString("UserID").toString()),
      options: Options(
        headers: {"Authorization": "Bearer ${prefs.getString("accessToken")}"},
      ),
    );
    if (response.statusCode == 200) {
      try {
        return response.data;
      } catch (e) {
        debugPrint(e.toString());
        return false;
      }
    } else {
      throw Exception('Failed to get Notifications State');
    }
  }

  Future<bool> setNotificationsState(bool state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = await DioClass.getDio();
    String url = MikanoShopSetNotificationsState.replaceAll(
        "{id}", prefs.getString("UserID").toString());
    Response response = await dio.put(
      url,
      queryParameters: {"notificationsEnabled": state},
      options: Options(
        headers: {"Authorization": "Bearer ${prefs.getString("accessToken")}"},
      ),
    );
    if (response.statusCode == 204) {
      try {
        return state;
      } catch (e) {
        debugPrint(e.toString());
        return false;
      }
    } else {
      throw Exception('Failed to accept terms and services');
    }
  }

  Future<bool> getTermsState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = await DioClass.getDio();
    Response response = await dio.get(
      MikanoShopGetTermsState.replaceAll(
          "{id}", prefs.getString("UserID").toString()),
      options: Options(
        headers: {"Authorization": "Bearer ${prefs.getString("accessToken")}"},
      ),
    );
    if (response.statusCode == 200) {
      try {
        return response.data;
      } catch (e) {
        debugPrint(e.toString());
        return false;
      }
    } else {
      throw Exception('Failed to get shipping addresses');
    }
  }

  Future<bool> setTermsState(bool state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = await DioClass.getDio();
    String url = MikanoShopSetTermsState.replaceAll(
        "{id}", prefs.getString("UserID").toString());
    Response response = await dio.put(
      url,
      queryParameters: {"termsAccepted": state},
      options: Options(
        headers: {"Authorization": "Bearer ${prefs.getString("accessToken")}"},
      ),
    );
    if (response.statusCode == 204) {
      try {
        return true;
      } catch (e) {
        debugPrint(e.toString());
        return false;
      }
    } else {
      throw Exception('Failed to accept terms and services');
    }
  }

  Future<void> postContactUsRequest(
      String fullname, String email, String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = await DioClass.getDio();
    String url = MikanoShopContactUs;
    try {
      Response response = await dio.post(url,
          options: Options(headers: {
            "Authorization": "Bearer ${prefs.getString("accessToken")}"
          }),
          data: {"fullName": fullname, "email": email, "message": message});
      if (response.statusCode == 201) {
        toast("Request sent successfully");
        return;
      } else {
        toast("Failed to send request");
        return;
      }
    } catch (e) {
      toast("Failed to send request");
      return;
    }
  }

  Future<void> resetPassword(String email) async {
    String url = MikanoShopResetPassword;
    try {
      Response response = await dio.post(url, data: {"username": email});
      if (response.statusCode == 200) {
        toast(
            "If the mail exists, you will receive an email with instructions");
        return;
      } else {
        toast("Something went wrong");
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
      toast("Something went wrong");
      return;
    }
  }

  Future<bool> Checkout(Address add, List<CartProduct> products, bool byCard,
      String reference) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    add.customerAttributes = "";
    add.address2 = add.address1;
    try {
      Response response = await dio.post((MikanoShopPlaceOrder),
          data: {
            "order": {
              "payment_method_system_name": byCard
                  ? "Payments.CheckMoneyOrder"
                  : "Payments.CheckMoneyOrder",
              "shipping_method": "Shipping.FixedByWeightByTotal",
              "customer_id": prefs.getString("StoreCustomerId").toInt(),
              "billing_address": {
                "first_name": add.firstName,
                "last_name": add.lastName,
                "email": add.email,
                "company": add.company,
                "country_id": add.countryId,
                "country": add.country,
                "state_province_id": add.stateProvinceId,
                "city": add.city,
                "address1": add.address1,
                "address2": add.address2,
                "zip_postal_code": add.zipPostalCode,
                "phone_number": add.phoneNumber,
                "fax_number": add.faxNumber,
                "customer_attributes": add.customerAttributes,
                "created_on_utc": add.createdOnUtc,
                "province": add.province,
                "id": add.id
              },
              "shipping_address": {
                "first_name": add.firstName,
                "last_name": add.lastName,
                "email": add.email,
                "company": add.company,
                "country_id": add.countryId,
                "country": add.country,
                "state_province_id": add.stateProvinceId,
                "city": add.city,
                "address1": add.address1,
                "address2": add.address2,
                "zip_postal_code": add.zipPostalCode,
                "phone_number": add.phoneNumber,
                "fax_number": add.faxNumber,
                "customer_attributes": add.customerAttributes,
                "created_on_utc": add.createdOnUtc,
                "province": add.province,
                "id": add.id
              },
            }
          },
          options: Options(headers: {
            'Authorization': 'Bearer ${prefs.getString("StoreToken")}',
          }));
      if (response.statusCode == 200) {
        Order order = Order.fromJson(response.data['orders'][0]);
        if (byCard) {
          await dio.put(
              MikanoShopVerifyandMarkAsPaidOrder.replaceFirst(
                      "{id}", order.id.toString())
                  .replaceFirst("{reference}", reference.toString()),
              options: Options(headers: {
                'Authorization': 'Bearer ${prefs.getString("StoreToken")}',
              }));
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<List<Order>> getOrdersByCustomerID(
      {int limit = -1, int page = -1}) async {
    List<Order> orders = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> params = {};
    if (limit != -1) {
      params["limit"] = limit;
    }
    if (page != -1) {
      params["page"] = page;
    }
    // params['Fields'] = Params;
    try {
      Response response = await dio.get(
        MikanoShopGetOrdersByCustomerIdURL.replaceAll(
            '{customerID}', prefs.getString("StoreCustomerId").toString()),
        queryParameters: params,
        options: Options(headers: {
          "Authorization": "Bearer ${prefs.getString("StoreToken")}"
        }),
      );
      if (response.statusCode == 200) {
        try {
          for (var item in response.data['orders']) {
            Order order = Order.fromJson(item);
            orders.add(order);
          }
          return orders;
        } catch (e) {
          debugPrint(e.toString());
          return orders;
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      debugPrint(e.toString());
      return orders;
    }
  }

  Future<bool> deleteAddress(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response response = await dio.delete(
        MikanoShopDeleteAddress.replaceAll(
                '{customerId}', prefs.getString("StoreCustomerId").toString())
            .replaceAll("{addressId}", id.toString()),
        options: Options(headers: {
          "Authorization": "Bearer ${prefs.getString("StoreToken")}"
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete Address');
      }
    } catch (e) {
      throw Exception('Failed to delete Address');
    }
  }

  Future<bool> deleteAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response response = await dio.delete(
        MikanoShopDeleteLoggedInUser,
        options: Options(headers: {
          "Authorization": "Bearer ${prefs.getString("StoreToken")}"
        }),
      );
      Response res2 = await dio.delete(
        userDeleteInfoUrl.replaceAll(
            "{id}", prefs.getString('UserID').toString()),
        options: Options(headers: {
          "Authorization": "Bearer ${prefs.getString("accessToken")}"
        }),
      );
      if (response.statusCode == 200 && res2.statusCode! >= 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> requestAQuote(RFQ rfq, int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Todo the logic
    try {
      Response response = await dio.post(
        MikanoShopRfq,
        data: {
          "rfq": {
            "name": rfq.name,
            "email": rfq.email,
            "phone": rfq.phone,
            "address": rfq.address,
            "note": rfq.note,
            "product_id": productId,
            "customer_id": prefs.getString("StoreCustomerId").toString(),
          }
        },
        options: Options(headers: {
          "Authorization": "Bearer ${prefs.getString("StoreToken")}"
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
