import 'package:get/get.dart';
import 'package:firebasework/model/BlogModel.dart';

class CategoriesBlogsController extends GetxController {
  final categories = [
    "Technology", "Education", "Health & Wellness", "Travel", "Food", "Business",
    "Science", "Lifestyle", "Entertainment", "Sports", "Art & Design", "News",
    "Personal Development", "Others"
  ];

  var selectedCategory = "Technology".obs;
  var customCategory = "".obs;

  // This should be set from the parent (HomeScreen) whenever blogs are fetched
  var allBlogs = <BlogModel>[].obs;

  List<BlogModel> get filteredBlogs {
    if (selectedCategory.value == "Others") {
      return customCategory.value.isNotEmpty
          ? allBlogs.where((blog) =>
      blog.category.toLowerCase() == customCategory.value.toLowerCase()).toList()
          : [];
    }
    return allBlogs.where((blog) => blog.category == selectedCategory.value).toList();
  }

  void selectCategory(String cat) {
    selectedCategory.value = cat;
    if (cat != "Others") customCategory.value = "";
  }

  void setCustomCategory(String val) {
    customCategory.value = val;
  }

  void setBlogs(List<BlogModel> blogs) {
    allBlogs.value = blogs;
  }
}