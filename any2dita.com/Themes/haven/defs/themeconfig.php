<?php
// Theme: haven
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
$tweaks[$themeName]['outerprop'] = ' id="menu"';
$tweaks[$themeName]['activeprop'] = ' class="selected"'; 

$wrap['outer'] = 'ul';
$wrap['repeat'] = 'li';
$wrap['sep'] = '<li>|</li>';


/* define all local widgets here (esp those requiring dedicated wrappers) */

$db = array(
	array('lorem ipsum dolor sit amet','<img class="imgright" alt="image description" src="Themes/haven/images/image.gif" />
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut sem purus, tempor et, interdum ac, venenatis at, 
velit. Morbi massa sem, pellentesque sed, sagittis vel, viverra ut, arcu. Sed euismod, mauris ac porta tempor, dui 
odio aliquet nisi, vitae vulputate leo tellus ut erat. <a title="mauris fringilla" href="index.html">Mauris fringilla</a> lectus ac arcu. Morbi lobortis, mi nec luctus 
ultrices, leo pede consequat diam, quis rutrum erat neque id nulla. Quisque sem. Phasellus interdum bibendum leo. 
Aliquam erat volutpat.</p>
<p>Morbi ac nibh. Vestibulum augue quam, luctus facilisis, vehicula ac, ullamcorper ultrices, 
tellus. Mauris posuere viverra nulla. In vel purus. Suspendisse turpis. Vivamus adipiscing tincidunt magna. Nam et 
lectus at nunc vehicula malesuada. Nunc at nisl. Nulla facilisi. Maecenas leo. Praesent ac lectus. Nulla tincidunt mi eu odio.</p>'),
	array('lunc dolor metus, laoreet in','<?php primary();?>
<p>Nunc dolor metus, laoreet in, viverra a, laoreet eu, lacus. Ut dolor tortor, ultricies vel, imperdiet sed, ullamcorper ut, 
dui. Mauris lacus metus, varius fermentum, varius eget, posuere vel, felis. Pellentesque viverra, nulla quis ultricies tincidunt,
 leo dolor mollis nunc, et viverra urna neque vitae nibh. Fusce ac massa. Donec auctor.</p>
<p class="blockquote">Primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aenean nibh. Lorem ipsum 
dolor sit amet, consectetuer adipiscing elit. Donec molestie. Mauris luctus.</p>
<p>Maecenas ultrices rutrum lacus. Fusce lorem ligula, luctus mollis, vehicula quis, scelerisque id, velit. Pellentesque ultricies 
elementum velit. Nunc hendrerit hendrerit lacus. Proin fringilla.</p>
<ul>
	<li><span>Proin dictum nulla vitae magna.</span></li>
	<li><span>Donec sollicitudin ipsum sed felis.</span></li>
	<li><span>Morbi lectus felis, consectetuer nec.</span></li>
</ul>
 <p>Cras eget urna id eros egestas aliquam. Pellentesque vitae lacus. Cras lacus.</p>
<ol>
	<li><span>Proin dictum nulla vitae magna.</span></li>
	<li><span>Donec sollicitudin ipsum sed felis.</span></li>
	<li><span>Morbi lectus felis, consectetuer nec.</span></li>
</ol>
<p>Nulla sit amet pede quis est porttitor varius. Ut a nisi a mauris dignissim vehicula. Suspendisse potenti. In viverra. Ut at 
metus. Cras bibendum nulla ut risus. Vivamus luctus pulvinar pede. Ut dignissim, mi eget pretium euismod, ligula est tincidunt erat,
 nec euismod augue leo non nunc. Fusce risus. Nunc libero augue, ornare in, convallis et, iaculis a, diam. Pellentesque pretium pede sit amet neque. Vestibulum nibh.</p>')
);

?>