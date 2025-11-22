import React, { useState, useEffect } from "react";
import axios from "axios";
import UserTable from "../components/UserTable";
import UserModal from "../components/UserModal";
import { toast } from "react-toastify";

// Tạo instance axios với baseURL và headers mặc định
const api = axios.create({
  baseURL: "http://localhost:5000/api",
  withCredentials: true, // Cho phép gửi cookie với request
});

const UsersPage = () => {
  const [users, setUsers] = useState([]);
  const [filterRole, setFilterRole] = useState("all");
  const [editingUser, setEditingUser] = useState(null);

  // Lấy danh sách người dùng từ API
  const fetchUsers = async () => {
    try {
      const response = await api.get("/users/all");
      setUsers(response.data);
    } catch (error) {
      console.error("Lỗi khi lấy danh sách người dùng:", error);
      const errorMessage = error.response?.data?.message || "Có lỗi xảy ra khi tải dữ liệu người dùng";
      toast.error(errorMessage);
    }
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  const handleAddUser = async (user) => {
    try {
      const response = await api.post("/users", user);
      toast.success("Thêm người dùng thành công");
      fetchUsers(); // Làm mới danh sách sau khi thêm
      return true;
    } catch (error) {
      console.error("Lỗi khi thêm người dùng:", error);
      const errorMessage = error.response?.data?.message || "Có lỗi xảy ra khi thêm người dùng";
      toast.error(errorMessage);
      return false;
    }
  };

  const handleEditUser = async (updated) => {
    try {
      await api.put(`/users/${updated.id}`, updated);
      toast.success("Cập nhật thông tin thành công");
      fetchUsers(); // Làm mới danh sách sau khi cập nhật
      return true;
    } catch (error) {
      console.error("Lỗi khi cập nhật người dùng:", error);
      const errorMessage = error.response?.data?.message || "Có lỗi xảy ra khi cập nhật thông tin";
      toast.error(errorMessage);
      return false;
    }
  };

  const handleDeleteUser = async (id) => {
    if (!window.confirm("Bạn có chắc chắn muốn xóa người dùng này?")) return;
    
    try {
      await api.delete(`/users/${id}`);
      toast.success("Xóa người dùng thành công");
      fetchUsers(); // Làm mới danh sách sau khi xóa
    } catch (error) {
      console.error("Lỗi khi xóa người dùng:", error);
      const errorMessage = error.response?.data?.message || "Có lỗi xảy ra khi xóa người dùng";
      toast.error(errorMessage);
    }
  };

  const filteredUsers =
    filterRole === "all" ? users : users.filter((u) => u.role === filterRole);

  return (
    <div>

      <div className="container py-4">
        <div className="d-flex justify-content-between align-items-center mb-3">
          <h3>Quản lý người dùng</h3>
          <button
            className="btn btn-primary"
            data-bs-toggle="modal"
            data-bs-target="#userModal"
            onClick={() => setEditingUser(null)}
          >
            <i className="fa fa-plus me-2"></i>Thêm người dùng
          </button>
        </div>

        <div className="mb-3">
          <select
            className="form-select w-auto"
            value={filterRole}
            onChange={(e) => setFilterRole(e.target.value)}
          >
            <option value="all">Tất cả vai trò</option>
            <option value="buyer">Người mua</option>
            <option value="seller">Người bán</option>
            <option value="admin">Quản trị</option>
          </select>
        </div>

        <UserTable
          users={filteredUsers}
          onEdit={setEditingUser}
          onDelete={handleDeleteUser}
        />
      </div>

      <UserModal
        editingUser={editingUser}
        onAdd={handleAddUser}
        onEdit={handleEditUser}
      />
    </div>
  );
};

export default UsersPage;
