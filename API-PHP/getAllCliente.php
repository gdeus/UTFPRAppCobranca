<?php
include 'conexao.php';

$user = $_POST['user'];

$queryResult=$connect->query("SELECT d.id, d.id_user, u.nome, d.id_compra, d.valor, d.parcela, d.data_vcto, d.pago FROM Divida d, user u WHERE d.id_user = u.id and id_user='".$user."' order by data_vcto");

$result=array();


while($fetchData=$queryResult->fetch_assoc()){
	$result[]=$fetchData;
}

echo json_encode($result);

?>
