<?php

namespace App\Controllers;

use Firebase\JWT\JWT;
use App\Models\User;
use App\Helpers\Response;

class AuthController {

    public function login() {
        $config = require __DIR__ . '/../../config.php';
        $secret = $config['jwt']['secret_key'];

        $data = json_decode(file_get_contents("php://input"));

        if (!isset($data->username) || !isset($data->password)) {
            return Response::error("Datos incompletos", 400);
        }

        $user = User::findByUsername($data->username);

        $hashedInput = hash('sha512', $data->password);

        if (!$user || !password_verify($hashedInput, $user['password'])) {
            return Response::error("Credenciales inválidas", 401);
        }

        $payload = [
            "iss" => "localhost",
            "iat" => time(),
            "exp" => time() + 3600,
            "data" => [
                "id" => $user['id_empleado'],
                "usuario" => $user['username']
            ]
        ];

        $jwt = JWT::encode($payload, $secret, 'HS256');

        return Response::json([
            "token" => $jwt
        ]);
    }
}
