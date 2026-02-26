<?php

require_once __DIR__ . '/../vendor/autoload.php';

// Inicializar variables de entorno (.env) lo más pronto posible
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/../');
$dotenv->safeLoad();

use App\Controllers\AuthController;
use App\Controllers\UserController;
use App\Controllers\EquipoController;
use App\Middleware\JwtMiddleware;
use App\Helpers\Response;

// Configurar cabeceras CORS para que la aplicación en Dart pueda consumir la API
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Manejo de la petición Preflight enviada por navegadores y clientes
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit;
}

header("Content-Type: application/json; charset=utf-8");

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// Extraer el Base Path desde la configuración de entorno (Ej: "/RMSmira_api/public" o "/api" en producción)
$appUrl = $_ENV['APP_URL'] ?? 'http://localhost/RMSmira_api/public';
$basePath = parse_url($appUrl, PHP_URL_PATH);
// Si $basePath es null o "/", lo seteamos a vacío para validaciones seguras
if (!$basePath || $basePath === '/') {
    $basePath = '';
}

// Remover la barra final de basePath por si acaso
$basePath = rtrim($basePath, '/');

if ($uri === "$basePath/login" && $_SERVER['REQUEST_METHOD'] === 'POST') {
    (new AuthController())->login();
} elseif ($uri === "$basePath/me" && $_SERVER['REQUEST_METHOD'] === 'GET') {
    // Al llamar handle(), valida el token y devuelve el Payload (o mata la ejecución con HTTP 401)
    $jwtDecoded = JwtMiddleware::handle();
    (new UserController())->me($jwtDecoded);
} elseif ($uri === "$basePath/manuales/marcas" && $_SERVER['REQUEST_METHOD'] === 'GET') {
    $jwtDecoded = JwtMiddleware::handle();
    (new EquipoController())->getMarcasDisponibles($jwtDecoded);
} elseif ($uri === "$basePath/manuales/equipos" && $_SERVER['REQUEST_METHOD'] === 'GET') {
    $jwtDecoded = JwtMiddleware::handle();
    $marcaId = isset($_GET['marca_id']) ? $_GET['marca_id'] : null;
    (new EquipoController())->getEquiposPorMarcaId($jwtDecoded, $marcaId);
} elseif ($uri === "$basePath/manuales/equipo" && $_SERVER['REQUEST_METHOD'] === 'GET') {
    $jwtDecoded = JwtMiddleware::handle();
    $equipoId = isset($_GET['id']) ? $_GET['id'] : null;
    (new EquipoController())->getDetalleEquipo($jwtDecoded, $equipoId);
} else {
    Response::error("Ruta no encontrada o método no permitido", 404);
}