<?php

namespace App\Controller;

use Doctrine\DBAL\Connection;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Kernel;
use Symfony\Component\Routing\Attribute\Route;

final class HomeController
{
    #[Route('/', name: 'turnkey_home', methods: ['GET'])]
    public function index(Connection $connection): Response
    {
        $message = $connection->fetchOne(
            'SELECT message FROM turnkey_status WHERE id = 1'
        );

        $body = sprintf(
            '<!doctype html><html lang="en"><head><meta charset="utf-8">'
            . '<meta name="viewport" content="width=device-width, initial-scale=1">'
            . '<title>TurnKey Symfony</title></head><body>'
            . '<main><h1>TurnKey Symfony</h1><p>Symfony %s LTS sample application</p>'
            . '<p id="database-status">%s</p></main></body></html>',
            htmlspecialchars(Kernel::VERSION, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8'),
            htmlspecialchars((string) $message, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8')
        );

        return new Response($body);
    }
}
