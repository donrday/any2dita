<?php

//$contentPath = contentPath();
//$themePath =  themePath();



register_filter('xform_xsl','ditaxform_default_xsl');
function ditaxform_default_xsl($junk) {
	$ixsl = pluginsPath().'dita-docs/stylesheet.xsl';
	return $ixsl;
}

//register_filter('xform_xsl','dita2html_xsl');
function dita2html_xsl($junk) {
	$ixsl = pluginsPath().'dita-docs/xsl/dita2html.xsl';
	return $ixsl;
}

//register_filter('xform_xsl','t2h_xsl');
function t2h_xsl($junk) {
	$ixsl = pluginsPath().'dita-docs/xsl/t2h.xsl';
	return $ixsl;
}

//register_filter('xform_xsl','ditaxform_raw_xsl');
function ditaxform_raw_xsl($junk) {
	$ixsl = pluginsPath().'dita-docs/xsl/paged-raw.xsl';
	return $ixsl;
}

//register_filter('xform_xsl','dita2opml_xsl');
function dita2opml_xsl($junk) {
	$ixsl = pluginsPath().'dita-docs/xsl/dita2opml.xsl';
	return $ixsl;
}


register_action('xform_init','ditaxform_init');

function ditaxform_init() {
	// set this ONLY if we need to
	if (getenv('XML_CATALOG_FILES') == '') {
		// Based on execution OS: Linux | WINNT |
		switch ( PHP_OS) {
			case 'Linux':
			case 'DARWIN':
				// For Linux, uncomment one of the following assignments and use whichever works.
				$xmlcatalogFile = INSTALL_OFFSET."../../../etc/xml/catalog";
				putenv('XML_CATALOG_FILES='.$xmlcatalogFile);
				//$_ENV['XML_CATALOG_FILES'] = $xmlcatalogFile;
				break;
			case 'WINNT':
				// For Windows, assign this path to the XML_CATALOG_FILES system variable under
				// the My Computer/Properties/Advanced settings and reboot.
				ob_start();
				echo 'The XML_CATALOG_FILES environment variable cannot be set dynamically in Windows.<br/>';
				echo ' It must be set via the Windows Advanced Environment settings.<br/>';
				echo 'After reboot, this script should continue running normally.<br/>';
				$output = ob_get_contents();
				ob_end_clean();	
				return $output;
				break;
			default:
				//Need to extend the OS use cases based on testing
				ob_start();
				echo 'Could not detect operating system for the application.';
				echo 'Please report the value "'.PHP_OS.'" to the developers.<br/>';
				$output = ob_get_contents();
				ob_end_clean();	
				return $output;
				break;
		}
	}
}


// XML DOCUMENT RENDITION FROM FILE:
register_action('xform','plugin_ditaxform'); // $outstream = hook_actxform_streamion('xform',$srcstream);

function plugin_ditaxform() {
	hook_action('xform_init');
	global $post;
	ob_start();
	if (isset($post->title)) { echo '<h4>'.$post->title.'</h4>';}
	echo setup_xform();
	$output = ob_get_contents();
	ob_end_clean();
	echo $output;
}

function setup_xform() {
	global $page, $list, $groupName, $post, $xmlfn;
	//echo "XFORM RECEIVED FILENAME: $xmlfn<br/>";
	$xmlstream = hook_filter('get_resource', ''); // this returns a stream for the specified resource.`

	$xsltfile = hook_filter('xform_xsl','');
	// Now we can retrieve the transformed result...
	// Note that we can hook alternate processors here, maybe based on xType or views/options
	$res = xpdXform($xmlstream,$xsltfile);
	return $res;
}



// XML DOCUMENT RENDITION FROM STREAM:
//register_filter('xform_stream','plugin_ditaxformstream'); // $outstream = hook_filter('xform_stream',$srcstream);
//register_filter('get_xformed','setup_xform');// $output = hook_filter('get_xform','filename.dita');
register_filter('get_xform','plugin_ditaxform_stream');

