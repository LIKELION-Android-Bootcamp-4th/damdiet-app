import 'package:damdiet/data/models/product/product.dart';
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoint/cart_endpoints.dart';
import '../../core/network/endpoint/favorite_products_endpoints.dart';
import '../../core/network/endpoint/product_endpoints.dart';
import '../models/cart/cart_request.dart';
import '../models/product/product_query.dart';
import '../models/response/api_response.dart';
import '../models/response/product_list_response.dart';

class ProductDatasource {
  final dio = ApiClient().dio;

  Future<ApiResponse<ProductListResponse>> getProducts({
    required ProductQuery query,
  }) async {
    final uri = ProductEndpoints.getProductsUri(queryParameters: query.toJson());

    final response = await dio.getUri(uri);

    if (response.statusCode == 200) {
      return ApiResponse<ProductListResponse>.fromJson(
        response.data,
        (json) => ProductListResponse.fromJson(json as Map<String, dynamic>),
      );
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'API 호출 실패: ${response.statusCode}',
      );
    }
  }

  Future<ApiResponse<Product>> getProductsDetail({required String id}) async {
    final uri = ProductEndpoints.getProductDetail(productId: id);

    final response = await dio.get(uri);

    if (response.statusCode == 200) {
      return ApiResponse<Product>.fromJson(
        response.data,
            (json) => Product.fromJson(json as Map<String, dynamic>),
      );
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'API 호출 실패: ${response.statusCode}',
      );
    }
  }

  Future<Response> toggleFavorite({required String id}) async {
    final uri = FavoriteProductEndpoints.postFavorite(productId: id);
    final response = await dio.post(uri);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'API 호출 실패: ${response.statusCode}',
      );
    }
  }

  Future<Response> postCart({required CartRequest cartRequest}) async {
    final uri = CartEndpoints.postCart;
    final response = await dio.post(uri, data: cartRequest.toJson());
    if (response.statusCode == 201) {
      return response;
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'API 호출 실패: ${response.statusCode}',
      );
    }
  }

}
