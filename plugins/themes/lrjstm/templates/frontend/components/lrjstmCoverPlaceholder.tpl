{**
 * plugins/themes/lrjstm/templates/frontend/components/lrjstmCoverPlaceholder.tpl
 *
 * Contents of the branded placeholder shown when an issue has no cover image.
 * The wrapping element (.lr-cover.lr-cover--placeholder) is provided by the
 * including template.
 *
 * @uses $coverIssue Issue
 *}
{if $currentContext}
	<span class="lr-cover__journal">{$currentContext->getLocalizedAcronym()|default:$currentContext->getLocalizedAbbreviation()|escape}</span>
{/if}
<span class="lr-cover__rule"></span>
<span class="lr-cover__issue">
	{if $coverIssue->getVolume()}{translate key="issue.vol"} {$coverIssue->getVolume()|escape}{/if}
	{if $coverIssue->getNumber()}{translate key="issue.no"} {$coverIssue->getNumber()|escape}{/if}
	{if $coverIssue->getYear()}<span class="lr-cover__year"><br>{$coverIssue->getYear()|escape}</span>{/if}
</span>
