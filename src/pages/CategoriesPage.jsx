import React, { useState, useEffect } from "react";
import CategoryTable from "../components/CategoryTable";
import CategoryModal from "../components/CategoryModal";
import { categoryService } from "../services/categoryService";

const CategoriesPage = () => {
  const [categories, setCategories] = useState([]);
  const [editingCategory, setEditingCategory] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchCategories = async () => {
    try {
      setIsLoading(true);
      setError(null);
      const data = await categoryService.getAll();
      setCategories(data);
    } catch (err) {
      console.error("Lỗi khi tải danh mục:", err);
      setError("Không thể tải danh sách danh mục. Vui lòng thử lại sau.");
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchCategories();
  }, []);

  const handleAdd = async (category) => {
    try {
      const newCategory = await categoryService.create(category);
      setCategories([...categories, newCategory]);
      return { success: true };
    } catch (error) {
      console.error("Lỗi khi thêm danh mục:", error);
      return { success: false, message: error.response?.data?.message || "Có lỗi xảy ra khi thêm danh mục" };
    }
  };

  const handleEdit = async (updated) => {
    try {
      const updatedCategory = await categoryService.update(updated.id, updated);
      setCategories(categories.map((c) => (c.id === updated.id ? updatedCategory : c)));
      return { success: true };
    } catch (error) {
      console.error("Lỗi khi cập nhật danh mục:", error);
      return { success: false, message: error.response?.data?.message || "Có lỗi xảy ra khi cập nhật danh mục" };
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm("Bạn có chắc chắn muốn xóa danh mục này?")) return;
    
    try {
      await categoryService.delete(id);
      setCategories(categories.filter((c) => c.id !== id));
    } catch (error) {
      console.error("Lỗi khi xóa danh mục:", error);
      alert(error.response?.data?.message || "Có lỗi xảy ra khi xóa danh mục");
    }
  };

  if (isLoading) {
    return (
      <div className="d-flex justify-content-center align-items-center" style={{ height: '300px' }}>
        <div className="spinner-border text-primary" role="status">
          <span className="visually-hidden">Loading...</span>
        </div>
        <span className="ms-2">Đang tải danh sách danh mục...</span>
      </div>
    );
  }

  return (
    <>
      <div className="d-flex justify-content-between align-items-center mb-3">
        <h3>Quản lý danh mục</h3>
        <button
          className="btn btn-primary"
          data-bs-toggle="modal"
          data-bs-target="#categoryModal"
          onClick={() => setEditingCategory(null)}
          disabled={isLoading}
        >
          <i className="fa fa-plus me-2"></i>Thêm danh mục
        </button>
      </div>

      {error && (
        <div className="alert alert-danger" role="alert">
          {error}
        </div>
      )}

      {!isLoading && categories.length === 0 ? (
        <div className="alert alert-info">Không có danh mục nào.</div>
      ) : (
        <CategoryTable 
          categories={categories} 
          onEdit={setEditingCategory} 
          onDelete={handleDelete} 
          disabled={isLoading}
        />
      )}

      <CategoryModal 
        editingCategory={editingCategory} 
        onAdd={handleAdd} 
        onEdit={handleEdit}
        onClose={() => setEditingCategory(null)}
      />
    </>
  );
};

export default CategoriesPage;
