import React, { useState, useEffect } from "react";
import CategoryTable from "../components/CategoryTable";
import CategoryModal from "../components/CategoryModal";

const CategoriesPage = () => {
  const [categories, setCategories] = useState([]);
  const [editingCategory, setEditingCategory] = useState(null);

  useEffect(() => {
    // Giả lập dữ liệu
    setCategories([
      { id: 1, name: "Điện thoại", parent_id: null },
      { id: 2, name: "Laptop", parent_id: null },
      { id: 3, name: "Phụ kiện", parent_id: null },
      { id: 4, name: "Tai nghe", parent_id: 3 },
    ]);
  }, []);

  const handleAdd = (cat) => setCategories([...categories, { ...cat, id: Date.now() }]);
  const handleEdit = (updated) =>
    setCategories(categories.map((c) => (c.id === updated.id ? updated : c)));
  const handleDelete = (id) => setCategories(categories.filter((c) => c.id !== id));

  return (
    <>
      <div className="d-flex justify-content-between align-items-center mb-3">
        <h3>Quản lý danh mục</h3>
        <button
          className="btn btn-primary"
          data-bs-toggle="modal"
          data-bs-target="#categoryModal"
          onClick={() => setEditingCategory(null)}
        >
          <i className="fa fa-plus me-2"></i>Thêm danh mục
        </button>
      </div>

      <CategoryTable categories={categories} onEdit={setEditingCategory} onDelete={handleDelete} />

      <CategoryModal editingCategory={editingCategory} onAdd={handleAdd} onEdit={handleEdit} />
    </>
  );
};

export default CategoriesPage;
