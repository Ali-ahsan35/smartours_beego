// Open modal
function openFilterModal() {
  document.getElementById("js-filter").classList.remove("hidden");
  document.body.classList.add("noscroll");
}

// Close modal
function closeFilterModal() {
  document.getElementById("js-filter").classList.add("hidden");
  document.body.classList.remove("noscroll");
}

// Buttons that open the modal
document
  .getElementById("js-price-range")
  .addEventListener("click", openFilterModal);
document
  .getElementById("js-guest-picker")
  .addEventListener("click", openFilterModal);
document
  .getElementById("filter-btn")
  .addEventListener("click", openFilterModal);

// Close on X button
document
  .querySelector(".js-trigger-hide")
  .addEventListener("click", closeFilterModal);

// Close on background layer click
document
  .querySelector("#js-filter .popup-layer")
  .addEventListener("click", closeFilterModal);

// Guest counter
const guestCount = document.getElementById("js-guest-count");
document.getElementById("js-guest-increase").addEventListener("click", () => {
  guestCount.textContent = parseInt(guestCount.textContent) + 1;
});
document.getElementById("js-guest-decrease").addEventListener("click", () => {
  const current = parseInt(guestCount.textContent);
  if (current > 0) guestCount.textContent = current - 1;
});

// Clear button
document.getElementById("js-clear-filter").addEventListener("click", () => {
  document
    .querySelectorAll("#js-filter input[type=checkbox]")
    .forEach((cb) => (cb.checked = false));
  guestCount.textContent = "0";
  document.getElementById("js-min-price").value = 0;
  document.getElementById("js-max-price").value = 100000;
});

// Search/Apply button — close modal for now, filtering logic comes later
document.getElementById("js-apply-filter").addEventListener("click", () => {
  closeFilterModal();
});
