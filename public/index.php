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

$appUrl = $_ENV['APP_URL'] ?? 'http://localhost/RMSmira_api/public';
$basePath = rtrim(parse_url($appUrl, PHP_URL_PATH) ?: '', '/');

$requestMethod = $_SERVER['REQUEST_METHOD'];
// Quitar el BasePath de la URI entrante para que las rutas solo vean lo que nos importa (ej: "/login" en vez de "/RMSmira/public/login")
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$route = str_replace($basePath, '', $uri);

// Router simplificado: Arreglo donde mapeamos el [MÉTODO][Ruta] => [Controlador, Función, ¿Requiere JWT?]
$routes = [
    'POST' => [
        '/login' => [AuthController::class, 'login', false]
    ],
    'GET' => [
        '/me' => [UserController::class, 'me', true],
        '/manuales/marcas' => [EquipoController::class, 'getMarcasDisponibles', true],
        '/manuales/equipos' => [EquipoController::class, 'getEquiposPorMarcaId', true],
        '/manuales/equipo' => [EquipoController::class, 'getDetalleEquipo', true]
    ]
];

// Comprobar si existe la ruta para ese método específico
if (isset($routes[$requestMethod][$route])) {
    list($controllerClass, $methodName, $requiresAuth) = $routes[$requestMethod][$route];

    $payload = null;
    if ($requiresAuth) {
        $payload = JwtMiddleware::handle();
    }

    $controller = new $controllerClass();
    
    // Llamamos siempre al método pasándole el array $_GET entero (el Controlador decide qué extrae)
    if ($requiresAuth) {
        $controller->$methodName($payload, $_GET);
    } else {
        $controller->$methodName($_GET);
    }
} else {
    Response::error("Ruta no encontrada o método no permitido", 404);
}