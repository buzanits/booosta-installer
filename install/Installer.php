<?php
namespace booosta\installer;

use Composer\Script\Event;
use Composer\Installer\PackageEvent;
use booosta\Framework as b;
b::load();

class Installer extends \booosta\base\Base
{
  public static function letsgo(Event $e)
  {
    print "Installer started.\n";
    print getcwd() . "\n";
    #return;

    if(is_readable('.installervars')):
      $installervars = json_decode(file_get_contents('.installervars'), true);
      extract($installervars);
    endif;

    $var['sitename'] = readline("Website name: [$default_sitename] ") ?: $default_sitename;
    $var['db_hostname'] = readline("DB hostname [$default_db_hostname]: ") ?: $default_db_hostname;
    $var['db_database'] = readline("DB name: [$default_db_name] ") ?: $default_db_name;
    $var['db_user'] = readline("DB user: [$default_db_user] ") ?: $default_db_user;
    $var['db_password'] = readline("DB_password: [$default_db_password] ") ?: $default_db_password;
    $var['password'] = readline("admin password: [$default_password] ") ?: $default_password;

    $json = json_encode($var);
    file_put_contents('.installervars', $json);

    file_put_contents('local/key.php', '<?php $this->key = "' . base64_encode(openssl_random_pseudo_bytes(32)) . '"; ?>');    

    $tpl = file_get_contents('local/config.incl.dist.php');
    $code = str_replace('{confirm_registration}', $var['registrationconfirmation'] ? 'true' : 'false', $tpl);
    $code = str_replace('{allow_registration}', $var['userregistration'] ? 'true' : 'false', $code);
    $code = str_replace('{sitename}', $var['sitename'], $code);
    $code = str_replace('{sitename_short}', substr($var['sitename'], 0, 3), $code);
    $code = str_replace('{mail_sender}', $var['email'] ?? 'my@email.com', $code);
    $code = str_replace('{db_module}', $var['database'] ?? 'mysqli', $code);
    $code = str_replace('{db_hostname}', $var['db_hostname'], $code);
    $code = str_replace('{db_database}', $var['db_database'], $code);
    $code = str_replace('{db_user}', $var['db_user'], $code);
    $code = str_replace('{db_password}', $var['db_password'], $code);
    $code = str_replace('{language}', $var['language'] ?? 'en', $code);
    $code = str_replace('{mail_backend}', $var['mail_module'] ?? 'php', $code);
    $code = str_replace('{smtp_host}', $var['smtp_host'] ?? '', $code);
    $code = str_replace('{smtp_username}', $var['smtp_username'] ?? '', $code);
    $code = str_replace('{smtp_password}', $var['smtp_password'] ?? '', $code);

    file_put_contents('local/config.incl.php', $code);

    $sql = file_get_contents('installer/mysql.sql');
    if(!$this->DB->query_value('select id from adminuser where id=1')) $this->DB->multi_query($sql);
    if($error = $this->DB->get_error()) $this->raise_error('setting up DB: ' . $error);

    $crypterclass = $this->config('crypter_class') ? $this->config('crypter_class') : 'aes256';
    $crypter = $this->makeInstance($crypterclass);
    $pwd = $crypter->encrypt($var['password']);
    #\booosta\debug("password: {$var['password']}"); \booosta\debug("enc: $pwd");
    $this->DB->query("update adminuser set password='$pwd' where username='admin'");
  }
}
