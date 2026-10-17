// Time Flies: Living Clock™ — public website
(function () {
  "use strict";

  // Live clock in the hero illustration
  var clock = document.querySelector("[data-clock]");
  var date = document.querySelector("[data-date]");
  var timeFmt = new Intl.DateTimeFormat(undefined, { hour: "numeric", minute: "2-digit" });
  var dateFmt = new Intl.DateTimeFormat(undefined, { weekday: "long", month: "long", day: "numeric" });
  function tick() {
    var now = new Date();
    if (clock) clock.textContent = timeFmt.format(now).replace(/\s?[AP]M$/i, "");
    if (date) date.textContent = dateFmt.format(now);
    setTimeout(tick, 1000 - now.getMilliseconds());
  }
  tick();

  // Footer year
  var year = document.querySelector("[data-year]");
  if (year) year.textContent = String(new Date().getFullYear());

  // Mobile navigation
  var toggle = document.querySelector(".nav__toggle");
  var links = document.getElementById("nav-links");
  if (toggle && links) {
    toggle.addEventListener("click", function () {
      var open = links.classList.toggle("open");
      toggle.setAttribute("aria-expanded", String(open));
    });
    links.addEventListener("click", function (e) {
      if (e.target.closest("a")) {
        links.classList.remove("open");
        toggle.setAttribute("aria-expanded", "false");
      }
    });
  }
})();
