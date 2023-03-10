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

**Work in progress** - this will be continued soon!
