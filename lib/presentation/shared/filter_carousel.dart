import 'package:flutter/material.dart';

import '../themes/palette.dart';
import '../themes/styles/app_text_styles.dart';

class AppFilterCarousel<T> extends StatefulWidget {
  final List<T> values;
  final List<String> titles;
  final Function(List<T>) onChange;

  const AppFilterCarousel({
    super.key,
    required this.titles,
    required this.onChange,
    required this.values,
  }) : assert(titles.length == values.length);

  @override
  State<AppFilterCarousel<T>> createState() => _AppFilterCarouselState<T>();
}

class _AppFilterCarouselState<T> extends State<AppFilterCarousel<T>> {
  final List<T> filter = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: 16),
          ...buildFilterItems(),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  void setValue(T value) {
    if (filter.contains(value)) {
      filter.remove(value);
    } else {
      filter.add(value);
    }
    setState(() {});
    widget.onChange(filter);
  }

  isSelected(T value) {
    return filter.contains(value);
  }

  List<Widget> buildFilterItems() {
    final List<Widget> result = [];

    for (var i = 0; i < widget.values.length; i++) {
      final buttonWidget = buildFilterButton(
        widget.titles[i],
        widget.values[i],
      );
      result.add(buttonWidget);
    }
    return result;
  }

  Widget buildFilterButton(String label, T value) {
    final isSelectedFilter = isSelected(value);
    return InkWell(
      onTap: () => setValue(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: isSelectedFilter ? AppPalette.accentGreen : AppPalette.gray4,
        ),
        child: Center(
            child: Text(
          label,
          style: AppTextStyles.bodySx.copyWith(
            color: isSelectedFilter ? AppPalette.white : AppPalette.black,
          ),
        )),
      ),
    );
  }
}
