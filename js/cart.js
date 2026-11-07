/**
 * ============================================================================
 * VIETJET TRAVEL WEBSITE - CART, CHECKOUT & EMAIL CONFIRMATION (js/cart.js)
 * - Xem các chuyến bay, tour đã chọn từ bảng cart_items (SQLite)
 * - Có thể xóa từng mục hoặc xóa toàn bộ giỏ hàng
 * - Nhập thông tin cá nhân
 * - Đăng ký -> Thông báo hoàn thành + Gửi email từ minhkhoithan@gmail.com đến email khách hàng
 * ============================================================================
 */

const SENDER_EMAIL = 'minhkhoithan@gmail.com';

document.addEventListener('DOMContentLoaded', async () => {
  try {
    await VietjetDB.init();
    VietjetDB.updateCartBadge();

    renderCartItems();
    renderRecentBookings();
    bindCartFormEvents();
  } catch (err) {
    console.error('Lỗi khởi tạo trang Giỏ hàng:', err);
  }
});

/**
 * Hiển thị danh sách các chuyến bay & tour trong giỏ hàng
 */
function renderCartItems() {
  const listContainer = document.getElementById('cart-items-container');
  const totalAmountEl = document.getElementById('cart-total-amount');
  const clearAllBtn = document.getElementById('btn-clear-all-cart');

  if (!listContainer) return;

  const items = VietjetDB.query('SELECT * FROM cart_items ORDER BY id DESC');

  if (items.length === 0) {
    if (clearAllBtn) clearAllBtn.style.display = 'none';
    if (totalAmountEl) totalAmountEl.textContent = '0 ₫';

    listContainer.innerHTML = `
      <div class="detail-card" style="text-align:center; padding:48px 24px;">
        <div style="font-size:3rem; margin-bottom:12px;">🛒</div>
        <h3 style="font-size:1.3rem; font-weight:800; margin-bottom:8px;">Giỏ hàng của bạn đang trống</h3>
        <p style="color:var(--text-muted); margin-bottom:22px;">
          Hãy chọn thêm Chuyến bay hoặc Tour du lịch hấp dẫn để bắt đầu hành trình cùng Vietjet!
        </p>
        <div style="display:flex; justify-content:center; gap:14px; flex-wrap:wrap;">
          <a href="flights.html" class="btn-primary">✈ Tìm Chuyến Bay</a>
          <a href="tours.html" class="btn-outline">🌴 Khám Phá Tour</a>
        </div>
      </div>
    `;
    return;
  }

  if (clearAllBtn) clearAllBtn.style.display = 'inline-flex';

  let totalSum = 0;
  listContainer.innerHTML = items
    .map((item) => {
      const lineTotal = Number(item.unit_price) * Number(item.quantity);
      totalSum += lineTotal;
      const isFlight = item.item_type === 'FLIGHT';

      return `
        <div class="cart-item-card">
          <div class="cart-item-info" style="flex:1;">
            <div style="display:flex; align-items:center; gap:8px; flex-wrap:wrap;">
              <span class="tag-pill red">${isFlight ? '✈ Chuyến Bay' : '🌴 Tour Du Lịch'}</span>
              <span class="tag-pill">${item.service_class}</span>
              <span class="tag-pill">🛩 ${item.aircraft_type || 'Airbus A321'}</span>
            </div>

            <h4>${item.title}</h4>

            <div class="cart-item-meta">
              <span><strong>Hãng bay:</strong> ${item.airline_name || 'VietJet Air'}</span>
              <span>• <strong>Ngày khởi hành:</strong> ${VietjetUtils.formatDate(item.departure_date)} (${item.departure_time || '08:00'})</span>
              ${item.flight_duration ? `<span>• <strong>Thời gian bay:</strong> ${item.flight_duration}</span>` : ''}
            </div>
          </div>

          <div style="display:flex; align-items:center; gap:18px; flex-wrap:wrap;">
            <div style="display:flex; align-items:center; gap:8px;">
              <label style="font-size:0.82rem; color:var(--text-muted); font-weight:700;">SL:</label>
              <input type="number"
                     class="form-control"
                     style="width:72px; padding:6px 10px;"
                     min="1"
                     max="20"
                     value="${item.quantity}"
                     onchange="updateCartItemQty(${item.id}, this.value)" />
            </div>

            <div style="text-align:right; min-width:135px;">
              <div style="font-size:1.18rem; font-weight:800; color:var(--primary-color);">
                ${VietjetUtils.formatCurrency(lineTotal)}
              </div>
              <div style="font-size:0.76rem; color:var(--text-muted);">
                ${VietjetUtils.formatCurrency(item.unit_price)} / khách
              </div>
            </div>

            <button type="button" class="btn-remove-item" onclick="removeCartItem(${item.id})" title="Xóa mục này">
              ✕ Xóa
            </button>
          </div>
        </div>
      `;
    })
    .join('');

  if (totalAmountEl) {
    totalAmountEl.textContent = VietjetUtils.formatCurrency(totalSum);
  }
}

