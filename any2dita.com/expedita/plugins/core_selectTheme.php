<?php

$currentCat = 'DITA';

// this file takes care of uiselectViews in old system.


register_filter("get_themes", "get_collection_themes");

function get_collection_themes($query='*') {
	global $themesOffset, $themesDir, $themeName;
	// Gets a list of groups in the application's repository
	$i = 0; $result = array(); 
	$dir = dir($themesOffset.$themesDir);
	// For every theme directory in the Themes path...
	while(false !== ($entry = $dir->read())) 	{
		// look at directory names only
		if ( strpos($entry,'.') === false ) {
			//  test each entry to keep current the default
			if ($entry == $themeName) {
				$sel = ' selected="selected"';
			} else {
				$sel = '';
			}
			$text = str_replace("_", " ", $entry);
			//echo "<option value='$entry' $sel>$text</option>"; 
			$row['entry'] = $entry;
			$row['sel'] = $sel;
			$row['title'] = $text; // allows for common sort handle
			$result[$i] = $row;
			$i++;
		}
	}
	if (sizeof($result) > 0) {
		usort($result, "sort_ascending");
	}
	return $result;
}


// leftover model request interfaces not supported in file mode yet
// Normally called as part of the 404 page response.
function button_addNewTopic($groupName, $mapName, $xmlfn) {
	// Note that $mapName is normally undefined where users might request a page (ie, bad link recovery),
	// but the call allows the value just in case this CAN be passed a known map context.
	// We know WHAT this resource is because $xmlfn has an extension (.dita, .ditamap, etc.)
	$desc = 'For contexts where a URL represents a resource that is not yet extant, expose this button to suggest creating a resource to match that request.';
?>
	<form action='<?php echo htmlentities($_SERVER['PHP_SELF']); ?>' method='post' style="display:inline">
	<input type='hidden' name='forGroup' value='<?php echo $groupName; ?>' />
	<input type='hidden' name='forMap' value='<?php echo $mapName; ?>' />
	<input type='hidden' name='resourceName' value='<?php echo $xmlfn; ?>' />
	<input type='hidden' name='topicType' value='concept' /><!-- for now -->
	<input type='submit' name='add-page' value='Add a New Page'/>
	</form>
<?php
}


function postButtons($items) {
	$z = explode(',',$items);
	foreach($z as $button) {
		switch($button) {
			case 'more':
				hook_action('listen_readmore');
				break;
			case 'comments':
				hook_action('listen_comment');
				break;
			
		}
	}
}

function postMappedResource() {
	echo 'You\'ve won the Internet! Consolation prize: <a href="http://tinyurl.com/jotsom-dita-without-tears">Jotsom How-to Guide</a>.';
	//addnew_form();
	?>
<form onsubmit="return confirm('Return to Jotsom?');">
    <input type="hidden" name="reset" value="reset"/>
    <input type="submit" value="Home"/>
</form>
<?php
}

// usable only for DB-based fetche...?
function showAuthors() {
	global $db, $currentAuthor;
	$hits = hook_filter('get_authors','*');
	// Note:  the class values are from themes. sidemenu is from SimpleBlog11
?>
	<ul class="sidemenu">
	 	<?php foreach($hits as $authName): ?>
			<li<?php  if ($authName == $currentAuthor) { echo ' class="active"'; }?>>
				<a href="?author=<?php echo $authName;?>">
					<?php echo $authName;?><?php //if ($authName == $currentAuthor) { echo ' (current)'; } ?>
				</a>
			</li>
		<?php endforeach; ?>
	</ul>
<?php
}

function showCategories() {
	global $db, $currentCat;
	$hits = hook_filter('get_categories','*');
?>
	<ul class="sidemenu">
	 	<?php foreach($hits as $catName): ?>
			<li<?php  if ($catName == $currentCat) { echo ' class="active"'; }?>>
				<a href="?category=<?php echo $catName;?>">
					<?php echo $catName;?><?php //if ($catName == $currentCat) { echo ' (current)'; } ?>
				</a>
			</li>
		<?php endforeach; ?>
	</ul>
<?php
}


register_filter('get_authors','getAuthors');

function getAuthors() {
	global $dbh, $msg;
	$query = 'SELECT DISTINCT author FROM posts';
	$resources = array('Grumpy','Bashful','Dopey','Sleepy','Happy','Sneezy','Doc');
	return $resources;
}


register_filter('get_categories','getCategories');

function getCategories() {
	global $dbh, $msg;
	$query = 'SELECT DISTINCT category FROM posts';
	$resources = array('DITA','Programming','Strategy');
	return $resources;
}

register_action('select_category','selectCategory');