function plugin_ditaxform_stream($fn) {
	//register_filter('xform_xsl','ditaxform_raw_xsl'); // registering this function enables raw (styled) output)
	//register_filter('xform_xsl','t2h_xsl');
	hook_action('xform_init');
	$xmlstream = hook_filter('get_resource', ''); // this returns a stream for the specified resource.`
	$xsltfile = hook_filter('xform_xsl','');
	// Note that we can hook alternate processors here, maybe based on xType or views/options
	$res = xpdXform($xmlstream,$xsltfile);
	return $res;
}

function xpdXform($sXml, $sXsl='dita2html.xsl', $context='widget') { 
	global $serviceType, $outputpath, $outmapname, $prefix, $headlevel1, $classlevel1, $widgetlevel1, $widgetclass1, $htmltype,
			$showConrefMarkup, $GENERATEOUTLINENUMBERING, $SHOWTOPIC, $contentDir, $groupName, $queryType, $resourceName,$catenv,
			$contentSlug;

	//$fXml = $xmlfn;//.$ext;
	//$fullparent = contentPath().$fXml;
	//$storagepath = dirname(realpath($fullparent));
	//echo '<br/>Originator: '.$fullparent.'<br/>';
	$storagepath = $outputpath;

	//$content = file_get_contents($fullparent);
	//echo '<br/>'.$xmlfn.':'.$fullparent.': <br/>'.$fp.']<br/>';
//echo "\n sXml:[[$sXml]]<br/>";
//exit;
	
	$xml = new DOMDocument();
	//$xml->load($fullparent, LIBXML_DTDLOAD|LIBXML_DTDVALID|LIBXML_ERR_WARNING |LIBXML_DTDATTR);
    $xml->loadXml(         $sXml, LIBXML_DTDLOAD|LIBXML_DTDVALID|LIBXML_ERR_WARNING |LIBXML_DTDATTR);    
	$xsl = new DOMDocument;
	$xsl->load(xslPath().$sXsl, LIBXML_NOCDATA); 
	$proc = new XSLTProcessor(); 
	// exslt security off
	$proc->importStylesheet( $xsl ); 
		// unclassified
		//$up = wp_upload_dir();
		$up['baseurl'] = '..';
		$mediapath = $up['baseurl'] . '/';
		$proc->setParameter('', 'mediapath', $mediapath);
		$proc->setParameter('', 'outputpath', $outputpath);
		// run-time params
		$proc->setParameter('', 'SHOW-CONREFMARKUP', $showConrefMarkup);
		$proc->setParameter('', 'GENERATE-OUTLINE-NUMBERING', $GENERATEOUTLINENUMBERING);
		$proc->setParameter('', 'SHOW-TOPIC', $SHOWTOPIC);
		// router (segments and resource id
		$proc->setParameter('', 'serviceType', $serviceType); 
		$proc->setParameter('', 'queryType', $queryType); 
		$proc->setParameter('', 'resourceName', $resourceName); 
		$proc->setParameter('', 'contentSlug', $storagepath); // the current document's key for return links (and db fetch)
		// source paths and content contexts
		$proc->setParameter('', 'contentDir', $contentDir); 
		$proc->setParameter('', 'groupName', $groupName); 
		$proc->setParameter('', 'contentPath', contentPath());//$contentDir);//.'/'.$groupName);
		$proc->setParameter('', 'restPath', $groupName.'/'.$queryType.'/'.$resourceName); //may need to add serviceType...
		//$proc->setParameter('', 'contentFile', $fXml);  // $xmlfn.$ext - resolved filename in local storage
		$proc->setParameter('', 'contentFile', $resourceName.'.dita'); 
		$proc->setParameter('', 'themePath', 'Themes/'); 
		$proc->setParameter('', 'mapName', $resourceName);//$_SESSION['currentMap']); 
		// theme/style params
		$proc->setParameter('', 'htmltype', $htmltype); 
		$proc->setParameter('', 'prefix', $prefix);
			if ($context=='widget') {
				$proc->setParameter('', 'headlevel1', $widgetlevel1); 
				$proc->setParameter('', 'classlevel1', $widgetclass1); 
			} else {
				$proc->setParameter('', 'headlevel1', $headlevel1); 
				$proc->setParameter('', 'classlevel1', $classlevel1); 
			}
	$content = $proc->transformToXML($xml);
	// exslt security on
	return $content; 
} 




