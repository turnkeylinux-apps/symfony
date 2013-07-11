Symfony - PHP Web Framework
===========================

`Symfony`_ is a web application framework written in PHP which follows
the model-view-controller (MVC) paradigm. It provides an architecture,
components and tools for developers to build complex web applications
faster by minimizing repetitive coding tasks.

This appliance includes all the standard features in `TurnKey Core`_,
and on top of that:

- Symfony configurations:
   
   - Installed from upstream source code to /var/www/symfony
   - Preconfigured project and frontend application.
   - Enabled Symfony app security out of the box (XSS an CSRF).
   - Includes PHP XSLT support (required for database access).

- SSL support out of the box.
- `PHPMyAdmin`_ administration frontend for MySQL (listening on
  port 12322 - uses SSL).
- Postfix MTA (bound to localhost) to allow sending of email
  (e.g., password recovery).
- Webmin modules for configuring Apache2, PHP, MySQL and Postfix.

In order to use *frontend_dev.php*, uncomment the check for localhost
(127.0.0.1) in */var/www/symfony/web/frontend_dev.php*

Credentials *(passwords set at first boot)*
-------------------------------------------

- Webmin, Webshell, SSH, MySQL: username **root**


.. _Symfony: http://www.symfony-project.org
.. _TurnKey Core: http://www.turnkeylinux.org/core
.. _PHPMyAdmin: http://www.phpmyadmin.net/
