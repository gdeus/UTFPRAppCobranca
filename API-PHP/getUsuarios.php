<?php
include 'conexao.php';

$queryResult=$connect->query("select * from user where tipo = 'cliente'");

$result=array();


while($fetchData=$queryResult->fetch_assoc()){
	$result[]=$fetchData;
}

echo json_encode($result);

?>
