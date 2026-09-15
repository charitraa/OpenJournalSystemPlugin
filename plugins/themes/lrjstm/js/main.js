/**
 * @file plugins/themes/lrjstm/js/main.js
 *
 * LRJSTM theme behaviour. The parent Default theme already handles the
 * mobile menu toggle and dropdowns; this file only adds:
 *  - aria-expanded state on the mobile menu button
 *  - a short count-up on the homepage statistics (skipped for reduced motion)
 */
(function () {
	'use strict';

	document.addEventListener('DOMContentLoaded', function () {
		var toggle = document.querySelector('.lr-nav-toggle');
		var menu = document.getElementById('lrSiteNav');
		if (toggle && menu) {
			toggle.addEventListener('click', function () {
				// The parent theme toggles the class in its own click handler,
				// which runs first because it is bound earlier.
				window.setTimeout(function () {
					toggle.setAttribute(
						'aria-expanded',
						menu.classList.contains('pkp_site_nav_menu--isOpen') ? 'true' : 'false'
					);
				}, 0);
			});
		}

		var counters = document.querySelectorAll('.lr-stat__value[data-count]');
		var reduceMotion = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
		if (!counters.length || reduceMotion || !('IntersectionObserver' in window)) {
			return;
		}

		function countUp(el) {
			var target = parseInt(el.getAttribute('data-count'), 10);
			if (!(target > 0)) {
				return;
			}
			var start = null;
			function step(time) {
				if (start === null) {
					start = time;
				}
				var progress = Math.min((time - start) / 800, 1);
				el.textContent = String(Math.round(target * (1 - Math.pow(1 - progress, 3))));
				if (progress < 1) {
					window.requestAnimationFrame(step);
				}
			}
			window.requestAnimationFrame(step);
		}

		var observer = new IntersectionObserver(function (entries) {
			entries.forEach(function (entry) {
				if (entry.isIntersecting) {
					observer.unobserve(entry.target);
					countUp(entry.target);
				}
			});
		}, { threshold: 0.5 });

		counters.forEach(function (el) {
			observer.observe(el);
		});
	});
})();
