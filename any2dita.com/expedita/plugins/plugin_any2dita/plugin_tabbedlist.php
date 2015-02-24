<?php
//This plugin is launched by a call_user_func_args function so it needs to global in any vars normally in application scope.
global $appType;

// Not yet clear whether we need this. Placeholder only
register_action('template_init','a2d_themesetup');
function a2d_themesetup() {
}

register_action('stagedlist','list_staged');
function list_staged() {
	// Collection of staged folders
	$path = "STAGE/";
	echo '<h3>Collection of current staged folders</h3>';
	// Loop over all of the files in the folder
	foreach(glob($path ."*") as $stagename) {
		$zipdir = $stagename;
		foreach(glob($zipdir ."/*.ditamap") as $map) {
			echo "<a href=\"?tab=admin&xform={$map}\">$stagename</a><br/>";
		}
		//echo "<a href=\"?tab=admin&xform={$stagename}.ditamap\" target=\"_blank\">$stagename</a><br/>";
	}
}


// Conditionally test whether to load the any2dita plugin at all
if ($appType == 'any2dita') {

	// Provide necessary JS call on body element. This enables the tabbed list function.
	register_action('scripts_body_event','dobodyjs');
	
	function dobodyjs() {
		echo ' onload="init()"';
	}


	// Define the working interface for submitting content to migrate.
	register_action('xpd_cssjs','tabContent_styles'); // hook_action('xpd_cssjs');
	
	function tabContent_styles() {
	?>
	    <style type="text/css">
	      ul#tabs { list-style-type: none; margin: 30px 0 0 0; padding: 0 0 0.2em 0; } /*padding was 0 0 0.3em 0*/
	      ul#tabs li { display: inline; }
	      ul#tabs li a { color: #42454a; background-color: #dedbde; border: 1px solid #c9c3ba; border-bottom: none; padding: 0.3em; text-decoration: none; }
	      ul#tabs li a:hover { background-color: #f1f0ee; }
	      ul#tabs li a.selected { color: #000; background-color: #f1f0ee; font-weight: bold; padding: 0.7em 0.3em 0.38em 0.3em; }
	      div.tabContent { border: 1px solid #c9c3ba; padding: 0.5em; background-color: #f1f0ee; }
	      div.tabContent.hide { display: none; }
	    </style>
	
	    <script type="text/javascript">
	    //<![CDATA[
	
	    var tabLinks = new Array();
	    var contentDivs = new Array();
	
	    function init() {
	
	      // Grab the tab links and content divs from the page
	      var tabListItems = document.getElementById('tabs').childNodes;
	      for ( var i = 0; i < tabListItems.length; i++ ) {
	        if ( tabListItems[i].nodeName == "LI" ) {
	          var tabLink = getFirstChildWithTagName( tabListItems[i], 'A' );
	          var id = getHash( tabLink.getAttribute('href') );
	          tabLinks[id] = tabLink;
	          contentDivs[id] = document.getElementById( id );
	        }
	      }
	
	      // Assign onclick events to the tab links, and
	      // highlight the first tab
	      var i = 0;
	
	      for ( var id in tabLinks ) {
	        tabLinks[id].onclick = showTab;
	        tabLinks[id].onfocus = function() { this.blur() };
	        if ( i == 0 ) tabLinks[id].className = 'selected';
	        i++;
	      }
	
	      // Hide all content divs except the first
	      var i = 0;
	
	      for ( var id in contentDivs ) {
	        if ( i != 0 ) contentDivs[id].className = 'tabContent hide';
	        i++;
	      }
	    }
	
	    function showTab() {
	      var selectedId = getHash( this.getAttribute('href') );
	
	      // Highlight the selected tab, and dim all others.
	      // Also show the selected content div, and hide all others.
	      for ( var id in contentDivs ) {
	        if ( id == selectedId ) {
	          tabLinks[id].className = 'selected';
	          contentDivs[id].className = 'tabContent';
	        } else {
	          tabLinks[id].className = '';
	          contentDivs[id].className = 'tabContent hide';
	        }
	      }
	
	      // Stop the browser following the link
	      return false;
	    }
	
	    function getFirstChildWithTagName( element, tagName ) {
	      for ( var i = 0; i < element.childNodes.length; i++ ) {
	        if ( element.childNodes[i].nodeName == tagName ) return element.childNodes[i];
	      }
	    }
	
	    function getHash( url ) {
	      var hashPos = url.lastIndexOf ( '#' );
	      return url.substring( hashPos + 1 );
	    }
	
	    //]]>
	    </script>
		<script src="<?php echo vendorPath();?>Whizzy/whizzywing.js" type="text/javascript"></script>
	<?php
	}


	register_action('a2d_form','view_tabbed_forms'); // hook_action('a2d_form');
	
	function view_tabbed_forms() {
	global $outputpath, $sRtf, $sXml, $sMdn, $sWkm;// useful only if a reentrant editing mode is enabled, not currently supported.
	
	// Tab definitions, one per form:
	?>
	<ul id="tabs">
	  <li><a href="#htmlform">HTML</a></li>
	  <li><a href="#rtform">Rich Text</a></li>
	  <li><a href="#mdform">Markdown</a></li>
	  <li><a href="#wkform">Wikimedia</a></li>
	</ul>
	<?php
	
	// Forms, one per content type: (id must match to a tab above)
	?>
	<div class="tabContent" id="htmlform">
		<form method="post" action="">
			<p>Paste tagged HTML content here:</p>
			<textarea name="htmlin" style="height:200px;width:100%" rows='5' cols='60'
			><?php //echo $sXml;?></textarea>
			<!--
			<p><b>OR</b><br/>
			Paste URL of known HTML page: <br/>
			[(this field is still under construction; use paste above for now)]</p>
			-->
			<!--<input type="text" name="url" placeholder="URL"/>-->
			<input type="text" name="pagename" placeholder="output document name"/>
			<br/><input type="text" name="prefix" placeholder="output file 'namespace'"/>
			<br/><input type="text" name="topictype" placeholder="topic type (e.g., 'Lightweight DITA')"/>
			<br/><input name="htsub" type="submit" value="Migrate"/>
		</form>
	</div>
	
	<div class="tabContent" id="rtform">
		<form method="post" action="">
			<p>Paste Rich Text content here (e.g., the copied heading and text of a Web topic):</p>
			<p>(A good paste example: <a href="https://groups.drupal.org/node/457768">https://groups.drupal.org/node/457768</a>)</p>
			<textarea name="rtfin" class="WYSIWYG"
				title="block text left center right insert link image table source" 
				style="height:200px;width:100%" rows='5' cols='60'
				><?php echo $sRtf;?></textarea>
			<br/><input type="text" name="pagename" placeholder="output document name"/>
			<br/><input type="text" name="prefix" placeholder="output file 'namespace'"/>
			<br/><input type="text" name="topictype" placeholder="topic type (e.g., 'Lightweight DITA')"/>
			<br/><input  name="rtsub"type="submit" value="Migrate"/>
		</form>
	</div>
	
	<div class="tabContent" id="mdform">
		<form method="post" action="">
			<p>Paste markdown content here:</p>
			<p>(Markdown sample: <a href="http://daringfireball.net/projects/markdown/basics.text">daringfireball.net/projects/markdown/basics.text</a>)</p>
			<textarea name="mdin" style="height:200px;width:100%" rows='5' cols='60'
			><?php //echo $sMdn;?></textarea>
			<p><b>OR</b><br/>
			Paste URL of known Markdown page:</p>
			<p>(URL example: <b>http://daringfireball.net/projects/markdown/basics.text</b>}</p>
			<input type="text" name="url" placeholder="URL"/>
			<br/><input type="text" name="pagename" placeholder="output document name"/>
			<br/><input type="text" name="prefix" placeholder="output file 'namespace'"/>
			<br/><input type="text" name="topictype" placeholder="topic type (e.g., 'Lightweight DITA')"/>
			<br/><input name="mdsub" type="submit" value="Migrate"/>
		</form>
	</div>
	
	<div class="tabContent" id="wkform">
		<form method="post" action="">
			<p>Paste wikitext content here:</p>
			<textarea name="wkin" style="height:200px;width:100%" rows='5' cols='60'
			><?php //echo $sWkm;?></textarea>
			<p><b>OR</b><br/>
			Paste URL of known Mediawiki page</p>
			<input type="text" name="endpoint" placeholder="wiki endpoint"/> / <input type="text" name="pagename" placeholder="page name"/>
			<p>URL example: <b>http://www.mediawiki.org/wiki</b> /FAQ</p>
			<p>Page name example: http://www.mediawiki.org/wiki/ <b>FAQ</b></p>
			<input type="text" name="pagename" placeholder="output document name (page title)"/>
			<br/><input type="text" name="prefix" placeholder="output file 'namespace (up to 4 chars)'"/>
			<br/><input type="text" name="topictype" placeholder="topic type (e.g., 'Lightweight DITA')"/>
			<br/><input name="wksub" type="submit" value="Migrate"/>
		</form>
	</div>
	<?php
	}
}


?>