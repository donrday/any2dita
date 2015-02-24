<?php
// Theme: vasile
$htmltype = 'HTML5'; // cue for transform-based syntax and overrides
$headlevel1 = '1'; // for primary topic heading level
$widgetlevel1 = '3'; // for widget heading level; theme-dependent, secondary context

$classlevel1 = '1'; // for primary topic's levelled class value (expeDITA specific, not theme)
$headclass1 = ''; // for primary toic title styling (pass in only the class value)
$widgetclass1 = ''; // for widget title styling (pass in the full class value)

// outerprop: What, if anything, to apply to the ul wrapper of the navigation list.
// activeprop: What, if anything, to apply to the (usually) li item container of the navigation list.
// anchorprop: What, if anything, to apply to the anchor tag itself rather than to the item container.
$tweaks[$themeName]['activeprop'] = ' class="active"'; 


/* navigation example from template (for comparison):
<nav>
	<ul>
		<li class="active"><a href="#">Home</a></li>
		<li><a href="#">About</a></li>
		<li><a href="#">Portfolio</a></li>
		<li><a href="#">Contact</a></li>
	</ul>
</nav>

*/
