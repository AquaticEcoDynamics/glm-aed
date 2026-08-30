/* Live filter for the configuration reference.
 *
 * Rows carry a data-search attribute written at build time (variable name,
 * block name and description, lowercased). We do not read textContent,
 * because MathJax rewrites the LaTeX cells into <mjx-container> elements and
 * would otherwise pollute the haystack.
 */
(function () {
  "use strict";

  var input = document.getElementById("q");
  var count = document.getElementById("count");
  var none = document.getElementById("noresults");
  if (!input) return;

  var sections = Array.prototype.slice.call(document.querySelectorAll("main section"));
  var chips = {};
  Array.prototype.forEach.call(document.querySelectorAll("nav.jump a"), function (a) {
    chips[a.getAttribute("href").slice(1)] = a;
  });

  var groups = Array.prototype.slice.call(document.querySelectorAll("h2.group"));
  var rows = Array.prototype.slice.call(document.querySelectorAll("tr[data-search]"));
  var total = rows.length;

  function apply(query) {
    var terms = query.toLowerCase().split(/\s+/).filter(Boolean);
    var shown = 0;

    sections.forEach(function (section) {
      var hits = 0;
      var live = {};

      section.querySelectorAll("tr[data-search]").forEach(function (tr) {
        var hay = tr.getAttribute("data-search");
        var ok = terms.every(function (t) { return hay.indexOf(t) !== -1; });
        tr.hidden = !ok;
        if (ok) {
          hits++;
          var sub = tr.getAttribute("data-sub");
          if (sub) live[sub] = true;
        }
      });

      // Keep a sub-heading only while something beneath it still matches.
      section.querySelectorAll("tr.subhead").forEach(function (tr) {
        tr.hidden = terms.length > 0 && !live[tr.getAttribute("data-sub")];
      });

      section.hidden = hits === 0;
      var chip = chips[section.id];
      if (chip) chip.classList.toggle("dim", hits === 0);
      shown += hits;
    });

    // Hide a group heading once all of its blocks are filtered out.
    groups.forEach(function (h) {
      var any = false;
      for (var n = h.nextElementSibling; n && n.tagName !== "H2"; n = n.nextElementSibling) {
        if (n.tagName === "SECTION" && !n.hidden) { any = true; break; }
      }
      h.hidden = !any;
    });

    if (none) none.hidden = shown !== 0;
    if (count) {
      count.textContent = terms.length
        ? shown + " of " + total
        : total + " variables";
    }
  }

  var timer;
  input.addEventListener("input", function () {
    clearTimeout(timer);
    timer = setTimeout(function () { apply(input.value); }, 80);
  });

  input.addEventListener("keydown", function (e) {
    if (e.key === "Escape") { input.value = ""; apply(""); }
  });

  // "/" focuses the box, the way most documentation sites behave.
  document.addEventListener("keydown", function (e) {
    if (e.key === "/" && document.activeElement !== input) {
      e.preventDefault();
      input.focus();
      input.select();
    }
  });

  // Clicking a jump chip while filtering is confusing -- clear first.
  Array.prototype.forEach.call(document.querySelectorAll("nav.jump a"), function (a) {
    a.addEventListener("click", function () {
      if (input.value) { input.value = ""; apply(""); }
    });
  });

  apply("");
})();
