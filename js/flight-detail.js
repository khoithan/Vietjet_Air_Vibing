/**
 * ============================================================================
 * VIETJET TRAVEL WEBSITE - FLIGHT DETAIL LOGIC (js/flight-detail.js)
 * Hiển thị: Điểm đi, điểm đến, thời gian bay, hãng bay, loại máy bay (Boeing, Airbus...)
 * Chọn giá vé: Hạng Phổ Thông, Hạng Thương Gia
 * Chọn chuyến bay sẽ được lưu vào Giỏ Hàng (bảng cart_items trong SQLite)
 * ============================================================================
 */

let currentFlight = null;
let selectedFareClass = 'economy'; // 'economy' | 'business'

document.addEventListener('DOMContentLoaded', async () => {
  try {
    await VietjetDB.init();
    VietjetDB.updateCartBadge();

    const flightId = Number(VietjetUtils.getQueryParam('id')) || 1;
    const initialClass = VietjetUtils.getQueryParam('class');
    if (initialClass === 'business') {
      selectedFareClass = 'business';
    }

    loadFlightDetail(flightId);
  } catch (err) {
    console.error('Lỗi tải chi tiết chuyến bay:', err);
  }
});

function loadFlightDetail(flightId) {
  const sql = `
    SELECT f.*, a.logo_url, a.country
    FROM flights f
    LEFT JOIN airlines a ON f.airline_id = a.id
    WHERE f.id = ?
  `;
  currentFlight = VietjetDB.queryOne(sql, [flightId]);

  if (!currentFlight) {
    currentFlight = VietjetDB.queryOne(`
      SELECT f.*, a.logo_url, a.country
      FROM flights f
      LEFT JOIN airlines a ON f.airline_id = a.id
      ORDER BY f.id ASC LIMIT 1
    `);
  }

  if (!currentFlight) return;

  renderFlightDetailView();
}

