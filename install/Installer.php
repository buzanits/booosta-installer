<?php
namespace booosta\installer;

require_once __DIR__ . '/../vendor/autoload.php';

use Composer\Script\Event;
use Composer\Installer\PackageEvent;
use booosta\Framework as b;
b::croot();
b::load();

class Installer
{
  public static function letsgo(Event $e)
  {
    print "Installer started.\n";

    if(is_readable('.installervars')):
      $installervars = json_decode(file_get_contents('.installervars'), true);
      extract($installervars);
    endif;

    $var['sitename'] = readline("Website name: [$sitename] ") ?: $sitename;
    $var['db_hostname'] = readline("DB hostname [$db_hostname]: ") ?: $db_hostname;
    $var['db_name'] = readline("DB name: [$db_name] ") ?: $db_name;
    $var['db_user'] = readline("DB user: [$db_user] ") ?: $db_user;
    $var['db_password'] = readline("DB_password: [$db_password] ") ?: $db_password;
    $var['password'] = readline("admin password: [$password] ") ?: $password;

    $json = json_encode($var);
    file_put_contents('.installervars', $json);

    file_put_contents('local/key.php', '<?php $this->key = "' . base64_encode(openssl_random_pseudo_bytes(32)) . '"; ?>');    

    $tpl = file_get_contents('local/config.incl.dist.php');
    $code = str_replace('{confirm_registration}', !empty($var['registrationconfirmation']) ? 'true' : 'false', $tpl);
    $code = str_replace('{allow_registration}', !empty($var['userregistration']) ? 'true' : 'false', $code);
    $code = str_replace('{sitename}', $var['sitename'], $code);
    $code = str_replace('{sitename_short}', substr($var['sitename'], 0, 3), $code);
    $code = str_replace('{mail_sender}', $var['email'] ?? 'my@email.com', $code);
    $code = str_replace('{db_module}', $var['database'] ?? 'mysqli', $code);
    $code = str_replace('{db_hostname}', $var['db_hostname'], $code);
    $code = str_replace('{db_database}', $var['db_name'], $code);
    $code = str_replace('{db_user}', $var['db_user'], $code);
    $code = str_replace('{db_password}', $var['db_password'], $code);
    $code = str_replace('{language}', $var['language'] ?? 'en', $code);
    $code = str_replace('{mail_backend}', $var['mail_module'] ?? 'php', $code);
    $code = str_replace('{smtp_host}', $var['smtp_host'] ?? '', $code);
    $code = str_replace('{smtp_username}', $var['smtp_username'] ?? '', $code);
    $code = str_replace('{smtp_password}', $var['smtp_password'] ?? '', $code);

    file_put_contents('local/config.incl.php', $code);

    // next part must not be run in static function to have $this->DB available
    $worker = new Worker();
    $worker();
  }
}


class Worker extends \booosta\base\Base
{
  public function __invoke()
  {
    include 'local/config.incl.php';

    $sql = file_get_contents('install/mysql.sql');
    if(!$this->DB->query_value("show tables like 'adminuser'")) $this->DB->multi_query($sql);
    #if(!$this->DB->query_value('select id from adminuser where id=1')) $this->DB->multi_query($sql);
    if($error = $this->DB->get_error()) print 'setting up DB: ' . $error;
    #if($error = $this->DB->get_error()) $this->raise_error('setting up DB: ' . $error);

    $crypterclass = $this->config('crypter_class') ? $this->config('crypter_class') : 'aes256';
    $crypter = $this->makeInstance($crypterclass);
    $pwd = $crypter->encrypt($var['password']);
    #\booosta\debug("password: {$var['password']}"); \booosta\debug("enc: $pwd");
    $this->DB->query("update adminuser set password='$pwd' where username='admin'");

    print "\nInstaller has finished now. Check if everything looks fine and then delete the install directory and the file .installervars\n\n";
  }
}
