<?php
// functions for editor/transform manipulation of save stream


// use logic to wrap these around a new image: http://html5doctor.com/the-figure-figcaption-elements/
function transformHTML($instr, $taglist, $xslFile, $prefix="xform") {
	global $a2dxsl, $targ_path, $fullpath, $imglist;
	/*
	echo '<h3>As passed into transfromHTML:</h3>';
	echo $instr;
	echo '<pre>';
	echo htmlentities($instr);
	echo '</pre>';
	//*/
	
	// for now, a dummy variable emulating a global that we expect in later transforms
	$resourceName = 'ResourceName';
	
	/* ======================== Neuter characters that don't transition through PHP nicely ==================== */
	// Note: These replacements occur across markup as well as pcdata, but are typically only in markup. Nevertheless, watch for trouble.
	// First: Disable smart punctuation and single characters in troublesome codepoints by placing into shortcode syntax
	$instr = str_replace('’',			"'",			$instr);
	$instr = str_replace('“',			'"',			$instr);
	$instr = str_replace('”',			'"',			$instr);
	$instr = str_replace("&#x20;",		' ',			$instr);
	$instr = str_replace('“',			'"',			$instr);
	$instr = str_replace('”',			'"',			$instr);
	// Neuter any symbols that DOM processing might literalize (to be restored after processing).
	$instr = str_replace('&lt;',		'[symname:lt]',			$instr); 
	$instr = str_replace('&gt;',		'[symname:gt]',			$instr);
	$instr = str_replace('&semi;',		'[symname:semi]',		$instr); 
	$instr = str_replace('&apos;',		'[symname:apos]',		$instr); 

	// common HTML symbols
	$instr = str_replace("<p>&nbsp;</p>",		'',				$instr); // remove empty paragraphs on input
	$instr = str_replace('&quot;',		'[symname:quot]',		$instr); 
	$instr = str_replace('&nbsp;',		'[symname:nbsp]',		$instr); 
	$instr = str_replace('&ndash;',		'[symname:ndash]',		$instr);


	// Finally: Neuter and unicodize any literals that can cause problems (must be after the representational symbols)
	// trade
	$instr = str_replace('&trade;',		'[symname:trade]',		$instr); // named
	$instr = str_replace('&#x2122;',	'[symname:trade]',		$instr); // charent
	$instr = str_replace('™',			'[symname:trade]',		$instr); // glyph
	// reg
	$instr = str_replace('&reg;',		'[symname:reg]',		$instr); // named
	$instr = str_replace('&#xAE;',		'[symname:reg]',		$instr); // charent
	$instr = str_replace('®', 			'[symname:reg]',		$instr); // glyph
	// copy
	$instr = str_replace('&copy;',		'[symname:copy]',		$instr); // named
	$instr = str_replace('&#xA9;',		'[symname:copy]',		$instr); // charent
	$instr = str_replace('©',			'[symname:copy]',		$instr); // glyph
	
	// others (char only--need expanded)
	$instr = str_replace('&#8220;',		'[symname:ldquo]',		$instr); // charent
	$instr = str_replace('&#8221;',		'[symname:rdquo]',		$instr); // charent
	$instr = str_replace('&lsquo;',		'[symname:lsquo]',		$instr); // named
	$instr = str_replace('&rsquo;',		'[symname:rsquo]',		$instr); // named
	$instr = str_replace('&ldquo;',		'[symname:ldquo]',		$instr); // named
	$instr = str_replace('&rdquo;',		'[symname:rdquo]',		$instr); // named
	$instr = str_replace('«',			'[symname:laquo]',		$instr); // glyph
	$instr = str_replace('»',			'[symname:raquo]',		$instr); // glyph
	$instr = str_replace('€',			'[symname:euro]',		$instr); // glyph

	// Neuter known hex sequences
	$instr = str_replace("\xE28094",	"[symname:emdash]", 	$instr);
	$instr = str_replace("\x97206973",	"[symname:emdash]", 	$instr);
	
	// truly last minute changes for word leftovers
	$wobj = pack("H*" , 'EFBFBC');
	$instr = str_replace($wobj,      '[#xEFBFBC]', $instr); // EFBFBC (word 'obj' key
	$CRLF = "\r\n";
	//$instr = str_replace($CRLF,		'[asciiname:CRLF]',		$instr); // carriage return/line 
	
	/* ====== Process for shortcodes before sending content on through ====== */
	// Plan: convert shortcoded section into XML processing instruction syntax; 
	// 		use dedicated templates to process each code independently.
	// Note: this is squirrelly because the braces could occur within or span across markup.
	while (strpos($instr, '{code') != 0) {
		//$innerCode = GetBetween($instr, '{', '}');
		$instr = str_replace('{code_end}',				'</pre>',		$instr);
		$instr = str_replace('{code_start}',			'<pre>',		$instr);
		//$instr = str_replace('}</p>',			'? >',		$instr);
		//$instr = str_replace('<p>{',			'< ?',		$instr); // remove surrounding para context if present
		//$instr = str_replace('}',			'? >',		$instr);
		//$instr = str_replace('{',			'< ?',		$instr); // get any remaining pairs
	}
	// convert all remaining shortcode wrappers to a proper element wrapper so we can parse them.
	$instr = preg_replace('/{([^{}]*)}/', "<shortcode>$1</shortcode>", $instr);
	// Can we also parse off the first token as a spanned element:
	// <shortcode><cmd>$1</cmd>$2</shortcode> 
	
	// Add an outer container to ensure a single document element. Hint at character set for DOMDocument's awareness.
	$symname = generateID($prefix);
	$instr = "<html name='$symname'><head><meta http-equiv='Content-type' content='text/html; charset=UTF-8' /></head><body>$instr</body></html>";
	$cmsversion = $instr;
	//file_put_contents('temp.html', $cmsversion);

	/* ======================== Clean the markup through XSLT transforms (cleaner than regex & dom) ==================== */

	// create an XSLT processor and load the stylesheet as a DOM 
	// NOTE: regarding use of HTML as input to XMLish DOM ops, see 
	//     http://devzone.zend.com/1538/php-dom-xml-extension-encoding-processing/

	// Group the nodes between named headings as nested blocks
	// http://stackoverflow.com/questions/10683421/wrap-segments-of-html-with-divs-and-generate-table-of-contents-from-html-tags
	$xml = new DOMDocument;
	$xml->encoding = 'UTF-8'; // make this explicit; PHP DOM is not consistent on input
	libxml_use_internal_errors(true); //set as 'true' to prevent warning messages from displaying because of the bad HTML
	$xml->loadHTML($instr);
	libxml_clear_errors();
	
	$pane = null;

/*
	// Bound the scope indicated by each li in li
	foreach ($xml->getElementsByTagName('li') as $hd) {
	    $pane_nodes = array($hd);
	    for ($next = $hd->nextSibling; $next && (strpos(' li ul ol ', $next->nodeName) == 0); $next = $next->nextSibling) {
	        $pane_nodes[] = $next;
	    }
	    $pane = $xml->createElement('sl');
		$symname = generateID($prefix);
	    $hd->parentNode->replaceChild($pane, $hd);
	    foreach ($pane_nodes as $node) {
	        $pane->appendChild($node);
	    }
	}
*/

	// Bound the scope indicated by each h6
	foreach ($xml->getElementsByTagName('h6') as $hd) {
	    $pane_nodes = array($hd);
	    for ($next = $hd->nextSibling; $next && (strpos(' h1 h2 h3 h4 h5 h6', $next->nodeName) == 0); $next = $next->nextSibling) {
	        $pane_nodes[] = $next;
	    }
	    $pane = $xml->createElement('prototopic');
		$symname = generateID($prefix);
	    $pane->setAttribute('id', $symname);
	    $pane->setAttribute('level', '6');
	    $hd->parentNode->replaceChild($pane, $hd);
	    foreach ($pane_nodes as $node) {
	        $pane->appendChild($node);
	    }
	}

	// Bound the scope indicated by each h5
	foreach ($xml->getElementsByTagName('h5') as $hd) {
	    $pane_nodes = array($hd);
	    for ($next = $hd->nextSibling; $next && (strpos(' h1 h2 h3 h4 h5 h6', $next->nodeName) == 0); $next = $next->nextSibling) {
	        $pane_nodes[] = $next;
	    }
	    $pane = $xml->createElement('prototopic');
		$symname = generateID($prefix);
	    $pane->setAttribute('id', $symname);
	    $pane->setAttribute('level', '5');
	    $hd->parentNode->replaceChild($pane, $hd);
	    foreach ($pane_nodes as $node) {
	        $pane->appendChild($node);
	    }
	}

	// Bound the scope indicated by each h4
	foreach ($xml->getElementsByTagName('h4') as $hd) {
	    $pane_nodes = array($hd);
	    for ($next = $hd->nextSibling; $next && (strpos(' h1 h2 h3 h4 h5 h6', $next->nodeName) == 0); $next = $next->nextSibling) {
	        $pane_nodes[] = $next;
	    }
	    $pane = $xml->createElement('prototopic');
		$symname = generateID($prefix);
	    $pane->setAttribute('id', $symname);
	    $pane->setAttribute('level', '4');
	    $hd->parentNode->replaceChild($pane, $hd);
	    foreach ($pane_nodes as $node) {
	        $pane->appendChild($node);
	    }
	}

	// Bound the scope indicated by each h3
	foreach ($xml->getElementsByTagName('h3') as $hd) {
	    $pane_nodes = array($hd);
	    for ($next = $hd->nextSibling; $next && (strpos(' h1 h2 h3 h4 h5 h6', $next->nodeName) == 0); $next = $next->nextSibling) {
	        $pane_nodes[] = $next;
	    }
	    $pane = $xml->createElement('prototopic');
		$symname = generateID($prefix);
	    $pane->setAttribute('id', $symname);
	    $pane->setAttribute('level', '3');
	    $hd->parentNode->replaceChild($pane, $hd);
	    foreach ($pane_nodes as $node) {
	        $pane->appendChild($node);
	    }
	}

	// Bound the scope indicated by each h2
	foreach ($xml->getElementsByTagName('h2') as $hd) {
	    $pane_nodes = array($hd);
	    for ($next = $hd->nextSibling; $next && (strpos(' h1 h2 h3 h4 h5 h6', $next->nodeName) == 0); $next = $next->nextSibling) {
	        $pane_nodes[] = $next;
	    }
	    $pane = $xml->createElement('prototopic');
		$symname = generateID($prefix); // pass a prefix value; use the return as both id and filename
	    $pane->setAttribute('id', $symname);
	    $pane->setAttribute('level', '2');
	    //$pane->setAttribute('title', $hd->nodeValue);
	    $hd->parentNode->replaceChild($pane, $hd);
	    foreach ($pane_nodes as $node) {
	        $pane->appendChild($node);
	    }
	}

	// Bound the scope indicated by each h1
	foreach ($xml->getElementsByTagName('h1') as $hd) {
	    // first collect all nodes
	    $pane_nodes = array($hd);
	    // iterate until another h1 or no more siblings
	    for ($next = $hd->nextSibling; $next && strpos(' h1 h3 h3 h4 h5 h6', $next->nodeName) == 0; $next = $next->nextSibling) {
	        $pane_nodes[] = $next;
	    }
	    // create the wrapper node
	    $pane = $xml->createElement('prototopic');
		$symname = generateID($prefix); // pass a prefix value; use the return as both id and filename
	    $pane->setAttribute('id', $symname);
	    $pane->setAttribute('level', '1');
	    // replace the h1 with the new pane
	    $hd->parentNode->replaceChild($pane, $hd);
	    // and move all nodes into the newly created pane
	    foreach ($pane_nodes as $node) {
	        $pane->appendChild($node);
	    }
	}

	//$tag = $xml->getElementsByTagName('topic')->item(0);
	//foreach ($tag->childNodes as $child){ $innerbody->appendChild($innerbody->importNode($child, true)); }

	// Use this DOM opportunity to loop through and retrieve all images into staging folder
	// Actually, since the html file is local or pasted, we have no real access to the image resource. Hmmm...
	// OK, for now, collect the names in array $imglist and report it at the end.
	$images = $xml->getElementsByTagName('img'); 
	foreach ($images as $image) {
		// http://stackoverflow.com/questions/724391/saving-image-from-php-url
	    $srcfile = $image->getAttribute('src');
	    $imglist[] = $fullpath.'/'.ltrim($srcfile,'/');
	    //$url = ''.$srcfile;
		//$file= file($url);
		//file_put_contents($fullpath.'/'.$targ_path.'/'.$srcfile, $file);
		// http://daringfireball.net/graphics/markdown/mt_textformat_menu.png
 	}


	// Now wrap each topic (albeit nested) with a topicref
	foreach ($xml->getElementsByTagName('prototopic') as $topic) {
	    // query the id from the topic to use as the filename
		$symname = $topic->getAttribute('id');
	    // first collect all nodes
	    $pane_nodes = array($topic);
	    // iterate until another h1 or no more siblings
	    for ($next = $topic->nextSibling; $next && strpos(' prototopic', $next->nodeName) == 0; $next = $next->nextSibling) {
	        $pane_nodes[] = $next;
	    }
	
	    // create the wrapper node
	    $pane = $xml->createElement('topicref');
	    //$pane->setAttribute('navtitle', $topicref->nodeValue);
	    $pane->setAttribute('href', $symname.'.dita');
		$symlevel = $topic->getAttribute('level');
	    $pane->setAttribute('level', $symlevel);
	
	    // replace the h1 with the new pane
	    $topic->parentNode->replaceChild($pane, $topic);
	    // and move all nodes into the newly created pane
	    foreach ($pane_nodes as $node) {
	        $pane->appendChild($node);
	    }
	}


	/*
	echo '<h3>After adding DITA-compatible section wrappers:</h3>';
	//echo "<h4>(segments: ".implode(",", $segments).")</h4>";
	echo '<tt>';
	echo htmlentities($xml->saveXML());
	echo '</tt>';
	//exit;
	//*/


//	$instr = $xml->saveHTML(); //save our modified string for a second pass, now through DOMDocument



	// Now relaod it for the transformToXML pass (should be able to pipe the existing DOM object through)
//	$xml = new DOMDocument(); 
//	$xml->encoding = 'UTF-8'; // make this explicit; PHP DOM is not consistent on input
//	$xml->loadHTML($instr); // parse the wild (non-XHTML) HTML DOM as well-formed
	// could actually do the above grouping here
	$domxp = new DOMXPath($xml);
	$xml->loadXML($xml->saveXML()); // uplift the HTML DOM to XML DOM

//	$items = $domxp->query('//p/p'); foreach ($items as $item) {renameElement($item, 'b');}
//echo "xslFile: $xslFile<br/>";exit;
//echo $a2dxsl.$xslFile.':'.file_exists($a2dxsl.'html2mid.xsl').'<br/>';

	$xslt = new DOMDocument(); 
	$xslt->load($xslFile, LIBXML_ERR_ERROR ); 
	$xproc = new XSLTProcessor(); 
		$xproc->setParameter('', 'h2>AttributesNamed', "'|style|'"); 
	$xproc->importStylesheet( $xslt ); 


	$instr = $xproc->transformToXML($xml );  // this produces our "DITA fragment" string.
	
	// Something has introduced spurious RE symbols into the stream, perhaps via loadHTML's normalization.
	// Ideally this should be fixed in allowed content nodes, not whitespace-respecting nodes.
	//$instr = str_replace('&#13;',   '', $instr); // \n
	$instr = str_replace('&#13;',     "\r\n",       $instr);
	
	/*
	echo '<h3>After DOM-based xslt transform:</h3>';
	echo '<pre>';
	echo htmlentities($instr);
	echo '</pre>';
	//exit;
	//*/
	
	/* ======================== Revert the neutered characters back to symbols (not literals) ==================== */

	// Return these back to legitimate Unicode character entities for save stream.
	$instr = str_replace('[symname:apos]',		'&apos;',	$instr); 
	$instr = str_replace('[symname:semi]',		'&semi;',	$instr); 
	$instr = str_replace('[symname:lt]',		'&lt;',		$instr); 
	$instr = str_replace('[symname:gt]',		'&gt;',		$instr);

	$instr = str_replace('[symname:emdash]',	'&#x2014;',		$instr);
	$instr = str_replace('[symname:nbsp]',		'&#x20;',		$instr); 
	$instr = str_replace('[symname:ndash]',		'&#x2013;',		$instr);
	$instr = str_replace('[symname:trade]',		'&#x2122;',		$instr);
	$instr = str_replace('[symname:reg]',		'&#xAE;',		$instr);
	$instr = str_replace('[symname:copy]',		'&#xA9;',		$instr);
	$instr = str_replace('[symname:laquo]',		'&#171;',		$instr); 
	$instr = str_replace('[symname:raquo]',		'&#187;',		$instr);
	$instr = str_replace('[symname:lsquo]',		'&#x2018;',		$instr);
	$instr = str_replace('[symname:rsquo]',		'&#x2019;',		$instr);
	$instr = str_replace('[symname:ldquo]',		'&#x201C;',		$instr);
	$instr = str_replace('[symname:rdquo]',		'&#x201D;',		$instr);
	$instr = str_replace('[symname:euro]',		'&#x20AC;',		$instr); // euro
	//$instr = str_replace('&#13;',    '', $instr); // line break (oops, don't take out PRE usage)
	
	// Run some "just in case" exit cleanups (this is an ongoing list--add to it as needed)
	$instr = str_replace('&Acirc;',		'\x20',      $instr); //
	$instr = str_replace('&acirc;',		'\x20',      $instr); //
	$instr = str_replace('&oelig;',		'&#x0153;',  $instr);
	$instr = str_replace('[#x0D0A]', 	"\r\n",       $instr);

	// remove any remaining non-wanted markup (this may be no longer needful if the xslt handled things properly)
	//$instr = strip_tags($instr, $taglist); // finally, remove everything NOT in the $tagslist parameter (allow only valid DITA tags)
	
	/*
	echo '<h3>After final character transpositions</h3>';
	echo '<pre>';
	echo htmlentities($instr);
	echo '</pre>';
	//exit;
	//*/
	return $instr;
}


