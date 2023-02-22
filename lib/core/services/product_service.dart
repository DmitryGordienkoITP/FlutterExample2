import 'package:injectable/injectable.dart';

import '../../data/data_providers/api/product_api_provider.dart';
import '../../data/models/paging.dart';
import '../../data/models/product_model.dart';
import '../common/enums/sort_direction_type.dart';
import '../common/enums/sort_types/product_sort_type.dart';

@Singleton(scope: 'fullAccess')
class ProductService {
  List<ProductModel> products = [];

  final ProductAPIProvider _productApi;

  ProductService(this._productApi);

  Future<List<ProductModel>> getAll({bool force = false}) async {
    if (force || products.isEmpty) {
      final result = await _productApi.get(pageSize: 1000000);
      products = result.items;
    }
    return products;
  }

  Future<Paging<ProductModel>> getAllPaged() async {
    return await _productApi.get();
  }

  Future<Paging<ProductModel>> getFilteredPaged({
    String? search,
    String sort = ProductSortType.ETSNGName,
    SortDirectionType sortDir = SortDirectionType.asc,
  }) async {
    return await _productApi.get(
      search: search,
      sort: sort,
      sortDir: sortDir,
    );
  }
}
