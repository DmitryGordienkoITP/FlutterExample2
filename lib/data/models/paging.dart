import '../../core/common/enums/sort_direction_type.dart';

class Paging<T> {
  int pageIndex;
  int pageSize;
  int total;
  int totalPages;
  SortDirectionType sortDirectionType;
  String sort;
  List<T> items;

  Paging(
    this.pageIndex,
    this.pageSize,
    this.total,
    this.totalPages,
    this.sortDirectionType,
    this.sort,
    this.items,
  );

  bool get isLastPage => pageIndex == totalPages - 1;
  int get nextPageIndex => isLastPage ? pageIndex : pageIndex + 1;

  static Paging<T> empty<T>() {
    return Paging<T>(0, 0, 0, 0, SortDirectionType.asc, '', []);
  }

  static Paging<T> fromMap<T>(dynamic obj) {
    var result = Paging<T>(0, 0, 0, 0, SortDirectionType.asc, '', []);
    result.pageIndex = obj['pageIndex'] ?? 0;
    result.pageSize = obj['pageSize'] ?? 0;
    result.total = obj['total'] ?? 0;
    result.totalPages = obj['totalPages'] ?? 0;
    result.sortDirectionType =
        SortDirectionType.values[obj['sortDirectionType'] ?? 0];
    result.sort = obj['sort'] ?? 'unknown';
    //final items = obj['items'] as List<T>;

    return result;
  }
}