// XML DOCUMENT RENDITION FROM DOM object:
register_filter('get_xformdom','plugin_ditaxform_dom');

function plugin_ditaxform_dom($dom) {
	hook_action('xform_init');
	$xsltfile = hook_filter('xform_xsl','');
	$res = transformDomStream($dom,$xsltfile);
	return $res;
}

function transformDomStream($xml, $sXsl='dita2html.xsl', $context='widget') {
	global $serviceType, $outputpath, $outmapname, $prefix, $headlevel1, $classlevel1, $widgetlevel1, $widgetclass1, $htmltype,
			$showConrefMarkup, $GENERATEOUTLINENUMBERING, $SHOWTOPIC, $contentDir, $groupName, $queryType, $resourceName,$catenv,
			$contentSlug;

	$storagepath = $outputpath;
	
	//$xml = new DOMDocument();
	//$xml->load($fullparent, LIBXML_DTDLOAD|LIBXML_DTDVALID|LIBXML_ERR_WARNING |LIBXML_DTDATTR);
    //$xml->loadXml(         $sXml, LIBXML_DTDLOAD|LIBXML_DTDVALID|LIBXML_ERR_WARNING |LIBXML_DTDATTR);    
	$xsl = new DOMDocument;
	$xsl->load(xslPath().$sXsl, LIBXML_NOCDATA); 
	$proc = new XSLTProcessor(); 
	// exslt security off
	$proc->importStylesheet( $xsl ); 
		// unclassified
		//$up = wp_upload_dir();
		$up['baseurl'] = '..';
		$mediapath = $up['baseurl'] . '/';
		$proc->setParameter('', 'mediapath', $mediapath);
		$proc->setParameter('', 'outputpath', $outputpath);
		// run-time params
		$proc->setParameter('', 'SHOW-CONREFMARKUP', $showConrefMarkup);
		$proc->setParameter('', 'GENERATE-OUTLINE-NUMBERING', $GENERATEOUTLINENUMBERING);
		$proc->setParameter('', 'SHOW-TOPIC', $SHOWTOPIC);
		// router (segments and resource id
		$proc->setParameter('', 'serviceType', $serviceType); 
		$proc->setParameter('', 'queryType', $queryType); 
		$proc->setParameter('', 'resourceName', $resourceName); 
		$proc->setParameter('', 'contentSlug', $storagepath); // the current document's key for return links (and db fetch)
		// source paths and content contexts
		$proc->setParameter('', 'contentDir', $contentDir); 
		$proc->setParameter('', 'groupName', $groupName); 
		$proc->setParameter('', 'contentPath', contentPath());//$contentDir);//.'/'.$groupName);
		$proc->setParameter('', 'restPath', $groupName.'/'.$queryType.'/'.$resourceName); //may need to add serviceType...
		//$proc->setParameter('', 'contentFile', $fXml);  // $xmlfn.$ext - resolved filename in local storage
		$proc->setParameter('', 'contentFile', $resourceName.'.dita'); 
		$proc->setParameter('', 'themePath', 'Themes/'); 
		$proc->setParameter('', 'mapName', $resourceName);//$_SESSION['currentMap']); 
		// theme/style params
		$proc->setParameter('', 'htmltype', $htmltype); 
		$proc->setParameter('', 'prefix', $prefix);
			if ($context=='widget') {
				$proc->setParameter('', 'headlevel1', $widgetlevel1); 
				$proc->setParameter('', 'classlevel1', $widgetclass1); 
			} else {
				$proc->setParameter('', 'headlevel1', $headlevel1); 
				$proc->setParameter('', 'classlevel1', $classlevel1); 
			}
	$content = $proc->transformToXML($xml);
	// exslt security on
	return $content; 
}


