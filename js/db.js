/**
 * ============================================================================
 * VIETJET TRAVEL WEBSITE - SQLITE DATABASE ENGINE (js/db.js)
 * Đọc trực tiếp dữ liệu từ file SQLite/db.db (hoặc db.db) bằng sql.js (WebAssembly)
 * và lưu trạng thái Giỏ hàng / Đặt chỗ bền vững vào localStorage.
 * ============================================================================
 */

const DB_STORAGE_KEY = 'vietjet_sqlite_db_v1';

const VietjetDB = {
  db: null,
  SQL: null,

  /**
   * Khởi tạo SQLite Database
   */
  async init() {
    if (this.db) return this.db;

    // 1. Nạp thư viện sql.js WebAssembly
    if (typeof initSqlJs === 'undefined') {
      throw new Error('Thư viện sql.js chưa được nạp.');
    }

    this.SQL = await initSqlJs({
      locateFile: (file) => `https://cdnjs.cloudflare.com/ajax/libs/sql.js/1.10.3/${file}`
    });

    // 2. Kiểm tra xem người dùng đã có phiên bản DB lưu trong localStorage chưa
    const savedBase64 = localStorage.getItem(DB_STORAGE_KEY);
    if (savedBase64) {
      try {
        const bytes = this.base64ToUint8Array(savedBase64);
        this.db = new this.SQL.Database(bytes);
        return this.db;
      } catch (err) {
        console.warn('Khôi phục DB từ localStorage thất bại, tiến hành đọc lại từ db.db:', err);
      }
    }

    // 3. Đọc trực tiếp từ file SQLite/db.db hoặc db.db
    let dbBytes = null;
    const dbPaths = ['SQLite/db.db', 'db.db', 'SQLite/vietjet.db', 'SQLite/full.db'];

    for (const path of dbPaths) {
      try {
        const response = await fetch(path);
        if (response.ok) {
          const buffer = await response.arrayBuffer();
          const uint8 = new Uint8Array(buffer);
          // Kiểm tra header "SQLite format 3"
          if (uint8.length > 16 && uint8[0] === 0x53 && uint8[1] === 0x51 && uint8[2] === 0x4c) {
            dbBytes = uint8;
            console.log(`Đã tải thành công cơ sở dữ liệu SQLite từ: ${path}`);
            break;
          }
        }
      } catch (fetchErr) {
        // Nếu mở trực tiếp qua giao thức file://, fetch có thể bị chặn CORS
      }
    }

    // 4. Fallback khi mở trực tiếp file .html (file://) không qua HTTP Server:
    // Sử dụng bản nhị phân của chính file db.db được đóng gói trong SQLite/vietjet_db_binary.js
    if (!dbBytes && window.VIETJET_SQLITE_BASE64) {
      dbBytes = this.base64ToUint8Array(window.VIETJET_SQLITE_BASE64);
      console.log('Đã nạp cơ sở dữ liệu SQLite nhị phân từ db.db (chế độ local file).');
    }

    if (dbBytes) {
      this.db = new this.SQL.Database(dbBytes);
      this.save();
      return this.db;
    }

    throw new Error('Không thể nạp file cơ sở dữ liệu db.db');
  },

  /**
   * Lưu snapshot nhị phân của SQLite vào localStorage sau khi thêm/xóa giỏ hàng hoặc đặt vé
   */
  save() {
    if (!this.db) return;
    const data = this.db.export();
    const base64 = this.uint8ArrayToBase64(data);
    localStorage.setItem(DB_STORAGE_KEY, base64);
    this.updateCartBadge();
  },

  /**
   * Đặt lại database về trạng thái gốc của file db.db
   */
  async resetToDefault() {
    localStorage.removeItem(DB_STORAGE_KEY);
    this.db = null;
    await this.init();
    this.updateCartBadge();
  },

  /**
   * Thực thi câu lệnh SELECT và trả về mảng các Object
   */
  query(sql, params = []) {
    if (!this.db) throw new Error('Database chưa được khởi tạo.');
    const stmt = this.db.prepare(sql);
    stmt.bind(params);
    const rows = [];
    while (stmt.step()) {
      rows.push(stmt.getAsObject());
    }
    stmt.free();
    return rows;
  },

  /**
   * Thực thi câu lệnh SELECT trả về 1 dòng đầu tiên
   */
  queryOne(sql, params = []) {
    const rows = this.query(sql, params);
    return rows.length > 0 ? rows[0] : null;
  },

  /**
   * Thực thi câu lệnh INSERT, UPDATE, DELETE
   */
  run(sql, params = []) {
    if (!this.db) throw new Error('Database chưa được khởi tạo.');
    this.db.run(sql, params);
    this.save();
  },

  /**
   * Lấy tổng số lượng sản phẩm trong bảng cart_items
   */
  getCartCount() {
    if (!this.db) return 0;
    try {
      const row = this.queryOne('SELECT COALESCE(SUM(quantity), 0) AS total FROM cart_items');
      return row ? Number(row.total) : 0;
    } catch {
      return 0;
    }
  },

  /**
   * Cập nhật số lượng hiển thị trên nút Giỏ Hàng ở Header
   */
  updateCartBadge() {
    const badges = document.querySelectorAll('.cart-count-badge');
    const count = this.getCartCount();
    badges.forEach((el) => {
      el.textContent = count;
    });
  },

  /**
   * Chuyển đổi Base64 <-> Uint8Array
   */
  base64ToUint8Array(base64) {
    const binaryString = window.atob(base64.trim());
    const len = binaryString.length;
    const bytes = new Uint8Array(len);
    for (let i = 0; i < len; i++) {
      bytes[i] = binaryString.charCodeAt(i);
    }
    return bytes;
  },

  uint8ArrayToBase64(uint8Array) {
    let binary = '';
    const chunkSize = 0x8000;
    for (let i = 0; i < uint8Array.length; i += chunkSize) {
      const sub = uint8Array.subarray(i, i + chunkSize);
      binary += String.fromCharCode.apply(null, sub);
    }
    return window.btoa(binary);
  }
};

/**
 * Các hàm tiện ích định dạng tiền tệ & ngày tháng
 */
const VietjetUtils = {
  formatCurrency(amount) {
    const num = Number(amount) || 0;
    return new Intl.NumberFormat('vi-VN').format(num) + ' ₫';
  },

  formatDate(dateStr) {
    if (!dateStr) return 'Linh hoạt';
    const parts = dateStr.split('-');
    if (parts.length !== 3) return dateStr;
    return `${parts[2]}/${parts[1]}/${parts[0]}`;
  },

  formatTripType(type, isDirect) {
    const map = {
      'round-trip': 'Vé khứ hồi',
      'one-way': 'Vé một chiều',
      'direct': 'Bay thẳng',
      'multi-city': 'Nhiều thành phố'
    };
    const label = map[type] || type;
    if (isDirect && type !== 'direct' && type !== 'multi-city') {
      return `${label} • Bay thẳng`;
    }
    return label;
  },

  getQueryParam(name) {
    const params = new URLSearchParams(window.location.search);
    return params.get(name);
  }
};
