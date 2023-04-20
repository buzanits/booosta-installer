# Booosta PHP framework

Welcome to the Booosta web framework

## Tutorial (3)

In the previous chapter we changed the behaviour of our application in the basic CRUD functions. Now let us define our own actions.

### Defining additional actions

When typing the URL `https://www.myhost.com/lecturer/edit/8` the first part after the hostname (`lecturer`) is the script that is called. In this case `lecturer.php`. The second
part (`edit`) ist the action that is called. The action `action_edit()` is derived from the superclass. You could override it to change its behaviour. But it is better to use the
hook functions described in Chapter 2 to do this. The last part (`8`) is the id of the record worked on.

Now we can define our own action:

```
  protected function action_showcourses() {
    $courses = $this->DB->query_value_set("select id from course where lecturer=?", $this->id);

    foreach($courses as $course) {
      $data = $this->DB->query_list("select name, starttime, description from course where id=?", $course);
      $this->TPL['courselist'] .= "<tr><td>{$data['name']}</td><td>{$data['starttime']}</td><td>{$data['description']}</td></tr>";
    }

    $this->maintpl = "tpl/showcourses.tpl";
  }
```

Let's look at this piece of code. The method is named `action_showcourses`. This function is automatically called when the URL `https://www.myhost.com/showcourses` is called.
In the first line of the method we use an object named `$this->DB`. This object holds the current database connection and provides several public methods to access the database.
These methods are:

- `query($sql, $params)`
  executes a SQL query against the DBMS that does not expect a result (like `insert`, `update` or `delete` statements)
- `query_value($sql, $params)`
  executes a SQL query that returns exectly one value (like `select name from lecturer where id=1`)
- `query_value_set($sql, $params)`
  executes a SQL query that returns a set of values from one column and several rows (like `select name from lecturer`)
- `query_list($sql, $params)`
  executes a SQL query that returns several columns of one row (like `select * from lecturer where id=1`)
- `query_arrays($sql, $params)`
  executes a SQL query that returns several columns of several rows (like `select * from lecturer`)
- `query_index_array($sql, $params)`
  executes a SQL query that must return exactly two columns per row (like `select id, name from lecturer`). The result is an array indexed with the first row and with the second row in the data.

The parameter `$sql` is the query to execute. To prevent SQL injection, values can be masked with a `?` in the query string. Those will be replaced with the values in the parameter `$params`.
This is simply an array with all the values that replace `?` in the query string. If there is only one value to replace, the parameter can be a scalar value instead of an array.
The class providing this methods is defined in the `database` module and the module `mysqli`.

In the object variable `$this->id` the id of the current record is hold (e. g. in the `edit` action). In the actions `default` and `new` this variable is not defined.

In the las line of the action method you see the variable `$this->maintpl`. This holds the template that is used for rendering the output in the browser. It can hold two different contents:
The name of a file that holds the template or the content of the template itself. So if you do `$this->maintpl = "Hello, World!";` then the string "Hello, World!" is printed in the browser.
You can also place the template file inside the `lang-xy/type-adminuser/` structure inside `tpl/`. Then you just make `$this->maintpl = "showcourses.tpl";` and the file will be found in the directory
of the current language and user type.

### Code for non admin users

Up to now we only created code for admin users. In our example admin users are the stuff of our colleague that manage all the courses and lecturers. Now we add a different user type. This
should be the students that take the courses and are teached by the lecturers. They should have different forms and menus than admin users. We create the data for users in a quite similar way
as we do it for adminusers:

```
#> composer mkuserfiles
> @putenv COMPOSER=vendor/booosta/mkfiles/composer.json
> \booosta\mkfiles\Mkfiles::invoke
table name: registration
subtable name:
supertable name: course

#> composer mkuserfiles
> @putenv COMPOSER=vendor/booosta/mkfiles/composer.json
> \booosta\mkfiles\Mkfiles::invoke
table name: course
subtable name: registration
supertable name:
```

With this two commands we create two PHP files, `user_registration.php` and `user_course.php`. As you see, these are prefixed with `user_` to distinguish them from the scripts running
the admin user actions. The template files are placed under `tpl/lang-en/type-user/`. As with the admin templates, you can copy the folder `lang-en` to translate the templates to a different
language, that has been set in `local/config.incl.php`.

When you look into the just created PHP files, you see, that they look quite similar to the admin scripts. Except the class is derived from `\booosta\usersystem\Webappuser` insted of 
`\booosta\usersystem\Webappadmin`. For executing these scripts you must log in with a user account, not an adminuser account. This is done with `https://my.domain.com/login_user` instead of
`login_adminuser`. Adminusers can create new users in the `User Administration / User` menu on the left.

Users can register themselves if the key `allow_registration` is set to `true` in `local/config.incl.php`, which is `false` by default. If you want to force self registered users to confirm
their email address by clicking on a link sent to them, also set `confirm_registration` to `true` in the config. If you want to direct anyone that types `https://my.domain.com` into the browser 
to the user area instead of the admin area, edit `index.php` and replace `/admin` with `/user` there. Then a default page in the user area will be displayed if a user is logged in and if not,
the user login page will appear.