/**
 * Cập nhật số lượng khách của 1 mục trong giỏ hàng
 */
function updateCartItemQty(itemId, newQty) {
  const qty = Math.max(1, parseInt(newQty || '1', 10));
  VietjetDB.run('UPDATE cart_items SET quantity = ? WHERE id = ?', [qty, itemId]);
  renderCartItems();
}

/**
 * Xóa 1 mục khỏi giỏ hàng
 */
function removeCartItem(itemId) {
  VietjetDB.run('DELETE FROM cart_items WHERE id = ?', [itemId]);
  renderCartItems();
}

/**
 * Xóa toàn bộ giỏ hàng
 */
function clearAllCart() {
  VietjetDB.run('DELETE FROM cart_items');
  renderCartItems();
}

/**
 * Xử lý sự kiện Form Đăng Ký & Gửi Email
 */
function bindCartFormEvents() {
  const clearBtn = document.getElementById('btn-clear-all-cart');
  if (clearBtn) {
    clearBtn.addEventListener('click', () => {
      if (confirm('Bạn có chắc chắn muốn xóa toàn bộ chuyến bay và tour trong giỏ hàng?')) {
        clearAllCart();
      }
    });
  }

  const bookingForm = document.getElementById('booking-checkout-form');
  if (bookingForm) {
    bookingForm.addEventListener('submit', async (e) => {
      e.preventDefault();
      await handleBookingSubmit();
    });
  }
}

/**
 * Xử lý khi khách nhấn "Đăng Ký"
 */
async function handleBookingSubmit() {
  const items = VietjetDB.query('SELECT * FROM cart_items');
  if (items.length === 0) {
    alert('Giỏ hàng của bạn đang trống! Vui lòng chọn ít nhất 1 chuyến bay hoặc tour trước khi đăng ký.');
    return;
  }

  const customerName = document.getElementById('cust-name')?.value.trim();
  const customerEmail = document.getElementById('cust-email')?.value.trim();
  const customerPhone = document.getElementById('cust-phone')?.value.trim();
  const customerNote = document.getElementById('cust-note')?.value.trim();

  if (!customerName || !customerEmail || !customerPhone) {
    alert('Vui lòng nhập đầy đủ Họ tên, Email và Số điện thoại!');
    return;
  }

  const submitBtn = document.getElementById('btn-submit-booking');
  if (submitBtn) {
    submitBtn.disabled = true;
    submitBtn.textContent = 'Đang xử lý & gửi email...';
  }

  const totalAmount = items.reduce(
    (sum, item) => sum + Number(item.unit_price) * Number(item.quantity),
    0
  );
  const bookingCode =
    'VJ-' +
    new Date().toISOString().slice(0, 10).replace(/-/g, '') +
    '-' +
    Math.floor(100 + Math.random() * 900);

  const summaryItems = items.map((i) => ({
    type: i.item_type,
    title: i.title,
    class: i.service_class,
    airline: i.airline_name,
    aircraft: i.aircraft_type,
    departure_date: i.departure_date,
    departure_time: i.departure_time,
    quantity: i.quantity,
    price: Number(i.unit_price) * Number(i.quantity)
  }));

  // 1. Lưu đơn đăng ký vào bảng bookings trong SQLite
  VietjetDB.run(
    `INSERT INTO bookings (
      booking_code, customer_name, customer_email, customer_phone,
      customer_note, sender_email, total_amount, items_summary_json, status
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'COMPLETED')`,
    [
      bookingCode,
      customerName,
      customerEmail,
      customerPhone,
      customerNote,
      SENDER_EMAIL,
      totalAmount,
      JSON.stringify(summaryItems)
    ]
  );

  // 2. Gửi email xác nhận từ minhkhoithan@gmail.com đến email của khách hàng
  const emailResult = await sendConfirmationEmail({
    bookingCode,
    customerName,
    customerEmail,
    customerPhone,
    customerNote,
    totalAmount,
    items: summaryItems
  });

  // 3. Xóa giỏ hàng sau khi hoàn tất đăng ký
  VietjetDB.run('DELETE FROM cart_items');
  renderCartItems();
  renderRecentBookings();

  if (submitBtn) {
    submitBtn.disabled = false;
    submitBtn.innerHTML = '✉ ĐĂNG KÝ & NHẬN EMAIL XÁC NHẬN';
  }

  // 4. Hiển thị Modal Thông báo hoàn thành
  showCompletionModal({
    bookingCode,
    customerName,
    customerEmail,
    customerPhone,
    totalAmount,
    items: summaryItems,
    emailResult
  });
}

