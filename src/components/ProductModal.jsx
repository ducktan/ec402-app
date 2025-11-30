import React, { useState, useEffect } from "react";
import Swal from 'sweetalert2';
import { Modal } from 'bootstrap';

const ProductModal = ({ editingProduct, onAdd, onEdit, categories }) => {
  const [form, setForm] = useState({
    name: "",
    category_id: "",
    price: "",
    stock: "",
    images: [],
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (editingProduct) setForm(editingProduct);
    else
      setForm({
        name: "",
        category_id: "",
        price: "",
        stock: "",
        images: [],
      });
  }, [editingProduct]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);
    setIsSubmitting(true);
    
    try {
      // Convert price to number and stock to integer
      const productData = {
        ...form,
        price: parseFloat(form.price) || 0,
        stock: parseInt(form.stock) || 0,
        category_id: form.category_id ? parseInt(form.category_id) : null,
      };
      
      const result = editingProduct 
        ? await onEdit(productData)
        : await onAdd(productData);
      
      if (result?.success) {
        // Close the modal immediately
        const modalElement = document.getElementById('productModal');
        if (modalElement) {
          const modal = Modal.getInstance(modalElement) || new Modal(modalElement);
          modal.hide();
          // Reset form
          setForm({ name: "", category_id: "", price: "", stock: "", images: [] });
          cleanupModal();
        }

        // Show success message after closing modal
        await Swal.fire({
          toast: true,
          position: 'top-end',
          icon: 'success',
          title: editingProduct ? 'Cập nhật sản phẩm thành công' : 'Thêm sản phẩm mới thành công',
          showConfirmButton: false,
          timer: 2000,
          timerProgressBar: true
        });
      } else if (result?.message) {
        setError(result.message);
      }
    } catch (err) {
      console.error("Lỗi khi lưu sản phẩm:", err);
      // Show error message as toast
      await Swal.fire({
        toast: true,
        position: 'top-end',
        icon: 'error',
        title: err.response?.data?.message || 'Có lỗi xảy ra khi lưu sản phẩm',
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
    const modal = document.getElementById('productModal');
    if (!modal) return;

    const handleHidden = () => {
      cleanupModal();
      setForm({ name: "", category_id: "", price: "", stock: "", images: [] });
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
  }, [editingProduct]);

  return (
    <div className="modal fade" id="productModal" tabIndex="-1">
      <div className="modal-dialog modal-lg">
        <form onSubmit={handleSubmit} className="modal-content">
          <div className="modal-header">
            <h5 className="modal-title">
              {editingProduct ? "Chỉnh sửa sản phẩm" : "Thêm sản phẩm"}
            </h5>
            <button
              type="button"
              className="btn-close"
              data-bs-dismiss="modal"
            ></button>
          </div>
          <div className="modal-body">
            <div className="row g-3">
              <div className="col-md-6">
                <label className="form-label">Tên sản phẩm</label>
                <input
                  type="text"
                  className="form-control"
                  value={form.name}
                  onChange={(e) => setForm({ ...form, name: e.target.value })}
                />
              </div>

              <div className="col-md-6">
                <label className="form-label">Danh mục</label>
                <select
                  className="form-select"
                  value={form.category_id}
                  onChange={(e) =>
                    setForm({ ...form, category_id: e.target.value })
                  }
                >
                  <option value="">Chọn danh mục</option>
                  {categories.map(category => (
                    <option key={category.id} value={category.id}>
                      {category.name}
                    </option>
                  ))}
                </select>
              </div>

              <div className="col-md-6">
                <label className="form-label">Giá (₫)</label>
                <input
                  type="number"
                  className="form-control"
                  value={form.price}
                  onChange={(e) =>
                    setForm({ ...form, price: parseFloat(e.target.value) })
                  }
                />
              </div>

              <div className="col-md-6">
                <label className="form-label">Tồn kho</label>
                <input
                  type="number"
                  className="form-control"
                  value={form.stock}
                  onChange={(e) =>
                    setForm({ ...form, stock: parseInt(e.target.value) })
                  }
                />
              </div>

              <div className="col-12">
                <label className="form-label">Ảnh sản phẩm (URL)</label>
                <input
                  type="text"
                  className="form-control"
                  placeholder="Nhập URL hình ảnh, cách nhau bằng dấu phẩy"
                  value={form.images.join(",")}
                  onChange={(e) =>
                    setForm({
                      ...form,
                      images: e.target.value
                        .split(",")
                        .map((url) => url.trim())
                        .filter((url) => url !== ""),
                    })
                  }
                />
              </div>

              {form.images.length > 0 && (
                <div className="col-12 d-flex flex-wrap gap-2">
                  {form.images.map((url) => (
                    <img
                      key={url}
                      src={url}
                      alt="preview"
                      width="70"
                      height="70"
                      className="rounded border"
                    />
                  ))}
                </div>
              )}
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

export default ProductModal;
