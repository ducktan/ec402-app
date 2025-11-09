const pool = require('../config/db'); // Import pool kết nối

class Brand {

    // CREATE
    static async create({ name, description, logo_url }) {
        const [result] = await pool.execute(
            'INSERT INTO brands (name, description, logo_url) VALUES (?, ?, ?)',
            [name, description ?? null, logo_url ?? null]
        );

        return {
            id: result.insertId,
            name,
            description,
            logo_url,
        };
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
    static async update(id, fields) {
        // Lọc các trường có giá trị hợp lệ
        const keys = Object.keys(fields).filter(key => fields[key] !== undefined);
        if (keys.length === 0) return false;

        // Tạo chuỗi SET động: "name = ?, description = ?"
        const setClause = keys.map(key => `${key} = ?`).join(", ");
        const values = keys.map(key => fields[key]);

        // Thêm id vào cuối mảng value
        values.push(id);

        const [result] = await pool.execute(
            `UPDATE brands SET ${setClause} WHERE id = ?`,
            values
        );

        return result.affectedRows > 0;
    }

    // DELETE
    static async delete(id) {
        const [result] = await pool.execute('DELETE FROM brands WHERE id = ?', [id]);
        return result.affectedRows > 0; // Trả về true nếu delete thành công
    }
}

module.exports = Brand;