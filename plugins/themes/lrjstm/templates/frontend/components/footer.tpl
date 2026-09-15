{**
 * plugins/themes/lrjstm/templates/frontend/components/footer.tpl
 *
 * LRJSTM site footer. Based on lib/pkp/templates/frontend/components/footer.tpl
 * and keeps the sidebar hook, the Page Footer content from
 * Settings > Website > Appearance, script loading and the page footer hook.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars?
 *
 * @hook Templates::Common::Sidebar []
 * @hook Templates::Common::Footer::PageFooter []
 *}

	</div><!-- pkp_structure_main -->

	{if empty($isFullWidth)}
		{capture assign="sidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
		{if $sidebarCode}
			<div class="pkp_structure_sidebar left" role="complementary">
				{$sidebarCode}
			</div><!-- pkp_sidebar.left -->
		{/if}
	{/if}
</div><!-- pkp_structure_content -->

<div class="pkp_structure_footer_wrapper lr-footer" role="contentinfo">
	<a id="pkp_content_footer"></a>

	{if $currentContext}
	<div class="lr-container lr-footer__grid">
		<div class="lr-footer__brand">
			{if $displayPageHeaderLogo}
				<span class="lr-footer__logo">
					<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" alt="{$displayPageHeaderLogo.altText|default:''|escape}" loading="lazy" />
				</span>
			{/if}
			<p class="lr-footer__name">{$currentContext->getLocalizedName()|escape}</p>
			{if $lrjstmOptions.aboutInstitution}
				<p class="lr-footer__desc">{$lrjstmOptions.aboutInstitution|escape}</p>
			{elseif $lrjstmOptions.tagline}
				<p class="lr-footer__desc">{$lrjstmOptions.tagline|escape}</p>
			{/if}
			{if $lrjstmSocialLinks}
				<ul class="lr-social" aria-label="{translate|escape key="plugins.themes.lrjstm.footer.follow"}">
					{foreach from=$lrjstmSocialLinks key=network item=socialUrl}
						<li>
							<a href="{$socialUrl|escape}" target="_blank" rel="noopener">
								<span class="fa {if $network == 'x'}fa-twitter{elseif $network == 'youtube'}fa-youtube-play{else}fa-{$network|escape}{/if}" aria-hidden="true"></span>
								<span class="pkp_screen_reader">{translate key="plugins.themes.lrjstm.social.$network"}</span>
							</a>
						</li>
					{/foreach}
				</ul>
			{/if}
		</div>

		<div class="lr-footer__col">
			<h2 class="lr-footer__heading">{translate key="plugins.themes.lrjstm.footer.quickLinks"}</h2>
			<ul>
				<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about"}">{translate key="about.aboutContext"}</a></li>
				<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="current"}">{translate key="journal.currentIssue"}</a></li>
				<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}">{translate key="archive.archives"}</a></li>
				<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="editorialMasthead"}">{translate key="common.editorialMasthead"}</a></li>
				<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="search"}">{translate key="common.search"}</a></li>
			</ul>
		</div>

		<div class="lr-footer__col">
			<h2 class="lr-footer__heading">{translate key="plugins.themes.lrjstm.footer.forAuthors"}</h2>
			<ul>
				<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions"}">{translate key="about.submissions"}</a></li>
				<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions" anchor="authorGuidelines"}">{translate key="about.authorGuidelines"}</a></li>
				<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="privacy"}">{translate key="about.privacyStatement"}</a></li>
				<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="information" op="authors"}">{translate key="navigation.infoForAuthors"}</a></li>
				<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="information" op="readers"}">{translate key="navigation.infoForReaders"}</a></li>
			</ul>
		</div>

		<div class="lr-footer__col lr-footer__contact">
			<h2 class="lr-footer__heading">{translate key="plugins.themes.lrjstm.footer.contact"}</h2>
			<ul>
				{if $currentContext->getData('contactName')}
					<li class="lr-footer__contact-name">{$currentContext->getData('contactName')|escape}</li>
				{/if}
				{if $currentContext->getData('contactEmail')}
					<li><a href="mailto:{$currentContext->getData('contactEmail')|escape}">{$currentContext->getData('contactEmail')|escape}</a></li>
				{/if}
				{if $lrjstmOptions.institutionPhone}
					<li><a href="tel:{$lrjstmOptions.institutionPhone|escape}">{$lrjstmOptions.institutionPhone|escape}</a></li>
				{/if}
				{if $currentContext->getData('mailingAddress')}
					<li class="lr-footer__address">{$currentContext->getData('mailingAddress')|escape|nl2br}</li>
				{/if}
				{if $lrjstmOptions.institutionUrl}
					<li><a href="{$lrjstmOptions.institutionUrl|escape}" target="_blank" rel="noopener">{$lrjstmOptions.institutionUrl|replace:'https://':''|replace:'http://':''|trim:'/'|escape}</a></li>
				{/if}
				<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="contact"}">{translate key="about.contact"} &rarr;</a></li>
			</ul>
		</div>
	</div>
	{/if}

	{if $pageFooter}
		<div class="lr-container">
			<div class="pkp_footer_content lr-footer__custom">
				{$pageFooter}
			</div>
		</div>
	{/if}

	<div class="lr-footer__bottom">
		<div class="lr-container lr-footer__bottom-inner">
			<p>
				&copy; {$lrjstmYear|escape}
				{if $currentContext}{$currentContext->getLocalizedName()|escape}.{else}{$siteTitle|escape}.{/if}
				{if $currentContext && $currentContext->getData('publisherInstitution')}
					{translate key="plugins.themes.lrjstm.footer.publishedBy" publisher=$currentContext->getData('publisherInstitution')|escape}
				{/if}
			</p>
			<div class="pkp_brand_footer">
				<a href="{url page="about" op="aboutThisPublishingSystem"}">
					<img alt="{translate key="about.aboutThisPublishingSystem"}" src="{$baseUrl}/templates/images/ojs_brand_white.png" width="120" height="78">
				</a>
			</div>
		</div>
	</div>
</div><!-- pkp_structure_footer_wrapper -->

</div><!-- pkp_structure_page -->

{load_script context="frontend"}

{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>
