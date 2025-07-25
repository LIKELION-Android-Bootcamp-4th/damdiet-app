import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoint/cart_endpoints.dart';
import '../models/cart/cart.dart';
import '../models/cart/discount.dart';

class CartDatasource {
  final dio = ApiClient().dio;

  Future<Cart> fetchCart() async {
    final response = await dio.get(CartEndpoints.getCart);
    if (response.statusCode == 200) {
      return Cart.fromJson(response.data);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: '장바구니 불러오기 실패: ${response.statusCode}',
      );
    }
  }

  Future<void> addToCart({
    required String productId,
    required int quantity,
    required int unitPrice,
    required Discount discount,
  }) async {
    final response = await dio.post(CartEndpoints.postCart, data: {
      'productId': productId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'discount': discount.toJson(),
    });

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: '장바구니 추가 실패: ${response.statusCode}',
      );
    }
  }

  Future<void> removeItems(List<String> cartIds) async {
    final response = await dio.delete(CartEndpoints.deleteCart, data: {'cartIds': cartIds});

    if (response.statusCode != 200) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: '장바구니 아이템 삭제 실패: ${response.statusCode}',
      );
    }
  }

  Future<void> clearCart() async {
    final response = await dio.delete(CartEndpoints.clearCart);

    if (response.statusCode != 200) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: '장바구니 전체 비우기 실패: ${response.statusCode}',
      );
    }
  }

  Future<void> updataQuantity({required String cartId, required int quantity}) async {
    final endpoint = CartEndpoints.updateCartItemQuantity(cartId);
    final response = await dio.patch(endpoint, data: {'quantity': quantity});

    if (response.statusCode != 200) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: '장바구니 수량 변경 실패: ${response.statusCode}',
      );
    }
  }
}
