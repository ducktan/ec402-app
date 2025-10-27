import React, { useState, useEffect } from "react";

const CategoryModal = ({ editingCategory, onAdd, onEdit }) => {
  const [form, setForm] = useState({ name: "", parent_id: "" });

  useEffect(() => {
    if (editingCategory) setForm(editingCategory);
    else setForm({ name: "", parent_id: "" });
  }, [editingCategory]);

  const handleSubmit = (e) => {
    e.preventDefault();
    if (editingCategory) onEdit(form);
    else onAdd(form);
  };

  return (
    <div
      className="modal fade"
      id="categoryModal"
      tabIndex="-1"
      aria-labelledby="categoryModalLabel"
      aria-hidden="true"
    >
      <div className="modal-dialog">
        <form onSubmit={handleSubmit} className="modal-content">
          <div className="modal-header">
            <h5 className="modal-title">
              {editingCategory ? "Chỉnh sửa danh mục" : "Thêm danh mục mới"}
            </h5>
            <button type="button" className="btn-close" data-bs-dismiss="modal"></button>
          </div>

          <div className="modal-body">
            <div className="mb-3">
              <label className="form-label">Tên danh mục</label>
              <input
                type="text"
                className="form-control"
                value={form.name}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
                required
              />
            </div>
            <div className="mb-3">
              <label className="form-label">ID danh mục cha (nếu có)</label>
              <input
                type="number"
                className="form-control"
                value={form.parent_id || ""}
                onChange={(e) => setForm({ ...form, parent_id: e.target.value || null })}
              />
            </div>
          </div>

          <div className="modal-footer">
            <button type="submit" className="btn btn-success" data-bs-dismiss="modal">
              Lưu
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default CategoryModal;
