Symfony - PHP Web Framework
===========================

`Symfony`_ is a web application framework written in PHP which follows
the model-view-controller (MVC) paradigm. It provides an architecture,
components and tools for developers to build complex web applications
faster by minimizing repetitive coding tasks.

This appliance includes all the standard features in `TurnKey Core`_,
and on top of that:

- Symfony v3.4 LTS configurations:
   
   - Installed from upstream source code to /var/www/symfony
   - Preconfigured new project and frontend application.
   - Enabled Symfony app security out of the box (XSS an CSRF).
   - Includes PHP XSLT support (required for database access).
   - Symfony Demo Application installed at /var/www/symfony_demo

   **Security note**: Updates to Symfony may require supervision so
   they **ARE NOT** configured to install automatically. See the
   Symfony documentation on `minor`_ and/or `major`_ upgrades.

- SSL support out of the box.
- `Adminer`_ administration frontend for MySQL (listening on port
  12322 - uses SSL).
- Postfix MTA (bound to localhost) to allow sending of email
  (e.g., password recovery).
- Webmin modules for configuring Apache2, PHP, MySQL and Postfix.

To receive notifications of Symfony security updates, we recommend
that you sign up for a free `SensioLabs account`_ and enable Symfony
`security notifications`_.

Credentials *(passwords set at first boot)*
-------------------------------------------

- Webmin, SSH, MySQL: username **root**
- Adminer: username **adminer**

.. _Symfony: http://symfony.com
.. _TurnKey Core: https://www.turnkeylinux.org/core
.. _Adminer: https://www.adminer.org/
.. _minor: https://symfony.com/doc/current/setup/upgrade_minor.html
.. _major: https://symfony.com/doc/current/setup/upgrade_major.html
.. _SensioLabs account: https://connect.sensiolabs.com/login
.. _security notifications: https://symfony.com/account/notifications
