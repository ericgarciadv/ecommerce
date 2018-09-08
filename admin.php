<?php

use \Egrdev\PageAdmin;
use \Egrdev\Model\User;

$app->get('/admin', function() {
    
	User::verifyLogin();

	$page = new PageAdmin();

	$page->setTpl("index");

});

$app->get('/admin/login', function() {
    
	$page = new PageAdmin([
		"header"=>false,
		"footer"=>false
	]);

	$page->setTpl("login", [
		'msgError'=>User::getError(),
	]);

});

$app->get('/admin/logout', function() {
    
    User::logout();

    header("Location: /admin/login");
    exit;

});

$app->post('/admin/login', function() {

	try {
		User::login($_POST["login"],$_POST["password"]);	
	} catch (Exception $e) {
		User::setError("Usuário ou senha inválida.");
		header("Location: /admin/login");
		exit;
	}

	header("Location: /admin");
	exit;
});

?>