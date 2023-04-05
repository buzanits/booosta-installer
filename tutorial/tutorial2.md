# Booosta PHP framework

Welcome to the Booosta web framework

## Tutorial (2)

In the previous step we created the files for our application. And we can use the application already! But there is only the basic functionallity of CRUD (create, read, update, delete) implemented. We can make our app richer by editing the created files.

- Be aware, that subsequent calls to `composer mkfiles` will overwrite the files and your edits would be lost!

### Changing the main menu

When you reload your web app, you will see, that under the **Application** menu, there is a new menu entry **Lecturer**. But there are none for **Course** or **Registration**. This is because those two tables are subtables of other tables. This is explained in the previous page of this tutorial. You access the records of this tables via their corresponding record in the supertable. For example, to see all the `course`s of a `lecturer`, open this lecturer and you see his courses.

We also see a Dummy menu entry, which has been created, because there has to be at least one entry in each menu for the CSS to work properly. Now as we have our own entry, we can safely delete that.

The admins main menu is defined in the file `incl/menudefinitionfile_admin.php`:
```php
    'Application' => [
        'Dummy' => '/index',
        #'Test' => '{%base_dir}test.php',
        'Lecturer' => 'lecturer',
        ###menuitems###
    ],
```
Ignore the commented out lines that contain the string `{%base_dir}`. They are for special configurations of Booosta. You can delete them or leave them. But do **not** delete the line `###menuitems###`. That is needed for subsequent menu items that are automatically added by `composer mkfiles`.

So we delete the Dummy line. We also could add additional menu items:
```php
    'Application' => [
        'Lecturer' => 'lecturer',
        'New lecturer' => 'lecturer/new',
        'Our homepage' => 'https://www.supercolleague.edu',
        ###menuitems###
    ],
```

You also could add additional main menu entries. But always have at least one menu item inside it.

### Changing the template files

The templates are inside the folder `tpl/`. You can edit them there. Let's have a look on the template for adding new lecturers `tpl/lecturer_new.tpl`:

```
{BBOXCENTER}
{BPANEL|paneltitle::New Lecturer}

{BFORMSTART|lecturer}
{HIDDEN|action|newdo}
{HIDDEN|form_token|{%form_token}}

{BTEXT|name|texttitle::Name}
{BDATE|birthdate|texttitle::Birthdate}
{BSELECT|gender|texttitle::Gender
m
f}
{BTEXT|email|texttitle::Email}
{BTEXTAREA|comment|10|texttitle::Comment}

{BFORMSUBMIT|class::center-block}
{BFORMEND}
{BLINK|Back|javascript:history.go(-1);}

{/BPANEL}
{/BBOXCENTER}
```

- `{BBOXCENTER}` opens a centered box in the main area of the browser window
- `{BPANEL|paneltitle::New Lecturer}` adds a panel with the headline _New Lecturer_
- `{BFORMSTART|lecturer}` opens a HTML form that calls `/lecturer` when submitted
- `{HIDDEN|action|newdo}` adds a hidden field to the form. Here the field `action` with value `newdo`.
- `{BTEXT|name|texttitle::Name}` adds a text item to the form. Here the field `name`. `texttitle` is the caption in the form.
- `{BDATE|birthdate|texttitle::Birthdate}` adds a datefield that uses a nice datepicker
- `{BSELECT|gender|texttitle::Gender …}` adds a select to chose from. The options are in the subsequent lines.
- `{BTEXTAREA|comment|10|texttitle::Comment}` adds a textarea. Here with 10 lines in size.
- `{BFORMSUBMIT|class::center-block}` adds a submit button to the form
- `{BLINK|Back|javascript:history.go(-1);}` adds a link button. Here with the caption `Back` and the link target `javascript:history.go(-1)` which makes the browser to go one step back in history

Try playing around in this file and see, how the output in the browser changes!

Maybe you wonder, how Booosta knows when to use a date field, a texarea, a select or an ordinary text field. It determines this from the datatype in the database table. This is how datatypes
are mapped to HTML form fields:

