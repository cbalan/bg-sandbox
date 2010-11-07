 = FooBar =

  Example on how to package drupal site using:
   - drush_make: Drush plugin that allows building a drupal site based on an ini make file. 
      * Details here: http://drupal.org/project/drush_make

   - phing: Build tool (Ant clone for php). 
      * Details here: http://phing.info
 
   - debhelper: This example used dpkg as package manager.
      * Details here: http://packages.ubuntu.com/maverick/debhelper


 == Dependencies ==
 
  * Phing install
     # sudo apt-get install php-pear
     # pear channel-discovery pear.phing.info
     # pear install --alldeps phing/phing

  * Drush_make
     # sudo apt-get install drush 
     # sudo drush dl drush_make

  * Debhelper
     # sudo apt-get install debhelper


 == Package foobar site ==

  * checkout source   
     # git clone git://github.com/cbalan/bg-sandbox.git bg-sandbox

  * package foobar drupal site:
     # cd bg-sandbox/drupal-phing-deb
     # phing clean package
  Resulted foobar deb can be found under bg-sandbox/drupal-phing-deb/target/deb/foobar*.deb


 == Install foobar site ==
 
  * dpkg -i foobar*.deb
 

 == No configs ==
 
  Please note that this example does not provide any web server(apache2) configuration or database initialization.
  For more details check out:
    - http://packages.ubuntu.com/maverick/dh-make-drupal
    - http://packages.ubuntu.com/maverick/drupal6   


