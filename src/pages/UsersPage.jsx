import React, { useState, useEffect } from "react";
import UserTable from "../components/UserTable";
import UserModal from "../components/UserModal";
import Swal from "sweetalert2";
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
      setUsers(data);
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
      if (response && response.data) {
        setUsers(prevUsers => [...prevUsers, response.data]);
        return { success: true };
      } else {
        await fetchUsers();
        return { success: true };
      }
    } catch (error) {
      console.error("Lỗi khi thêm người dùng:", error);
      throw error;
    }
  };

  const handleEditUser = async (updated) => {
    try {
      const response = await userService.update(updated.id, updated);
      // Make sure we're using the updated user data from the response
      const updatedUser = response.data || response; // Handle both formats
      
      // Update the users list with the updated user data
      setUsers(prevUsers => {
        const updatedUsers = prevUsers.map((u) => 
          u.id === updated.id ? { ...u, ...updated, ...updatedUser } : u
        );
        return updatedUsers;
      });
      
      // Return success with the updated user data
      return { success: true, user: { ...updated, ...updatedUser } };
    } catch (error) {
      console.error("Lỗi khi cập nhật người dùng:", error);
      throw error;
    }
  };

  const handleDeleteUser = async (id) => {
    const result = await Swal.fire({
      title: 'Bạn có chắc chắn?',
      text: "Bạn sẽ không thể hoàn tác hành động này!",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Có, xóa người dùng!',
      cancelButtonText: 'Hủy'
    });

    if (result.isConfirmed) {
      try {
        await userService.delete(id);
        setUsers(users.filter((u) => u.id !== id));
        await Swal.fire(
          'Đã xóa!',
          'Người dùng đã được xóa.',
          'success'
        );
      } catch (error) {
        console.error("Lỗi khi xóa người dùng:", error);
        Swal.fire(
          'Lỗi!',
          error.response?.data?.message || 'Có lỗi xảy ra khi xóa người dùng',
          'error'
        );
      }
    }
  };

  const filteredUsers = React.useMemo(() => {
    if (!Array.isArray(users)) return [];
    return filterRole === "all" ? [...users] : users.filter((u) => u.role === filterRole);
  }, [users, filterRole]);

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

      {isLoading ? null : (
        filteredUsers.length === 0 ? (
          <div key="no-users" className="alert alert-info">Không có người dùng nào.</div>
        ) : (
          <div key={`user-table-${filteredUsers.length}`}>
            <UserTable
              users={filteredUsers}
              onEdit={setEditingUser}
              onDelete={handleDeleteUser}
            />
          </div>
        )
      )}

      <UserModal
        editingUser={editingUser}
        onAdd={handleAddUser}
        onEdit={handleEditUser}
        setEditingUser={setEditingUser}
      />
    </>
  );
};

export default UsersPage;