/* ========================== transform utilities ================================ */

function generateId($prefix='generated') {
	$arr = str_split('ABCDEFGHIJKLMNOPQRSTUVWXYZ'); // character options for constructed name
	shuffle($arr); // randomize the array
	$arr = array_slice($arr, 0, 6); // get the first six (random) characters out
	return $prefix.'_'.implode('', $arr);
}

// DOM/xpath method. Changes the name of element $element to $newName. http://php.net/manual/en/class.domelement.php
function renameElement($element, $newName) {
  $newElement = $element->ownerDocument->createElement($newName);
  $parentElement = $element->parentNode;
  $parentElement->insertBefore($newElement, $element);

  $childNodes = $element->childNodes;
  while ($childNodes->length > 0) {
    $newElement->appendChild($childNodes->item(0));
  }

  $attributes = $element->attributes;
  while ($attributes->length > 0) {
    $attribute = $attributes->item(0);
    if (!is_null($attribute->namespaceURI)) {
      $newElement->setAttributeNS('http://www.w3.org/2000/xmlns/',
                                  'xmlns:'.$attribute->prefix,
                                  $attribute->namespaceURI);
    }
    $newElement->setAttributeNode($attribute);
  }

  $parentElement->removeChild($element);
}


function contains($substring, $string) {
	if(strpos($string, $substring) === false) {
		return false;
	} else {
		return true;
	}
}


