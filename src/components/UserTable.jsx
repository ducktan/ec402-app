import React from "react";

const UserTable = ({ users, onEdit, onDelete }) => {
  return (
    <table className="table table-striped table-hover">
      <thead className="table-dark">
        <tr>
          <th>ID</th>
          <th>Tên</th>
          <th>Email</th>
          <th>Vai trò</th>
          <th>Điện thoại</th>
          <th>Hành động</th>
        </tr>
      </thead>
      <tbody>
        {users.map((u) => (
          <tr key={u.id}>
            <td>{u.id}</td>
            <td>{u.name}</td>
            <td>{u.email}</td>
            <td>
              <span className={`badge bg-${u.role === "admin" ? "danger" : u.role === "seller" ? "warning" : "secondary"}`}>
                {u.role}
              </span>
            </td>
            <td>{u.phone}</td>
            <td>
              <button
                className="btn btn-sm btn-outline-primary me-2"
                data-bs-toggle="modal"
                data-bs-target="#userModal"
                onClick={() => onEdit(u)}
              >
                <i className="fa fa-edit"></i>
              </button>
              <button
                className="btn btn-sm btn-outline-danger"
                onClick={() => onDelete(u.id)}
              >
                <i className="fa fa-trash"></i>
              </button>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
};

export default UserTable;
