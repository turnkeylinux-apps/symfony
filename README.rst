Symfony - PHP Web Framework
===========================

`Symfony`_ is a web application framework written in PHP which follows
the model-view-controller (MVC) paradigm. It provides an architecture,
components and tools for developers to build complex web applications
faster by minimizing repetitive coding tasks.

This appliance includes all the standard features in `TurnKey Core`_,
and on top of that:

- Symfony v2.7 LTS configurations:
   
   - Installed from upstream source code to /var/www/symfony
   - Preconfigured new project and frontend application.
   - Enabled Symfony app security out of the box (XSS an CSRF).
   - Includes PHP XSLT support (required for database access).
   - Symfony Demo Application installed at /var/www/symfony_demo

- SSL support out of the box.
- `Adminer`_ administration frontend for MySQL (listening on port
  12322 - uses SSL).
- Postfix MTA (bound to localhost) to allow sending of email
  (e.g., password recovery).
- Webmin modules for configuring Apache2, PHP, MySQL and Postfix.

Credentials *(passwords set at first boot)*
-------------------------------------------

- Webmin, Webshell, SSH, MySQL: username **root**


.. _Symfony: http://symfony.com
.. _TurnKey Core: http://www.turnkeylinux.org/core
.. _Adminer: http://www.adminer.org/
