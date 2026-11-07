/**
 * ============================================================================
 * VIETJET TRAVEL WEBSITE - FLIGHTS LISTING & FILTER LOGIC (js/flights.js)
 * Bên trái: Filter giá vé tăng/giảm dần, vé khứ hồi, vé một chiều, bay thẳng,
 *           nhiều thành phố, các hãng hàng không, thời gian cất cánh (giờ),
 *           hạng dịch vụ (Phổ thông, Thương gia).
 * Bên phải: Các chuyến bay của các hãng, ngày cất cánh, thời gian bay, giá tiền, dịch vụ.
 * Click chọn chuyến bay sẽ đến trang Chi tiết chuyến bay (flight-detail.html).
 * ============================================================================
 */

document.addEventListener('DOMContentLoaded', async () => {
  try {
    await VietjetDB.init();
    VietjetDB.updateCartBadge();

    populateAirlineFilterCheckboxes();
    applyUrlParamsToFilters();
    bindFilterEvents();
    filterAndRenderFlights();
  } catch (err) {
    console.error('Lỗi khởi tạo trang Chuyến bay:', err);
  }
});

/**
 * Render danh sách checkbox các hãng hàng không từ bảng airlines
 */
function populateAirlineFilterCheckboxes() {
  const container = document.getElementById('filter-airlines-list');
  if (!container) return;

  const airlines = VietjetDB.query('SELECT * FROM airlines ORDER BY id ASC');
  container.innerHTML = airlines
    .map(
      (a) => `
      <label class="filter-check-label">
        <input type="checkbox" name="filter_airline" value="${a.name}" />
        <span>${a.name}</span>
      </label>
    `
    )
    .join('');
}

/**
 * Đọc Query Params từ URL (nếu người dùng tìm kiếm từ Trang chủ hoặc click logo hãng bay)
 */
function applyUrlParamsToFilters() {
  const airlineParam = VietjetUtils.getQueryParam('airline');
  const tripTypeParam = VietjetUtils.getQueryParam('trip_type');
  const originParam = VietjetUtils.getQueryParam('origin');
  const destParam = VietjetUtils.getQueryParam('destination');

  if (airlineParam) {
    const checkboxes = document.querySelectorAll('input[name="filter_airline"]');
    checkboxes.forEach((cb) => {
      if (cb.value.toLowerCase() === airlineParam.toLowerCase()) {
        cb.checked = true;
      }
    });
  }

  if (tripTypeParam) {
    const tripCheckboxes = document.querySelectorAll('input[name="filter_trip_type"]');
    tripCheckboxes.forEach((cb) => {
      if (cb.value === tripTypeParam) {
        cb.checked = true;
      }
    });
  }

  const originSelect = document.getElementById('filter-origin');
  const destSelect = document.getElementById('filter-destination');
  if (originSelect && originParam) originSelect.value = originParam;
  if (destSelect && destParam) destSelect.value = destParam;
}

/**
 * Lắng nghe sự kiện thay đổi bộ lọc
 */
function bindFilterEvents() {
  const filterInputs = document.querySelectorAll(
    '#flights-filter-sidebar input, #flights-filter-sidebar select'
  );
  filterInputs.forEach((el) => {
    el.addEventListener('change', () => filterAndRenderFlights());
  });

  const resetBtn = document.getElementById('btn-reset-flight-filters');
  if (resetBtn) {
    resetBtn.addEventListener('click', () => {
      document.querySelectorAll('#flights-filter-sidebar input[type="checkbox"]').forEach((cb) => {
        cb.checked = false;
      });
      const sortAsc = document.querySelector('input[name="filter_sort"][value="price_asc"]');
      if (sortAsc) sortAsc.checked = true;
      const defaultClass = document.querySelector('input[name="filter_class"][value="all"]');
      if (defaultClass) defaultClass.checked = true;

      const originSelect = document.getElementById('filter-origin');
      const destSelect = document.getElementById('filter-destination');
      if (originSelect) originSelect.value = '';
      if (destSelect) destSelect.value = '';

      window.history.replaceState({}, '', 'flights.html');
      filterAndRenderFlights();
    });
  }
}

/**
 * Thực thi truy vấn lọc SQLite và hiển thị danh sách chuyến bay
 */
