<?php  

use \Egrdev\Model\User;
use \Egrdev\Model\Cart;

function formatPrice($vlPrice)
{

	if(!$vlPrice > 0) $vlPrice = 0;

	return number_format($vlPrice, 2, ",", ".");
}

function checkLogin($inadmin = true){

	return User::checkLogin($inadmin);
}

function getUserName(){
	$user = User::getFromSession();

	return $user->getdesperson();
}

function getCartNrQtd() {
	$cart = Cart::getFromSession();

	$totals = $cart->getProductTotals();

	return $totals['nrqtd'];
}

function getCartSubtotal() {
	$cart = Cart::getFromSession();

	$totals = $cart->getProductTotals();

	return formatPrice($totals['vlprice']);
}
?>