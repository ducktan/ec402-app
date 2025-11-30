import axios from 'axios';


// Tạo instance axios với cấu hình mặc định
const api = axios.create({
  baseURL: 'http://localhost:5000/api',
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Thêm interceptor để thêm token vào header
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

export const userService = {
  // Lấy tất cả người dùng (public endpoint)
  getAll: async () => {
    try {
      const response = await api.get('/users/admin');
      return response.data; 
    } catch (error) {
      console.error('Lỗi khi lấy danh sách người dùng:', error);
      throw error;
    }
  },

  // Thêm người dùng mới
  create: async (user) => {
    try {
      // Thêm trường mặc định nếu cần
      const userData = {
        ...user,
        password: user.password || '123456', // Mật khẩu mặc định, có thể thay đổi
        role: user.role || 'buyer' // Vai trò mặc định
      };
      
      const response = await api.post('auth/register', userData);
      return response.data;
    } catch (error) {
      console.error('Lỗi khi thêm người dùng:', error);
      throw error;
    }
  },

  // Cập nhật thông tin người dùng
  update: async (id, user) => {
    try {
      const response = await api.put(`/users/${id}`, user);
      return response.data;
    } catch (error) {
      console.error('Lỗi khi cập nhật người dùng:', error);
      throw error;
    }
  },

  // Xóa người dùng
  delete: async (id) => {
    try {
      const response = await api.delete(`/users/${id}`);
      return response.data;
    } catch (error) {
      console.error('Lỗi khi xóa người dùng:', error);
      throw error;
    }
  },

  // Đăng nhập
  login: async (email, password) => {
    try {
      const response = await api.post('/auth/login', { email, password });
      if (response.data.token) {
        localStorage.setItem('token', response.data.token);
      }
      return response.data;
    } catch (error) {
      console.error('Lỗi khi đăng nhập:', error);
      throw error;
    }
  },

  // Đăng xuất
  logout: () => {
    localStorage.removeItem('token');
  },

  // Lấy thông tin người dùng hiện tại
  getCurrentUser: async () => {
    try {
      const response = await api.get('/users/me');
      return response.data;
    } catch (error) {
      console.error('Lỗi khi lấy thông tin người dùng:', error);
      throw error;
    }
  }
};
