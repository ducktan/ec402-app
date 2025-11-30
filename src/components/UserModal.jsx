import React, { useState, useEffect, useRef } from "react";
import 'bootstrap/dist/css/bootstrap.min.css';
import { Modal } from 'bootstrap';
import Swal from 'sweetalert2';

const UserModal = ({ editingUser, onAdd, onEdit, setEditingUser }) => {
  const modalRef = useRef(null);
  const [form, setForm] = useState({
    name: "",
    email: "",
    phone: "",
    role: "buyer",
  });

  useEffect(() => {
    if (editingUser) {
      // Ensure no null values in the form
      setForm({
        name: editingUser.name || "",
        email: editingUser.email || "",
        phone: editingUser.phone || "",
        role: editingUser.role || "buyer"
      });
    } else {
      setForm({ name: "", email: "", phone: "", role: "buyer" });
    }
  }, [editingUser]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      let result;
      if (editingUser) {
        result = await onEdit({ ...form, id: editingUser.id });
      } else {
        result = await onAdd(form);
      }
      
      // Only proceed if the operation was successful
      if (result && result.success) {
        // Close the modal immediately
        const modalElement = document.getElementById('userModal');
        if (modalElement) {
          const modal = Modal.getInstance(modalElement) || new Modal(modalElement);
          modal.hide();
          // Reset form and editing state
          setForm({ name: "", email: "", phone: "", role: "buyer" });
          setEditingUser(null);
          cleanupModal();
        }

        // Show success message after closing modal
        await Swal.fire({
          toast: true,
          position: 'top-end',
          icon: 'success',
          title: editingUser ? 'Cập nhật thành công' : 'Thêm mới thành công',
          showConfirmButton: false,
          timer: 2000,
          timerProgressBar: true
        });
      }
    } catch (error) {
      console.error("Error submitting form:", error);
      // Show error message
      await Swal.fire({
        toast: true,
        position: 'top-end',
        icon: 'error',
        title: 'Có lỗi xảy ra. Vui lòng thử lại',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true
      });
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
    const modal = modalRef.current;
    if (!modal) return;

    const handleHidden = () => {
      cleanupModal();
      setForm({ name: "", email: "", phone: "", role: "buyer" });
      setEditingUser(null);
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
  }, [editingUser, setEditingUser]);

  return (
    <div
      className="modal fade"
      id="userModal"
      ref={modalRef}
      tabIndex="-1"
      aria-labelledby="userModalLabel"
      aria-hidden="true"
      data-bs-backdrop="static"
    >
      <div className="modal-dialog">
        <form onSubmit={handleSubmit} className="modal-content">
          <div className="modal-header">
            <h5 className="modal-title" id="userModalLabel">
              {editingUser ? "Chỉnh sửa người dùng" : "Thêm người dùng mới"}
            </h5>
            <button type="button" className="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>

          <div className="modal-body">
            <div className="mb-3">
              <label className="form-label">Họ tên</label>
              <input
                type="text"
                className="form-control"
                value={form.name || ""}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
                required
              />
            </div>
            <div className="mb-3">
              <label className="form-label">Email</label>
              <input
                type="email"
                className="form-control"
                value={form.email || ""}
                onChange={(e) => setForm({ ...form, email: e.target.value })}
                required
              />
            </div>
            <div className="mb-3">
              <label className="form-label">Điện thoại</label>
              <input
                type="text"
                className="form-control"
                value={form.phone || ""}
                onChange={(e) => setForm({ ...form, phone: e.target.value })}
              />
            </div>
            <div className="mb-3">
              <label className="form-label">Vai trò</label>
              <select
                className="form-select"
                value={form.role || "buyer"}
                onChange={(e) => setForm({ ...form, role: e.target.value })}
              >
                <option value="buyer">Người mua</option>
                <option value="seller">Người bán</option>
                <option value="admin">Quản trị</option>
              </select>
            </div>
          </div>

          <div className="modal-footer">
            <button type="button" className="btn btn-secondary" data-bs-dismiss="modal">
              Hủy
            </button>
            <button type="submit" className="btn btn-primary">
              Lưu
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default UserModal;
