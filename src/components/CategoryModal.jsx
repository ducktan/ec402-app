import React, { useState, useEffect, useRef } from "react";
import Swal from 'sweetalert2';
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
        // Close the modal immediately
        const modalElement = document.getElementById('categoryModal');
        if (modalElement) {
          const modal = Modal.getInstance(modalElement) || new Modal(modalElement);
          modal.hide();
          // Reset form
          setForm({ name: "", parent_id: "" });
          cleanupModal();
        }

        // Show success message after closing modal
        await Swal.fire({
          toast: true,
          position: 'top-end',
          icon: 'success',
          title: editingCategory ? 'Cập nhật danh mục thành công' : 'Thêm danh mục mới thành công',
          showConfirmButton: false,
          timer: 2000,
          timerProgressBar: true
        });
      } else if (result?.message) {
        setError(result.message);
      }
    } catch (err) {
      console.error("Lỗi khi lưu danh mục:", err);
      // Show error message as toast
      await Swal.fire({
        toast: true,
        position: 'top-end',
        icon: 'error',
        title: 'Có lỗi xảy ra khi lưu danh mục',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true
      });
    } finally {
      setIsSubmitting(false);
    }
  };

  // Function to clean up modal and backdrop
  const cleanupModal = () => {
    // Remove modal-open class from body
    document.body.classList.remove('modal-open');
    
    // Remove any remaining modal backdrop
    const backdrops = document.getElementsByClassName('modal-backdrop');
    while (backdrops[0]) {
      backdrops[0].parentNode.removeChild(backdrops[0]);
    }
    
    // Reset body styles
    document.body.style.overflow = '';
    document.body.style.paddingRight = '';
  };

  // Handle modal show/hide events
  useEffect(() => {
    const modal = document.getElementById('categoryModal');
    if (!modal) return;

    const handleHidden = () => {
      cleanupModal();
      setForm({ name: "", parent_id: "" });
      setError(null);
    };

    const handleShow = () => {
      // Ensure body has modal-open class when modal is shown
      document.body.classList.add('modal-open');
    };
    
    modal.addEventListener('hidden.bs.modal', handleHidden);
    modal.addEventListener('show.bs.modal', handleShow);
    
    // Cleanup function
    return () => {
      modal.removeEventListener('hidden.bs.modal', handleHidden);
      modal.removeEventListener('show.bs.modal', handleShow);
      // Ensure cleanup when component unmounts
      cleanupModal();
    };
  }, [editingCategory]);

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
