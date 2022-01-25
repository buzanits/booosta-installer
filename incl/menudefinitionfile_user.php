<?php
$menu = [
         'Settings' => [
                            'Personal Settings' => 'user_self{%script_extension}',
                          ],

         'Application' => [
                            'Dummy' => '/index',
                            ###menuitems###
                          ],
         'Logout' => '/logout_user',
         #'Logout' => '{%base_dir}{%usersystem_dir}exec/logout_user{%script_extension}',
        ];

$menuicons = [
        'Settings' => '<i class="fas fa-cogs"></i>',
        'Application' => '<i class="fas fa-cogs"></i>',
        'Logout' => '<i class="fas fa-sign-out-alt"></i>',

            ];

