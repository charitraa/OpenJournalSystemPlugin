/**
 * LRJSTM Theme — interaction layer
 *
 * Deliberately small: one orchestrated moment (the stats ledger counting
 * up on first view), nothing else animated. Respects users who've asked
 * for reduced motion.
 */
(function () {
	'use strict';

	function prefersReducedMotion() {
		return window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
	}

	function animateCount(el) {
		var target = parseInt(el.getAttribute('data-count'), 10);
		if (isNaN(target) || target <= 0 || prefersReducedMotion()) {
			return;
		}

		var duration = 900;
		var start = null;

		function step(timestamp) {
			if (!start) start = timestamp;
			var progress = Math.min((timestamp - start) / duration, 1);
			el.textContent = Math.floor(progress * target);
			if (progress < 1) {
				window.requestAnimationFrame(step);
			} else {
				el.textContent = target;
			}
		}

		window.requestAnimationFrame(step);
	}

	document.addEventListener('DOMContentLoaded', function () {
		var counts = document.querySelectorAll('.lrjstm-ledger dd[data-count]');

		if (!counts.length) {
			return;
		}

		if ('IntersectionObserver' in window) {
			var observer = new IntersectionObserver(
				function (entries) {
					entries.forEach(function (entry) {
						if (entry.isIntersecting) {
							animateCount(entry.target);
							observer.unobserve(entry.target);
						}
					});
				},
				{ threshold: 0.4 }
			);
			counts.forEach(function (el) {
				observer.observe(el);
			});
		} else {
			counts.forEach(animateCount);
		}
	});
})();
