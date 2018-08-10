<?php
  if (!isset($_GET['action']))
  {
    die("You must not access this page directly!");
  }

  // Construct the e-mail
  $content = "";
  if ($_GET['name']) { 	$content .= 'Name: '	. trim($_GET['name'])."\n"; }
  if ($_GET['email']) { 	$content .= 'Email: '	. trim($_GET['email'])."\n"; }
  if ($_GET['comment']) { 	$content .= 'Comment: '	. str_replace('<br />', "\n", trim($_GET['comment']))."\n\n"; }

  $content = wordwrap($content, 70);
  //"$server = 'localhost';"$username = 'root';"$password = 'kmsjhs1910';""$database = 'arabella_production';"

$send_to = 'iain_wilkinson@blackradley.com';
$headers = 'From: ' . $_GET['email'];

if(mail($send_to, 'You have received a Website Comment from '.$_GET['name'], $content, $headers))
{
  echo 'contact_form|<p style="text-align:left;">
Thank you, your comment has been sent.</p>
';}
else{
  echo 'contact_form|<p style="text-align:left;">
Sorry, your comment could not been sent, please try again.</p>
<p style="text-align:left;"><a href="/3014.html">&laquo; back to Contact Page</a></p>
';}
?>
