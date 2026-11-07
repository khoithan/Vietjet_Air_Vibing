/**
 * ============================================================================
 * VIETJET TRAVEL WEBSITE - TOUR DETAIL LOGIC (js/tour-detail.js)
 * Hiển thị: Điểm đi, điểm đến, thời gian bay, hãng bay, loại máy bay (Boeing, Airbus...)
 * Lịch trình chuyến đi (Itinerary Timeline)
 * Chọn tour sẽ được lưu vào Giỏ Hàng (cart_items trong SQLite)
 * ============================================================================
 */

let currentTour = null;

document.addEventListener('DOMContentLoaded', async () => {
  try {
    await VietjetDB.init();
    VietjetDB.updateCartBadge();

    const tourId = Number(VietjetUtils.getQueryParam('id')) || 1;
    loadTourDetail(tourId);
  } catch (err) {
    console.error('Lỗi tải chi tiết Tour:', err);
  }
});

function loadTourDetail(tourId) {
  const sql = `
    SELECT t.*, a.logo_url
    FROM tours t
    LEFT JOIN airlines a ON t.airline_id = a.id
    WHERE t.id = ?
  `;
  currentTour = VietjetDB.queryOne(sql, [tourId]);

  if (!currentTour) {
    currentTour = VietjetDB.queryOne(`
      SELECT t.*, a.logo_url
      FROM tours t
      LEFT JOIN airlines a ON t.airline_id = a.id
      ORDER BY t.id ASC LIMIT 1
    `);
  }

  if (!currentTour) return;
  renderTourDetailView();
}