- `DATE` or `DATETIME` becomes a date field with a datepicker (DATETIME does not provide a picker for hours or minutes. But you can add something like `12:45:00` manually.
- `TEXT` becomes a textarea
- `INT` with a foreign key on it becomes a select with values from the foreign key table
- `TINYINT` becomes a checkbox
- anything else becomes a text field

So it is very important that you carefully make decisions about the datatypes in your tables and the foreign keys!

Now we see, that our select for the lecturers gender ist not very amazing. Because we only store `m` or `f` in the database, the wizard only shows these values. We want to make this a little bit prettier. We want the words `male` or `female` to appear in the select, but still send the letters to the server like they are in the database:

```
{BSELECT|gender|texttitle::Gender
[m]male
[f]female}
```
In the brackets `[]` we tell the templateparser which values to use and afterwards we tell it, which values to display.

### Changing the script files

Now add a new lecturer with the form. After you submit the form, you come back to the list of lecturers with already one entry in the list - the one you just created. But the list looks rather ugly. It shows the ID - a useless information - and for the gender only the one character. So let's edit the file `lecturer.php`:

```php
class App extends booosta\usersystem\Webappadmin
{
  #protected $fields = 'name,edit,delete';
  #protected $header = 'Name,Edit,Delete';
```

Here you see that a new class named `App` is defined which is derived from the superclass `booosta\usersystem\Webappadmin`. This superclass contains all the basic CRUD logic that is done in your web app. You also see that there are class variables `$fields` and `$header` which are commented out. You can remove the `#` in front of these lines end edit the content of this variable. You just set the content to the names of database fields you want to have displayed in the list. This list is comma seperated:

```php
class App extends booosta\usersystem\Webappadmin
{
  protected $fields = 'name,birthdate,gender,comment,edit,delete';
  protected $header = 'Name,Date of Birth,Gender,Comment,Edit,Delete';
```

Save the file and reload your browser tab. You will se that magically the ID field disappeared from the list. It is not in the `$fields` variable. Go and play around with these two variables!

Now we want the gender to be displayed more nicely. If you are familar with object oriented programming, you know that methods of superclasses can be overridden in subclasses. There is a method `in_default_makelist($list)` that is called in the superclass after the list of records has been created in the default action. The default action is the one that is called when you do not add anything after `/lecturer` in the URL. So we add the following method just before the closing `}` of the class:

```php
  protected function in_default_makelist($list) {
      $list->add_replaces('gender', [function($val) { return $val == 'f' ? 'female' : 'male'; }]);
  }
```
  
 This looks quite complicated. But it's easy. The method `add_replaces` of the `$list` object replaces the field `gender` (which must be present in `$fields` above) with the second parameter. This parameter could be a simple value like `'hello world`' or the result of a function. If you use a function it has to be inside an array for technical reasons. This function looks at the value that is read from the database and if it reads `f`, it returns `female` otherwise `male`. Save and reload and see the result.

Your also can use all other fields of the current record as variables in `add_replaces`:

```php
  protected function in_default_makelist($list) {
      $list->add_replaces('gender', [function($val) { return $val == 'f' ? '{name} is female' : '{name} is male'; }]);
  }
```

If the logic of the function you call inside `add_replaces` is very complicated, you could define an additional method in this class with all this logic and then call this method inside of `add_replaces`.

Now click on the edit icon of one of your records and you come to the edit form. It looks quite like the form for creating new records. When you open tpl/lecturer_edit.tpl you see one obvious difference: There is an additional parameter in each template parser tag, that holds the current value that is to be displayed in the form:

```
{BTEXT|name|{*name}|texttitle::Name}
{BDATE|birthdate|{*birthdate}|texttitle::Birthdate}
{BSELECT|gender|{%gender}|texttitle::Gender
m
f}
{BTEXTAREA|comment|10|texttitle::Comment
{*comment}}
```

Here `{*name}` or `{%gender}` hold these values. This is the way variable values are displayed in the templates. There is a slightly difference between `{*` and `{%`: The first one escapes the characters `" { } | $ \` so that they are displayed on the page. The second one does not so the template parser interprets them as special control characters. So you can put variables inside variables for example.

The values used here are automatically prefilled by the Booosta webapp module. But you can define your own. Put this line on top of the name line:

```
{BSTATIC|{*hello}|Message}
{BTEXT|name|{*name}|texttitle::Name}
```

and add this method to lecturer.php:

```php
  protected function before_action_edit() {
      $this->TPL['hello'] = 'Hello World!';
  }
```

The `$this->TPL['hello']` in the script appears as `{*hello}` in the template!

You see, that on the bottom of the page, there is a panel with the courses of this lecturer. This is empty of course, as we did not create any courses yet. So click on **New Course** to create one.
You will see another form similar to the New Lecturer from we already know. You see, that the TINYINT field `isopen` became a checkbox field in the form. When the user checks it, a `1` will be
sent to the database, else there will be stored a `0` in the database. This is because Mysql and MariaDB do not know boolean datatypes.

When you fill in all the fields and submit the form you will come back to the **Edit lecturer** page. You might wonder, why you are not at a list of all courses now. This is because `course`
is a subtable of `lecturer`. This means, every course belongs to a lecturer and therefore all his courses are displayed at the lecturers edit page.

You see, that the list is not very beautiful again. Last time we fixed that by adding class variables `$fields` and `$header`. There is a similar mechanism for the display of the sub data:
`$sub_fields` and `$sub_header`. They have to appear in the script for the supertable - in our case `lecturer.php`:

```php
  protected $sub_fields = 'name,isopen,starttime,endtime,edit,delete';
  protected $sub_header = 'Name,Open,Start,End,edit,delete';
```

Now our list is pretty. Let's make work for our users easier now. We know that our colleague creates every course 6 months in advance. So when the secretary creates a new course, we display
the day in 6 months as default. (Well that may be a Sunday, but we ignore that to keep the example simple.) We calculate that date, provide it to the template and use it in the template.

`course.php` (inside the class definition):
```php
  protected function before_action_new() {
    $this->TPL['defaultStartDate'] = date('Y-m-d 09:00:00', strtotime('+6 months'));
    $this->TPL['defaultEndDate'] = date('Y-m-d 10:00:00', strtotime('+6 months'));
  }
```

replace in `tpl/course_new.tpl`:
```
{BDATE|starttime|{*defaultStartDate}|texttitle::Starttime}
{BDATE|endtime|{*defaultEndDate}|texttitle::Endtime}
```

When you now open the form for new courses you see these dates prefilled in the fields. Of course you can edit the values there. In the code you have seen something new: We add a new method
named `before_action_new()` to our class. This is a method defined in a superclass that usually does _nothing_. But you can override this method to do something. `before_action_new()` is
automatically called just before Booosta is building the form for adding a new record. Here the method defines two new template variables.

There are several methods, that can be overridden:

- `before_action_new()`
- `after_action_new()`
- `before_action_edit()`
- `after_action_edit()`
- `before_action_delete()`
- `after_action_delete()`
- `before_action_newdo()`
- `after_action_newdo()`
- `before_action_editdo()`
- `after_action_editdo()`
- `before_action_deleteyes()`
- `after_action_deleteyes()`
- `before_action_default()`
- `after_action_default()`

The first six are self explanating. They are called before and after the corresponding action. The last two are called before and after the list of records is created. For example, when
you call `/lecturer` in your application, the `action_default()` is executed, which builds this list. `before_action_default()` is then called before this is done. By the way, you also can
override the complete `action_default()`, so that something completely different is done when `/lecturer` is called.

All the methods that end with `do` are called before or after the corresponding action in the database is really executed. So `before_action_newdo()` is called before the new
record is inserted into the database table, `after_action_newdo()` after that.

Now let's say, after we added a course for a lecturer, we want to send an email to him. We add to `course.php`:
```php
  protected function after_action_newdo() {
    $lecturer = $this->getDataobject('lecturer', $this->VAR['lecturer']);
    $email = $lecturer->get('email');
    $text = 'A new course with the following name has been added for you: ' . $this->VAR['name'];

    if($email) {
      $mail = $this->makeInstance('email', 'office@supercolleague.edu', $email, 'New course added', $text);
      $mail->send();
    }
  }
```

This method is called after the record has been inserted. We learn some new things here: First, the method `$this->getDataobject()`. This method retrieves a record from the database and
returns a data object with the corresponding data in it. You can imagine data objects as what MVC frameworks refer as _model_. Booosta only uses a very loose MVC approach. You can see the
templates and the template engine as _view_, the classes you define in the PHP files as _controller_ and the data objects as _model_. Of course, this is **not** a real MVC system!

The first parameter of `getDataobject` is the name of the table where the data is derived from. The second is a clause, telling which record to get. This can be a SQL where clause like 
`"lastname='Doe'"` or an integer, which is the `id` of the record. In this second parameter we see another new thing: `$this->VAR`. In this array all the `GET` and `POST` parameters that
are passed to the script are present. The form sends a `POST` parameter `lecturer` to the script and we can read it here with `$this->VAR['lecturer']`. Data objects are defined in the
Booosta module [dataobjects](https://github.com/buzanits/booosta-dataobjects).

The next line shows, how we can access the data of the retrieved record. The method `get($column)` reads the value of a named column of the record. So `$lecturer->get('email')` reads
the value of the field `email` in the record retrieved in the previous line. In line 7 we have another new feature. We create a new object of the class `email`. Usually you create new
objects with the keyword `new` in PHP. In Booosta you do it with `$this->makeInstance()`. The reason is, that there are several initialisations done in the object after creation, such as
inheriting the database connection. Of course `new` still works and has to be used when instantiating non Booosta objects.

In this example, a new object of a class is created, that is defined in the Booosta module [email](https://github.com/buzanits/booosta-email). As you see, Booosta is organized in several
modules. All Booosta classes are defined in modules that reside under `vendor/booosta/modulename`. All classes are subclasses of the basic class `booosta\base\Base` which is defined in the
[base module](https://github.com/buzanits/booosta-base). The first parameter of `makeInstance()` is the class name and the further parameters are the parameters of the classes constructor.

In fact, there are additional hook functions that are executed before and after an action like adding records. They deal with the data itself. Let's say, if the end date of a course is not
provided, we want to automatically add an end date one hour after the begin of a course. We add to `course.php`:
```
  protected function before_add_($data, $obj) {
    if($data['endtime'] == '') $obj->set('endtime', date('Y-m-d H:i:s', strtotime($data['starttime'] . ' +1 hours')));
  }
```

So how does this work? There are two parameters. In `$data` all the data submitted by the HTML form is present. `$obj` is a data object that holds the *new* data. This object has not stored
this data in the database when this method is called. This means, we can manipulate the data in this object and the manipulated data will go into the database. So in this example we set the
field `endtime` to a new value that is one hour after the time that is provided in the field `starttime`.

There are several hook functions called before and after the CRUD actions where data can be read or manipulated:

- `before_add_($data, $obj)`
- `after_add_($data, $newid)`
- `before_edit_($id, $data, $obj)`
- `after_edit_($id, $data)`
- `before_delete_($id)`
- `after_delete_($id)`

Be aware of the trailing _ in all of this functions! The reason for this _ is a historical one and it has never been changed ;-)

In all of these functions `$id` holds the id of the current record worked on, `$data` the values that have been sumitted by the form, `$newid` is the id of the recently added record
and `$obj` is the dataobject that holds the data that will be inserted or updated to the database. Manipulating values in `$data` has no effect. To change the data sent to the database
you have to set the values in this object with `$obj->set('fieldname', 'newvalue');`.

As a rule of thumb you should place actions that do not work with data in the `before_action...` and `after_action...` methods and the others in the latter ones.

