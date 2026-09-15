{**
 * plugins/themes/lrjstm/templates/frontend/objects/issue_summary.tpl
 *
 * Issue card used in the archive. Based on
 * templates/frontend/objects/issue_summary.tpl, with a branded placeholder
 * when the issue has no cover image.
 *
 * @uses $issue Issue The issue
 *}
{if $issue->getShowTitle()}
	{assign var=issueTitle value=$issue->getLocalizedTitle()}
{/if}
{assign var=issueSeries value=$issue->getIssueSeries()}
{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}

<div class="obj_issue_summary lr-issue-card">

	<a class="cover lr-cover{if !$issueCover} lr-cover--placeholder{/if}" href="{url op="view" path=$issue->getBestIssueId()}" tabindex="-1" aria-hidden="true">
		{if $issueCover}
			<img src="{$issueCover|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}" loading="lazy">
		{else}
			{if $currentContext}
				<span class="lr-cover__abbr">{$currentContext->getLocalizedAcronym()|default:$currentContext->getLocalizedAbbreviation()|escape}</span>
			{/if}
			{if $issue->getVolume()}<span class="lr-cover__vol">{translate key="issue.vol"} {$issue->getVolume()|escape}</span>{/if}
			{if $issue->getNumber()}<span class="lr-cover__no">{translate key="issue.no"} {$issue->getNumber()|escape}</span>{/if}
			{if $issue->getYear()}<span class="lr-cover__year">{$issue->getYear()|escape}</span>{/if}
		{/if}
	</a>

	<div class="lr-issue-card__body">
		<h2>
			<a class="title" href="{url op="view" path=$issue->getBestIssueId()}">
				{if $issueTitle}
					{$issueTitle|escape}
				{else}
					{$issueSeries|escape}
				{/if}
			</a>
			{if $issueTitle && $issueSeries}
				<div class="series">
					{$issueSeries|escape}
				</div>
			{/if}
		</h2>

		{if $issue->getLocalizedDescription()}
			<div class="description">
				{$issue->getLocalizedDescription()|strip_unsafe_html}
			</div>
		{/if}
	</div>
</div><!-- .obj_issue_summary -->
