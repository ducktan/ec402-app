import 'package:get/get.dart';
import '../../../services/review_api.dart';
import '../../../utils/helpers/user_session.dart';

class ReviewController extends GetxController {
  // === Reactive state ===
  var isLoading = false.obs;

  var reviews = <Map<String, dynamic>>[].obs;
  var avgRating = 0.0.obs;
  var reviewsCount = 0.obs;
  var previewReviews = <Map<String, dynamic>>[].obs;
  var starDistribution = <int, int>{}.obs;

  // Token & userId
  String? token;
  int? userId;

  @override
  void onInit() {
    super.onInit();
    _loadUserSession();
  }

  /// Load token + userId từ SharedPreferences
  Future<void> _loadUserSession() async {
    final storedToken = await UserSession.getToken();
    final userInfo = await UserSession.getUserInfo();

    if (storedToken != null && userInfo != null) {
      token = storedToken;
      userId = userInfo['id'] as int;
      print("Loaded user session: userId=$userId token=$token");
    }
  }

  /// Gán token và userId (sau khi login)
  void setAuth({required String authToken, required int userId}) {
    token = authToken;
    this.userId = userId;
  }

  /// Load review theo productId
  Future<void> fetchReviewsByProduct(int productId) async {
    try {
      isLoading(true);
      final data = await ReviewApi.getReviewsByProduct(productId);

      reviewsCount.value = data['count'] ?? 0;
      avgRating.value = double.tryParse(data['avgRating'].toString()) ?? 0.0;

      reviews.assignAll(List<Map<String, dynamic>>.from(data['reviews'] ?? []));
      previewReviews.assignAll(reviews.take(2).toList());

      // Phân bố sao
      starDistribution.clear();
      for (var i = 1; i <= 5; i++) {
        starDistribution[i] = reviews.where((r) => r['rating'] == i).length;
      }
    } catch (e) {
      print("Error fetching reviews: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Thêm review
  Future<bool> addReview({
    required int productId,
    required int rating,
    String? comment,
  }) async {
    if (token == null || userId == null) {
      print("Cannot add review: user not logged in");
      return false;
    }

    try {
      final res = await ReviewApi.addReview(
        productId: productId,
        userId: userId!,
        rating: rating,
        comment: comment,
        token: token!,
      );
      print(res);
      await fetchReviewsByProduct(productId);
      return true;
    } catch (e) {
      print("Error adding review: $e");
      return false;
    }
  }

  // Sửa review
  Future<bool> updateReview({
    required int reviewId,
    required int productId,
    required int rating,
    String? comment,
  }) async {
    if (token == null) return false;

    try {
      final res = await ReviewApi.updateReview(
        reviewId: reviewId,
        rating: rating,
        comment: comment,
        token: token!,
      );
      await fetchReviewsByProduct(productId);
      return true;
    } catch (e) {
      print("Error updating review: $e");
      return false;
    }
  }

  // Xóa review
  Future<bool> deleteReview({
    required int reviewId,
    required int productId,
  }) async {
    if (token == null) return false;

    try {
      final res = await ReviewApi.deleteReview(reviewId: reviewId, token: token!);
      await fetchReviewsByProduct(productId);
      return true;
    } catch (e) {
      print("Error deleting review: $e");
      return false;
    }
  }
}
