<?php

namespace App\Models;

use App\Config\Database;

class Equipo {

    public static function getEquiposConMarcas() {
        $conn = Database::getInstance();

        // Consulta uniendo equipos con marcas y manejando colisiones de nombres
        // Seleccionamos todos los campos de equipos y los específicos faltantes/diferentes de marcas
        $query = "
            SELECT 
                e.*,
                m.id as id_marca_db,
                m.marca as nombre_marca_db,
                m.web as marca_web,
                m.logo as marca_logo
            FROM equipos e 
            JOIN marcas m ON e.marca_id = m.id
        ";
        
        $stmt = $conn->prepare($query);

        if (!$stmt) {
            die("Prepare failed: (" . $conn->errno . ") " . $conn->error);
        }

        $stmt->execute();

        $result = $stmt->get_result();
        $equipos = [];
        while ($row = $result->fetch_assoc()) {
            $equipos[] = $row;
        }

        return $equipos;
    }

    public static function getMarcasConEquipos() {
        $conn = Database::getInstance();

        // Obtiene las marcas que tienen al menos un equipo asignado
        $query = "
            SELECT DISTINCT m.id, m.marca, m.web, m.logo 
            FROM marcas m 
            JOIN equipos e ON m.id = e.marca_id
            ORDER BY m.marca ASC
        ";
        
        $stmt = $conn->prepare($query);

        if (!$stmt) {
            die("Prepare failed: (" . $conn->errno . ") " . $conn->error);
        }

        $stmt->execute();
        $result = $stmt->get_result();
        
        $marcas = [];
        while ($row = $result->fetch_assoc()) {
            $marcas[] = $row;
        }

        return $marcas;
    }

    public static function getEquiposPorMarca($marcaId) {
        $conn = Database::getInstance();

        // Obtiene información básica de los equipos para listar
        $query = "
            SELECT id, tituloequipo, referencia, modelo, imagen 
            FROM equipos 
            WHERE marca_id = ?
            ORDER BY tituloequipo ASC
        ";
        
        $stmt = $conn->prepare($query);

        if (!$stmt) {
            die("Prepare failed: (" . $conn->errno . ") " . $conn->error);
        }

        $stmt->bind_param("i", $marcaId);
        $stmt->execute();
        $result = $stmt->get_result();
        
        $equipos = [];
        while ($row = $result->fetch_assoc()) {
            $equipos[] = $row;
        }

        return $equipos;
    }

    public static function getEquipoDetalle($equipoId) {
        $conn = Database::getInstance();

        // Obtiene todo el detalle de un equipo específico
        $query = "
            SELECT 
                e.*,
                m.id as id_marca_db,
                m.marca as nombre_marca_db,
                m.web as marca_web,
                m.logo as marca_logo
            FROM equipos e 
            JOIN marcas m ON e.marca_id = m.id
            WHERE e.id = ?
            LIMIT 1
        ";
        
        $stmt = $conn->prepare($query);

        if (!$stmt) {
            die("Prepare failed: (" . $conn->errno . ") " . $conn->error);
        }

        $stmt->bind_param("i", $equipoId);
        $stmt->execute();
        
        $result = $stmt->get_result();
        return $result->fetch_assoc();
    }
}
