import React, { useState, useEffect } from "react";

const UserModal = ({ editingUser, onAdd, onEdit }) => {
  const [form, setForm] = useState({
    name: "",
    email: "",
    phone: "",
    role: "buyer",
  });

  useEffect(() => {
    if (editingUser) setForm(editingUser);
    else setForm({ name: "", email: "", phone: "", role: "buyer" });
  }, [editingUser]);

  const handleSubmit = (e) => {
    e.preventDefault();
    if (editingUser) onEdit(form);
    else onAdd(form);
    const modal = window.bootstrap.Modal.getInstance(document.getElementById("userModal"));
    modal.hide();
  };

  return (
    <div
      className="modal fade"
      id="userModal"
      tabIndex="-1"
      aria-labelledby="userModalLabel"
      aria-hidden="true"
    >
      <div className="modal-dialog">
        <form onSubmit={handleSubmit} className="modal-content">
          <div className="modal-header">
            <h5 className="modal-title" id="userModalLabel">
              {editingUser ? "Chỉnh sửa người dùng" : "Thêm người dùng mới"}
            </h5>
            <button type="button" className="btn-close" data-bs-dismiss="modal"></button>
          </div>

          <div className="modal-body">
            <div className="mb-3">
              <label className="form-label">Họ tên</label>
              <input
                type="text"
                className="form-control"
                value={form.name}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
                required
              />
            </div>
            <div className="mb-3">
              <label className="form-label">Email</label>
              <input
                type="email"
                className="form-control"
                value={form.email}
                onChange={(e) => setForm({ ...form, email: e.target.value })}
                required
              />
            </div>
            <div className="mb-3">
              <label className="form-label">Điện thoại</label>
              <input
                type="text"
                className="form-control"
                value={form.phone}
                onChange={(e) => setForm({ ...form, phone: e.target.value })}
              />
            </div>
            <div className="mb-3">
              <label className="form-label">Vai trò</label>
              <select
                className="form-select"
                value={form.role}
                onChange={(e) => setForm({ ...form, role: e.target.value })}
              >
                <option value="buyer">Người mua</option>
                <option value="seller">Người bán</option>
                <option value="admin">Quản trị</option>
              </select>
            </div>
          </div>

          <div className="modal-footer">
            <button type="submit" className="btn btn-success">
              Lưu
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default UserModal;
