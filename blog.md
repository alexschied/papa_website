---
layout: default
title: Blog
permalink: /blog/
---

<h1>Blog</h1>

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
</style>

<script>
(function(){
  const tl = document.getElementById('timeline');
  const start = 1990, end = new Date().getFullYear(), span = end - start;
  const padL = 4, padR = 4, axisY = 20, baseLen = 0, amp = 110, sigma = 46, beta = 1.2;

  let ticks = [];
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
  }
  if (document.readyState === 'complete') requestAnimationFrame(build);
  else window.addEventListener('load', () => requestAnimationFrame(build));
  window.addEventListener('resize', build);

  let current = null;
  tl.addEventListener('mousemove', e => {
    const cx = e.clientX - tl.getBoundingClientRect().left;
    const sel = document.getElementById('tl-selected');
    let best = null, bd = Infinity;
    for (const t of ticks) {
      const d = t.x - cx;
      t.el.style.height = (baseLen + amp * Math.exp(-Math.pow(Math.abs(d) / sigma, beta))) + 'px';
      if (Math.abs(d) < bd) { bd = Math.abs(d); best = t; }
    }
    if (best && sel) {
      current = best.yr;
      sel.textContent = best.yr;
      sel.style.left = best.x + 'px';
      sel.style.top = (axisY + amp + 8) + 'px';
      sel.style.opacity = 1;
    }
  });
  tl.addEventListener('mouseleave', () => {
    const sel = document.getElementById('tl-selected');
    for (const t of ticks) t.el.style.height = '0px';
    if (sel) sel.style.opacity = 0; current = null;
  });
  tl.addEventListener('click', () => {
    if (current != null) window.location.href = '/jahrgang_' + current + '/';
  });
})();
</script>


{% assign months = "Januar,Februar,März,April,Mai,Juni,Juli,August,September,Oktober,November,Dezember" | split: "," %}

<ul>
  {% for post in site.posts %}
    {% assign m = post.date | date: "%-m" | minus: 1 %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
      <span>{{ post.date | date: "%-d" }}. {{ months[m] }} {{ post.date | date: "%Y" }}</span>
    </li>
  {% endfor %}
</ul>
