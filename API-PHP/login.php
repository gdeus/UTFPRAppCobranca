<?php

    include 'conexao.php';

    $user = $_POST['user'];
    $senha = $_POST['senha'];

    $consultar=$connect->query("SELECT * FROM user WHERE user='".$user."' and senha='".$senha."'");

    $resultado=array();

    while($extraerDatos=$consultar->fetch_assoc()){
        $resultado[]=$extraerDatos;
    }

    echo json_encode($resultado);

    ?>