//<img class="aligncenter" alt="portrait photo of Don Day" src="http://conteldyn.com/Content/content/images/About-Don-Day%20206%20px.png" />
//  style="margin: 10px auto 1.625em; clear: both; display: block; border: 1px solid rgb(221, 221, 221); padding: 6px; max-width: 97.5%; height: auto;"

// http://ditio.net/2008/11/04/php-string-to-hex-and-hex-to-string-functions/
function hexToStr($hex)
{
    $string='';
    for ($i=0; $i < strlen($hex)-1; $i+=2)
    {
        $string .= chr(hexdec($hex[$i].$hex[$i+1]));
    }
    return $string;
}

//http://stackoverflow.com/questions/6694956/how-do-you-rename-a-tag-in-simplexml-through-a-dom-object

function cleanHTML_tidy($brokenHTML) {
	$dom = new DOMDocument;
	$dom->loadHTML($brokenHTML);
	foreach( $dom->getElementsByTagName("strong") as $pnode ) {
	    $divnode = $dom->createElement("b", $pnode->nodeValue);
	    $dom->appendChild($divnode, $pnode);
	}
	/*
	foreach( $dom->getElementsByTagName("em") as $pnode ) {
	    $divnode = $dom->createElement("i", $pnode->nodeValue);
	    $dom->replaceChild($divnode, $pnode);
	}
	*/
	return $dom->saveHTML();
}
