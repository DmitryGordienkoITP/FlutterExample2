import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../core/common/enums/sort_direction_type.dart';
import '../../../core/common/enums/sort_types/product_sort_type.dart';
import '../../models/paging.dart';
import '../../models/product_model.dart';
import '../../../core/environment/app_environment.dart';
import 'base_api_provider.dart';

@Injectable(scope: 'fullAccess')
class ProductAPIProvider extends BaseAPIProvider {
  final _authApiUrl = '${AppEnvironment.apiUrl}/product/lookup';

  Future<Paging<ProductModel>> get({
    int? pageIndex,
    int? pageSize,
    String? search,
    String sort = ProductSortType.ETSNGName,
    SortDirectionType sortDir = SortDirectionType.asc,
  }) async {
    var url = '$_authApiUrl?sort=$sort&sortDir=${sortDir.index}';

    url = pageIndex != null ? '$url&pageIndex=$pageIndex' : url;
    url = pageSize != null ? '$url&pageSize=$pageSize' : url;
    url = search != null ? '$url&search=$search' : url;

    final response = await securedHttp.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    var paging = Paging.fromMap<ProductModel>(responseData);

    final items = responseData['items'] as List<dynamic>;
    for (var el in items) {
      final product = ProductModel.fromMap(el);
      paging.items.add(product);
    }
    return paging;
  }
}
