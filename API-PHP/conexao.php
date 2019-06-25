<?php

$connect = new mysqli("localhost","root","","banco_cobranca");

if($connect){
	
}else{
	echo "Fallo, revise ip o firewall";
	exit();
}