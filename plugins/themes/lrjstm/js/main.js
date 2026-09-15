/**
 * @file plugins/themes/lrjstm/js/main.js
 *
 * LRJSTM theme behaviour. Small progressive enhancements only; every link
 * and form works without JavaScript. The parent Default theme still handles
 * the mobile menu toggle and dropdown menus.
 */
(function () {
	'use strict';

	document.addEventListener('DOMContentLoaded', function () {
		// Mobile menu: keep aria-expanded in sync with the parent theme's toggle.
		var navToggle = document.querySelector('.lr-nav-toggle');
		var nav = document.getElementById('lrSiteNav');
		if (navToggle && nav) {
			navToggle.addEventListener('click', function () {
				window.setTimeout(function () {
					navToggle.setAttribute(
						'aria-expanded',
						nav.classList.contains('pkp_site_nav_menu--isOpen') ? 'true' : 'false'
					);
				}, 0);
			});
		}

		// Header search: open the inline panel instead of leaving the page.
		var searchToggle = document.querySelector('.lr-search-toggle');
		var searchPanel = document.getElementById('lrSearchPanel');
		if (searchToggle && searchPanel) {
			var setSearchOpen = function (open) {
				searchPanel.hidden = !open;
				searchToggle.setAttribute('aria-expanded', open ? 'true' : 'false');
				if (open) {
					var input = searchPanel.querySelector('input[name="query"]');
					if (input) {
						input.focus();
					}
				}
			};
			searchToggle.addEventListener('click', function (event) {
				event.preventDefault();
				setSearchOpen(searchPanel.hidden);
			});
			searchPanel.addEventListener('keydown', function (event) {
				if (event.key === 'Escape') {
					setSearchOpen(false);
					searchToggle.focus();
				}
			});
		}

		// Mark the navigation link for the current page.
		var here = window.location.href.split('#')[0].replace(/\/$/, '');
		document.querySelectorAll('#navigationPrimary a[href]').forEach(function (link) {
			if (link.href.replace(/\/$/, '') === here) {
				link.setAttribute('aria-current', 'page');
			}
		});
	});
})();
