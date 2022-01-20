<?php
namespace booosta\installer;

use Composer\Script\Event;
use Composer\Installer\PackageEvent;
#use booosta\Framework as b;
#b::load();

class Installer #extends \booosta\base\Base
{
  public static function letsgo(Event $e)
  {
    print "Installer started.\n";
    print_r($e->getArguments());

    
  }
}
