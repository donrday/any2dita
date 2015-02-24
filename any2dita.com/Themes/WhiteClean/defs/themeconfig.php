<?php
// $themeName: WhiteClean
$htmltype = 'XHTML'; // cue for transform-based syntax and overrides
$headlevel1 = '2'; // for primary topic heading level
$widgetlevel1 = '2'; // for widget heading level; theme-dependent, secondary context

$classlevel1 = '1'; // for primary topic's levelled class value (expeDITA specific, not theme)
$headclass1 = ''; // for primary topic title styling (pass in only the class value)
$widgetclass1 = ''; // for widget title styling (pass in the full class value)

// outerprop: What, if anything, to apply to the ul wrapper of the navigation list.
// activeprop: What, if anything, to apply to the (usually) li item container of the navigation list.
// anchorprop: What, if anything, to apply to the anchor tag itself rather than to the item container.

$wrap['outer'] = 'ul';
$wrap['repeat'] = 'li';
$wrap['sep'] = '';


/* navigation example from template (for comparison):

<div id="menu">
	<ul>
		<li><a href="#">Home</a></li>
	</ul>
</div>

*/

/* content example:
<h2><a href="#">[title]</a></h2>
<div class="articles">
	[content]
</div>

*/

/* sidebar example:
<h2>[title]</h2>
[content]

*/