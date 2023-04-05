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

- query($sql, $params)
  executes a SQL query against the DBMS that does not expect a result (like `insert`, `update` or `delete` statements)
- query_value($sql, $params)
  executes a SQL query that returns exectly one value (like `select name from lecturer where id=1`)
- query_value_set($sql, $params)
  executes a SQL query that returns a set of values from one column and several rows (like `select name from lecturer`)
- query_list($sql, $params)
  executes a SQL query that returns several columns of one row (like `select * from lecturer where id=1`)
- query_arrays($sql, $params)
  executes a SQL query that returns several columns of several rows (like `select * from lecturer`)
- query_index_array($sql, $params)
  executes a SQL query that must return exactly two columns per row (like `select id, name from lecturer`). The result is an array indexed with the first row and with the second row in the data.

The parameter `$sql` is the query to execute. To prevent SQL injection, values can be masked with a `?` in the query string. Those will be replaced with the values in the parameter `$params`.
This is simply an array with all the values that replace `?` in the query string. If there is only one value to replace, the parameter can be a scalar value instead of an array.
The class providing this methods is defined in the `database` module and the module `mysqli`.

In the object variable `$this->id` the id of the current record is hold (e. g. in the `edit` action). In the actions `default` and `new` this variable is not defined.

In the las line of the action method you see the variable `$this->maintpl`. This holds the template that is used for rendering the output in the browser. It can hold two different contents:
The name of a file that holds the template or the content of the template itself. So if you do `$this->maintpl = "Hello, World!";` then the string "Hello, World!" is printed in the browser.


