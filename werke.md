---
layout: default
title: Werke
---

# Werke

> Ausgehend von einem linearen Modulsystem werden quadratische Bildobjekte strukturiert, die darin eingeschriebenen Formen gesteigert, verändert oder verdeckt. Die malerische Fläche wechselt zwischen expressiver Farbigkeit und reduziertem Hell/Dunkel, positive und negative Formen ergeben ein rhythmisiertes Bildgeflecht.

[comment]: slideshow

<div class="slideshow">
  {% assign slides = site.static_files | where_exp: "f", "f.path contains '/static/images/'" %}
  {% for img in slides %}
    {% if img.extname == ".jpg" or img.extname == ".jpeg" or img.extname == ".JPG" %}
      <img src="{{ img.path | relative_url }}"
           class="slide {% if forloop.first %}active{% endif %}"
           alt="">
    {% endif %}
  {% endfor %}
  <button class="prev" onclick="changeSlide(-1)" aria-label="Previous slide">‹</button>
  <button class="next" onclick="changeSlide(1)" aria-label="Next slide">›</button>
  <button class="fullscreen-btn" onclick="toggleFullscreen()" aria-label="Toggle fullscreen">⛶</button>
</div>

<style>
.slideshow { position: relative; max-width: 800px; margin: auto; }
.slide { display: none; width: 100%; }
.slide.active { display: block; }

/* Shared button styling — hidden until hover */
.prev, .next, .fullscreen-btn {
  position: absolute;
  background: rgba(0,0,0,0.4); color: #fff; border: 0;
  cursor: pointer;
  opacity: 0;
  transition: opacity 0.25s ease;
}
.slideshow:hover .prev,
.slideshow:hover .next,
.slideshow:hover .fullscreen-btn {
  opacity: 1;
}
/* Keep them reachable for keyboard users */
.prev:focus-visible,
.next:focus-visible,
.fullscreen-btn:focus-visible { opacity: 1; }

.prev, .next {
  top: 50%; transform: translateY(-50%);
  padding: 0.5rem 1rem; font-size: 1.5rem; line-height: 1;
}
.prev { left: 0; }
.next { right: 0; }

.fullscreen-btn {
  top: 0; right: 0;
  padding: 0.4rem 0.6rem; font-size: 1rem;
}

/* Fullscreen presentation */
.slideshow:fullscreen,
.slideshow:-webkit-full-screen {
  max-width: none; width: 100%; height: 100%;
  margin: 0; background: #fff;
  display: flex; align-items: center; justify-content: center;
}
.slideshow:fullscreen .slide.active,
.slideshow:-webkit-full-screen .slide.active {
  width: auto; max-width: 100%; max-height: 100%; object-fit: contain;
}
</style>

<script>
let current = 0;
function changeSlide(dir) {
  const slides = document.querySelectorAll('.slide');
  slides[current].classList.remove('active');
  current = (current + dir + slides.length) % slides.length;
  slides[current].classList.add('active');
}

function toggleFullscreen() {
  const ss = document.querySelector('.slideshow');
  if (!document.fullscreenElement && !document.webkitFullscreenElement) {
    (ss.requestFullscreen || ss.webkitRequestFullscreen).call(ss);
  } else {
    (document.exitFullscreen || document.webkitExitFullscreen).call(document);
  }
}
// setInterval(() => changeSlide(1), 4000);
</script>
