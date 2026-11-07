/**
 * ============================================================================
 * VIETJET TRAVEL WEBSITE - HOME PAGE LOGIC (js/home.js)
 * - Xử lý form tìm kiếm chuyến bay (Vé khứ hồi / Vé một chiều, Điểm đi, Điểm đến, Ngày)
 * - Hiển thị 8 Tour du lịch nổi bật (thumbnail 600x400, hãng du lịch, số ngày/đêm, giá tour)
 * - Hiển thị các Hãng hàng không đối tác (Click vào logo dẫn tới trang Chuyến Bay)
 * ============================================================================
 */

document.addEventListener('DOMContentLoaded', async () => {
  try {
    await VietjetDB.init();
    VietjetDB.updateCartBadge();

    initSearchForm();
    renderFeaturedTours();
    renderAirlines();
  } catch (err) {
    console.error('Lỗi khởi tạo trang chủ:', err);
  }
});

/**
 * 1. Khởi tạo khung tìm kiếm chuyến bay
 */
function initSearchForm() {
  const tripRadios = document.querySelectorAll('input[name="trip_type"]');
  const returnDateInput = document.getElementById('search-return-date');
  const radioLabels = document.querySelectorAll('.trip-radio-label');

  tripRadios.forEach((radio) => {
    radio.addEventListener('change', () => {
      radioLabels.forEach((lbl) => lbl.classList.remove('active'));
      radio.closest('.trip-radio-label').classList.add('active');

      if (radio.value === 'one-way') {
        returnDateInput.disabled = true;
        returnDateInput.value = '';
      } else {
        returnDateInput.disabled = false;
        if (!returnDateInput.value) {
          returnDateInput.value = '2026-11-18';
        }
      }
    });
  });

  const searchForm = document.getElementById('home-flight-search-form');
  if (searchForm) {
    searchForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const tripType = document.querySelector('input[name="trip_type"]:checked')?.value || '';
      const origin = document.getElementById('search-origin')?.value || '';
      const destination = document.getElementById('search-destination')?.value || '';
      const depDate = document.getElementById('search-dep-date')?.value || '';
      const retDate = document.getElementById('search-return-date')?.value || '';

      const params = new URLSearchParams();
      if (tripType) params.set('trip_type', tripType);
      if (origin) params.set('origin', origin);
      if (destination) params.set('destination', destination);
      if (depDate) params.set('dep_date', depDate);
      if (retDate && tripType === 'round-trip') params.set('ret_date', retDate);

      window.location.href = `flights.html?${params.toString()}`;
    });
  }
}

/**
 * 2. Hiển thị 8 Tour du lịch nổi bật từ SQLite (db.db)
 * Hình thumbnail chuẩn 600x400, hãng du lịch, số ngày/đêm, giá tour.
 * Click vào dẫn đến trang Tour (tours.html)
 */
function renderFeaturedTours() {
  const container = document.getElementById('featured-tours-grid');
  if (!container) return;

  const tours = VietjetDB.query(
    'SELECT * FROM tours WHERE is_featured = 1 ORDER BY id ASC LIMIT 8'
  );

  if (tours.length === 0) {
    container.innerHTML = '<p>Chưa có dữ liệu tour du lịch.</p>';
    return;
  }

  container.innerHTML = tours
    .map(
      (tour) => `
      <article class="tour-card" onclick="window.location.href='tours.html?highlight=${tour.id}'" title="Click để đến trang Tour">
        <div class="tour-thumb-wrapper">
          <img src="${tour.thumbnail_url}" alt="${tour.title}" width="600" height="400" loading="lazy" />
          <span class="tour-duration-badge">⏱ ${tour.duration_text}</span>
          <span class="tour-agency-badge">🏢 ${tour.travel_agency}</span>
        </div>
        <div class="tour-card-body">
          <div class="tour-meta-row">
            <span>✈ ${tour.airline_name}</span>
            <span>📍 ${tour.origin_city} ➔ ${tour.destination_city}</span>
          </div>
          <h3 class="tour-card-title">${tour.title}</h3>
          <div class="tour-card-footer">
            <div>
              <span class="tour-price-label">Giá trọn gói / khách</span>
              <span class="tour-price-value">${VietjetUtils.formatCurrency(tour.price)}</span>
            </div>
            <span class="btn-outline" style="padding: 7px 14px; font-size: 0.82rem;">Xem Tour ➔</span>
          </div>
        </div>
      </article>
    `
    )
    .join('');
}

/**
 * 3. Hiển thị danh sách Logo các hãng hàng không từ SQLite (db.db)
 * Click vào logo dẫn đến trang Chuyến Bay (flights.html?airline=...)
 */
function renderAirlines() {
  const container = document.getElementById('airlines-partners-grid');
  if (!container) return;

  const airlines = VietjetDB.query('SELECT * FROM airlines ORDER BY id ASC');

  container.innerHTML = airlines
    .map(
      (airline) => `
      <div class="airline-logo-card" onclick="window.location.href='flights.html?airline=${encodeURIComponent(airline.name)}'" title="Xem các chuyến bay của ${airline.name}">
        <div class="airline-logo-img-box">
          <img src="${airline.logo_url}" alt="${airline.name}" onerror="this.src='images/2aOboRAvPCnNF8ux8l12JJoKC6uw9yMZkM5dUYs4.jpg'" />
        </div>
        <div>
          <div class="airline-logo-name">${airline.name}</div>
          <div class="airline-logo-country">${airline.country} • Mã: ${airline.code}</div>
        </div>
      </div>
    `
    )
    .join('');
}
