import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../../data/models/product_model.dart';
import '../../../../../core/services/product_service.dart';
import '../../../../shared/app_divider.dart';
import '../../../../shared/custom_app_bar.dart';
import '../../../../shared/empty_list_placeholder.dart';
import '../../../../themes/palette.dart';
import '../../../../themes/styles/app_text_styles.dart';
import '../../../../themes/styles/appbar_styles.dart';

class _ViewModelState {
  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];

  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final _state = _ViewModelState();
  bool isLoading = false;
  _ViewModelState get state => _state;

  final ProductService productService = GetIt.instance.get<ProductService>();

  final scrollController = ScrollController();

  _ViewModel() {
    getProducts();
  }

  Future<void> getProducts({bool force = false}) async {
    isLoading = true;
    notifyListeners();
    state.products = await productService.getAll(force: force);
    state.filteredProducts = state.products;
    isLoading = false;
    notifyListeners();
  }

  filterProducts(String? searchString) async {
    if (scrollController.hasClients) scrollController.jumpTo(0);
    if (searchString == null || searchString.isEmpty) {
      state.filteredProducts = state.products;
    } else {
      state.filteredProducts =
          state.products.where((el) => el.isLike(searchString)).toList();
    }
    notifyListeners();
  }

  selectItem(BuildContext context, ProductModel item) {
    Navigator.pop(context, item);
  }
}

class ProductSelectionModal extends StatelessWidget {
  const ProductSelectionModal({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const ProductSelectionModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: WillPopScope(
        onWillPop: () async {
          FocusScope.of(context).unfocus();
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppPalette.white,
          appBar: CustomAppBar(
            centerTitle: true,
            title: Text('Выбор груза', style: AppBarStyles.subScreenTitle()),
          ),
          body: Column(
            children: const [
              _SearchField(),
              AppDivider(),
              _ProductsList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<_ViewModel>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CupertinoSearchTextField(onChanged: vm.filterProducts),
    );
  }
}

class _ProductsList extends StatelessWidget {
  const _ProductsList();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<_ViewModel>();
    final products = vm.state.filteredProducts;
    return Expanded(
      child: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: () => vm.getProducts(force: true),
                  child: ListView.separated(
                    controller: vm.scrollController,
                    separatorBuilder: (context, index) => const AppDivider(),
                    itemCount: products.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => vm.selectItem(context, products[index]),
                      child: buildItem(products[index]),
                    ),
                  ),
                )
              : const EmptyListPlaceholder('Нет подходящих грузов'),
    );
  }

  Padding buildItem(ProductModel product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        product.publicName,
        style: AppTextStyles.bodySM,
      ),
    );
  }
}
