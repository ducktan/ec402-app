import React from "react";

const ProductTable = ({ products, onEdit, onDelete }) => {
  return (
    <table className="table table-bordered align-middle">
      <thead className="table-light">
        <tr>
          <th>#</th>
          <th>Ảnh</th>
          <th>Tên sản phẩm</th>
          <th>Danh mục</th>
          <th>Giá</th>
          <th>Tồn kho</th>
          <th>Thao tác</th>
        </tr>
      </thead>
      <tbody>
        {products.length > 0 ? (
          products.map((p, i) => (
            <tr key={p.id}>
              <td>{i + 1}</td>
              <td>
                <img
                  src={p.images?.[0] || "https://via.placeholder.com/60"}
                  alt={p.name}
                  width="60"
                  height="60"
                  className="rounded"
                />
              </td>
              <td>{p.name}</td>
              <td>{p.category_name || "—"}</td>
              <td>{p.price.toLocaleString()} ₫</td>
              <td>{p.stock}</td>
              <td>
                <button
                  className="btn btn-sm btn-warning me-2"
                  data-bs-toggle="modal"
                  data-bs-target="#productModal"
                  onClick={() => onEdit(p)}
                >
                  <i className="fa fa-edit"></i>
                </button>
                <button
                  className="btn btn-sm btn-danger"
                  onClick={() => onDelete(p.id)}
                >
                  <i className="fa fa-trash"></i>
                </button>
              </td>
            </tr>
          ))
        ) : (
          <tr>
            <td colSpan="7" className="text-center">
              Không có sản phẩm
            </td>
          </tr>
        )}
      </tbody>
    </table>
  );
};

export default ProductTable;