function xmlXform($xml, $xslt='stylesheet.xsl', $context='widget') { 
//return "XML $xml XSLT $xslt <br/>";
	$xslDoc = new DOMDocument();
	$xslDoc->load($xslt);
	
	$xmlDoc = new DOMDocument();
	$xmlDoc->load($xml, LIBXML_DTDLOAD|LIBXML_DTDVALID|LIBXML_ERR_WARNING |LIBXML_DTDATTR);

	$proc = new XSLTProcessor();

	$proc->importStylesheet($xslDoc);			
	$html = $proc->transformToXML($xmlDoc);
	return $html;
}


register_filter('trydita2html','renderItem'); //echo hook_action('dita2html',array());
function renderItem($item) {
	global $resourceName;
	$sXml = $item[0];
	$sXsl = 'dita2html.xsl';
	//$xslfile = hook_filter('xform_xsl','');
	//$xmlfile = contentPath().$resourceName;
	//$xslfile = pluginsPath().'dita-docs/xsl/'.$sXsl;
	$xslfile = xslPath().$sXsl;
	$xmlfile = contentPath().$sXml;
	
	//echo "$xmlfile processed by $xslfile<br/>";
	
	// Load the XML source
	$xml = new DOMDocument;
	$xml->load($xmlfile, LIBXML_DTDLOAD|LIBXML_DTDVALID|LIBXML_ERR_WARNING |LIBXML_DTDATTR);
	
	$xsl = new DOMDocument;
	$xsl->load($xslfile, LIBXML_NOCDATA); 
	
	// Configure the transformer
	$proc = new XSLTProcessor;
	$proc->importStyleSheet($xsl); // attach the xsl rules
	
	//echo '<hr/>'.$proc->transformToXML($xml).'<hr/>';
	$html = $proc->transformToXML($xml);
	return $html;
}

function xtransformDomStream($xml, $sXsl='dita2html.xsl', $context='widget') {
	global $serviceType, $outputpath, $outmapname, $prefix, $headlevel1, $classlevel1, $widgetlevel1, $widgetclass1, $htmltype,
			$showConrefMarkup, $GENERATEOUTLINENUMBERING, $SHOWTOPIC, $contentDir, $groupName, $queryType, $resourceName,$catenv,
			$contentSlug;

	$storagepath = $outputpath;
}

// XML-specific info: defer into common_XML or the new plugin
$xmlcatalogOffset = INSTALL_OFFSET.'../'; // use the name of your OT install directory if you wish. Add into the transform's plugin?
$xmlcatalogDir = 'DITA-OT'; // use the name of your OT install directory if you wish. Add into the transform's plugin?

function xmlcatalogPath() {
	global $xmlcatalogOffset, $xmlcatalogDir;
	return "{$xmlcatalogOffset}$xmlcatalogDir/";
}

// XSLT-specific info: defer into common_XML or the new plugin
define ('XSL_SECPREFS_NONE', 0); // For latest PHP versions, this property manages XSLT's permissions to write to file in the content storage.
$xslOffset = INSTALL_OFFSET.'pkg/plugins/dita-docs/';//'./';
$xslDir = 'xsl';

function xslPath() {
	global $xslOffset, $xslDir;
	//return "{$xslOffset}$xslDir/";
	//return INSTALL_OFFSET.'pkg/plugins/dita-docs/xsl/';
	return pluginsPath().'dita-docs/xsl/';
}

?>