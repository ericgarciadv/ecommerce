<?php  

use \Egrdev\Page;
use \Egrdev\Model\Category;
use \Egrdev\Model\Product;

$app->get('/', function() {

	$product = Product::ListAll();

	$page = new Page();

	$page->setTpl("index", [
		'products'=>Product::checkList($product)
	]);

});

$app->get("/categories/:idcategory", function($idcategory){

	$category = new Category();

	$category->get((int)$idcategory);

	$page = new Page();

	$page->setTpl("category", [
		'category'=>$category->getValues(),
		'products'=>[]
	]);

});

?>