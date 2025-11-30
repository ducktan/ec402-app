import React, { useState, useEffect } from "react";
import * as bootstrap from 'bootstrap';
import ProductTable from "../components/ProductTable";
import ProductModal from "../components/ProductModal";
import { productService } from "../services/productService";
import { categoryService } from "../services/categoryService";
import { toast } from "react-toastify";
import Swal from 'sweetalert2';

const ProductsPage = () => {
  const [products, setProducts] = useState([]);
  const [editingProduct, setEditingProduct] = useState(null);
  const [filterCategory, setFilterCategory] = useState("all");
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const [categories, setCategories] = useState([]);
  const [categoryMap, setCategoryMap] = useState({});

  // Fetch all categories
  const fetchCategories = async () => {
    try {
      const categoriesData = await categoryService.getAll();
      setCategories(categoriesData);
      // Create a map of category_id to category name
      const map = {};
      categoriesData.forEach(category => {
        map[category.id] = category.name;
      });
      setCategoryMap(map);
      return map;
    } catch (error) {
      console.error('Error fetching categories:', error);
      toast.error('Không thể tải danh mục sản phẩm');
      return {};
    }
  };

  const fetchProducts = async (catMap = {}) => {
    try {
      setIsLoading(true);
      setError(null);
      
      // If no category map provided, get it
      const categoryMap = Object.keys(catMap).length > 0 ? catMap : await fetchCategories();
      
      const productsData = await productService.getAll();
      
      // For each product, fetch its images
      const productsWithImages = await Promise.all(
        productsData.map(async (product) => {
          try {
            const images = await productService.getProductImages(product.id);
            return {
              ...product,
              images: images.map(img => img.image_url),
              category_name: categoryMap[product.category_id] || 'Không xác định'
            };
          } catch (error) {
            console.error(`Error fetching images for product ${product.id}:`, error);
            return {
              ...product,
              images: []
            };
          }
        })
      );
      
      setProducts(productsWithImages);
    } catch (error) {
      console.error("Error fetching products:", error);
      setError("Không thể tải danh sách sản phẩm. Vui lòng thử lại sau.");
      toast.error("Có lỗi xảy ra khi tải danh sách sản phẩm");
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    const loadData = async () => {
      const catMap = await fetchCategories();
      // Only fetch products after we have the category map
      await fetchProducts(catMap);
    };
    loadData();
  }, []);

 const handleAddProduct = async (productData) => {
  try {
    setIsLoading(true);
    
    // Log dữ liệu nhận được từ form
    console.log('Dữ liệu nhận từ form:', productData);
    
    // Chỉ gửi các trường cần thiết và đảm bảo kiểu dữ liệu đúng
    const productPayload = {
      // Bỏ brand_id để server tự động gán
      category_id: productData.category_id ? parseInt(productData.category_id) : null,
      name: productData.name,
      description: productData.description || '',
      price: parseFloat(productData.price) || 0,
      stock: productData.stock ? parseInt(productData.stock) : 0
    };
    
    console.log('Dữ liệu chuẩn bị gửi lên server:', productPayload);
    
    const response = await productService.create(productPayload);
    
    if (response && response.data) {
      // Làm mới danh sách sản phẩm
      await fetchProducts();
      toast.success("Thêm sản phẩm thành công");
      return { success: true };
    }
    return { success: false };
  } catch (error) {
    console.error("Lỗi khi thêm sản phẩm:", error);
    const errorMessage = error.response?.data?.message || "Có lỗi xảy ra khi thêm sản phẩm";
    toast.error(errorMessage);
    return { success: false, message: errorMessage };
  } finally {
    setIsLoading(false);
  }
};

  const handleEditProduct = async (productData) => {
  try {
    setIsLoading(true);
    console.log('Updating product with data:', productData);
    
    // Tạo bản sao của dữ liệu sản phẩm để chỉnh sửa
    const updateData = { ...productData };
    
    // Chuẩn hóa dữ liệu số
    if (updateData.price) updateData.price = parseFloat(updateData.price) || 0;
    if (updateData.sale_price) updateData.sale_price = parseFloat(updateData.sale_price) || 0;
    if (updateData.stock) updateData.stock = parseInt(updateData.stock) || 0;
    
    // Xử lý category_id nếu có
    if (updateData.category_id && typeof updateData.category_id === 'object') {
      updateData.category_id = updateData.category_id.id || updateData.category_id;
    }
    
    // Tách hình ảnh ra khỏi dữ liệu cập nhật chính
    const existingImages = Array.isArray(updateData.images) 
      ? updateData.images.filter(img => typeof img === 'string')
      : [];
    
    // Xóa trường images khỏi dữ liệu cập nhật
    delete updateData.images;
    
    // Chuẩn bị dữ liệu cập nhật sản phẩm (không bao gồm ảnh)
    const updatePayload = {
      id: updateData.id,
      name: updateData.name,
      price: Number(updateData.price),
      description: updateData.description || "",
      stock: Number(updateData.stock) || 0,
      brand_id: Number(updateData.brand_id),
      category_id: Number(updateData.category_id)
    };
    
    console.log('Dữ liệu chuẩn bị cập nhật:', updatePayload);
    
    // 1. Cập nhật thông tin sản phẩm (không bao gồm ảnh)
    const response = await productService.update(updateData.id, updatePayload);
    
    // 2. Xử lý cập nhật ảnh (nếu có)
    if (Array.isArray(productData.images)) {
      // Xử lý ảnh mới (nếu có)
      const newImages = productData.images.filter(img => img instanceof File);
      for (const imageFile of newImages) {
        try {
          await productService.uploadImage(updateData.id, imageFile);
        } catch (uploadError) {
          console.error('Lỗi khi tải lên hình ảnh mới:', uploadError);
          toast.error(`Lỗi khi tải lên hình ảnh mới: ${uploadError.message}`);
        }
      }
      
      // Xử lý ảnh hiện có (nếu có thay đổi)
      if (existingImages.length > 0) {
        try {
          // Gọi API cập nhật danh sách ảnh thông qua productService
          await productService.updateProductImages(updateData.id, existingImages);
        } catch (imageUpdateError) {
          console.error('Lỗi khi cập nhật danh sách ảnh:', imageUpdateError);
          toast.error('Có lỗi khi cập nhật danh sách ảnh sản phẩm');
        }
      }
    }
    
    // Làm mới danh sách sản phẩm
    await fetchProducts();
    
    // Đóng modal nếu đang mở
    const modal = document.getElementById('productModal');
    if (modal) {
      const bootstrapModal = bootstrap.Modal.getInstance(modal);
      if (bootstrapModal) {
        bootstrapModal.hide();
      }
    }
    
    toast.success("Cập nhật sản phẩm thành công");
    return { success: true };
    
  } catch (error) {
    console.error("Lỗi khi cập nhật sản phẩm:", error);
    
    // Lấy thông báo lỗi chi tiết từ phản hồi API
    let errorMessage = "Có lỗi xảy ra khi cập nhật sản phẩm";
    if (error.response) {
      if (error.response.data && error.response.data.message) {
        errorMessage = error.response.data.message;
      } else if (error.response.status === 500) {
        errorMessage = "Lỗi máy chủ nội bộ. Vui lòng thử lại sau.";
      }
    } else if (error.request) {
      errorMessage = "Không nhận được phản hồi từ máy chủ. Vui lòng kiểm tra kết nối mạng.";
    }
    
    toast.error(errorMessage);
    return { 
      success: false, 
      message: errorMessage,
      details: error.response?.data
    };
  } finally {
    setIsLoading(false);
  }
};

  const handleDeleteProduct = async (id) => {
    const result = await Swal.fire({
      title: 'Bạn có chắc chắn?',
      text: "Bạn sẽ không thể hoàn tác hành động này!",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Có, xóa sản phẩm!',
      cancelButtonText: 'Hủy'
    });

    if (result.isConfirmed) {
      try {
        setIsLoading(true);
        await productService.delete(id);
        setProducts(products.filter((p) => p.id !== id));
        
        // Show success message
        await Swal.fire({
          toast: true,
          position: 'top-end',
          icon: 'success',
          title: 'Đã xóa sản phẩm thành công',
          showConfirmButton: false,
          timer: 2000,
          timerProgressBar: true
        });
      } catch (error) {
        console.error("Lỗi khi xóa sản phẩm:", error);
        // Show error message
        await Swal.fire({
          toast: true,
          position: 'top-end',
          icon: 'error',
          title: error.response?.data?.message || 'Có lỗi xảy ra khi xóa sản phẩm',
          showConfirmButton: false,
          timer: 3000,
          timerProgressBar: true
        });
        throw error;
      } finally {
        setIsLoading(false);
      }
    }
  };

  const filtered = filterCategory === "all"
    ? products
    : products.filter((p) => p.category_id === Number(filterCategory));
    
  // Get unique categories for filter dropdown
  const uniqueCategories = [
    { id: 'all', name: 'Tất cả danh mục' },
    ...categories
  ];

  if (isLoading) {
    return (
      <div className="container py-4">
        <div className="text-center">
          <div className="spinner-border text-primary" role="status">
            <span className="visually-hidden">Loading...</span>
          </div>
          <p className="mt-2">Đang tải sản phẩm...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="container py-4">
        <div className="alert alert-danger" role="alert">
          {error}
        </div>
      </div>
    );
  }

  return (
    <div>
      <div className="container py-4">
        <div className="d-flex justify-content-between align-items-center mb-3">
          <h2 className="mb-0">Danh sách sản phẩm</h2>
          <div className="d-flex gap-2">
            <select 
              className="form-select" 
              style={{ width: 'auto' }}
              value={filterCategory}
              onChange={(e) => setFilterCategory(e.target.value)}
            >
              {uniqueCategories.map(cat => (
                <option key={cat.id} value={cat.id}>
                  {cat.name}
                </option>
              ))}
            </select>
            <button
              className="btn btn-primary"
              data-bs-toggle="modal"
              data-bs-target="#productModal"
              onClick={() => setEditingProduct(null)}
            >
              <i className="fa fa-plus"></i> Thêm sản phẩm
            </button>
          </div>
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
        categories={categories}
      />
    </div>
  );
};

export default ProductsPage;
