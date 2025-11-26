import React, { useState, useEffect } from "react";
import UserTable from "../components/UserTable";
import UserModal from "../components/UserModal";
import { toast } from "react-toastify";
import { userService } from "../services/userService";

const UsersPage = () => {
  const [users, setUsers] = useState([]);
  const [filterRole, setFilterRole] = useState("all");
  const [editingUser, setEditingUser] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchUsers = async () => {
    try {
      setIsLoading(true);
      setError(null);

      const data = await userService.getAll();
      if (Array.isArray(data)) {
        setUsers(data);
      } else if (Array.isArray(data.data)) {
        setUsers(data.data);
      } else {
        setUsers([]);
      }
    } catch (err) {
      console.error("Lỗi khi tải người dùng:", err);
      setError("Không thể tải danh sách người dùng. Vui lòng thử lại sau.");
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  const handleAddUser = async (user) => {
    try {
      const response = await userService.create(user);
      // The server should return the created user with the generated ID
      if (response && response.data) {
        setUsers([...users, response.data]);
        return { success: true };
      } else {
        // If the response format is different, refetch the users list to ensure we have the latest data
        await fetchUsers();
        return { success: true };
      }
    } catch (error) {
      console.error("Lỗi khi thêm người dùng:", error);
      return { 
        success: false, 
        message: error.response?.data?.message || "Có lỗi xảy ra khi thêm người dùng" 
      };
    }
  };

  const handleEditUser = async (updated) => {
    try {
      const updatedUser = await userService.update(updated.id, updated);
      setUsers(users.map((u) => (u.id === updated.id ? updatedUser : u)));
      return { success: true };
    } catch (error) {
      console.error("Lỗi khi cập nhật người dùng:", error);
      return { 
        success: false, 
        message: error.response?.data?.message || "Có lỗi xảy ra khi cập nhật thông tin" 
      };
    }
  };

  const handleDeleteUser = async (id) => {
    if (!window.confirm("Bạn có chắc chắn muốn xóa người dùng này?")) return;
    
    try {
      await userService.delete(id);
      setUsers(users.filter((u) => u.id !== id));
    } catch (error) {
      console.error("Lỗi khi xóa người dùng:", error);
      const errorMessage = error.response?.data?.message || "Có lỗi xảy ra khi xóa người dùng";
      toast.error(errorMessage);
    }
  };

  const filteredUsers =
    filterRole === "all" ? users : users.filter((u) => u.role === filterRole);

  if (isLoading) {
    return (
      <div className="d-flex justify-content-center align-items-center" style={{ height: '300px' }}>
        <div className="spinner-border text-primary" role="status">
          <span className="visually-hidden">Loading...</span>
        </div>
        <span className="ms-2">Đang tải danh sách người dùng...</span>
      </div>
    );
  }

  return (
    <>
      <div className="d-flex justify-content-between align-items-center mb-3">
        <h3>Quản lý người dùng</h3>
        <button
          className="btn btn-primary"
          data-bs-toggle="modal"
          data-bs-target="#userModal"
          onClick={() => setEditingUser(null)}
          disabled={isLoading}
        >
          <i className="fa fa-plus me-2"></i>Thêm người dùng
        </button>
      </div>

      {error && (
        <div className="alert alert-danger" role="alert">
          {error}
        </div>
      )}

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

      {!isLoading && users.length === 0 ? (
        <div className="alert alert-info">Không có người dùng nào.</div>
      ) : (
        <UserTable
          users={filteredUsers}
          onEdit={setEditingUser}
          onDelete={handleDeleteUser}
        />
      )}

      <UserModal
        editingUser={editingUser}
        onAdd={handleAddUser}
        onEdit={handleEditUser}
      />
    </>
  );
};

export default UsersPage;
