---
layout: default
title: Jahrgänge
permalink: /jahrgange/
---

[comment]: jahrgänge
<div class="timeline-wrap">
  <h1 class="tl-title">Jahrgänge</h1>
  <div id="timeline" class="timeline"></div>
</div>

<style>
.timeline-wrap { padding:1.5rem 0; }
.tl-title { margin:0 0 6px; }
.timeline { position:relative; width:100%; height:170px; cursor:pointer; }
.tl-tick { position:absolute; width:2px; background:#111; transform:translateX(-50%); }
.tl-selected { position:absolute; transform:translateX(-50%); font-size:16px; font-weight:600; color:#111; white-space:nowrap; opacity:0; transition:opacity .1s; pointer-events:none; }
.tl-hint { position:absolute; left:50%; transform:translateX(-50%); font-size:12px; color:#777; white-space:nowrap; opacity:0; transition:opacity .15s; pointer-events:none; }
@media (pointer: coarse) {
  .timeline { touch-action: pan-y; }
}
</style>

<script>
(function(){
  const tl = document.getElementById('timeline');
  const start = 1990, end = new Date().getFullYear(), span = end - start;
  const padL = 4, padR = 4, axisY = 20, baseLen = 0, amp = 110, sigma = 46, beta = 1.2;

  let ticks = [];
  let current = null;
  let currentX = null;
  let lastTouch = 0;
  // Nach einem Touch feuert der Browser synthetische mousemove/click-Events —
  // die dürfen die Touch-Logik nicht überschreiben
  const isSyntheticMouse = () => Date.now() - lastTouch < 800;

  // gemeinsame Logik: setzt Tick-Höhen + Label anhand einer x-Position
  function focusAt(cx){
    const sel = document.getElementById('tl-selected');
    let best = null, bd = Infinity;
    for (const t of ticks) {
      const d = t.x - cx;
      t.el.style.height = (baseLen + amp * Math.exp(-Math.pow(Math.abs(d) / sigma, beta))) + 'px';
      if (Math.abs(d) < bd) { bd = Math.abs(d); best = t; }
    }
    if (best && sel) {
      current = best.yr;
      currentX = best.x;
      sel.textContent = best.yr;
      sel.style.left = best.x + 'px';
      sel.style.top = (axisY + amp + 8) + 'px';
      sel.style.opacity = 1;
    }
  }

  function build(){
    const W = tl.clientWidth;
    if (!W) { requestAnimationFrame(build); return; }
    tl.innerHTML = '';
    ticks = [];
    const innerW = W - padL - padR;

    const axis = document.createElement('div');
    axis.style.cssText = `position:absolute;left:${padL}px;top:${axisY}px;width:${innerW}px;height:2px;background:#111;`;
    tl.appendChild(axis);

    const xOf = yr => padL + ((yr - start) / span) * innerW;
    for (let yr = start; yr <= end; yr++) {
      const x = xOf(yr);
      const t = document.createElement('div');
      t.className = 'tl-tick';
      t.style.left = x + 'px'; t.style.top = axisY + 'px'; t.style.height = baseLen + 'px';
      tl.appendChild(t);
      ticks.push({ yr, x, el: t });
    }

    const sel = document.createElement('div');
    sel.className = 'tl-selected';
    sel.id = 'tl-selected';
    tl.appendChild(sel);

    const hint = document.createElement('div');
    hint.className = 'tl-hint';
    hint.id = 'tl-hint';
    hint.textContent = 'Jahr erneut antippen zum Öffnen';
    hint.style.top = (axisY + amp + 34) + 'px';
    tl.appendChild(hint);

    // Initialzustand: erstes Jahr ausgewählt anzeigen
    if (ticks.length) focusAt(ticks[0].x);
  }

  if (document.readyState === 'complete') requestAnimationFrame(build);
  else window.addEventListener('load', () => requestAnimationFrame(build));
  window.addEventListener('resize', build);

  tl.addEventListener('mousemove', e => {
    if (isSyntheticMouse()) return;
    const cx = e.clientX - tl.getBoundingClientRect().left;
    focusAt(cx);
  });
  tl.addEventListener('mouseleave', () => {
    if (isSyntheticMouse()) return;
    const sel = document.getElementById('tl-selected');
    const hint = document.getElementById('tl-hint');
    for (const t of ticks) t.el.style.height = '0px';
    if (sel) sel.style.opacity = 0;
    if (hint) hint.style.opacity = 0;
    current = null;
    currentX = null;
  });
  tl.addEventListener('click', () => {
    if (isSyntheticMouse()) return;
    if (current != null) window.location.href = '/jahrgang_' + current + '/';
  });

  // Touch: Wischen wählt ein Jahr aus (Auswahl bleibt stehen),
  // erneutes Antippen des ausgewählten Jahres öffnet es
  let touchStartX = 0, touchStartY = 0, touchMoved = false, touchPrevYear = null;

  tl.addEventListener('touchstart', e => {
    lastTouch = Date.now();
    const r = tl.getBoundingClientRect();
    touchStartX = e.touches[0].clientX - r.left;
    touchStartY = e.touches[0].clientY;
    touchMoved = false;
    touchPrevYear = current;
    focusAt(touchStartX);
  }, { passive: true });

  tl.addEventListener('touchmove', e => {
    lastTouch = Date.now();
    const r = tl.getBoundingClientRect();
    const cx = e.touches[0].clientX - r.left;
    if (Math.abs(cx - touchStartX) > 8 || Math.abs(e.touches[0].clientY - touchStartY) > 8) touchMoved = true;
    if (e.cancelable) e.preventDefault();
    focusAt(cx);
  }, { passive: false });

  tl.addEventListener('touchend', () => {
    lastTouch = Date.now();
    const hint = document.getElementById('tl-hint');
    if (!touchMoved && touchPrevYear != null && current === touchPrevYear) {
      window.location.href = '/jahrgang_' + current + '/';
      return;
    }
    if (current != null && hint) hint.style.opacity = 1;
  });
})();
</script>
