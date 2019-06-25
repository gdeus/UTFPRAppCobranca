<?php

    include 'conexao.php';

    $user = $_POST['user'];
    $data1 = $_POST['data1'];
	$data2 = $_POST['data2'];

    $consultar=$connect->query("select d.id, d.id_user, u.nome, d.id_compra, d.valor, d.parcela, d.data_vcto, d.pago from user u, divida d WHERE u.id = d.id_user and u.id = '".$user."' AND d.data_vcto BETWEEN '".$data1."' and '".$data2."'");

    $resultado=array();

    while($extraerDatos=$consultar->fetch_assoc()){
        $resultado[]=$extraerDatos;
    }

    echo json_encode($resultado);

?>