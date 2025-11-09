const Brand = require('../models/brandModel');

// CREATE: Tạo brand mới
exports.createBrand = async (req, res) => {
    try {
        const { name, description, logo_url } = req.body;
        if (!name) {
            return res.status(400).json({ success: false, message: 'Brand name is required' });
        }
        const newBrand = await Brand.create({ name, description, logo_url });
        res.status(201).json({ success: true, data: newBrand });
    } catch (error) {
        console.log("!!! LỖI TẠI createBrand:", error);

        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

// READ: Lấy tất cả brands
exports.getAllBrands = async (req, res) => {
    try {
        const brands = await Brand.findAll();
        res.status(200).json({ success: true, count: brands.length, data: brands });
    } catch (error) {
        console.log("!!! LỖI TẠI getAllBrands:", error);

        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

// READ: Lấy 1 brand theo ID
exports.getBrandById = async (req, res) => {
    try {
        const brand = await Brand.findById(req.params.id);
        if (!brand) {
            return res.status(404).json({ success: false, message: 'Brand not found' });
        }
        res.status(200).json({ success: true, data: brand });
    } catch (error) {
        console.log("!!! LỖI TẠI getBrandById:", error);

        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

// UPDATE: Cập nhật brand theo ID
exports.updateBrand = async (req, res) => {
    try {
        const { name, description, logo_url } = req.body;
        const updated = await Brand.update(req.params.id, { name, description, logo_url });

        if (!updated) {
            return res.status(404).json({ success: false, message: 'Brand not found or no changes made' });
        }
        const updatedBrand = await Brand.findById(req.params.id);
        res.status(200).json({ success: true, data: updatedBrand });
    } catch (error) {
        console.log("!!! LỖI TẠI updateBrand:", error);

        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

// DELETE: Xóa brand theo ID
exports.deleteBrand = async (req, res) => {
    try {
        const deleted = await Brand.delete(req.params.id);
        if (!deleted) {
            return res.status(404).json({ success: false, message: 'Brand not found' });
        }
        res.status(204).json({ success: true, data: null });
    } catch (error) {
        console.log("!!! LỖI TẠI deleteBrand:", error);

        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};