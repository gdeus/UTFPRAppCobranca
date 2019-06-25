<?php

    include 'conexao.php';

    $consultar=$connect->query("select d.id, d.id_user, u.nome, d.id_compra, d.valor, d.parcela, d.data_vcto, d.pago from user u, divida d WHERE u.id = d.id_user and d.pago = 0 and CURDATE() > data_vcto");

    $resultado=array();

    while($extraerDatos=$consultar->fetch_assoc()){
        $resultado[]=$extraerDatos;
    }

    echo json_encode($resultado);

?>