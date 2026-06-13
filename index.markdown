---
layout: default
title: Home
---

# Werke

Ausgehend von einem linearen Modulsystem werden quadratische Bildobjekte strukturiert, die darin eingeschriebenen Formen gesteigert, verändert oder verdeckt. Die malerische Fläche wechselt zwischen expressiver Farbigkeit und reduziertem Hell/Dunkel, positive und negative Formen ergeben ein rhythmisiertes Bildgeflecht.
---

<div class="slideshow">
  {% assign slides = site.static_files | where_exp: "f", "f.path contains '/static/images/'" %}
  {% for img in slides %}
    {% if img.extname == ".jpg" or img.extname == ".jpeg" or img.extname == ".JPG" %}
      <img src="{{ img.path | relative_url }}"
           class="slide {% if forloop.first %}active{% endif %}"
           alt="">
    {% endif %}
  {% endfor %}
  <button class="prev" onclick="changeSlide(-1)">‹</button>
  <button class="next" onclick="changeSlide(1)">›</button>
</div>

<style>
.slideshow { position: relative; max-width: 800px; margin: auto; }
.slide { display: none; width: 100%; }
.slide.active { display: block; }
.prev, .next {
  position: absolute; top: 50%; transform: translateY(-50%);
  background: rgba(0,0,0,0.4); color: #fff; border: 0;
  padding: 0.5rem 1rem; cursor: pointer;
}
.prev { left: 0; } .next { right: 0; }
</style>

<script>
let current = 0;
function changeSlide(dir) {
  const slides = document.querySelectorAll('.slide');
  slides[current].classList.remove('active');
  current = (current + dir + slides.length) % slides.length;
  slides[current].classList.add('active');
}
setInterval(() => changeSlide(1), 4000);
</script>
