 = FooBar =

  Example on how to package drupal app using:
   - drush_make: Drush plugin that allows building a drupal site based on an ini make file. 
      * Details here: http://drupal.org/project/drush_make

   - phing: Build tool (Ant clone for php). 
      * Details here: http://phing.info
 
   - debhelper: This example used dpkg as package manager.
      * Details here: http://packages.ubuntu.com/maverick/debhelper


 = Dependencies =
 
 * Phing install
     # sudo apt-get install php-pear
     # pear channel-discovery pear.phing.info
     # pear install --alldeps phing/phing

 * Drush_make
     # sudo apt-get install drush 
     # sudo drush dl drush_make

 * Debhelper
     # sudo apt-get install debhelper

