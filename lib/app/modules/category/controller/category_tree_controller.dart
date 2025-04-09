import 'package:get/get.dart';
import 'package:shopperz/app/modules/category/model/category_tree.dart';
import 'package:shopperz/app/modules/home/model/category_model.dart';
import 'package:shopperz/data/remote_services/remote_services.dart';

class CategoryTreeController extends GetxController {
  final isLoading = false.obs;
  final categoryTreeList = <CategoryTreeModel>[].obs;

  Future<void> fetchCategoryTree() async {
    isLoading(true);
    final data = await RemoteServices().fetchCategoryTree();
    isLoading(false);

    data.fold((error) => error.toString(), (categoryTree) {
      categoryTreeList.value = categoryTree;
    });
  }

  final categoryModel = CategoryModel().obs;

  Future<void> fetchCategory() async {
    // isLoading(true);
    final data = await RemoteServices().fetchCategory();
    // isLoading(false);
    data.fold((error) => error.toString(), (category) {
      categoryModel.value = category;
    });
  }

  @override
  void onInit() {
    fetchCategory();
    fetchCategoryTree();
    super.onInit();
  }
}