function filterAndRenderFlights() {
  const sortValue =
    document.querySelector('input[name="filter_sort"]:checked')?.value || 'price_asc';
  const selectedClass =
    document.querySelector('input[name="filter_class"]:checked')?.value || 'all';
  const originVal = document.getElementById('filter-origin')?.value || '';
  const destVal = document.getElementById('filter-destination')?.value || '';

  const checkedTripTypes = Array.from(
    document.querySelectorAll('input[name="filter_trip_type"]:checked')
  ).map((el) => el.value);

  const checkedAirlines = Array.from(
    document.querySelectorAll('input[name="filter_airline"]:checked')
  ).map((el) => el.value);

  const checkedTimeSlots = Array.from(
    document.querySelectorAll('input[name="filter_time"]:checked')
  ).map((el) => el.value);

  // Lấy toàn bộ chuyến bay kèm logo hãng từ SQLite
  const sql = `
    SELECT f.*, a.logo_url
    FROM flights f
    LEFT JOIN airlines a ON f.airline_id = a.id
  `;
  let flights = VietjetDB.query(sql);

  // 1. Lọc Điểm đi & Điểm đến
  if (originVal) {
    flights = flights.filter((f) => f.origin_code === originVal);
  }
  if (destVal) {
    flights = flights.filter((f) => f.destination_code === destVal);
  }

  // 2. Lọc Loại vé (Khứ hồi, Một chiều, Bay thẳng, Nhiều thành phố)
  if (checkedTripTypes.length > 0) {
    flights = flights.filter((f) => {
      return checkedTripTypes.some((type) => {
        if (type === 'direct') return f.is_direct === 1 || f.trip_type === 'direct';
        return f.trip_type === type;
      });
    });
  }

  // 3. Lọc Hãng hàng không
  if (checkedAirlines.length > 0) {
    flights = flights.filter((f) => checkedAirlines.includes(f.airline_name));
  }

  // 4. Lọc Thời gian cất cánh (giờ)
  if (checkedTimeSlots.length > 0) {
    flights = flights.filter((f) => {
      const hour = parseInt(f.departure_time.split(':')[0], 10);
      return checkedTimeSlots.some((slot) => {
        if (slot === 'early_morning') return hour >= 0 && hour < 6;
        if (slot === 'morning') return hour >= 6 && hour < 12;
        if (slot === 'afternoon') return hour >= 12 && hour < 18;
        if (slot === 'evening') return hour >= 18 && hour <= 23;
        return true;
      });
    });
  }

  // 5. Xác định giá và dịch vụ theo Hạng dịch vụ đang chọn (Phổ thông vs Thương gia)
  const isBusinessView = selectedClass === 'business';

  // 6. Sắp xếp Giá tăng/giảm dần
  flights.sort((a, b) => {
    const priceA = isBusinessView ? a.price_business : a.price_economy;
    const priceB = isBusinessView ? b.price_business : b.price_economy;
    return sortValue === 'price_desc' ? priceB - priceA : priceA - priceB;
  });

  // 7. Render kết quả
  const countEl = document.getElementById('flights-count-num');
  if (countEl) countEl.textContent = flights.length;

  const listEl = document.getElementById('flights-results-list');
  if (!listEl) return;

  if (flights.length === 0) {
    listEl.innerHTML = `
      <div class="detail-card" style="text-align:center; padding: 48px 24px;">
        <h3 style="margin-bottom: 10px; color: var(--primary-color);">Không tìm thấy chuyến bay phù hợp</h3>
        <p style="color: var(--text-muted); margin-bottom: 20px;">Vui lòng thử điều chỉnh hoặc đặt lại bộ lọc bên trái để xem tất cả các chuyến bay.</p>
        <button class="btn-primary" onclick="document.getElementById('btn-reset-flight-filters').click()">Xem tất cả chuyến bay</button>
      </div>
    `;
    return;
  }

  listEl.innerHTML = flights
    .map((f) => {
      const displayPrice = isBusinessView ? f.price_business : f.price_economy;
      const displayClassLabel = isBusinessView ? 'Hạng Thương Gia' : 'Hạng Phổ Thông';
      const displayServices = isBusinessView ? f.services_business : f.services_economy;
      const classParam = isBusinessView ? '&class=business' : '&class=economy';

      return `
        <article class="flight-card" onclick="window.location.href='flight-detail.html?id=${f.id}${classParam}'">
          <div class="flight-card-main">
            <div class="flight-airline-info">
              <div class="flight-airline-logo">
                <img src="${f.logo_url || 'images/2aOboRAvPCnNF8ux8l12JJoKC6uw9yMZkM5dUYs4.jpg'}" alt="${f.airline_name}" onerror="this.src='images/2aOboRAvPCnNF8ux8l12JJoKC6uw9yMZkM5dUYs4.jpg'" />
              </div>
              <div>
                <div class="flight-airline-name">${f.airline_name}</div>
                <div class="flight-code-badge">${f.flight_code} • ${f.aircraft_type}</div>
              </div>
            </div>

            <div class="flight-schedule-box">
              <div class="flight-time-point">
                <div class="flight-hour">${f.departure_time}</div>
                <div class="flight-city">${f.origin_city} (${f.origin_code})</div>
              </div>

              <div class="flight-duration-line">
                <span class="flight-duration-text">⏱ ${f.duration}</span>
                <div class="flight-line-graphic"></div>
                <span class="flight-type-sub">${VietjetUtils.formatTripType(f.trip_type, f.is_direct)}</span>
              </div>

              <div class="flight-time-point">
                <div class="flight-hour">${f.arrival_time}</div>
                <div class="flight-city">${f.destination_city} (${f.destination_code})</div>
              </div>
            </div>

            <div class="flight-price-action">
              <span class="tag-pill red" style="margin-bottom: 6px;">${displayClassLabel}</span>
              <span class="flight-price-amount">${VietjetUtils.formatCurrency(displayPrice)}</span>
              <span class="flight-price-unit">Giá 1 chiều / hành khách</span>
              <button type="button" class="btn-primary" style="width: 100%; padding: 10px 16px;">
                Chọn chuyến bay ➔
              </button>
            </div>
          </div>

          <div class="flight-card-footer">
            <div>
              <strong>📅 Ngày cất cánh:</strong> ${VietjetUtils.formatDate(f.departure_date)}
              ${f.return_date ? ` • <strong>Ngày về:</strong> ${VietjetUtils.formatDate(f.return_date)}` : ''}
            </div>
            <div>
              <strong>🎁 Dịch vụ (${displayClassLabel}):</strong> ${displayServices}
            </div>
          </div>
        </article>
      `;
    })
    .join('');
}
