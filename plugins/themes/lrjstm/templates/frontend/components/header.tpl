{**
 * plugins/themes/lrjstm/templates/frontend/components/header.tpl
 *
 * LRJSTM site header. Based on lib/pkp/templates/frontend/components/header.tpl
 * and keeps its skip links, menu areas (primary/user), element IDs and the
 * mobile toggle classes used by the parent theme's JavaScript.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars?
 *}
{strip}
	{assign var="showingLogo" value=true}
	{if !$displayPageHeaderLogo}
		{assign var="showingLogo" value=false}
	{/if}
{/strip}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if} lr-theme" dir="{$currentLocaleLangDir|escape|default:"ltr"}">
	<div class="pkp_structure_page">

		<header class="pkp_structure_head lr-header" id="headerNavigationContainer" role="banner">
			{include file="frontend/components/skipLinks.tpl"}

			{* Top utility bar: ISSN + account menu *}
			<div class="lr-topbar">
				<div class="lr-container lr-topbar__inner">
					<div class="lr-topbar__issn">
						{if $currentContext && $currentContext->getData('onlineIssn')}
							<span>{translate key="plugins.themes.lrjstm.eIssn"}: {$currentContext->getData('onlineIssn')|escape}</span>
						{/if}
						{if $currentContext && $currentContext->getData('printIssn')}
							<span>{translate key="plugins.themes.lrjstm.pIssn"}: {$currentContext->getData('printIssn')|escape}</span>
						{/if}
					</div>
					<nav class="pkp_navigation_user_wrapper lr-topbar__user" id="navigationUserWrapper" aria-label="{translate|escape key="plugins.themes.lrjstm.userMenu"}">
						{load_menu name="user" id="navigationUser" ulClass="pkp_navigation_user" liClass="profile"}
					</nav>
				</div>
			</div>

			<div class="lr-container lr-header__main">
				{if !$requestedPage || $requestedPage === 'index'}
					<h1 class="pkp_screen_reader">
						{if $currentContext}
							{$displayPageHeaderTitle|escape}
						{else}
							{$siteTitle|escape}
						{/if}
					</h1>
				{/if}

				{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}
				<a href="{$homeUrl}" class="lr-brand">
					{if $displayPageHeaderLogo}
						<img class="lr-brand__logo" src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" width="{$displayPageHeaderLogo.width|escape}" height="{$displayPageHeaderLogo.height|escape}" alt="{$displayPageHeaderLogo.altText|default:''|escape}" />
					{/if}
					<span class="lr-brand__text">
						<span class="lr-brand__name">
							{if $currentContext}
								{$currentContext->getLocalizedName()|escape}
							{elseif $displayPageHeaderTitle}
								{$displayPageHeaderTitle|escape}
							{else}
								{$siteTitle|escape}
							{/if}
						</span>
						{if $currentContext && $activeTheme && $activeTheme->getOption('tagline')}
							<span class="lr-brand__tagline">{$activeTheme->getOption('tagline')|escape}</span>
						{/if}
					</span>
				</a>

				<button class="pkp_site_nav_toggle lr-nav-toggle" type="button" aria-controls="lrSiteNav" aria-expanded="false">
					<span>{translate key="plugins.themes.lrjstm.openMenu"}</span>
				</button>

				{capture assign="primaryMenu"}
					{load_menu name="primary" id="navigationPrimary" ulClass="pkp_navigation_primary"}
				{/capture}
				<nav class="pkp_site_nav_menu lr-nav" id="lrSiteNav" aria-label="{translate|escape key="common.navigation.site"}">
					<a id="siteNav"></a>
					<div class="pkp_navigation_primary_row">
						<div class="pkp_navigation_primary_wrapper">
							{$primaryMenu}
							{if $currentContext && $requestedPage !== 'search'}
								<div class="pkp_navigation_search_wrapper">
									<a href="{url page="search"}" class="pkp_search pkp_search_desktop">
										<span class="fa fa-search" aria-hidden="true"></span>
										{translate key="common.search"}
									</a>
								</div>
							{/if}
						</div>
					</div>
				</nav>
			</div>
		</header>

		{if $isFullWidth}
			{assign var=hasSidebar value=0}
		{/if}
		<div class="pkp_structure_content{if $hasSidebar} has_sidebar{/if}">
			<div class="pkp_structure_main" role="main">
				<a id="pkp_content_main"></a>