function renderTourDetailView() {
  const container = document.getElementById('tour-detail-content');
  if (!container || !currentTour) return;

  let itinerary = [];
  try {
    itinerary = JSON.parse(currentTour.itinerary_json || '[]');
  } catch {
    itinerary = [];
  }

  container.innerHTML = `
    <div class="detail-card">
      <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:16px; margin-bottom:20px;">
        <div>
          <div style="display:flex; gap:8px; flex-wrap:wrap; margin-bottom:8px;">
            <span class="tag-pill red">⏱ ${currentTour.duration_text}</span>
            <span class="tag-pill">🏢 Hãng lữ hành: ${currentTour.travel_agency}</span>
          </div>
          <h2 style="font-size:1.75rem; font-weight:800; color:var(--text-primary);">${currentTour.title}</h2>
        </div>
        <a href="tours.html" class="btn-outline">← Quay lại danh sách Tour</a>
      </div>

      <!-- Hình ảnh 600x400 & Khung đặt Tour nhanh -->
      <div style="display:grid; grid-template-columns: 1.25fr 0.95fr; gap:28px; align-items:start;">
        <div style="border-radius:var(--radius-md); overflow:hidden; border:1px solid var(--border-color); aspect-ratio: 600 / 400;">
          <img src="${currentTour.thumbnail_url}" alt="${currentTour.title}" width="600" height="400" style="width:100%; height:100%; object-fit:cover;" />
        </div>

        <div style="background:var(--bg-secondary); border:1.5px solid rgba(238,29,35,0.2); border-radius:var(--radius-md); padding:24px;">
          <span style="font-size:0.84rem; color:var(--text-muted); font-weight:700; text-transform:uppercase;">Giá Tour Trọn Gói / Khách</span>
          <div style="font-size:2.1rem; font-weight:800; color:var(--primary-color); margin:6px 0 16px;">
            ${VietjetUtils.formatCurrency(currentTour.price)}
          </div>

          <div style="display:flex; flex-direction:column; gap:10px; font-size:0.93rem; margin-bottom:20px; padding-bottom:16px; border-bottom:1px dashed var(--border-color);">
            <div><strong>📍 Hành trình:</strong> ${currentTour.origin_city} (${currentTour.origin_code}) ➔ ${currentTour.destination_city} (${currentTour.destination_code})</div>
            <div><strong>✈ Hãng hàng không:</strong> ${currentTour.airline_name}</div>
            <div><strong>🛩 Loại máy bay:</strong> <span style="color:var(--primary-color); font-weight:700;">${currentTour.aircraft_type}</span></div>
            <div><strong>📅 Ngày khởi hành:</strong> ${VietjetUtils.formatDate(currentTour.departure_date)} (Cất cánh: ${currentTour.departure_time})</div>
            <div><strong>⏱ Thời gian bay:</strong> ${currentTour.flight_duration}</div>
            <div><strong>🎁 Dịch vụ bao gồm:</strong> ${currentTour.services}</div>
          </div>

          <div style="display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:16px;">
            <label for="tour-guest-qty" style="font-weight:700;">Số lượng khách:</label>
            <input type="number" id="tour-guest-qty" class="form-control" value="1" min="1" max="20" style="width:100px;" />
          </div>

          <button type="button" class="btn-primary" style="width:100%; font-size:1.05rem; padding:15px;" onclick="addTourToCart()">
            🛒 Chọn Tour & Lưu Vào Giỏ Hàng
          </button>
        </div>
      </div>

      <!-- Bảng thông số Hàng không của Tour -->
      <div class="specs-table" style="margin-top:26px;">
        <div class="spec-box">
          <div class="spec-label">Điểm Đi ➔ Điểm Đến</div>
          <div class="spec-val">📍 ${currentTour.origin_city} ➔ ${currentTour.destination_city}</div>
        </div>
        <div class="spec-box">
          <div class="spec-label">Thời Gian Bay</div>
          <div class="spec-val">⏱ ${currentTour.flight_duration} (Khởi hành ${currentTour.departure_time})</div>
        </div>
        <div class="spec-box">
          <div class="spec-label">Hãng Bay Đồng Hành</div>
          <div class="spec-val">✈ ${currentTour.airline_name}</div>
        </div>
        <div class="spec-box">
          <div class="spec-label">Loại Máy Bay (Boeing / Airbus)</div>
          <div class="spec-val">🛩 ${currentTour.aircraft_type}</div>
        </div>
      </div>
    </div>

    <!-- LỊCH TRÌNH CHUYẾN ĐI CHI TIẾT -->
    <div class="detail-card">
      <h3 style="font-size:1.45rem; font-weight:800; color:var(--text-primary); margin-bottom:6px;">
        🗓 Lịch Trình Chuyến Đi Chi Tiết (${currentTour.duration_text})
      </h3>
      <p style="color:var(--text-muted); font-size:0.95rem;">
        Hành trình được thiết kế trọn gói bởi <strong>${currentTour.travel_agency}</strong> kết hợp bay cùng <strong>${currentTour.airline_name} (${currentTour.aircraft_type})</strong>.
      </p>

      <div class="itinerary-timeline">
        ${itinerary
          .map(
            (step) => `
          <div class="itinerary-step">
            <div class="itinerary-day-title">${step.day}</div>
            <p style="color:var(--text-secondary); font-size:0.95rem;">${step.details}</p>
          </div>
        `
          )
          .join('')}
      </div>

      <div style="margin-top:28px; text-align:right;">
        <button type="button" class="btn-primary" style="padding:14px 32px; font-size:1.05rem;" onclick="addTourToCart()">
          🛒 Chọn Tour Này (Lưu Vào Giỏ Hàng)
        </button>
      </div>
    </div>
  `;
}

function addTourToCart() {
  if (!currentTour) return;

  const qtyInput = document.getElementById('tour-guest-qty');
  const quantity = Math.max(1, parseInt(qtyInput?.value || '1', 10));

  VietjetDB.run(
    `INSERT INTO cart_items (
      item_type, ref_id, title, subtitle,
      origin_city, destination_city, service_class,
      unit_price, quantity, departure_date, departure_time,
      flight_duration, airline_name, aircraft_type
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      'TOUR',
      currentTour.id,
      currentTour.title,
      `${currentTour.travel_agency} • ${currentTour.duration_text}`,
      currentTour.origin_city,
      currentTour.destination_city,
      'Tour Trọn Gói',
      currentTour.price,
      quantity,
      currentTour.departure_date,
      currentTour.departure_time,
      currentTour.flight_duration,
      currentTour.airline_name,
      currentTour.aircraft_type
    ]
  );

  window.location.href = 'cart.html?added=tour';
}
