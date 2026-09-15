/**
 * @file plugins/themes/lrjstm/js/main.js
 *
 * LRJSTM theme behaviour. The parent Default theme already handles the
 * mobile menu toggle and dropdowns; this only keeps aria-expanded in sync
 * on the mobile menu button.
 */
(function () {
	'use strict';

	document.addEventListener('DOMContentLoaded', function () {
		var toggle = document.querySelector('.lr-nav-toggle');
		var menu = document.getElementById('lrSiteNav');
		if (!toggle || !menu) {
			return;
		}
		toggle.addEventListener('click', function () {
			// The parent theme toggles the class in its own click handler first.
			window.setTimeout(function () {
				toggle.setAttribute(
					'aria-expanded',
					menu.classList.contains('pkp_site_nav_menu--isOpen') ? 'true' : 'false'
				);
			}, 0);
		});
	});
})();
