import React, { useState, useEffect } from "react";

const ProductModal = ({ editingProduct, onAdd, onEdit }) => {
  const [form, setForm] = useState({
    name: "",
    category_id: "",
    price: "",
    stock: "",
    images: [],
  });

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

  const handleSubmit = () => {
    if (editingProduct) onEdit(form);
    else onAdd(form);
  };

  return (
    <div className="modal fade" id="productModal" tabIndex="-1">
      <div className="modal-dialog modal-lg">
        <div className="modal-content">
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
                  <option value="1">Điện thoại</option>
                  <option value="2">Laptop</option>
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
                  {form.images.map((url, i) => (
                    <img
                      key={i}
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

          <div className="modal-footer">
            <button className="btn btn-secondary" data-bs-dismiss="modal">
              Hủy
            </button>
            <button
              className="btn btn-success"
              data-bs-dismiss="modal"
              onClick={handleSubmit}
            >
              Lưu
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProductModal;
