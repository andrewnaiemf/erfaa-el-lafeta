(function () {
  const STATIONS = [
    { n: 1, label: "🌐 اكتشف الويب", file: "lesson-01.html" },
    { n: 2, label: "🧱 HTML مكعبات", file: "lesson-02.html" },
    { n: 3, label: "🎨 CSS ألوان", file: "lesson-03.html" },
    { n: 4, label: "🤖 أول AI", file: "lesson-04.html" },
    { n: 5, label: "✨ AI أوسع", file: "lesson-05.html" },
    { n: 6, label: "❓ لعبة عني", file: "lesson-06.html" },
    { n: 7, label: "🎮 ألعاب + موقع", file: "lesson-07.html" },
    { n: 8, label: "🎉 المعرض", file: "lesson-08.html" }
  ];

  const current = parseInt(document.body.dataset.lesson || "0", 10);

  function renderRoadmap() {
    const host = document.getElementById("roadmap");
    if (!host) return;
    host.innerHTML = STATIONS.map(function (s) {
      var cls = "station";
      if (s.n < current) cls += " done";
      else if (s.n === current) cls += " current";
      else cls += " future";
      return (
        '<div class="' + cls + '">' +
        '<div class="num">' + s.n + "</div>" +
        '<div class="label">' + s.label + "</div></div>"
      );
    }).join("");
  }

  renderRoadmap();
})();
