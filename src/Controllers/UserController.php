<?php

namespace App\Controllers;

use App\Models\User;
use App\Helpers\Response;

class UserController {

    public function me($jwtPayload) {
        // Obtenemos el ID del empleado que fue guardado en el JWT durante el login
        $idEmpleado = $jwtPayload->data->id;

        // Consultamos sus roles fresquecitos de la base de datos
        $roles = User::getUserRoles($idEmpleado);

        // Generamos los menús permitidos basados en el rol (Backend-Driven UI)
        $menus = $this->generarMenuPorRoles($roles);

        return Response::json([
            "usuario" => $jwtPayload->data->usuario,
            "roles" => $roles,
            "menu" => $menus
        ]);
    }

    private function generarMenuPorRoles($roles) {
        $menuPermitido = [];
        $idsRoles = array_column($roles, 'role_id');

        // Menús que todos los usuarios autenticados pueden ver (ej. Dashboard base y Perfil)
        $menuPermitido[] = [
            "id" => "inicio",
            "titulo" => "Inicio",
            "icono" => "home",
            "ruta" => "/home"
        ];

        // Reglas de negocio (Para este ejemplo asumimos que admin es role_id = 3)
        // Puedes agregar más roles y case(s) según tengas en tu tabla as_user_roles.
        foreach ($idsRoles as $roleId) {
            if ($roleId == 3) { // Si es Admin
                $menuPermitido[] = [
                    "id" => "usuarios",
                    "titulo" => "Usuarios",
                    "icono" => "people",
                    "ruta" => "/admin/usuarios"
                ];
                $menuPermitido[] = [
                    "id" => "configuracion",
                    "titulo" => "Configuración",
                    "icono" => "settings",
                    "ruta" => "/admin/config"
                ];
            }
            
            // Ejemplo: si role_id 2 es "Empleado Regular"
            if ($roleId == 2) {
                // Agregar menús específicos para empleado
                $menuPermitido[] = [
                    "id" => "mis_tareas",
                    "titulo" => "Mis Tareas",
                    "icono" => "check_box",
                    "ruta" => "/tareas"
                ];
            }
        }

        return $menuPermitido;
    }
}