function selectCategory() {
	global $db, $currentCat, $canonicalURL;
	//if ($currentCat == '') {$currentCat = '*';}
	$hits = hook_filter('get_categories','*');
	// style="display:inline!important;margin-bottom:0"
	ob_start();
	?>
	<form action="<?php echo $canonicalURL;?>" method="get"> 
	<select  name="category" onChange="this.form.submit();" >
		<option value="<?php echo $currentCat; ?>" selected="selected"><?php echo $currentCat; ?></option>
		<optgroup label="----------------"></optgroup>
			<option value='*'>*</option>
	 	<?php foreach($hits as $catName): ?>
			<option value='<?php echo $catName;?>'><?php echo $catName;?></option>
		<?php endforeach; ?>
	</select> 
	</form> 
	<?php
	$content = ob_get_contents();
	ob_end_clean();
	echo $content;
}



/* Usable for basic expeDITA function (not db-dependent) */

register_action('select_theme','selectTheme');

function selectTheme() {
	global $themeName, $canonicalURL;
	$hits = hook_filter('get_themes','*');
		//echo 'IN SELECTTHEME: <br/>';exit;

	// Hook to get the config overrides for this group
	ob_start();
	?>
	<form class="singlelineform" action="<?php echo $canonicalURL;?>" method="get"> 
	<select name="themeName" id="selecttheme" onChange="this.form.submit();">
		<option value="<?php echo $themeName; ?>" selected="selected"><?php echo $themeName; ?></option>
		<optgroup label="----------------"></optgroup>
		<?php foreach($hits as $theme):?>
			<option value='<?php echo $theme['entry'];?>' <?php echo $theme['sel'];?>><?php echo $theme['title'];?></option>
		<?php endforeach;?>
	</select> 
	</form> 
	<?php
	$content = ob_get_contents();
	ob_end_clean();
	echo $content;
}


register_action('select_xtype','selectXType');

function selectXType() {
global $xType, $canonicalURL;
	// Hook to get the config overrides for this group
	ob_start();
	?>
	<form class="singlelineform" action="<?php echo $canonicalURL;?>" method="get"> 
	<select name="xType" id="selectxtype" onChange="this.form.submit();">
		<option value="<?php echo $xType; ?>" selected="selected"><?php echo $xType; ?></option>
		<optgroup label="----------------"></optgroup>
		<optgroup label="Applies to any type:"></optgroup>
		<option value='post'>Post (normal)</option>
		<option value='html'>HTML</option>
		<option value='text'>Text</option>
		<option value='xml'>XML</option>
		<option value='json'>JSON</option>
		<!-- other xtype ops depend on other form values being present, such as groupsearch.-->
		<!--
		<option value='ooxml'>OOXML</option>
		<optgroup label="Map-specific:"></optgroup>
		<option value='all'>Map Aggregate view</option>
		<option value='html'>Map ToC view</option>
		<option value='omanual'>oManual</option>
		<option value='header'>header</option>
		<option value='opml'>OPML</option>
		<option value='mar'>Map Archive</option>
		<option value='zip'>Zip</option>
		<option value='nodebody'>Node Body</option>
		<option value='maplist'>Map List</option>
		<option value='single'>Single</option>
		-->
	</select> 
	</form> 
	<?php	
	$content = ob_get_contents();
	ob_end_clean();
	echo $content;
}


register_action('select_editor','selectEditor');

function selectEditor() {
global $editorName, $canonicalURL;
	// Hook to get the config overrides for this group
	ob_start();
	?>
	<form class="singlelineform" action="<?php echo $canonicalURL;?>" method="get"> 
	<select name="editorName" id="selecteditor" onChange="this.form.submit();">
		<option value="<?php echo $editorName; ?>" selected="selected"><?php echo $editorName; ?></option>
		<optgroup label="----------------"></optgroup>
		<option value='text'>Text</option>
		<option value='code'>Code</option>
		<option value='nestedSortable'>DnD maps (demo)</option>
		<!--
		<optgroup label="--not integrated yet--"></optgroup>
		<option value='richtext'>Rich Text--Mozilla</option>
		<option value='whizzy'>Rich Text--Whizzywig</option>
		<option value='OxygenWeb'>Web-oXygen</option>
		<option value='XMLed'>XMLed (demo)</option>
		-->
		<option value='form'>Form for Task (demo)</option>
		<option value='tryedit'>Form for All (demo)</option>
		<!-- Others to patch in as possible
		<option value='DITAStormSE'>Web-DITA Storm SE</option>
		<option value='DITAStorm'>Web-DITA Storm</option>
		<option value='Speck'>Rich Text (SpeckEditor)</option>
		<option value='Xopus'>Web-Xopus</option>
		<option value='DITA Exchange'>DITA Exchange</option>
		<option value='SimplyXML'>Simply XML</option>
		<option value='QuarkXMLAuthor'>Quark XML Author</option>
		-->
	</select> 
	</form> 
	<?php	
	$content = ob_get_contents();
	ob_end_clean();
	echo $content;
}

register_action('select_ditaval','selectDitavalProp');

// reserve this for more definitive DITAval prop construction (actual att/val/action/startflag/etc values)
function selectDitavalProp() {
	ob_start();
	?>
	<p>Select ditaval property file.</p>
	<?php	
	$content = ob_get_contents();
	ob_end_clean();
	echo $content;
}



register_action('select_groupform','selectGroupForm');

