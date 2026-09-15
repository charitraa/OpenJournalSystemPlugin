{**
 * plugins/themes/lrjstm/templates/frontend/pages/issueArchive.tpl
 *
 * Issue archive. Based on templates/frontend/pages/issueArchive.tpl; the
 * issues on the current page are grouped by year (LrjstmThemePlugin::
 * assignArchiveData) and shown as cover cards. Pagination is unchanged.
 *
 * @uses $issues Array Collection of issues to display
 * @uses $lrjstmIssuesByYear array Issues on this page grouped by year
 * @uses $prevPage int The previous page number
 * @uses $nextPage int The next page number
 * @uses $showingStart int The number of the first item on this page
 * @uses $showingEnd int The number of the last item on this page
 * @uses $total int Count of all published monographs
 *}
{capture assign="pageTitle"}
	{if $prevPage}
		{translate key="archive.archivesPageNumber" pageNumber=$prevPage+1}
	{else}
		{translate key="archive.archives"}
	{/if}
{/capture}
{include file="frontend/components/header.tpl" pageTitleTranslated=$pageTitle}

<div class="page page_issue_archive">
	{include file="frontend/components/breadcrumbs.tpl" currentTitle=$pageTitle}
	<h1>
		{$pageTitle|escape}
	</h1>

	{* No issues have been published *}
	{if empty($issues)}
		<div class="lr-empty">
			<span class="fa fa-book" aria-hidden="true"></span>
			<p>{translate key="current.noCurrentIssueDesc"}</p>
			{if $lrjstmOptions.legacyArchiveUrl}
				<a class="lr-btn lr-btn--secondary" href="{$lrjstmOptions.legacyArchiveUrl|escape}" target="_blank" rel="noopener">{translate key="plugins.themes.lrjstm.legacyArchive"} <span class="fa fa-external-link" aria-hidden="true"></span></a>
			{/if}
		</div>

	{* List issues *}
	{else}
		{foreach from=$lrjstmIssuesByYear key=archiveYear item=yearIssues}
			<section class="lr-archive__year" aria-labelledby="lrArchiveYear-{$archiveYear|escape}">
				<h2 class="lr-archive__yeartitle" id="lrArchiveYear-{$archiveYear|escape}">{if $archiveYear}{$archiveYear|escape}{else}{translate key="archive.archives"}{/if}</h2>
				<ul class="issues_archive">
					{foreach from=$yearIssues item="issue"}
						<li>
							{include file="frontend/objects/issue_summary.tpl" heading="h3"}
						</li>
					{/foreach}
				</ul>
			</section>
		{/foreach}

		{* Pagination *}
		{if $prevPage > 1}
			{capture assign=prevUrl}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive" path=$prevPage}{/capture}
		{elseif $prevPage === 1}
			{capture assign=prevUrl}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}{/capture}
		{/if}
		{if $nextPage}
			{capture assign=nextUrl}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive" path=$nextPage}{/capture}
		{/if}
		{include
			file="frontend/components/pagination.tpl"
			prevUrl=$prevUrl
			nextUrl=$nextUrl
			showingStart=$showingStart
			showingEnd=$showingEnd
			total=$total
		}
	{/if}
</div>

{include file="frontend/components/footer.tpl"}
