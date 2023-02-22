import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/helpers/money_helper.dart';
import '../../../../../core/services/factory_service.dart';
import '../../../../../data/models/factory_model.dart';
import '../../../../../data/models/product_model.dart';
import '../../../../shared/app_divider.dart';
import '../../../../shared/custom_app_bar.dart';
import '../../../../shared/empty_list_placeholder.dart';
import '../../../../themes/palette.dart';
import '../../../../themes/styles/app_text_styles.dart';
import '../../../../themes/styles/appbar_styles.dart';

class _ViewModelState {
  ProductModel? product;
  List<FactoryModel> factories = [];
  List<FactoryModel> filteredFactories = [];

  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final _state = _ViewModelState();
  bool isLoading = false;
  _ViewModelState get state => _state;

  final FactoryService factoryService = GetIt.instance.get<FactoryService>();

  _ViewModel({ProductModel? product}) {
    state.product = product;
    getFactories();
  }

  final scrollController = ScrollController();

  getFactories() async {
    isLoading = true;
    notifyListeners();

    state.factories =
        await factoryService.get(force: true, productId: state.product?.id);

    for (var factory in state.factories) {
      factory.products = factory.products
          .where((element) => element.productId == state.product!.id)
          .toList();
    }
    state.filteredFactories = state.factories;

    isLoading = false;
    notifyListeners();
  }

  filterFactories(String? searchString) async {
    if (scrollController.hasClients) scrollController.jumpTo(0);
    if (searchString == null || searchString.isEmpty) {
      state.filteredFactories = state.factories;
    } else {
      state.filteredFactories =
          state.factories.where((el) => el.isLike(searchString)).toList();
    }
    notifyListeners();
  }

  selectItem(BuildContext context, FactoryModel item) {
    Navigator.pop(context, item);
  }
}

class FactorySelectionModal extends StatelessWidget {
  const FactorySelectionModal({Key? key}) : super(key: key);

  static Widget create({ProductModel? product}) {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(product: product),
      child: const FactorySelectionModal(),
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
            title: Text('Выбор завода', style: AppBarStyles.subScreenTitle()),
          ),
          body: Column(
            children: const [
              _SearchField(),
              AppDivider(),
              _FactoriesList(),
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
      child: CupertinoSearchTextField(onChanged: vm.filterFactories),
    );
  }
}

class _FactoriesList extends StatelessWidget {
  const _FactoriesList();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<_ViewModel>();
    final factories = vm.state.filteredFactories;
    return Expanded(
      child: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : factories.isNotEmpty
              ? ListView.separated(
                  controller: vm.scrollController,
                  separatorBuilder: (context, index) => const AppDivider(),
                  itemCount: factories.length,
                  itemBuilder: (context, index) =>
                      buildItem(context, factories[index]),
                )
              : const EmptyListPlaceholder('Нет подходящих заводов'),
    );
  }

  Widget buildItem(BuildContext context, FactoryModel factory) {
    final vm = context.read<_ViewModel>();
    final product = factory.products[0];
    final formatedPrice = MoneyHelper.format(product.price);
    final formatedDate =
        DateFormat('h:mm:ss d.MM.yyy').format(product.priceUpdatedAt);

    final textStyle = product.isActive
        ? AppTextStyles.bodySM.copyWith(color: AppPalette.black)
        : AppTextStyles.bodySM.copyWith(color: AppPalette.gray1);

    final textStyleBold = textStyle.copyWith(fontWeight: FontWeight.w600);

    return InkWell(
      onTap: product.isActive ? () => vm.selectItem(context, factory) : null,
      child: Container(
        color: product.isActive ? AppPalette.white : AppPalette.gray5,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(factory.name, style: textStyle),
            const SizedBox(height: 2),
            Row(
              children: [
                Text('$formatedPrice руб.', style: textStyleBold),
                Text(' на $formatedDate', style: textStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
