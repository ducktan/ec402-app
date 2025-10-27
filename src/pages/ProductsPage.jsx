import React, { useState, useEffect } from "react";
import ProductTable from "../components/ProductTable";
import ProductModal from "../components/ProductModal";

const ProductsPage = () => {
  const [products, setProducts] = useState([]);
  const [editingProduct, setEditingProduct] = useState(null);
  const [filterCategory, setFilterCategory] = useState("all");

  useEffect(() => {
    // Giả lập fetch dữ liệu
    setProducts([
      {
        id: 1,
        name: "iPhone 15 Pro Max",
        seller_id: 3,
        category_id: 1,
        category_name: "Điện thoại",
        price: 34990000,
        stock: 12,
        images: [
          "https://cdn.tgdd.vn/Products/Images/42/281570/iphone-15-pro-max-thumb.jpg",
        ],
      },
      {
        id: 2,
        name: "Laptop Asus Vivobook",
        seller_id: 4,
        category_id: 2,
        category_name: "Laptop",
        price: 17990000,
        stock: 5,
        images: [
          "https://cdn.tgdd.vn/Products/Images/44/253856/asus-vivobook-thumb.jpg",
        ],
      },
    ]);
  }, []);

  const handleAddProduct = (p) =>
    setProducts([...products, { ...p, id: Date.now() }]);

  const handleEditProduct = (p) =>
    setProducts(products.map((item) => (item.id === p.id ? p : item)));

  const handleDeleteProduct = (id) =>
    setProducts(products.filter((p) => p.id !== id));

  const filtered =
    filterCategory === "all"
      ? products
      : products.filter((p) => p.category_id === Number(filterCategory));

  return (
    <div>

      <div className="container py-4">
        <div className="d-flex justify-content-between align-items-center mb-3">
          <h3>Quản lý sản phẩm</h3>
          <button
            className="btn btn-primary"
            data-bs-toggle="modal"
            data-bs-target="#productModal"
            onClick={() => setEditingProduct(null)}
          >
            <i className="fa fa-plus me-2"></i>Thêm sản phẩm
          </button>
        </div>

        <div className="mb-3">
          <select
            className="form-select w-auto"
            value={filterCategory}
            onChange={(e) => setFilterCategory(e.target.value)}
          >
            <option value="all">Tất cả danh mục</option>
            <option value="1">Điện thoại</option>
            <option value="2">Laptop</option>
          </select>
        </div>

        <ProductTable
          products={filtered}
          onEdit={setEditingProduct}
          onDelete={handleDeleteProduct}
        />
      </div>

      <ProductModal
        editingProduct={editingProduct}
        onAdd={handleAddProduct}
        onEdit={handleEditProduct}
      />
    </div>
  );
};

export default ProductsPage;
