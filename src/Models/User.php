<?php

namespace App\Models;

use App\Config\Database;

class User {

    public static function findByUsername($username) {
        $conn = Database::getInstance();

        $query = "SELECT * FROM as_users WHERE username = ?";
        $stmt = $conn->prepare($query);

        if (!$stmt) {
            die("Prepare failed: (" . $conn->errno . ") " . $conn->error);
        }

        $stmt->bind_param("s", $username);
        $stmt->execute();

        $result = $stmt->get_result();
        return $result->fetch_assoc();
    }

    public static function getUserRoles($idEmpleado) {
        $conn = Database::getInstance();

        // Cruzamos la tabla de usuarios con la de roles usando el campo 'user_role' (que es el ID del rol)
        $query = "
            SELECT r.role, r.role_id 
            FROM as_users u 
            JOIN as_user_roles r ON u.user_role = r.role_id 
            WHERE u.id_empleado = ?
        ";
        
        $stmt = $conn->prepare($query);

        if (!$stmt) {
            die("Prepare failed: (" . $conn->errno . ") " . $conn->error);
        }

        $stmt->bind_param("i", $idEmpleado);
        $stmt->execute();

        $result = $stmt->get_result();
        $roles = [];
        while ($row = $result->fetch_assoc()) {
            $roles[] = $row;
        }

        return $roles;
    }
}