function renderFlightDetailView() {
  const container = document.getElementById('flight-detail-content');
  if (!container || !currentFlight) return;

  const ecoBenefits = currentFlight.services_economy.split(',').map((s) => s.trim());
  const bizBenefits = currentFlight.services_business.split(',').map((s) => s.trim());

  container.innerHTML = `
    <div class="detail-card">
      <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:14px;">
        <div style="display:flex; align-items:center; gap:14px;">
          <img src="${currentFlight.logo_url || 'images/2aOboRAvPCnNF8ux8l12JJoKC6uw9yMZkM5dUYs4.jpg'}"
               alt="${currentFlight.airline_name}"
               style="width:58px; height:58px; object-fit:contain; border:1px solid var(--border-color); border-radius:10px; padding:6px;"
               onerror="this.src='images/2aOboRAvPCnNF8ux8l12JJoKC6uw9yMZkM5dUYs4.jpg'" />
          <div>
            <span class="tag-pill red">${VietjetUtils.formatTripType(currentFlight.trip_type, currentFlight.is_direct)}</span>
            <h2 style="font-size:1.55rem; font-weight:800; margin-top:4px;">
              ${currentFlight.origin_city} (${currentFlight.origin_code}) ➔ ${currentFlight.destination_city} (${currentFlight.destination_code})
            </h2>
          </div>
        </div>
        <a href="flights.html" class="btn-outline">← Quay lại danh sách chuyến bay</a>
      </div>

      <div class="flight-overview-banner">
        <div style="text-align:center;">
          <div style="font-size:0.85rem; color:var(--text-muted); font-weight:700;">ĐIỂM XUẤT PHÁT</div>
          <div style="font-size:2rem; font-weight:800; color:var(--primary-color);">${currentFlight.departure_time}</div>
          <div style="font-size:1.15rem; font-weight:700;">${currentFlight.origin_city} (${currentFlight.origin_code})</div>
          <div style="font-size:0.88rem; color:var(--text-muted);">Ngày đi: ${VietjetUtils.formatDate(currentFlight.departure_date)}</div>
        </div>

        <div style="text-align:center; min-width:180px;">
          <div style="font-size:0.9rem; font-weight:800; color:var(--primary-color); margin-bottom:6px;">
            ⏱ Thời gian bay: ${currentFlight.duration}
          </div>
          <div class="flight-line-graphic" style="width:180px; margin:0 auto;"></div>
          <div style="font-size:0.84rem; color:var(--text-secondary); margin-top:8px; font-weight:700;">
            ✈ Tàu bay: ${currentFlight.aircraft_type}
          </div>
        </div>

        <div style="text-align:center;">
          <div style="font-size:0.85rem; color:var(--text-muted); font-weight:700;">ĐIỂM ĐẾN</div>
          <div style="font-size:2rem; font-weight:800; color:var(--primary-color);">${currentFlight.arrival_time}</div>
          <div style="font-size:1.15rem; font-weight:700;">${currentFlight.destination_city} (${currentFlight.destination_code})</div>
          <div style="font-size:0.88rem; color:var(--text-muted);">
            ${currentFlight.return_date ? `Ngày về: ${VietjetUtils.formatDate(currentFlight.return_date)}` : 'Hành trình 1 chiều'}
          </div>
        </div>
      </div>

      <div class="specs-table">
        <div class="spec-box">
          <div class="spec-label">Hãng Hàng Không</div>
          <div class="spec-val">🏢 ${currentFlight.airline_name} (${currentFlight.flight_code})</div>
        </div>
        <div class="spec-box">
          <div class="spec-label">Loại Máy Bay (Boeing / Airbus)</div>
          <div class="spec-val">🛩 ${currentFlight.aircraft_type}</div>
        </div>
        <div class="spec-box">
          <div class="spec-label">Thời Gian Bay</div>
          <div class="spec-val">⏱ ${currentFlight.duration} (${currentFlight.departure_time} - ${currentFlight.arrival_time})</div>
        </div>
        <div class="spec-box">
          <div class="spec-label">Điểm Đi ➔ Điểm Đến</div>
          <div class="spec-val">📍 ${currentFlight.origin_city} ➔ ${currentFlight.destination_city}</div>
        </div>
      </div>
    </div>

    <!-- CHỌN HẠNG GIÁ VÉ: HẠNG PHỔ THÔNG & HẠNG THƯƠNG GIA -->
    <div class="detail-card">
      <h3 style="font-size:1.45rem; font-weight:800; margin-bottom:6px; color:var(--text-primary);">
        Chọn Hạng Giá Vé Của Bạn
      </h3>
      <p style="color:var(--text-muted); font-size:0.95rem;">
        Vui lòng click chọn <strong>Hạng Phổ Thông</strong> hoặc <strong>Hạng Thương Gia</strong> trước khi lưu chuyến bay vào Giỏ Hàng.
      </p>

      <div class="fare-classes-grid">
        <!-- Card 1: Hạng Phổ Thông -->
        <div class="fare-card ${selectedFareClass === 'economy' ? 'selected' : ''}"
             id="fare-card-economy"
             onclick="selectFareClass('economy')">
          <div class="fare-card-header">
            <div class="fare-name">Hạng Phổ Thông (Economy / Eco)</div>
            <div class="fare-price">${VietjetUtils.formatCurrency(currentFlight.price_economy)}</div>
            <div style="font-size:0.82rem; opacity:0.9; margin-top:4px;">Tiết kiệm & Linh hoạt trên tàu bay ${currentFlight.aircraft_type}</div>
          </div>
          <div class="fare-card-body">
            ${ecoBenefits
              .map(
                (b) => `
              <div class="fare-benefit-item">
                <span class="check">✔</span>
                <span>${b}</span>
              </div>
            `
              )
              .join('')}
            <div class="fare-benefit-item">
              <span class="check">✔</span>
              <span>Làm thủ tục trực tuyến (Check-in Online) miễn phí</span>
            </div>
          </div>
          <div class="fare-card-footer">
            <label style="cursor:pointer; font-weight:800; color:var(--primary-color); display:inline-flex; align-items:center; gap:8px;">
              <input type="radio" name="fare_class_radio" value="economy" ${selectedFareClass === 'economy' ? 'checked' : ''} style="accent-color:var(--primary-color); width:18px; height:18px;" />
              Chọn Hạng Phổ Thông
            </label>
          </div>
        </div>

        <!-- Card 2: Hạng Thương Gia -->
        <div class="fare-card business ${selectedFareClass === 'business' ? 'selected' : ''}"
             id="fare-card-business"
             onclick="selectFareClass('business')">
          <div class="fare-card-header">
            <div class="fare-name">👑 Hạng Thương Gia (Business / SkyBoss)</div>
            <div class="fare-price">${VietjetUtils.formatCurrency(currentFlight.price_business)}</div>
            <div style="font-size:0.82rem; opacity:0.92; margin-top:4px;">Đặc quyền thượng hạng • Ưu tiên toàn diện</div>
          </div>
          <div class="fare-card-body">
            ${bizBenefits
              .map(
                (b) => `
              <div class="fare-benefit-item">
                <span class="check">✔</span>
                <span><strong>${b}</strong></span>
              </div>
            `
              )
              .join('')}
            <div class="fare-benefit-item">
              <span class="check">✔</span>
              <span>Miễn phí thay đổi ngày giờ bay & quầy làm thủ tục ưu tiên riêng</span>
            </div>
          </div>
          <div class="fare-card-footer">
            <label style="cursor:pointer; font-weight:800; color:var(--primary-color); display:inline-flex; align-items:center; gap:8px;">
              <input type="radio" name="fare_class_radio" value="business" ${selectedFareClass === 'business' ? 'checked' : ''} style="accent-color:var(--primary-color); width:18px; height:18px;" />
              Chọn Hạng Thương Gia
            </label>
          </div>
        </div>
      </div>

      <!-- KHU VỰC XÁC NHẬN LƯU VÀO GIỎ HÀNG -->
      <div style="margin-top:28px; padding-top:22px; border-top:1px solid var(--border-color); display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:18px;">
        <div style="display:flex; align-items:center; gap:14px;">
          <label for="passenger-qty" style="font-weight:700;">Số lượng hành khách:</label>
          <input type="number" id="passenger-qty" class="form-control" value="1" min="1" max="10" style="width:90px;" />
        </div>

        <button type="button" class="btn-primary" style="font-size:1.08rem; padding:15px 34px;" onclick="addSelectedFlightToCart()">
          🛒 Chọn Chuyến Bay & Lưu Vào Giỏ Hàng
        </button>
      </div>
    </div>
  `;
}

