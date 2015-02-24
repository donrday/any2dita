<?php
// Theme: light
// inspiration: 
//
$htmltype = 'XHTML'; // cue for transform-based syntax and overrides
$headlevel1 = '1'; // for primary topic heading level
$widgetlevel1 = '3'; // for widget heading level; theme-dependent, secondary context

$classlevel1 = '1'; // for primary topic's levelled class value (expeDITA specific, not theme)
$headclass1 = ''; // for primary topic title styling (pass in only the class value)
$widgetclass1 = ''; // for widget title styling (pass in the full class value)

// outerprop: What, if anything, to apply to the ul wrapper of the navigation list.
// activeprop: What, if anything, to apply to the (usually) li item container of the navigation list.
// anchorprop: What, if anything, to apply to the anchor tag itself rather than to the item container.
//$tweaks[$themeName]['outerprop'] = ' id="menu"';
$tweaks[$themeName]['activeprop'] = ' class="active"'; 

$wrap['outer'] = '';
$wrap['repeat'] = '';
$wrap['sep'] = '';


?>