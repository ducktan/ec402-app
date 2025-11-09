const pool = require('../config/db'); // Import pool kết nối

class Brand {

    // CREATE
    static async create({ name, description, logo_url }) {
        const [result] = await pool.execute(
            'INSERT INTO brands (name, description, logo_url) VALUES (?, ?, ?)',
            [name, description, logo_url]
        );
        return { id: result.insertId, name, description, logo_url };
    }

    // READ (All)
    static async findAll() {
        const [rows] = await pool.execute('SELECT * FROM brands');
        return rows;
    }

    // READ (By ID)
    static async findById(id) {
        const [rows] = await pool.execute('SELECT * FROM brands WHERE id = ?', [id]);
        return rows[0]; // Trả về object đầu tiên hoặc undefined
    }

    // UPDATE
    static async update(id, { name, description, logo_url }) {
        const [result] = await pool.execute(
            'UPDATE brands SET name = ?, description = ?, logo_url = ? WHERE id = ?',
            [name, description, logo_url, id]
        );
        return result.affectedRows > 0; // Trả về true nếu update thành công
    }

    // DELETE
    static async delete(id) {
        const [result] = await pool.execute('DELETE FROM brands WHERE id = ?', [id]);
        return result.affectedRows > 0; // Trả về true nếu delete thành công
    }
}

module.exports = Brand;