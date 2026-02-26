<?php

namespace App\Middleware;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use App\Helpers\Response;

class JwtMiddleware {

    public static function handle() {
        $config = require __DIR__ . '/../../config.php';
        $secret = $config['jwt']['secret_key'];

        $headers = getallheaders();

        if (!isset($headers['Authorization'])) {
            self::unauthorized();
        }

        $authHeader = $headers['Authorization'];
        $tokenParts = explode(" ", $authHeader);

        if (count($tokenParts) < 2 || strcasecmp($tokenParts[0], 'Bearer') !== 0) {
            self::unauthorized();
        }

        $token = $tokenParts[1];
        try {
            return JWT::decode($token, new Key($secret, 'HS256'));
        } catch (\Exception $e) {
            self::unauthorized();
        }
    }

    private static function unauthorized() {
        Response::error("No autorizado", 401);
    }
}