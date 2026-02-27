<?php

namespace App\Controllers;

use App\Models\Equipo;
use App\Helpers\Response;

class EquipoController {

    public function getManuales($jwtPayload) {
        // En caso de que se necesite usar datos del usuario autenticado:
        // $idEmpleado = $jwtPayload->data->id;
        
        // Obtener la lista de equipos y manuales de la base de datos
        $equipos = Equipo::getEquiposConMarcas();

        // Devolver una respuesta JSON
        return Response::json([
            "success" => true,
            "data" => $equipos
        ]);
    }

    public function getMarcasDisponibles($jwtPayload) {
        $marcas = Equipo::getMarcasConEquipos();

        return Response::json([
            "success" => true,
            "data" => $marcas
        ]);
    }

    public function getEquiposPorMarcaId($jwtPayload, $queryParams = []) {
        $marcaId = isset($queryParams['marca_id']) ? $queryParams['marca_id'] : null;

        if (!$marcaId || !is_numeric($marcaId)) {
            return Response::error("Se requiere un ID de marca válido", 400);
        }

        $equipos = Equipo::getEquiposPorMarca($marcaId);

        return Response::json([
            "success" => true,
            "data" => $equipos
        ]);
    }

    public function getDetalleEquipo($jwtPayload, $queryParams = []) {
        $equipoId = isset($queryParams['id']) ? $queryParams['id'] : null;

        if (!$equipoId || !is_numeric($equipoId)) {
            return Response::error("Se requiere un ID de equipo válido", 400);
        }

        $equipo = Equipo::getEquipoDetalle($equipoId);

        if (!$equipo) {
            return Response::error("Equipo no encontrado", 404);
        }

        return Response::json([
            "success" => true,
            "data" => $equipo
        ]);
    }
}
