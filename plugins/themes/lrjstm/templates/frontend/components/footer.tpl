{**
 * plugins/themes/lrjstm/templates/frontend/components/footer.tpl
 *
 * LRJSTM site footer. Based on lib/pkp/templates/frontend/components/footer.tpl.
 * Kept from core: the sidebar hook, the Page Footer content from
 * Settings > Website > Appearance, the OJS/PKP credit link, {load_script}
 * and the page footer hook.
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
				{assign var=footerSummary value=$currentContext->getLocalizedData('description')|strip_unsafe_html|strip_tags|trim}
				{if $footerSummary}
					<p class="lr-footer__desc">{$footerSummary|truncate:220:"…"}</p>
				{/if}
				{if $currentContext->getData('publisherInstitution')}
					<p class="lr-footer__publisher">
						{if $lrjstmOptions.institutionUrl}
							{translate key="plugins.themes.lrjstm.footer.publishedBy" publisher=$currentContext->getData('publisherInstitution')|escape}
							<a href="{$lrjstmOptions.institutionUrl|escape}" target="_blank" rel="noopener">{$lrjstmOptions.institutionUrl|replace:'https://':''|replace:'http://':''|trim:'/'|escape}</a>
						{else}
							{translate key="plugins.themes.lrjstm.footer.publishedBy" publisher=$currentContext->getData('publisherInstitution')|escape}
						{/if}
					</p>
				{/if}
			</div>

			<nav class="lr-footer__col" aria-labelledby="lrFooterJournal">
				<h2 class="lr-footer__heading" id="lrFooterJournal">{translate key="plugins.themes.lrjstm.footer.journal"}</h2>
				<ul>
					<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="current"}">{translate key="journal.currentIssue"}</a></li>
					<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}">{translate key="archive.archives"}</a></li>
					<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about"}">{translate key="about.aboutContext"}</a></li>
					<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="editorialMasthead"}">{translate key="plugins.themes.lrjstm.editorialBoard"}</a></li>
					{if $currentContext->getData('enableAnnouncements')}
						<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="announcement"}">{translate key="announcement.announcements"}</a></li>
					{/if}
				</ul>
			</nav>

			<nav class="lr-footer__col" aria-labelledby="lrFooterAuthors">
				<h2 class="lr-footer__heading" id="lrFooterAuthors">{translate key="plugins.themes.lrjstm.footer.forAuthors"}</h2>
				<ul>
					<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions"}">{translate key="plugins.themes.lrjstm.submitPaper"}</a></li>
					<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions" anchor="authorGuidelines"}">{translate key="about.authorGuidelines"}</a></li>
					{if $lrjstmOptions.ethicsUrl}
						<li><a href="{$lrjstmOptions.ethicsUrl|escape}">{translate key="plugins.themes.lrjstm.ethics"}</a></li>
					{/if}
					{if $lrjstmOptions.peerReviewUrl}
						<li><a href="{$lrjstmOptions.peerReviewUrl|escape}">{translate key="plugins.themes.lrjstm.peerReview"}</a></li>
					{/if}
					{if $lrjstmOptions.policiesUrl}
						<li><a href="{$lrjstmOptions.policiesUrl|escape}">{translate key="plugins.themes.lrjstm.policies"}</a></li>
					{/if}
					<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="information" op="authors"}">{translate key="navigation.infoForAuthors"}</a></li>
				</ul>
			</nav>

			<div class="lr-footer__col lr-footer__contact">
				<h2 class="lr-footer__heading">{translate key="about.contact"}</h2>
				<ul>
					{if $currentContext->getData('contactName')}
						<li class="lr-footer__contact-name">{$currentContext->getData('contactName')|escape}</li>
					{/if}
					{if $currentContext->getData('contactEmail')}
						<li><span class="fa fa-envelope-o" aria-hidden="true"></span><a href="mailto:{$currentContext->getData('contactEmail')|escape}">{$currentContext->getData('contactEmail')|escape}</a></li>
					{/if}
					{if $lrjstmOptions.institutionPhone}
						<li><span class="fa fa-phone" aria-hidden="true"></span><a href="tel:{$lrjstmOptions.institutionPhone|escape}">{$lrjstmOptions.institutionPhone|escape}</a></li>
					{/if}
					{if $currentContext->getData('mailingAddress')}
						<li class="lr-footer__address"><span class="fa fa-map-marker" aria-hidden="true"></span><span>{$currentContext->getData('mailingAddress')|escape|nl2br}</span></li>
					{/if}
					<li><a class="lr-footer__more" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="contact"}">{translate key="plugins.themes.lrjstm.footer.contactPage"}</a></li>
				</ul>
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
		</div>
	{/if}

	{* Page Footer content from Settings > Website > Appearance, shown only when enabled in the theme options (it usually repeats this footer) *}
	{if $pageFooter && $lrjstmShowPageFooter}
		<div class="lr-container">
			<div class="pkp_footer_content lr-footer__custom">
				{$pageFooter}
			</div>
		</div>
	{/if}

	<div class="lr-footer__bottom">
		<div class="lr-container lr-footer__bottom-inner">
			<p class="lr-footer__copyright">
				&copy; {$lrjstmYear|escape} {if $currentContext}{$currentContext->getLocalizedName()|escape}{else}{$siteTitle|escape}{/if}
			</p>
			<ul class="lr-footer__legal">
				{if $currentContext}
					<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="privacy"}">{translate key="about.privacyStatement"}</a></li>
				{/if}
				{if $lrjstmOptions.accessibilityUrl}
					<li><a href="{$lrjstmOptions.accessibilityUrl|escape}">{translate key="plugins.themes.lrjstm.accessibility"}</a></li>
				{/if}
				<li class="pkp_brand_footer">
					<a href="{url page="about" op="aboutThisPublishingSystem"}">
						<img alt="{translate key="about.aboutThisPublishingSystem"}" src="{$baseUrl}/templates/images/ojs_brand.png" width="92" height="60">
					</a>
				</li>
			</ul>
		</div>
	</div>
</div><!-- pkp_structure_footer_wrapper -->

</div><!-- pkp_structure_page -->

{load_script context="frontend"}

{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>
