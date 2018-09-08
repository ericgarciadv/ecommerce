<?php  

use \Egrdev\Model\User;
use \Egrdev\Model\Cart;

function formatPrice($vlPrice)
{

	if(!$vlPrice > 0) $vlPrice = 0;

	return number_format($vlPrice, 2, ",", ".");
}

function formatDate($date) 
{
	return date('d/m/Y', strtotime($date));
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

function isHomeMenuActive(){

	if(isset($_SESSION['menuHome']) && $_SESSION['menuHome'] != NULL){
		return "active";
	} else {
		return "";
	}
}

function isProductsMenuActive(){
	if(isset($_SESSION['menuProducts']) && $_SESSION['menuProducts'] != NULL){
		return "active";
	} else {
		return "";
	}
}

function isCartMenuActive(){
	if(isset($_SESSION['menuCart']) && $_SESSION['menuCart'] != NULL){
		return "active";
	} else {
		return "";
	}
}

?>