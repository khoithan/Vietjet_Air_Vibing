/**
 * ============================================================================
 * VIETJET TRAVEL WEBSITE - TOURS LISTING & FILTER LOGIC (js/tours.js)
 * Bên trái: Filter giá vé tăng/giảm dần, các hãng hàng không, thời gian cất cánh (giờ)
 * Bên phải: Các tour du lịch, hãng bay, ngày cất cánh, thời gian bay, giá tiền, dịch vụ
 * Click chọn tour sẽ đến trang Chi tiết Tour (tour-detail.html)
 * ============================================================================
 */

document.addEventListener('DOMContentLoaded', async () => {
  try {
    await VietjetDB.init();
    VietjetDB.updateCartBadge();

    populateTourAirlineCheckboxes();
    bindTourFilterEvents();
    filterAndRenderTours();
  } catch (err) {
    console.error('Lỗi khởi tạo trang Tour:', err);
  }
});

function populateTourAirlineCheckboxes() {
  const container = document.getElementById('tour-filter-airlines-list');
  if (!container) return;

  const airlines = VietjetDB.query('SELECT * FROM airlines ORDER BY id ASC');
  container.innerHTML = airlines
    .map(
      (a) => `
      <label class="filter-check-label">
        <input type="checkbox" name="tour_filter_airline" value="${a.name}" />
        <span>${a.name}</span>
      </label>
    `
    )
    .join('');
}

function bindTourFilterEvents() {
  const inputs = document.querySelectorAll('#tours-filter-sidebar input');
  inputs.forEach((el) => {
    el.addEventListener('change', () => filterAndRenderTours());
  });

  const resetBtn = document.getElementById('btn-reset-tour-filters');
  if (resetBtn) {
    resetBtn.addEventListener('click', () => {
      document.querySelectorAll('#tours-filter-sidebar input[type="checkbox"]').forEach((cb) => {
        cb.checked = false;
      });
      const sortAsc = document.querySelector('input[name="tour_filter_sort"][value="price_asc"]');
      if (sortAsc) sortAsc.checked = true;
      filterAndRenderTours();
    });
  }
}

function filterAndRenderTours() {
  const sortValue =
    document.querySelector('input[name="tour_filter_sort"]:checked')?.value || 'price_asc';

  const checkedAirlines = Array.from(
    document.querySelectorAll('input[name="tour_filter_airline"]:checked')
  ).map((el) => el.value);

  const checkedTimeSlots = Array.from(
    document.querySelectorAll('input[name="tour_filter_time"]:checked')
  ).map((el) => el.value);

  const highlightId = Number(VietjetUtils.getQueryParam('highlight')) || 0;

  let tours = VietjetDB.query('SELECT * FROM tours');

  // 1. Lọc theo các hãng hàng không
  if (checkedAirlines.length > 0) {
    tours = tours.filter((t) => checkedAirlines.includes(t.airline_name));
  }

  // 2. Lọc theo thời gian cất cánh (giờ)
  if (checkedTimeSlots.length > 0) {
    tours = tours.filter((t) => {
      const hour = parseInt(t.departure_time.split(':')[0], 10);
      return checkedTimeSlots.some((slot) => {
        if (slot === 'early_morning') return hour >= 0 && hour < 6;
        if (slot === 'morning') return hour >= 6 && hour < 12;
        if (slot === 'afternoon') return hour >= 12 && hour < 18;
        if (slot === 'evening') return hour >= 18 && hour <= 23;
        return true;
      });
    });
  }

  // 3. Sắp xếp giá tăng / giảm dần
  tours.sort((a, b) => {
    return sortValue === 'price_desc' ? b.price - a.price : a.price - b.price;
  });

  const countEl = document.getElementById('tours-count-num');
  if (countEl) countEl.textContent = tours.length;

  const listEl = document.getElementById('tours-results-list');
  if (!listEl) return;

  if (tours.length === 0) {
    listEl.innerHTML = `
      <div class="detail-card" style="text-align:center; padding:48px 24px;">
        <h3 style="margin-bottom:10px; color:var(--primary-color);">Không tìm thấy Tour phù hợp với bộ lọc</h3>
        <p style="color:var(--text-muted); margin-bottom:20px;">Hãy thử bỏ chọn một số điều kiện lọc bên trái để xem tất cả các tour hấp dẫn.</p>
        <button class="btn-primary" onclick="document.getElementById('btn-reset-tour-filters').click()">Xem tất cả Tour</button>
      </div>
    `;
    return;
  }

  listEl.innerHTML = tours
    .map((t) => {
      const isHighlighted = highlightId === t.id;
      return `
        <article class="tour-list-card"
                 style="${isHighlighted ? 'border: 2.5px solid var(--primary-color); box-shadow: var(--shadow-red);' : ''}"
                 onclick="window.location.href='tour-detail.html?id=${t.id}'">
          <div class="tour-list-thumb">
            <img src="${t.thumbnail_url}" alt="${t.title}" width="600" height="400" loading="lazy" />
            <span class="tour-duration-badge">⏱ ${t.duration_text}</span>
            <span class="tour-agency-badge">🏢 ${t.travel_agency}</span>
          </div>

          <div class="tour-list-info">
            <div style="display:flex; gap:8px; flex-wrap:wrap;">
              <span class="tag-pill red">✈ Hãng bay: ${t.airline_name}</span>
              <span class="tag-pill">🛩 ${t.aircraft_type}</span>
              <span class="tag-pill">📍 ${t.origin_city} ➔ ${t.destination_city}</span>
            </div>

            <h3 class="tour-list-title">${t.title}</h3>

            <div class="tour-specs-grid">
              <div><strong>📅 Ngày cất cánh:</strong> ${VietjetUtils.formatDate(t.departure_date)}</div>
              <div><strong>🕒 Giờ cất cánh:</strong> ${t.departure_time}</div>
              <div><strong>⏱ Thời gian bay:</strong> ${t.flight_duration}</div>
              <div><strong>🏢 Lữ hành:</strong> ${t.travel_agency}</div>
            </div>

            <div style="font-size:0.86rem; color:var(--text-secondary); margin-top:4px;">
              <strong>🎁 Dịch vụ bao gồm:</strong> ${t.services}
            </div>
          </div>

          <div class="tour-list-action">
            <span style="font-size:0.78rem; color:var(--text-muted); font-weight:600;">Giá trọn gói / khách</span>
            <span class="flight-price-amount" style="margin: 4px 0 14px;">${VietjetUtils.formatCurrency(t.price)}</span>
            <button type="button" class="btn-primary" style="width:100%;">
              Xem Chi Tiết Tour ➔
            </button>
          </div>
        </article>
      `;
    })
    .join('');
}