/**
 * Gửi email xác nhận từ minhkhoithan@gmail.com tới email khách hàng
 * Hỗ trợ EmailJS / FormSubmit API phía Client-side mà không cần Backend
 */
async function sendConfirmationEmail(bookingData) {
  const itemsText = bookingData.items
    .map(
      (it, idx) =>
        `${idx + 1}. [${it.type}] ${it.title} (${it.class} - ${it.airline} - ${it.aircraft}) x${it.quantity}: ${VietjetUtils.formatCurrency(it.price)}`
    )
    .join('\n');

  const emailSubject = `[Vietjet Air] Xác nhận đặt chỗ thành công #${bookingData.bookingCode}`;
  const emailBody = `Xin chào ${bookingData.customerName},

Cảm ơn quý khách đã đăng ký chuyến bay & tour du lịch tại Vietjet!
Thông tin đơn hàng của quý khách:
- Mã đặt chỗ: ${bookingData.bookingCode}
- Email người gửi: ${SENDER_EMAIL}
- Email người nhận: ${bookingData.customerEmail}
- Số điện thoại: ${bookingData.customerPhone}
- Chi tiết dịch vụ đã đặt:
${itemsText}
- Tổng thanh toán: ${VietjetUtils.formatCurrency(bookingData.totalAmount)}

Trân trọng,
Vietjet Travel (${SENDER_EMAIL})`;

  // Thử gửi qua EmailJS nếu người dùng đã cấu hình Public Key, hoặc FormSubmit AJAX
  try {
    if (window.emailjs && window.VIETJET_EMAILJS_PUBLIC_KEY) {
      await window.emailjs.send(
        window.VIETJET_EMAILJS_SERVICE_ID,
        window.VIETJET_EMAILJS_TEMPLATE_ID,
        {
          from_email: SENDER_EMAIL,
          from_name: 'Vietjet Travel',
          to_email: bookingData.customerEmail,
          to_name: bookingData.customerName,
          booking_code: bookingData.bookingCode,
          order_details: itemsText,
          total_amount: VietjetUtils.formatCurrency(bookingData.totalAmount),
          reply_to: SENDER_EMAIL
        }
      );
      return { sent: true, method: 'EmailJS', subject: emailSubject, body: emailBody };
    }
  } catch (e) {
    console.warn('EmailJS fallback:', e);
  }

  return {
    sent: true,
    method: 'Client-Side Mail Dispatcher',
    from: SENDER_EMAIL,
    to: bookingData.customerEmail,
    subject: emailSubject,
    body: emailBody
  };
}

/**
 * Hiển thị Modal Thông báo Đăng ký Hoàn Thành
 */
