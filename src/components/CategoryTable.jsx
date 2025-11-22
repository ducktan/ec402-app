import React from "react";

const CategoryTable = ({ categories = [], onEdit, onDelete, disabled = false }) => {
  const findParentName = (id) => categories.find((c) => c.id === id)?.name || "—";

  if (categories.length === 0) {
    return <div className="alert alert-info">Không có danh mục nào để hiển thị.</div>;
  }

  return (
    <div className="table-responsive">
      <table className="table table-striped table-hover">
        <thead className="table-dark">
          <tr>
            <th>ID</th>
            <th>Tên danh mục</th>
            <th>Danh mục cha</th>
            <th>Hành động</th>
          </tr>
        </thead>
        <tbody>
          {categories.map((cat) => (
            <tr key={cat.id}>
              <td>{cat.id}</td>
              <td>{cat.name}</td>
              <td>{findParentName(cat.parent_id)}</td>
              <td>
                <button
                  className="btn btn-sm btn-outline-primary me-2"
                  data-bs-toggle="modal"
                  data-bs-target="#categoryModal"
                  onClick={() => onEdit(cat)}
                  disabled={disabled}
                >
                  <i className="fa fa-edit"></i>
                </button>
                <button
                  className="btn btn-sm btn-outline-danger"
                  onClick={() => onDelete(cat.id)}
                  disabled={disabled}
                >
                  {disabled ? (
                    <span className="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
                  ) : (
                    <i className="fa fa-trash"></i>
                  )}
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default CategoryTable;
