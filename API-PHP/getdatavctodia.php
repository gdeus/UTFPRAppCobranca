<?php
include 'conexao.php';

$queryResult=$connect->query("SELECT d.id, d.id_user, u.nome, d.id_compra, d.valor, d.parcela, d.data_vcto, d.pago FROM Divida d, user u where CURDATE() = data_vcto and u.id = d.id_user and pago = 0");

$result=array();


while($fetchData=$queryResult->fetch_assoc()){
	$result[]=$fetchData;
}

echo json_encode($result);

?>
