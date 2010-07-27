#!/bin/bash 

# Install drupal site from command line without doing any http calls.
# Please execute this script under drupal install directory.
# This script assummes that :
#   - database details have been already defined in site/default/settings.php
#   - you'll be fine with:
#        - default instalation profile
#        - "en" locale
#        - clean url enabled
#        - status updated enabled
#
# @author: Catalin Balan <catalin.balan@gmail.com>

site_name='Drupal brand new site'
site_mail='drupal@email.com'
account_name='admin'
account_email='admin@email.com'
account_password='password'

function cookies() {
  if [ -n "$1" ]; then
    echo "\$_COOKIE=unserialize('$1');"
  else
    echo 'function _cli_cookie_print(){print(serialize(array(session_name()=>session_id())));}
    register_shutdown_function("_cli_cookie_print");'
  fi

  echo '$_GET=array("profile"=>"default", "locale"=>"en", "id"=>"1"); $_REQUEST=$_GET;'
}

phpcode="$(cookies) include('install.php');"
cli_cookie=$(php -r "$phpcode"|tail -n1)

phpcode=$(cookies $cli_cookie)' $_GET["op"]="start"; $_REQUEST=$_GET; include("install.php");'
php -r "$phpcode"

phpcode=$(cookies $cli_cookie)' $_GET["op"]="do_nojs"; $_REQUEST=$_GET; include("install.php");'
php -r "$phpcode"

phpcode=$(cookies $cli_cookie)' $_GET["op"]="finished"; $_REQUEST=$_GET; include("install.php");'
php -r "$phpcode"

phpcode=$(cookies $cli_cookie)' $_POST=array("site_name"=>"'$site_name'", 
"site_mail"=>"'$site_mail'", 
"account"=>array("name"=>"'$account_name'", "mail"=>"'$account_email'", "pass"=>array("pass1"=>"'$account_password'", "pass2"=>"'$account_password'")),
"date_default_timezone"=>"0", 
"clean_url"=>"1",
"form_id"=>"install_configure_form", 
"update_status_module" => array("1"=>"1")); include("install.php");'
php -r "$phpcode" 

