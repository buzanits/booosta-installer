# Booosta PHP framework

Welcome to the Booosta web framework

## Tutorial

In this tutorial we will create a web application that administrates a small colleage that offers courses to its students. In this application the students are the users and the management of the colleage are the admin users. The application manages courses, lectors and registrations of students for courses. We will go through all the steps from installation to programming.

### Installation

#### Requirements
- PHP >= 8.0
- composer >= 2.3
  Installation of Booosta is done with composer. If you don't have composer installed, see https://getcomposer.org.
- Mysql or MariaDB
- mysqli PHP module

#### Setup your database in Mysql or MariaDB
```sh
#> mysql -u root -p
   Enter password: **********
MySQL [(none)]> create database supercolleage;
MySQL [(none)]> grant all privileges on supercolleage to supercolleage@localhost identified by '********';
MySQL [(none)]> exit
```
If your database is not at localhost, adjust the above commands. See Mysql documentation regarding this. Use a safe password.
#### Install your Booosta App
- If you want to use a Mysql or MariaDB database set it up togehter with a user that can access it.
```sh
#> cd /my/webservers/webspacesdirectory
#> composer create-project booosta/installer supercolleage
#> cd supercolleage
#> composer letsgo
[...]
Installer started.
Website name: [] Super Colleage
DB hostname [localhost]:
DB name: [] supercolleage
DB user: [] supercolleage
DB_password: [] ********
admin password: [] mysafeadminpw
```
- Select a safe password in the last line. It is your login password for the admin user.
  Use the database name and credentials you created in the previous step. 
- Let the webservers virtual hosts rootdir point to the new directory `supercolleage`
- Point your web browser to http://your.webspace.url 
  You should be able to log in with `admin` and the provided password (`mysafeadminpw` in our example above)

#### Create your Application

##### Create the DB tables for your data (or use phpmyadmin)
```sh
#> mysql -u supercolleage -p supercolleage
   Enter password: **********
MySQL [(supercolleage)]> 
  CREATE TABLE IF NOT EXISTS `lecturer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `birthdate` date DEFAULT NULL,
  `gender` enum('m','f') NOT NULL,
  `comment` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `course` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `lecturer` int(11) NOT NULL,
  `starttime` datetime NOT NULL,
  `endtime` datetime NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `lecturer` (`lecturer`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `registration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course` int(11) NOT NULL,
  `user` int(11) NOT NULL,
  `regdate` date NOT NULL,
  `grade` enum('Excellent','Good','Average','Deficient','Failing','Not attended') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `course` (`course`),
  KEY `user` (`user`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

ALTER TABLE `registration`
  ADD CONSTRAINT `registration_ibfk_1` FOREIGN KEY (`course`) REFERENCES `course` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `registration_ibfk_2` FOREIGN KEY (`user`) REFERENCES `user` (`id`) ON DELETE CASCADE;

ALTER TABLE `course`
  ADD CONSTRAINT `course_ibfk_1` FOREIGN KEY (`lecturer`) REFERENCES `lecturer` (`id`);
 
 MySQL [(none)]> exit
```

##### Create the PHP and template files

In this step all the files for your basic application are automatically created for you. You have to do this for every of your database tables.
````sh
#> composer mkfiles
> @putenv COMPOSER=vendor/booosta/mkfiles/composer.json
> \booosta\mkfiles\Mkfiles::invoke
table name:  lecturer
subtable name: course
supertable name: 
````
- In the above example we create all the scripts and templates for the `lecturer` table
- `course` is here defined as a subtable of `lecturer`. This means that every course is assigned to a particular lecutrer. A lecturer can have several courses. But a `course` can only be assigned to one `lecturer` (in our simple example).
- We do not define a supertable for lecturer, because there is none.

````sh
#> composer mkfiles
> @putenv COMPOSER=vendor/booosta/mkfiles/composer.json
> \booosta\mkfiles\Mkfiles::invoke
table name:  course
subtable name: registration
supertable name: lecturer
````
- As we create the files for course we not only define a subtable (`registration`) but also a supertable (`lecturer`).
That means that a course belongs to one lecturer and can have several registrations (users that take this course).

````sh
#> composer mkfiles
> @putenv COMPOSER=vendor/booosta/mkfiles/composer.json
> \booosta\mkfiles\Mkfiles::invoke
table name:  registration
subtable name: 
supertable name: course
````
- Here obviously we have no subtable to `registration`, but `course` is the supertable of `registration`.
- Basically you can now reload your browser and start working with the application. You can already create lecturers, courses, users and registrations.
- To add more fancy functionallity, we will edit our brand new files in the [next step](tutorial2.md) of this tutorial.
- Be aware that calling the `composer mkfiles` command again will overwrite existing files!