// In practice, this should be exposed only for Site Admin users due to sensitivity of group wishes.
// An ACL rule would render this only for 'siteadmin' role or be relaxed for sites with open sharing policies.
function selectGroupForm() {
	global $groupName, $mapName,$contentDir, $canonicalURL;
	ob_start();
	?>selectGroupForm:
	<form class="singlelineform" action="<?php echo $canonicalURL;?>" method="get"> 
	<select name="groupName" id="idlselect" onChange="this.form.submit();">
		<option value="<?php echo $groupName; ?>" selected="selected"><?php echo $groupName; ?></option>
		<optgroup label="----------------"></optgroup>
<?php
	// 	<option value="">Select...</option>
	// Search for all the groups in the content directory
	$d = dir("../$contentDir/");
	// For every group directory in the content path...
	while(false !== ($entry = $d->read())) 	{
		$isMeta = strpos($entry,'.');
		// look at directory names only
		if( $isMeta === false  )
		{
			//  test each entry to keep current the default
			if ($entry == $groupName) {
				$sel = 'selected="selected"';
			} else {
				$sel = '';
			}
			$text = str_replace("_", " ", $entry);
			echo "<option value='$entry' $sel>$text</option>"; 
		}
	}
?>
	</select> 
	</form> 
	<?php	
	$content = ob_get_contents();
	ob_end_clean();
	echo $content;
}

register_action('select_mapform','selectMapForm');

function selectMapForm() {
	global $groupName, $mapName, $contentDir, $canonicalURL;
	ob_start();
	?>selectMapForm:
	<form  class="singlelineform" action="<?php echo $canonicalURL;?>" method="get"> 
	<!--select name="jumpmenu" onChange="jumpto(document.form1.jumpmenu.options[document.form1.jumpmenu.options.selectedIndex].value)"-->
		<!--option>Jump to...</option-->
	<select name="group" id="mapselect" onChange="this.form.submit();" >
		<option value="<?php echo $groupName; ?>" selected="selected"><?php echo $groupName; ?></option>
		<optgroup label="----------------"></optgroup>
<?php
	// Query for all the maps in the current group (DRD: his function needs to be added)
	$searchpattern = contentPath()."*.ditamap";
	$views = glob($searchpattern);
	// Trim the data in the array to just the filename alone per entry, and sort it
	// Sort list of discovered map files
	sort($views,SORT_STRING);
	// Now build the option list.
	// For every .ditamap file...
	$thisMap = $mapName.".ditamap";
	foreach ($views as &$entry) {
		if(substr($entry,0,1) != '-')
		{
			//  test each entry to keep current the default
			//echo "Map comparing: $thisMap to $entry.<br/>";
			if ($entry == $thisMap) {
				$sel = ' selected="selected"';
			} else {
				$sel = '';
			}
			$text = str_replace("_", " ", $entry);
			echo "<option value='$entry' $sel>$text</option>"; 
		}
	}
?>
	</select> 
	</form> 
	<?php	
	$content = ob_get_contents();
	ob_end_clean();
	echo $content;
}

register_action('select_folderform','selectFolderForm');

function selectFolderForm() {
	global $groupName, $mapName,$contentDir, $canonicalURL,$folderName;
	ob_start();
	?>selectFolderForm:
	<form class="singlelineform" action="<?php echo $canonicalURL;?>" method="get"> 
	<select name="folderName" id="idlselect" onChange="this.form.submit();">
		<option value="<?php echo $folderName; ?>" selected="selected"><?php echo $folderName; ?></option>
		<optgroup label="----------------"></optgroup>
<?php
	// 	<option value="">Select...</option>
	// Search for all the groups in the content directory
	$d = dir("$contentDir/$groupName");
	// For every group directory in the content path...
	while(false !== ($entry = $d->read())) 	{
		// look at directory names only
		if( strpos($entry,'.') === false  ) {
			if( !($entry[0] == '_') ) {
				//  test each entry to keep current the default
				if ($entry == $folderName) {
					$sel = 'selected="selected"';
				} else {
					$sel = '';
				}
				$text = str_replace("_", " ", $entry);
				echo "<option value='$entry' $sel>$text</option>"; 
			}
		}
	}
	echo "<option value=''>./ (root)</option>"; 
?>
	</select> 
	</form> 
	<?php	
	$content = ob_get_contents();
	ob_end_clean();
	echo $content;
}

/* unfixed as yet */



/* formats for collections -- with pagination */

function listCollectionAsList($data) {
?>
<ul>
<?php foreach ($data as $row): ?>
	<li><a id="<?php echo $row['id'];?>" href="<?php echo $row['slug'];?>"><?php echo $row['title'];?></a></li>
<?php endforeach;?>
</ul>
<?php
}

function listCollectionAsDump($data) {
var_dump($data);
}

function listCollectionAsTable($data) {
?>
<table border="1">
<?php foreach ($data as $row): ?>
	<tr>
	<td><a id="<?php echo $row['id'];?>" href="<?php echo $row['slug'];?>"><?php echo $row['title'];?></a></td>
	</tr>
<?php endforeach;?>
</table>
<?php
}


?>