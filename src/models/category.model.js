const pool = require("../config/db");

class Category {
  // Tạo danh mục mới
  static async create({ name, parent_id }) {
    // Nếu không có parent_id, để null
    const pid = parent_id ? parent_id : null;

    const [result] = await pool.query(
      "INSERT INTO categories (name, parent_id) VALUES (?, ?)",
      [name, pid]
    );

    return {
      id: result.insertId,
      name,
      parent_id: pid,
    };
  }

  // Lấy tất cả danh mục
  static async getAll() {
    const [rows] = await pool.query("SELECT * FROM categories");
    return rows;
  }

  // Lấy chi tiết danh mục theo ID
  static async getById(id) {
    const [rows] = await pool.query("SELECT * FROM categories WHERE id = ?", [id]);
    return rows[0];
  }

  // Cập nhật danh mục
  static async update(id, data) {
  const fields = [];
  const values = [];

  if (data.name !== undefined) {
    fields.push("name = ?");
    values.push(data.name);
  }

  if (data.parent_id !== undefined) {
    fields.push("parent_id = ?");
    values.push(data.parent_id);
  }

  if (fields.length === 0) return await this.getById(id); // Không có gì để update

  const sql = `UPDATE categories SET ${fields.join(", ")} WHERE id = ?`;
  values.push(id);

  await pool.query(sql, values);
  return await this.getById(id);
}

  // Xóa danh mục
  static async delete(id) {
    await pool.query("DELETE FROM categories WHERE id = ?", [id]);
    return true;
  }

  // Lấy danh sách danh mục con theo parent_id
  static async getChildren(parent_id = null) {
    const [rows] = await pool.query(
      "SELECT * FROM categories WHERE parent_id " + (parent_id ? "= ?" : "IS NULL"),
      parent_id ? [parent_id] : []
    );
    return rows;
  }

  // Hàm dựng cây danh mục (đệ quy)
  static async getCategoryTree(parent_id = null) {
    const categories = await this.getChildren(parent_id);
    const tree = [];

    for (const cat of categories) {
      const children = await this.getCategoryTree(cat.id);
      tree.push({
        ...cat,
        children,
      });
    }

    return tree;
  }
}

module.exports = Category;
