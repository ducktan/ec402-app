import React from "react";

const CategoryTable = ({ categories, onEdit, onDelete }) => {
  const findParentName = (id) => categories.find((c) => c.id === id)?.name || "—";

  return (
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
              >
                <i className="fa fa-edit"></i>
              </button>
              <button
                className="btn btn-sm btn-outline-danger"
                onClick={() => onDelete(cat.id)}
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

export default CategoryTable;
