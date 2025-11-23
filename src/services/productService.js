import axios from 'axios';

const API_URL = 'http://localhost:5000/api/products';

// Tạo instance axios với cấu hình mặc định
const api = axios.create({
  baseURL: 'http://localhost:5000/api',
  headers: {
    'Content-Type': 'application/json',
  },
});

export const productService = {
  // Lấy tất cả sản phẩm
  getAll: async () => {
    try {
      const response = await api.get('/products');
      return response.data.data;
    } catch (error) {
      console.error('Error fetching products:', error);
      throw error;
    }
  },

  // Lấy sản phẩm theo ID
  getById: async (id) => {
    try {
      const response = await api.get(`/products/${id}`);
      return response.data;
    } catch (error) {
      console.error(`Error fetching product ${id}:`, error);
      throw error;
    }
  },

  // Get product images
  getProductImages: async (productId) => {
    try {
      const response = await api.get(`/products/${productId}/images`);
      return response.data.images || [];
    } catch (error) {
      console.error(`Error fetching images for product ${productId}:`, error);
      return [];
    }
  },

  // Thêm sản phẩm mới
  create: async (productData) => {
    try {
      console.log('Gửi yêu cầu tạo sản phẩm với dữ liệu:', JSON.stringify(productData, null, 2));
      
      const response = await api.post('/products', productData, {
        headers: {
          'Content-Type': 'application/json'
        },
        validateStatus: function (status) {
          return status < 500; // Chỉ reject nếu status >= 500
        }
      });
      
      console.log('Phản hồi từ server:', response);
      return response.data;
    } catch (error) {
      console.error('Error creating product:', error);
      throw error;
    }
  },

  // Cập nhật sản phẩm
  update: async (id, productData) => {
    try {
      // Gửi dữ liệu dạng JSON đến endpoint /products/:id
      const response = await api.put(`/products/${id}`, productData);
      return response.data;
    } catch (error) {
      console.error(`Error updating product ${id}:`, error);
      throw error;
    }
  },

  // Xóa sản phẩm
  delete: async (id) => {
    try {
      await api.delete(`/products/${id}`);
    } catch (error) {
      console.error(`Error deleting product ${id}:`, error);
      throw error;
    }
  },

  // Upload product image
  // Upload product image
  uploadImage: async (productId, imageFile) => {
    try {
      const formData = new FormData();
      formData.append('image', imageFile);
      
      const response = await api.post(`/products/${productId}/images`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });
      
      return response.data;
    } catch (error) {
      console.error('Error uploading product image:', error);
      throw error;
    }
  },
  
  // Update product images
  updateProductImages: async (productId, images) => {
    try {
      // Lấy danh sách ảnh hiện có
      const currentImages = await productService.getProductImages(productId);
      
      // Xóa tất cả ảnh cũ
      for (const img of currentImages) {
        try {
          await api.delete(`/product_images/${img.id}`);
        } catch (deleteError) {
          console.error(`Lỗi khi xóa ảnh cũ ${img.id}:`, deleteError);
        }
      }
      
      // Thêm các ảnh mới
      const results = [];
      for (const imageUrl of images) {
        if (imageUrl) {
          try {
            const response = await api.post(`/product_images`, {
              product_id: productId,
              image_url: imageUrl
            });
            results.push(response.data);
          } catch (addError) {
            console.error('Lỗi khi thêm ảnh mới:', addError);
          }
        }
      }
      
      return { success: true, data: results };
    } catch (error) {
      console.error('Lỗi khi cập nhật ảnh sản phẩm:', error);
      throw error;
    }
  },
};
