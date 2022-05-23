# Installer for the Booosta PHP Framework. 

This module provides all the installation steps for PHP Booosta.

Booosta allows to develop PHP web applications quick. It is mainly designed for small web applications. It does not provide a strict MVC distinction. Although the MVC concepts influence the framework. Templates, data objects can be seen as the Vs and Ms of MVC.

Up to version 3 Booosta was available at Sourceforge: https://sourceforge.net/projects/booosta/. From version 4 on it resides on Github and is installable from Packagist under `buzanits/booosta-installer`. Sorry, there will be no (easy) upgrade path from Booosta 3 to Booosta 4.

## Installation
### Requirements
- PHP >= 8.0
- composer  
  Installation of Booosta is done with composer. If you don't have composer installed, see https://getcomposer.org.  
  
suggested:
- Mysql or MariaDB
- mysqli PHP module

### Install your Booosta App
- If you want to use a Mysql or MariaDB database set it up togehter with a user that can access it.
```
#> composer create-project booosta/installer mycoolproject
#> cd mycoolproject
#> composer letsgo
```
- Then you answer some questions about your database connection
- You can install additional Booosta modules with
```
#> composer require booosta/modulename
```
### Create your Application
- Create the DB tables for your data with your favorite tools (like phpmyadmin)
- Create the PHP and template files for every table with
```
#> composer mkfiles
```
- Enter the name of the table you want the files to be created for
- If there is a subtable or supertable enter their name or leave the answer empty
- Edit the PHP files and templates to your need
- Be aware that calling the mkfiles command will overwrite existing files!
