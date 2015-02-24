<?php
// Theme: accumen
// inspiration: 
//
$htmltype = 'XHTML'; // cue for transform-based syntax and overrides
$headlevel1 = '2'; // for primary topic heading level
$widgetlevel1 = '3'; // for widget heading level; theme-dependent, secondary context

$classlevel1 = '1'; // for primary topic's levelled class value (expeDITA specific, not theme)
$headclass1 = ''; // for primary topic title styling (pass in only the class value)
$widgetclass1 = ''; // for widget title styling (pass in the full class value)

// outerprop: What, if anything, to apply to the ul wrapper of the navigation list.
// activeprop: What, if anything, to apply to the (usually) li item container of the navigation list.
// anchorprop: What, if anything, to apply to the anchor tag itself rather than to the item container.
$tweaks[$themeName]['outerprop'] = ' id="navlist"';
$tweaks[$themeName]['activeprop'] = ' class="first active"'; 

$wrap['outer'] = 'ul';
$wrap['repeat'] = 'li';
$wrap['sep'] = '';

/*
<ul>
	<li class="first active"><a href="#">Home</a></li>
	<li><a href="#">About</a></li>
	<li><a href="#">Photos</a></li>
	<li><a href="#">Portfolio</a></li>
	<li class="last"><a href="#">Contact</a></li>
</ul>
*/


?>