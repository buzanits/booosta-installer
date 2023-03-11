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

**Work in progress** - this will be continued soon!
