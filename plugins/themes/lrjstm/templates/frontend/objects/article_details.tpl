{**
 * plugins/themes/lrjstm/templates/frontend/objects/article_details.tpl
 *
 * Scholarly article layout for LRJSTM. Based on
 * templates/frontend/objects/article_details.tpl: every core component and
 * hook is kept (notices, authors with affiliations/ORCID, DOI, keywords,
 * abstract, Templates::Article::Main, usage chart, author biographies,
 * references with Templates::Article::Details::Reference, cover, galleys,
 * supplementary files, versions, data availability, issue/section/categories,
 * pub IDs, licence and Templates::Article::Details). Components are regrouped
 * into an article header, a download bar, the main text column and a
 * details column, keeping the .item / .label / .value markup pattern that
 * plugins rely on.
 *
 * @uses $article Submission This article
 * @uses $publication Publication The publication being displayed
 * @uses $firstPublication Publication The first published version of this article
 * @uses $currentPublication Publication The most recently published version of this article
 * @uses $issue Issue The issue this article is assigned to
 * @uses $section Section The journal section this article is assigned to
 * @uses $categories Category The category this article is assigned to
 * @uses $primaryGalleys array List of article galleys that are not supplementary or dependent
 * @uses $supplementaryGalleys array List of article galleys that are supplementary
 * @uses $keywords array List of keywords assigned to this article
 * @uses $pubIdPlugins Array of pubId plugins which this article may be assigned
 * @uses $licenseTerms string License terms.
 * @uses $licenseUrl string URL to license. Only assigned if license should be
 *   included with published submissions.
 * @uses $ccLicenseBadge string An image and text with details about the license
 *
 * @hook Templates::Article::Main []
 * @hook Templates::Article::Details::Reference []
 * @hook Templates::Article::Details []
 *}
{if !$heading}
	{assign var="heading" value="h3"}
{/if}
<article class="obj_article_details lr-article">

	{* Indicate if this is only a preview *}
	{if $publication->getData('status') !== PKP\submission\PKPSubmission::STATUS_PUBLISHED}
	<div class="cmp_notification notice">
		{capture assign="submissionUrl"}{url page="dashboard" op="editorial" workflowSubmissionId=$article->getId()}{/capture}
		{translate key="submission.viewingPreview" url=$submissionUrl}
	</div>
	{* Notification that this is an old version *}
	{elseif $currentPublication->getId() !== $publication->getId()}
		<div class="cmp_notification notice">
			{capture assign="latestVersionUrl"}{url page="article" op="view" path=$article->getBestId()}{/capture}
			{translate key="submission.outdatedVersion"
				datePublished=$publication->getData('datePublished')|date_format:$dateFormatShort
				urlRecentVersion=$latestVersionUrl|escape
			}
		</div>
	{/if}

	{* ============ ARTICLE HEADER ============ *}
	<header class="lr-article__header">
		{if $section || $categories}
			<p class="lr-article__area">
				{if $categories}
					{foreach from=$categories item=category name=areaCategories}
						<a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="catalog" op="category" path=$category->getPath()|escape}">{$category->getLocalizedTitle()|escape}</a>{if !$smarty.foreach.areaCategories.last}<span aria-hidden="true"> · </span>{/if}
					{/foreach}
				{elseif $section}
					<span>{$section->getLocalizedTitle()|escape}</span>
				{/if}
			</p>
		{/if}

		<h1 class="page_title">
			{$publication->getLocalizedTitle(null, 'html')|strip_unsafe_html}
		</h1>

		{if $publication->getLocalizedData('subtitle')}
			<h2 class="subtitle">
				{$publication->getLocalizedSubTitle(null, 'html')|strip_unsafe_html}
			</h2>
		{/if}

		{if $publication->getData('authors')}
			<section class="item authors">
				<h2 class="pkp_screen_reader">{translate key="article.authors"}</h2>
				<ul class="authors">
				{foreach from=$publication->getData('authors') item=author}
					<li>
						<span class="name">
							{$author->getFullName()|escape}
						</span>
						{if count($author->getAffiliations()) > 0}
							<span class="affiliation">
								{assign var="renderedAffiliation" value=false}
								{foreach from=$author->getAffiliations() item="affiliation"}
									{if $affiliation->getLocalizedName() || $affiliation->getRor()}
										{if $renderedAffiliation}{translate key="common.commaListSeparator"}{/if}
										{if $affiliation->getLocalizedName()}<span>{$affiliation->getLocalizedName()|escape}</span>{/if}
										{if $affiliation->getRor()}<a href="{$affiliation->getRor()|escape}">{$rorIdIcon}</a>{/if}
										{assign var="renderedAffiliation" value=true}
									{/if}
								{/foreach}
							</span>
						{/if}
						{assign var=authorUserGroup value=$userGroupsById[$author->getData('userGroupId')]}
						{if $authorUserGroup->showTitle}
							<span class="userGroup">
								{$authorUserGroup->getLocalizedData('name')|escape}
							</span>
						{/if}
						{if $author->getData('orcid')}
							<span class="orcid">
								{if $author->hasVerifiedOrcid()}
									{$orcidIcon}
								{else}
									{$orcidUnauthenticatedIcon}
								{/if}
								<a href="{$author->getData('orcid')|escape}" target="_blank">
									{$author->getOrcidDisplayValue()|escape}
								</a>
							</span>
						{/if}
					</li>
				{/foreach}
				</ul>
			</section>
		{/if}

		{* Publication information *}
		<div class="lr-article__pubinfo">
			{if $publication->getData('datePublished')}
				<div class="lr-article__pubitem">
					<span class="lr-article__pubkey">{translate key="submissions.published"}</span>
					<span class="lr-article__pubval">{$firstPublication->getData('datePublished')|date_format:$dateFormatShort}</span>
				</div>
			{/if}
			{if $issue}
				<div class="lr-article__pubitem">
					<span class="lr-article__pubkey">{translate key="issue.issue"}</span>
					<span class="lr-article__pubval"><a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">{$issue->getIssueIdentification()|escape}</a></span>
				</div>
			{/if}
			{if $publication->getData('pages')}
				<div class="lr-article__pubitem">
					<span class="lr-article__pubkey">{translate key="plugins.themes.lrjstm.pages"}</span>
					<span class="lr-article__pubval">{$publication->getData('pages')|escape}</span>
				</div>
			{/if}

			{* DOI *}
			{assign var=doiObject value=$article->getCurrentPublication()->getData('doiObject')}
			{if $doiObject}
				{assign var="doiUrl" value=$doiObject->getData('resolvingUrl')|escape}
				<section class="item doi lr-article__pubitem">
					<h2 class="label lr-article__pubkey">
						{capture assign=translatedDOI}{translate key="doi.readerDisplayName"}{/capture}
						{translate key="semicolon" label=$translatedDOI}
					</h2>
					<span class="value lr-article__pubval">
						<a href="{$doiUrl}">
							{$doiUrl}
						</a>
					</span>
				</section>
			{/if}
		</div>

		{* Article Galleys *}
		{if $primaryGalleys || $supplementaryGalleys}
			<div class="lr-article__downloads">
				{if $primaryGalleys}
					<div class="item galleys">
						<h2 class="pkp_screen_reader">
							{translate key="submission.downloads"}
						</h2>
						<ul class="value galleys_links">
							{foreach from=$primaryGalleys item=galley}
								<li>
									{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley purchaseFee=$currentJournal->getData('purchaseArticleFee') purchaseCurrency=$currentJournal->getData('currency')}
								</li>
							{/foreach}
						</ul>
					</div>
				{/if}
				{if $supplementaryGalleys}
					<div class="item galleys">
						<h3 class="pkp_screen_reader">
							{translate key="submission.additionalFiles"}
						</h3>
						<ul class="value supplementary_galleys_links">
							{foreach from=$supplementaryGalleys item=galley}
								<li>
									{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley isSupplementary="1"}
								</li>
							{/foreach}
						</ul>
					</div>
				{/if}
			</div>
		{/if}
	</header>

	<div class="row">
		<div class="main_entry">

			{* Abstract *}
			{if $publication->getLocalizedData('abstract')}
				<section class="item abstract">
					<h2 class="label">{translate key="article.abstract"}</h2>
					{$publication->getLocalizedData('abstract')|strip_unsafe_html}
				</section>
			{/if}

			{* Keywords *}
			{if !empty($publication->getLocalizedData('keywords'))}
			<section class="item keywords">
				<h2 class="label">
					{capture assign=translatedKeywords}{translate key="article.subject"}{/capture}
					{translate key="semicolon" label=$translatedKeywords}
				</h2>
				<span class="value">
					{foreach name="keywords" from=$publication->getLocalizedData('keywords') item="keyword"}
						<span class="lr-keyword">{$keyword.name|escape}</span>{if !$smarty.foreach.keywords.last}<span class="pkp_screen_reader">{translate key="common.commaListSeparator"}</span>{/if}
					{/foreach}
				</span>
			</section>
			{/if}

			{call_hook name="Templates::Article::Main"}

			{* Usage statistics chart *}
			{if $activeTheme && $activeTheme->getOption('displayStats') != 'none'}
				{$activeTheme->displayUsageStatsGraph($article->getId())}
				<section class="item downloads_chart">
					<h2 class="label">
						{translate key="plugins.themes.default.displayStats.downloads"}
					</h2>
					<div class="value">
						<canvas class="usageStatsGraph" data-object-type="Submission" data-object-id="{$article->getId()|escape}"></canvas>
						<div class="usageStatsUnavailable" data-object-type="Submission" data-object-id="{$article->getId()|escape}">
							{translate key="plugins.themes.default.displayStats.noStats"}
						</div>
					</div>
				</section>
			{/if}

			{* Author biographies *}
			{assign var="hasBiographies" value=0}
			{foreach from=$publication->getData('authors') item=author}
				{if $author->getLocalizedData('biography')}
					{assign var="hasBiographies" value=$hasBiographies+1}
				{/if}
			{/foreach}
			{if $hasBiographies}
				<section class="item author_bios">
					<h2 class="label">
						{if $hasBiographies > 1}
							{translate key="submission.authorBiographies"}
						{else}
							{translate key="submission.authorBiography"}
						{/if}
					</h2>
					<ul class="authors">
					{foreach from=$publication->getData('authors') item=author}
						{if $author->getLocalizedData('biography')}
							<li class="sub_item">
								<div class="label">
									{if $author->getLocalizedAffiliationNamesAsString()}
										{capture assign="authorName"}{$author->getFullName()|escape}{/capture}
										{capture assign="authorAffiliations"} {$author->getLocalizedAffiliationNamesAsString(null, ', ')|escape} {/capture}
										{translate key="submission.authorWithAffiliation" name=$authorName affiliation=$authorAffiliations}
									{else}
										{$author->getFullName()|escape}
									{/if}
								</div>
								<div class="value">
									{$author->getLocalizedData('biography')|strip_unsafe_html}
								</div>
							</li>
						{/if}
					{/foreach}
					</ul>
				</section>
			{/if}

			{* References *}
			{if count($parsedCitations) || (string) $publication->getData('citationsRaw')}
				<section class="item references">
					<h2 class="label">
						{translate key="submission.citations"}
					</h2>
					<div class="value">
						{if count($parsedCitations)}
							{foreach from=$parsedCitations item="parsedCitation"}
								<p>{$parsedCitation->getCitationWithLinks()|strip_unsafe_html} {call_hook name="Templates::Article::Details::Reference" citation=$parsedCitation}</p>
							{/foreach}
						{else}
							{$publication->getData('citationsRaw')|escape|nl2br}
						{/if}
					</div>
				</section>
			{/if}

		</div><!-- .main_entry -->

		<div class="entry_details">

			{* Article/Issue cover image *}
			{if $publication->getLocalizedData('coverImage') || ($issue && $issue->getLocalizedCoverImage())}
				<div class="item cover_image">
					<div class="sub_item">
						{if $publication->getLocalizedData('coverImage')}
							{assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
							<img
								src="{$publication->getLocalizedCoverImageUrl($article->getData('contextId'))|escape}"
								alt="{$coverImage.altText|escape|default:''}"
							>
						{else}
							<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
								<img src="{$issue->getLocalizedCoverImageUrl()|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}">
							</a>
						{/if}
					</div>
				</div>
			{/if}

			{if $publication->getData('datePublished')}
			<div class="item published">
				<section class="sub_item">
					<h2 class="label">
						{translate key="submissions.published"}
					</h2>
					<div class="value">
						{* If this is the original version *}
						{if $firstPublication->getId() === $publication->getId()}
							<span>{$firstPublication->getData('datePublished')|date_format:$dateFormatShort}</span>
						{* If this is an updated version *}
						{else}
							<span>{translate key="submission.updatedOn" datePublished=$firstPublication->getData('datePublished')|date_format:$dateFormatShort dateUpdated=$publication->getData('datePublished')|date_format:$dateFormatShort}</span>
						{/if}
					</div>
				</section>
				{if count($article->getPublishedPublications()) > 1}
					<section class="sub_item versions">
						<h2 class="label">
							{translate key="submission.versions"}
						</h2>
						<ul class="value">
							{foreach from=array_reverse($article->getPublishedPublications()) item=iPublication}
								{capture assign="name"}{translate key="submission.versionIdentity" datePublished=$iPublication->getData('datePublished')|date_format:$dateFormatShort version=$iPublication->getData('version')}{/capture}
								<li>
									{if $iPublication->getId() === $publication->getId()}
										{$name}
									{elseif $iPublication->getId() === $currentPublication->getId()}
										<a href="{url page="article" op="view" path=$article->getBestId()}">{$name}</a>
									{else}
										<a href="{url page="article" op="view" path=$article->getBestId()|to_array:"version":$iPublication->getId()}">{$name}</a>
									{/if}
								</li>
							{/foreach}
						</ul>
					</section>
				{/if}
			</div>
			{/if}

			{* Data Availability Statement *}
			{if $publication->getLocalizedData('dataAvailability')}
				<section class="item dataAvailability" id="data-availability-statement">
					<h2 class="label">{translate key="submission.dataAvailability"}</h2>
					{$publication->getLocalizedData('dataAvailability')|strip_unsafe_html}
				</section>
			{/if}

			{* Issue article appears in *}
			{if $issue || $section || $categories}
				<div class="item issue">

					{if $issue}
						<section class="sub_item">
							<h2 class="label">
								{translate key="issue.issue"}
							</h2>
							<div class="value">
								<a class="title" href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
									{$issue->getIssueIdentification()|escape}
								</a>
							</div>
						</section>
					{/if}

					{if $section}
						<section class="sub_item">
							<h2 class="label">
								{translate key="section.section"}
							</h2>
							<div class="value">
								{$section->getLocalizedTitle()|escape}
							</div>
						</section>
					{/if}

					{if $categories}
						<section class="sub_item">
							<h2 class="label">
								{translate key="category.category"}
							</h2>
							<div class="value">
								<ul class="categories">
									{foreach from=$categories item=category}
										<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="catalog" op="category" path=$category->getPath()|escape}">{$category->getLocalizedTitle()|escape}</a></li>
									{/foreach}
								</ul>
							</div>
						</section>
					{/if}
				</div>
			{/if}

			{* PubIds (requires plugins) *}
			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() == 'doi'}
					{continue}
				{/if}
				{assign var=pubId value=$publication->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					<section class="item pubid">
						<h2 class="label">
							{$pubIdPlugin->getPubIdDisplayType()|escape}
						</h2>
						<div class="value">
							{if $pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
								<a id="pub-id::{$pubIdPlugin->getPubIdType()|escape}" href="{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}">
									{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
								</a>
							{else}
								{$pubId|escape}
							{/if}
						</div>
					</section>
				{/if}
			{/foreach}

			{* Licensing info *}
			{if $currentContext->getLocalizedData('licenseTerms') || $publication->getData('licenseUrl')}
				<div class="item copyright">
					<h2 class="label">
						{translate key="submission.license"}
					</h2>
					{if $publication->getData('licenseUrl')}
						{if $ccLicenseBadge}
							{if $publication->getLocalizedData('copyrightHolder')}
								<p>{translate key="submission.copyrightStatement" copyrightHolder=$publication->getLocalizedData('copyrightHolder') copyrightYear=$publication->getData('copyrightYear')}</p>
							{/if}
							{$ccLicenseBadge}
						{else}
							<a href="{$publication->getData('licenseUrl')|escape}" class="copyright">
								{if $publication->getLocalizedData('copyrightHolder')}
									{translate key="submission.copyrightStatement" copyrightHolder=$publication->getLocalizedData('copyrightHolder') copyrightYear=$publication->getData('copyrightYear')}
								{else}
									{translate key="submission.license"}
								{/if}
							</a>
						{/if}
					{/if}
					{$currentContext->getLocalizedData('licenseTerms')}
				</div>
			{/if}

			{call_hook name="Templates::Article::Details"}

		</div><!-- .entry_details -->
	</div><!-- .row -->

</article>
