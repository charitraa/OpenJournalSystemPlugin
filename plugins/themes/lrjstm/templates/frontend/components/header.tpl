{**
 * plugins/themes/lrjstm/templates/frontend/components/header.tpl
 *
 * LRJSTM site header. Based on lib/pkp/templates/frontend/components/header.tpl.
 * Kept from core: headerHead.tpl ({load_header}, {load_stylesheet}), skip
 * links, the primary and user menu areas ({load_menu}), #navigationPrimary /
 * #navigationUser IDs, #siteNav, the .pkp_site_nav_toggle / .pkp_site_nav_menu
 * classes used by the parent theme's JavaScript, and the content wrappers.
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

			{* Institutional bar *}
			<div class="lr-topbar">
				<div class="lr-container lr-topbar__inner">
					{if $currentContext}
						<p class="lr-topbar__journal">
							<span class="lr-topbar__name">{$currentContext->getLocalizedName()|escape}</span>
							{if $currentContext->getData('onlineIssn')}
								<span class="lr-topbar__issn">{translate key="plugins.themes.lrjstm.eIssn"}: {$currentContext->getData('onlineIssn')|escape}</span>
							{/if}
							{if $currentContext->getData('printIssn')}
								<span class="lr-topbar__issn">{translate key="plugins.themes.lrjstm.pIssn"}: {$currentContext->getData('printIssn')|escape}</span>
							{/if}
						</p>
					{/if}
					<nav class="pkp_navigation_user_wrapper lr-topbar__user" id="navigationUserWrapper" aria-label="{translate|escape key="plugins.themes.lrjstm.userMenu"}">
						{load_menu name="user" id="navigationUser" ulClass="pkp_navigation_user" liClass="profile"}
					</nav>
				</div>
			</div>

			{* Masthead: identity and actions *}
			<div class="lr-masthead">
				<div class="lr-container lr-masthead__inner">
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
							{if $currentContext && $lrjstmOptions.tagline}
								<span class="lr-brand__tagline">{$lrjstmOptions.tagline|escape}</span>
							{/if}
						</span>
					</a>

					<div class="lr-masthead__actions">
						{if $currentContext}
							<a class="lr-iconbtn lr-search-toggle" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="search"}" aria-controls="lrSearchPanel" aria-expanded="false">
								<span class="fa fa-search" aria-hidden="true"></span>
								<span class="lr-iconbtn__label">{translate key="common.search"}</span>
							</a>
							<a class="lr-btn lr-btn--accent lr-masthead__submit" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions"}">
								{translate key="plugins.themes.lrjstm.submitPaper"}
							</a>
						{/if}
						<button class="pkp_site_nav_toggle lr-nav-toggle" type="button" aria-controls="lrSiteNav" aria-expanded="false">
							<span>{translate key="plugins.themes.lrjstm.openMenu"}</span>
						</button>
					</div>
				</div>

				{* Search panel (opened by the search button; the link works without JavaScript) *}
				{if $currentContext}
					<div class="lr-searchpanel" id="lrSearchPanel" hidden>
						<div class="lr-container">
							<form class="lr-searchbar lr-searchbar--compact" method="get" action="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="search" op="search"}" role="search">
								<label class="pkp_screen_reader" for="lrHeaderQuery">{translate key="plugins.themes.lrjstm.searchLabel"}</label>
								<span class="fa fa-search lr-searchbar__icon" aria-hidden="true"></span>
								<input class="lr-searchbar__input" type="search" id="lrHeaderQuery" name="query" placeholder="{translate|escape key="plugins.themes.lrjstm.searchPlaceholder"}">
								<button class="lr-btn lr-btn--primary lr-searchbar__submit" type="submit">{translate key="common.search"}</button>
							</form>
							<a class="lr-searchpanel__advanced" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="search"}">{translate key="plugins.themes.lrjstm.advancedSearch"}</a>
						</div>
					</div>
				{/if}
			</div>

			{* Primary navigation (Settings > Website > Setup > Navigation Menus) *}
			{capture assign="primaryMenu"}
				{load_menu name="primary" id="navigationPrimary" ulClass="pkp_navigation_primary"}
			{/capture}
			<nav class="pkp_site_nav_menu lr-nav" id="lrSiteNav" aria-label="{translate|escape key="common.navigation.site"}">
				<a id="siteNav"></a>
				<div class="lr-container pkp_navigation_primary_row">
					<div class="pkp_navigation_primary_wrapper">
						{$primaryMenu}
					</div>
				</div>
			</nav>
		</header>

		{if $isFullWidth}
			{assign var=hasSidebar value=0}
		{/if}
		<div class="pkp_structure_content{if $hasSidebar} has_sidebar{/if}">
			<div class="pkp_structure_main" role="main">
				<a id="pkp_content_main"></a>
