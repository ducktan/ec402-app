import 'package:get/get.dart';
import 'package:ec402_app/services/cart_api.dart';
import 'package:ec402_app/utils/helpers/user_session.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  // Observables for state management
  var isLoading = false.obs;
  var cartItems = <Map<String, dynamic>>[].obs;
  var cartCount = 0.obs;
  var totalPrice = 0.0.obs;
  var errorMessage = ''.obs; // For displaying errors

  @override
  void onInit() {
    super.onInit();
    fetchCart(); // Fetch cart on initialization
  }

  /// Fetch all cart items from the backend
  Future<void> fetchCart() async {
    try {
      isLoading.value = true;
      errorMessage.value = ''; // Clear previous errors
      final token = await UserSession.getToken();
      if (token == null) {
        errorMessage.value = 'Bạn chưa đăng nhập. Vui lòng đăng nhập để xem giỏ hàng.';
        isLoading.value = false;
        cartItems.value = []; // Ensure cart is empty
        _updateCartMetrics();
        return;
      }

      final items = await CartAPI.getCartItems(token);
      if (items != null) {
        cartItems.value = List<Map<String, dynamic>>.from(items);
        _updateCartMetrics();
      } else {
        // Handle cases where API returns null but no exception, maybe a 404
        errorMessage.value = 'Không thể tải giỏ hàng từ server.';
      }
    } catch (e) {
      errorMessage.value = 'Lỗi khi tải giỏ hàng: ${e.toString()}';
      print("Error fetchCart: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Add a product to the cart
  Future<void> addToCart({required int productId, int quantity = 1}) async {
    try {
      isLoading.value = true;
      errorMessage.value = ''; // Clear previous errors
      final token = await UserSession.getToken();
      if (token == null) {
        errorMessage.value = 'Vui lòng đăng nhập để thêm sản phẩm.';
        return;
      };

      final data = {'product_id': productId, 'quantity': quantity};
      final success = await CartAPI.addItemToCart(data, token);

      if (success) {
        await fetchCart(); // Refresh the cart
      } else {
        errorMessage.value = 'Không thể thêm sản phẩm vào giỏ hàng.';
      }
    } catch (e) {
      errorMessage.value = 'Lỗi: ${e.toString()}';
      print("Error addToCart: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Update quantity of a specific item in the cart
  Future<void> updateCartItemQuantity(int cartItemId, int quantity) async {
    // Prevent quantity from being less than 1, trigger delete instead
    if (quantity < 1) {
      deleteCartItem(cartItemId);
      return;
    }
    
    // Find the item in the local cart list
    int index = cartItems.indexWhere((item) => item['id'] == cartItemId);
    if (index == -1) return; // Item not found locally, should not happen

    try {
      isLoading.value = true;
      errorMessage.value = ''; // Clear previous errors
      final token = await UserSession.getToken();
      if (token == null) {
        errorMessage.value = 'Vui lòng đăng nhập để thực hiện thao tác này.';
        return;
      }

      // Get the product ID to send to the backend
      final productId = cartItems[index]['product']?['id'] as int?;
      if (productId == null) {
        errorMessage.value = 'ID sản phẩm không hợp lệ.';
        return;
      }
      
      final success = await CartAPI.updateCartItem(productId, quantity, token);
      
      if (success) {
        // Update the item locally for instant UI feedback
        cartItems[index]['quantity'] = quantity;
        _updateCartMetrics(); // Recalculate total count and price
      }
      // If not success, the snackbar error is shown from CartAPI
    } catch (e) {
      errorMessage.value = 'Lỗi: ${e.toString()}';
      print("Error updateCartItemQuantity: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Remove an item from the cart
  Future<void> deleteCartItem(int cartItemId) async {
    // Find the item in the local cart list
    int index = cartItems.indexWhere((item) => item['id'] == cartItemId);
    if (index == -1) return; // Item not found locally

    try {
      isLoading.value = true;
      errorMessage.value = ''; // Clear previous errors
      final token = await UserSession.getToken();
      if (token == null) {
        errorMessage.value = 'Vui lòng đăng nhập để thực hiện thao tác này.';
        return;
      }
      
      // Get the product ID to send to the backend
      final productId = cartItems[index]['product']?['id'] as int?;
      if (productId == null) {
        errorMessage.value = 'ID sản phẩm không hợp lệ.';
        return;
      }

      final success = await CartAPI.deleteCartItem(productId, token);
      if (success) {
        // Remove the item from the local list to update UI instantly
        cartItems.removeAt(index);
        _updateCartMetrics(); // Recalculate total
      }
      // If not success, the snackbar error is shown from CartAPI
    } catch (e) {
      errorMessage.value = 'Lỗi: ${e.toString()}';
      print("Error deleteCartItem: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Recalculates total count and price
  void _updateCartMetrics() {
    int count = 0;
    double total = 0.0;
    for (var item in cartItems) {
      final quantity = item['quantity'] as int? ?? 0;
      count += quantity;

      // Safely parse the price, which might be a String or a num
      final priceValue = item['product']?['price'];
      double price = 0.0;
      if (priceValue is String) {
        price = double.tryParse(priceValue) ?? 0.0;
      } else if (priceValue is num) {
        price = priceValue.toDouble();
      }
      
      total += quantity * price;
    }
    cartCount.value = count;
    totalPrice.value = total;
    cartItems.refresh(); // Notify listeners to rebuild
  }
}
