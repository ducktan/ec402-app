import axios from 'axios';

const API_URL = 'http://localhost:5000/api/categories';

export const categoryService = {
  // Lấy tất cả danh mục
  getAll: async () => {
    try {
      const response = await axios.get(API_URL);
      return response.data.data;
    } catch (error) {
      console.error('Error fetching categories:', error);
      throw error;
    }
  },

  // Thêm danh mục mới
  create: async (category) => {
    try {
      const response = await axios.post(API_URL, category);
      return response.data.data;
    } catch (error) {
      console.error('Error creating category:', error);
      throw error;
    }
  },

  // Cập nhật danh mục
  update: async (id, category) => {
    try {
      const response = await axios.put(`${API_URL}/${id}`, category);
      return response.data.data;
    } catch (error) {
      console.error('Error updating category:', error);
      throw error;
    }
  },

  // Xóa danh mục
  delete: async (id) => {
    try {
      await axios.delete(`${API_URL}/${id}`);
    } catch (error) {
      console.error('Error deleting category:', error);
      throw error;
    }
  }
};
