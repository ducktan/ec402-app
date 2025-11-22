import React, { useState, useEffect, useRef } from "react";
import { Modal } from 'bootstrap';

const CategoryModal = ({ editingCategory, onAdd, onEdit, onClose }) => {
  const [form, setForm] = useState({ name: "", parent_id: "" });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (editingCategory) {
      setForm({
        name: editingCategory.name || "",
        parent_id: editingCategory.parent_id || ""
      });
    } else {
      setForm({ name: "", parent_id: "" });
    }
    setError(null);
  }, [editingCategory]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);
    setIsSubmitting(true);
    
    try {
      const result = editingCategory 
        ? await onEdit({ ...form, id: editingCategory.id })
        : await onAdd(form);
      
      if (result?.success) {
        // Đóng modal nếu thêm/cập nhật thành công
        const modalElement = document.getElementById('categoryModal');
        if (modalElement) {
          const modal = Modal.getInstance(modalElement) || new Modal(modalElement);
          modal.hide();
        }
      } else if (result?.message) {
        setError(result.message);
      }
    } catch (err) {
      console.error("Lỗi khi lưu danh mục:", err);
      setError("Có lỗi xảy ra khi lưu danh mục. Vui lòng thử lại sau.");
    } finally {
      setIsSubmitting(false);
    }
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

          {error && (
            <div className="alert alert-danger mx-3 mb-0">
              {error}
            </div>
          )}
          <div className="modal-footer">
            <button 
              type="button" 
              className="btn btn-secondary" 
              data-bs-dismiss="modal"
              disabled={isSubmitting}
            >
              Hủy
            </button>
            <button 
              type="submit" 
              className="btn btn-success" 
              disabled={isSubmitting || !form.name.trim()}
            >
              {isSubmitting ? (
                <>
                  <span className="spinner-border spinner-border-sm me-1" role="status" aria-hidden="true"></span>
                  Đang xử lý...
                </>
              ) : (
                'Lưu'
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default CategoryModal;