function selectFareClass(fareType) {
  selectedFareClass = fareType;
  const ecoCard = document.getElementById('fare-card-economy');
  const bizCard = document.getElementById('fare-card-business');
  if (ecoCard && bizCard) {
    ecoCard.classList.toggle('selected', fareType === 'economy');
    bizCard.classList.toggle('selected', fareType === 'business');
  }
  const radios = document.querySelectorAll('input[name="fare_class_radio"]');
  radios.forEach((r) => {
    r.checked = r.value === fareType;
  });
}

function addSelectedFlightToCart() {
  if (!currentFlight) return;

  const qtyInput = document.getElementById('passenger-qty');
  const quantity = Math.max(1, parseInt(qtyInput?.value || '1', 10));

  const isBusiness = selectedFareClass === 'business';
  const serviceClass = isBusiness ? 'Hạng Thương Gia' : 'Hạng Phổ Thông';
  const unitPrice = isBusiness ? currentFlight.price_business : currentFlight.price_economy;
  const title = `${currentFlight.origin_city} (${currentFlight.origin_code}) ➔ ${currentFlight.destination_city} (${currentFlight.destination_code})`;
  const subtitle = `Chuyến bay ${currentFlight.flight_code} • ${VietjetUtils.formatTripType(currentFlight.trip_type, currentFlight.is_direct)}`;

  VietjetDB.run(
    `INSERT INTO cart_items (
      item_type, ref_id, title, subtitle,
      origin_city, destination_city, service_class,
      unit_price, quantity, departure_date, departure_time,
      flight_duration, airline_name, aircraft_type
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      'FLIGHT',
      currentFlight.id,
      title,
      subtitle,
      currentFlight.origin_city,
      currentFlight.destination_city,
      serviceClass,
      unitPrice,
      quantity,
      currentFlight.departure_date,
      currentFlight.departure_time,
      currentFlight.duration,
      currentFlight.airline_name,
      currentFlight.aircraft_type
    ]
  );

  window.location.href = 'cart.html?added=flight';
}