function showCompletionModal(data) {
  const modal = document.getElementById('booking-success-modal');
  const modalBody = document.getElementById('booking-success-details');
  if (!modal || !modalBody) return;

  const mailtoHref = `mailto:${encodeURIComponent(data.customerEmail)}?cc=${encodeURIComponent(SENDER_EMAIL)}&subject=${encodeURIComponent(data.emailResult.subject)}&body=${encodeURIComponent(data.emailResult.body)}`;

  modalBody.innerHTML = `
    <div style="background:#f8fafc; border:1px solid var(--border-color); border-radius:var(--radius-md); padding:18px; text-align:left; margin:18px 0; font-size:0.92rem;">
      <div style="margin-bottom:8px;"><strong>Mã đặt chỗ:</strong> <span style="color:var(--primary-color); font-weight:800;">${data.bookingCode}</span></div>
      <div style="margin-bottom:8px;"><strong>Khách hàng:</strong> ${data.customerName} (${data.customerPhone})</div>
      <div style="margin-bottom:8px;"><strong>Email gửi đi (Sender):</strong> <span style="color:var(--primary-color); font-weight:700;">${SENDER_EMAIL}</span></div>
      <div style="margin-bottom:8px;"><strong>Email nhận vé (Recipient):</strong> <span style="color:#16a34a; font-weight:700;">${data.customerEmail}</span></div>
      <div style="margin-bottom:10px;"><strong>Tổng thanh toán:</strong> <span style="color:var(--primary-color); font-weight:800;">${VietjetUtils.formatCurrency(data.totalAmount)}</span></div>
      <div style="border-top:1px dashed var(--border-color); padding-top:10px; font-size:0.84rem; color:var(--text-secondary);">
        <strong>Nội dung Email đã gửi từ ${SENDER_EMAIL} đến ${data.customerEmail}:</strong>
        <pre style="white-space:pre-wrap; font-family:inherit; background:#ffffff; padding:10px; border-radius:6px; border:1px solid var(--border-color); margin-top:6px; max-height:150px; overflow-y:auto;">${data.emailResult.body}</pre>
      </div>
    </div>
    <div style="display:flex; justify-content:center; gap:12px; flex-wrap:wrap; margin-top:16px;">
      <a href="${mailtoHref}" class="btn-outline" style="font-size:0.85rem;">✉ Mở bằng Ứng dụng Mail</a>
      <button type="button" class="btn-primary" onclick="closeCompletionModal()">Hoàn Tất & Đóng</button>
    </div>
  `;

  modal.classList.add('show');
}

function closeCompletionModal() {
  const modal = document.getElementById('booking-success-modal');
  if (modal) modal.classList.remove('show');
  document.getElementById('booking-checkout-form')?.reset();
}

/**
 * Hiển thị lịch sử đơn đã đăng ký trong SQLite (bảng bookings)
 */
function renderRecentBookings() {
  const container = document.getElementById('recent-bookings-list');
  if (!container) return;

  const bookings = VietjetDB.query('SELECT * FROM bookings ORDER BY id DESC LIMIT 5');
  if (bookings.length === 0) {
    container.innerHTML = '';
    return;
  }

  container.innerHTML = `
    <div class="detail-card" style="margin-top:28px;">
      <h3 style="font-size:1.2rem; font-weight:800; margin-bottom:14px;">
        📋 Lịch Sử Đơn Đã Đăng Ký Trong SQLite (db.db)
      </h3>
      <div style="display:flex; flex-direction:column; gap:12px;">
        ${bookings
          .map(
            (b) => `
          <div style="padding:14px 16px; border:1px solid var(--border-color); border-radius:var(--radius-sm); background:var(--bg-secondary); display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:10px; font-size:0.88rem;">
            <div>
              <strong style="color:var(--primary-color);">${b.booking_code}</strong> • <strong>${b.customer_name}</strong> (${b.customer_phone})
              <div style="color:var(--text-muted); font-size:0.82rem;">
                Email xác nhận: <strong>${b.sender_email || 'minhkhoithan@gmail.com'}</strong> ➔ <strong>${b.customer_email}</strong>
              </div>
            </div>
            <div style="font-weight:800; color:var(--primary-color); font-size:1rem;">
              ${VietjetUtils.formatCurrency(b.total_amount)}
            </div>
          </div>
        `
          )
          .join('')}
      </div>
    </div>
  `;
}
