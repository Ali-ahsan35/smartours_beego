const sortWrap = document.getElementById("js-filter-sort");
const defaultOpt = sortWrap.querySelector(".default-option");
const hiddenInput = document.getElementById("sort-properties");

defaultOpt.addEventListener("click", () => {
  sortWrap.classList.toggle("active");
});

sortWrap.querySelectorAll(".select-ul li").forEach((li) => {
  li.addEventListener("click", () => {
    const value = li.getAttribute("data-value");
    const text = li.querySelector("p").textContent;
    defaultOpt.querySelector("p").textContent = text;
    hiddenInput.value = value;
    sortWrap.classList.remove("active");

    // Call loadProperties from refine.js
    if (window.loadProperties && window.currentCategory) {
      window.loadProperties(window.currentCategory, value);
    }
  });
});

document.addEventListener("click", (e) => {
  if (!sortWrap.contains(e.target)) sortWrap.classList.remove("active");
});
