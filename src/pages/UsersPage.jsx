import React, { useState, useEffect } from "react";
import UserTable from "../components/UserTable";
import UserModal from "../components/UserModal";

const UsersPage = () => {
  const [users, setUsers] = useState([]);
  const [filterRole, setFilterRole] = useState("all");
  const [editingUser, setEditingUser] = useState(null);

  // Giả lập fetch từ API
  useEffect(() => {
    setUsers([
      { id: 1, role: "admin", name: "Nguyễn Văn A", email: "a@gmail.com", phone: "0900000001" },
      { id: 2, role: "buyer", name: "Trần Thị B", email: "b@gmail.com", phone: "0900000002" },
      { id: 3, role: "seller", name: "Lê Văn C", email: "c@gmail.com", phone: "0900000003" },
    ]);
  }, []);

  const handleAddUser = (user) =>
    setUsers([...users, { ...user, id: Date.now() }]);

  const handleEditUser = (updated) =>
    setUsers(users.map((u) => (u.id === updated.id ? updated : u)));

  const handleDeleteUser = (id) =>
    setUsers(users.filter((u) => u.id !== id));

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
