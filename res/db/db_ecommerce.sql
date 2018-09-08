-- phpMyAdmin SQL Dump
-- version 4.8.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 04-Set-2018 às 06:50
-- Versão do servidor: 10.1.31-MariaDB
-- PHP Version: 7.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_ecommerce`
--

DELIMITER $$
--
-- Procedures
--
CREATE  PROCEDURE `sp_addresses_save` (`pidaddress` INT(11), `pidperson` INT(11), `pdesaddress` VARCHAR(128), `pdesnumber` VARCHAR(16), `pdescomplement` VARCHAR(32), `pdescity` VARCHAR(32), `pdesstate` VARCHAR(32), `pdescountry` VARCHAR(32), `pdeszipcode` CHAR(8), `pdesdistrict` VARCHAR(32))  BEGIN

	IF pidaddress > 0 THEN
		
		UPDATE tb_addresses
        SET
			idperson = pidperson,
            desaddress = pdesaddress,
            desnumber = pdesnumber,
            descomplement = pdescomplement,
            descity = pdescity,
            desstate = pdesstate,
            descountry = pdescountry,
            deszipcode = pdeszipcode, 
            desdistrict = pdesdistrict
		WHERE idaddress = pidaddress;
        
    ELSE
		
		INSERT INTO tb_addresses (idperson, desaddress, desnumber, descomplement, descity, desstate, descountry, deszipcode, desdistrict)
        VALUES(pidperson, pdesaddress, pdesnumber, pdescomplement, pdescity, pdesstate, pdescountry, pdeszipcode, pdesdistrict);
        
        SET pidaddress = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_addresses WHERE idaddress = pidaddress;

END$$

CREATE  PROCEDURE `sp_carts_save` (`pidcart` INT, `pdessessionid` VARCHAR(64), `piduser` INT, `pdeszipcode` CHAR(8), `pvlfreight` DECIMAL(10,2), `pnrdays` INT)  BEGIN

    IF pidcart > 0 THEN
        
        UPDATE tb_carts
        SET
            dessessionid = pdessessionid,
            iduser = piduser,
            deszipcode = pdeszipcode,
            vlfreight = pvlfreight,
            nrdays = pnrdays
        WHERE idcart = pidcart;
        
    ELSE
        
        INSERT INTO tb_carts (dessessionid, iduser, deszipcode, vlfreight, nrdays)
        VALUES(pdessessionid, piduser, pdeszipcode, pvlfreight, pnrdays);
        
        SET pidcart = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_carts WHERE idcart = pidcart;

END$$

CREATE  PROCEDURE `sp_categories_save` (`pidcategory` INT, `pdescategory` VARCHAR(64))  BEGIN
	
	IF pidcategory > 0 THEN
		
		UPDATE tb_categories
        SET descategory = pdescategory
        WHERE idcategory = pidcategory;
        
    ELSE
		
		INSERT INTO tb_categories (descategory) VALUES(pdescategory);
        
        SET pidcategory = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_categories WHERE idcategory = pidcategory;
    
END$$

CREATE  PROCEDURE `sp_orders_save` (`pidorder` INT, `pidcart` INT(11), `piduser` INT(11), `pidstatus` INT(11), `pidaddress` INT(11), `pvltotal` DECIMAL(10,2))  BEGIN
	
	IF pidorder > 0 THEN
		
		UPDATE tb_orders
        SET
			idcart = pidcart,
            iduser = piduser,
            idstatus = pidstatus,
            idaddress = pidaddress,
            vltotal = pvltotal
		WHERE idorder = pidorder;
        
    ELSE
    
		INSERT INTO tb_orders (idcart, iduser, idstatus, idaddress, vltotal)
        VALUES(pidcart, piduser, pidstatus, pidaddress, pvltotal);
		
		SET pidorder = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * 
    FROM tb_orders a
    INNER JOIN tb_ordersstatus b USING(idstatus)
    INNER JOIN tb_carts c USING(idcart)
    INNER JOIN tb_users d ON d.iduser = a.iduser
    INNER JOIN tb_addresses e USING(idaddress)
    WHERE idorder = pidorder;
    
END$$

CREATE  PROCEDURE `sp_products_save` (`pidproduct` INT(11), `pdesproduct` VARCHAR(64), `pvlprice` DECIMAL(10,2), `pvlwidth` DECIMAL(10,2), `pvlheight` DECIMAL(10,2), `pvllength` DECIMAL(10,2), `pvlweight` DECIMAL(10,2), `pdesurl` VARCHAR(128))  BEGIN
	
	IF pidproduct > 0 THEN
		
		UPDATE tb_products
        SET 
			desproduct = pdesproduct,
            vlprice = pvlprice,
            vlwidth = pvlwidth,
            vlheight = pvlheight,
            vllength = pvllength,
            vlweight = pvlweight,
            desurl = pdesurl
        WHERE idproduct = pidproduct;
        
    ELSE
		
		INSERT INTO tb_products (desproduct, vlprice, vlwidth, vlheight, vllength, vlweight, desurl) 
        VALUES(pdesproduct, pvlprice, pvlwidth, pvlheight, pvllength, pvlweight, pdesurl);
        
        SET pidproduct = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_products WHERE idproduct = pidproduct;
    
END$$

CREATE  PROCEDURE `sp_userspasswordsrecoveries_create` (`piduser` INT, `pdesip` VARCHAR(45))  BEGIN
	
	INSERT INTO tb_userspasswordsrecoveries (iduser, desip)
    VALUES(piduser, pdesip);
    
    SELECT * FROM tb_userspasswordsrecoveries
    WHERE idrecovery = LAST_INSERT_ID();
    
END$$

CREATE  PROCEDURE `sp_usersupdate_save` (`piduser` INT, `pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)  BEGIN
	
    DECLARE vidperson INT;
    
	SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
    
    UPDATE tb_persons
    SET 
		desperson = pdesperson,
        desemail = pdesemail,
        nrphone = pnrphone
	WHERE idperson = vidperson;
    
    UPDATE tb_users
    SET
		deslogin = pdeslogin,
        despassword = pdespassword,
        inadmin = pinadmin
	WHERE iduser = piduser;
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = piduser;
    
END$$

CREATE  PROCEDURE `sp_users_delete` (`piduser` INT)  BEGIN
    
    DECLARE vidperson INT;
    
    SET FOREIGN_KEY_CHECKS = 0;
	
	SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
	
    DELETE FROM tb_addresses WHERE idperson = vidperson;
    DELETE FROM tb_addresses WHERE idaddress IN(SELECT idaddress FROM tb_orders WHERE iduser = piduser);
	DELETE FROM tb_persons WHERE idperson = vidperson;
    
    DELETE FROM tb_userslogs WHERE iduser = piduser;
    DELETE FROM tb_userspasswordsrecoveries WHERE iduser = piduser;
    DELETE FROM tb_orders WHERE iduser = piduser;
    DELETE FROM tb_cartsproducts WHERE idcart IN(SELECT idcart FROM tb_carts WHERE iduser = piduser);
    DELETE FROM tb_carts WHERE iduser = piduser;
    DELETE FROM tb_users WHERE iduser = piduser;
    
    SET FOREIGN_KEY_CHECKS = 1;
    
END$$

CREATE  PROCEDURE `sp_users_save` (`pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)  BEGIN
	
    DECLARE vidperson INT;
    
	INSERT INTO tb_persons (desperson, desemail, nrphone)
    VALUES(pdesperson, pdesemail, pnrphone);
    
    SET vidperson = LAST_INSERT_ID();
    
    INSERT INTO tb_users (idperson, deslogin, despassword, inadmin)
    VALUES(vidperson, pdeslogin, pdespassword, pinadmin);
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = LAST_INSERT_ID();
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_addresses`
--

CREATE TABLE `tb_addresses` (
  `idaddress` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `desaddress` varchar(128) NOT NULL,
  `desnumber` varchar(16) NOT NULL,
  `descomplement` varchar(32) DEFAULT NULL,
  `descity` varchar(32) NOT NULL,
  `desstate` varchar(32) NOT NULL,
  `descountry` varchar(32) NOT NULL,
  `deszipcode` char(8) NOT NULL,
  `desdistrict` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_addresses`
--

INSERT INTO `tb_addresses` (`idaddress`, `idperson`, `desaddress`, `desnumber`, `descomplement`, `descity`, `desstate`, `descountry`, `deszipcode`, `desdistrict`, `dtregister`) VALUES
(1, 1, 'Rua Fernando Simoni', '500', '', 'Rio de Janeiro', 'RJ', 'Brasil', '20755120', 'Pilares', '2018-08-31 23:30:02'),
(2, 1, 'Rua Fernando Simoni', '', '', 'Rio de Janeiro', 'RJ', 'Brasil', '20755120', 'Pilares', '2018-08-31 23:44:54'),
(3, 1, 'Rua Fernando Simoni', '500', '', 'Rio de Janeiro', 'RJ', 'Brasil', '20755120', 'Pilares', '2018-08-31 23:52:44'),
(4, 1, 'Rua Fernando Simoni', '500', 'Casa Aa', 'Rio de Janeiro', 'RJ', 'Brasil', '20755120', 'Pilares', '2018-09-02 17:45:41');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_carts`
--

CREATE TABLE `tb_carts` (
  `idcart` int(11) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `iduser` int(11) DEFAULT NULL,
  `deszipcode` char(8) DEFAULT NULL,
  `vlfreight` decimal(10,2) DEFAULT NULL,
  `nrdays` int(11) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_carts`
--

INSERT INTO `tb_carts` (`idcart`, `dessessionid`, `iduser`, `deszipcode`, `vlfreight`, `nrdays`, `dtregister`) VALUES
(1, 'chvo8skug658nu6kk3iht90aum', NULL, NULL, NULL, NULL, '2018-08-20 15:40:30'),
(2, 'ltckto26k19lhhi66opfv2ghgp', NULL, NULL, NULL, NULL, '2018-08-20 18:20:09'),
(3, 'iik39k3bnibadaqn96v1c80abr', NULL, NULL, NULL, NULL, '2018-08-22 18:56:41'),
(4, '9go26eprohi2jugaseb9ae2jug', NULL, NULL, NULL, NULL, '2018-08-23 14:58:01'),
(5, 'jh6ta5oa21o0kjeqgfa9u3v409', NULL, '20755120', '54.53', 1, '2018-08-23 22:47:32'),
(6, 'rnn1hufkbpe2n6fqj6v7pcn220', NULL, '20755120', '105.73', 1, '2018-08-24 02:28:59'),
(7, '6aeiti2mn73hq9jf1jrl9canh0', NULL, '20755120', '54.53', 1, '2018-08-24 03:29:22'),
(8, 'upmu4b5ele34mo0g30lpfrpoek', NULL, NULL, NULL, NULL, '2018-08-24 03:37:08'),
(9, 'h1bdfcqlld5ep0n0h71q5157e4', NULL, '20755120', '54.53', 1, '2018-08-24 06:12:45'),
(10, 'jdq49puchu2a0enl94h25tm4k0', NULL, '20755120', '54.53', 1, '2018-08-25 22:01:13'),
(11, '7arloqh9ddqs9bvi5dmqr2j2cg', 1, '20010020', '54.53', 1, '2018-08-26 05:41:58'),
(12, '7fradv569fj372j1limt8pth67', NULL, '20011030', '83.03', 1, '2018-08-26 08:09:57'),
(13, 'p0lp21oqnue6rj0qb760o6462g', NULL, '20010020', '54.53', 1, '2018-08-26 21:20:21'),
(14, 's88keqtr16quer18v8k4smocli', NULL, '20010020', '57.81', 1, '2018-08-26 22:13:29'),
(15, '44tpka17q8fhqbqsc1nqlq6pon', NULL, '20755120', '55.93', 1, '2018-08-27 00:41:06'),
(16, 'beut1nmqec7n9ge81ot5djmimm', NULL, NULL, NULL, NULL, '2018-08-27 15:20:35'),
(17, 'q8sn1s6jq4ov679ogdhpbga05e', NULL, '20755120', '55.93', 1, '2018-08-27 18:15:24'),
(18, '3qrqjtcfe62j64rrosc724ele7', NULL, '20755120', '59.21', 1, '2018-08-29 02:13:23'),
(19, '5jvvus596rvepoes2n29ujhrge', 1, '20755120', '84.53', 1, '2018-08-29 13:57:11'),
(20, 'df0ehkl2gkm6jlo8gprn6f9fgf', NULL, NULL, NULL, NULL, '2018-08-29 14:34:21'),
(21, '7m8b99p970f8h7mb7g71h0l6jf', NULL, NULL, NULL, NULL, '2018-08-29 23:07:02'),
(22, 'fpk8dd6k3f9i8sctmks1v0fejl', NULL, NULL, NULL, NULL, '2018-08-30 06:24:02'),
(23, 'j8efr6d4hk387dhj5leusej19q', NULL, NULL, NULL, NULL, '2018-08-31 00:50:07'),
(24, '18padi3tffavatqcvabhqr8hhb', 1, NULL, NULL, NULL, '2018-08-31 02:12:56'),
(25, 'u2i6nbftb7hf67u5noj88p21ig', NULL, NULL, NULL, NULL, '2018-08-31 15:07:31'),
(26, 'ssde9smd1su99pckjq5e71m9h3', NULL, NULL, NULL, NULL, '2018-08-31 16:17:02'),
(27, 'fnri76jimei4ci5mo0foj0tjdl', NULL, '20755120', '59.96', 1, '2018-08-31 23:16:33'),
(28, 'pvhr85mo09oc8gu10g6ku73r32', NULL, '20783120', '47.58', 1, '2018-09-01 21:58:23'),
(29, '7ktmt59cnrjbl01li88aaleqq7', NULL, '20755120', '47.58', 1, '2018-09-01 23:59:39'),
(30, 'ihm3o8hi5nsrt1esk7lef55gtc', NULL, NULL, NULL, NULL, '2018-09-02 00:14:12'),
(31, 'nemtbpt534g5qq0stta71kvh0a', NULL, NULL, NULL, NULL, '2018-09-02 00:15:20'),
(32, 'uffbknc6d1s20n97mt5ok6hq8i', NULL, '20755120', '47.58', 1, '2018-09-02 00:20:31'),
(33, 'i5lkkkf5u2l39fmc3479bo7o99', NULL, '20755120', '71.74', 1, '2018-09-02 17:36:26'),
(34, 'o54koj7vekm3fgcotcsc3r34qq', NULL, NULL, NULL, NULL, '2018-09-02 17:49:53'),
(35, '8n4mhli6puvl5hpmiseemakrqd', NULL, NULL, NULL, NULL, '2018-09-02 18:11:29'),
(36, '8kquf5eitmiknbusda5a99n0v5', NULL, NULL, NULL, NULL, '2018-09-03 01:24:52'),
(37, 'm4ekvus7fto4dca4om1b8vgunr', NULL, NULL, NULL, NULL, '2018-09-03 01:46:57');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_cartsproducts`
--

CREATE TABLE `tb_cartsproducts` (
  `idcartproduct` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL,
  `dtremoved` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_cartsproducts`
--

INSERT INTO `tb_cartsproducts` (`idcartproduct`, `idcart`, `idproduct`, `dtremoved`, `dtregister`) VALUES
(1, 3, 17, '0000-00-00 00:00:00', '2018-08-22 18:59:03'),
(2, 3, 21, '0000-00-00 00:00:00', '2018-08-22 19:00:42'),
(3, 3, 17, '2018-08-22 16:33:11', '2018-08-22 19:10:54'),
(4, 3, 17, '2018-08-22 16:33:13', '2018-08-22 19:11:34'),
(5, 3, 17, '2018-08-22 16:33:15', '2018-08-22 19:13:50'),
(6, 3, 17, '2018-08-22 16:33:16', '2018-08-22 19:32:42'),
(7, 3, 17, '2018-08-22 16:33:18', '2018-08-22 19:32:53'),
(8, 3, 17, NULL, '2018-08-22 19:32:57'),
(9, 4, 18, '2018-08-23 11:58:10', '2018-08-23 14:58:02'),
(10, 4, 18, '2018-08-23 11:58:11', '2018-08-23 14:58:07'),
(11, 4, 6, '2018-08-23 12:06:44', '2018-08-23 14:58:32'),
(12, 4, 6, '2018-08-23 12:06:45', '2018-08-23 14:58:36'),
(13, 4, 6, '2018-08-23 12:07:05', '2018-08-23 14:58:41'),
(14, 4, 6, '2018-08-23 12:07:05', '2018-08-23 15:06:51'),
(15, 4, 6, '2018-08-23 12:07:05', '2018-08-23 15:06:51'),
(16, 4, 6, '2018-08-23 12:07:06', '2018-08-23 15:06:53'),
(17, 4, 6, '2018-08-23 12:07:06', '2018-08-23 15:06:53'),
(18, 4, 6, '2018-08-23 12:07:06', '2018-08-23 15:06:54'),
(19, 4, 6, '2018-08-23 12:07:08', '2018-08-23 15:06:55'),
(20, 4, 6, '2018-08-23 12:07:10', '2018-08-23 15:06:56'),
(21, 4, 6, '2018-08-23 12:07:11', '2018-08-23 15:06:57'),
(22, 4, 6, '2018-08-23 12:08:04', '2018-08-23 15:06:59'),
(23, 4, 6, '2018-08-23 12:16:43', '2018-08-23 15:15:29'),
(24, 4, 6, '2018-08-23 12:16:45', '2018-08-23 15:15:34'),
(25, 4, 17, NULL, '2018-08-23 15:15:53'),
(26, 4, 6, NULL, '2018-08-23 15:16:12'),
(27, 4, 6, NULL, '2018-08-23 15:16:12'),
(28, 4, 6, NULL, '2018-08-23 15:16:12'),
(29, 4, 19, NULL, '2018-08-23 15:17:20'),
(30, 4, 19, NULL, '2018-08-23 15:17:20'),
(31, 4, 19, NULL, '2018-08-23 15:17:20'),
(32, 5, 6, '2018-08-23 20:39:45', '2018-08-23 22:48:52'),
(33, 5, 6, '2018-08-23 20:39:47', '2018-08-23 23:09:22'),
(34, 5, 6, '2018-08-23 20:39:48', '2018-08-23 23:27:55'),
(35, 5, 6, '2018-08-23 21:23:17', '2018-08-23 23:31:30'),
(36, 5, 17, '2018-08-23 21:24:40', '2018-08-23 23:41:07'),
(37, 5, 17, NULL, '2018-08-23 23:41:13'),
(38, 6, 6, '2018-08-23 23:30:21', '2018-08-24 02:28:59'),
(39, 6, 6, '2018-08-23 23:30:48', '2018-08-24 02:29:47'),
(40, 6, 17, '2018-08-23 23:31:23', '2018-08-24 02:31:00'),
(41, 6, 17, '2018-08-24 00:09:36', '2018-08-24 02:31:35'),
(42, 6, 17, NULL, '2018-08-24 03:09:29'),
(43, 6, 6, NULL, '2018-08-24 03:28:43'),
(44, 7, 6, '2018-08-24 00:29:39', '2018-08-24 03:29:31'),
(45, 7, 17, '2018-08-24 00:30:02', '2018-08-24 03:29:47'),
(46, 7, 6, '2018-08-24 00:32:46', '2018-08-24 03:30:09'),
(47, 7, 17, '2018-08-24 00:36:44', '2018-08-24 03:32:57'),
(48, 8, 6, NULL, '2018-08-24 03:37:08'),
(49, 9, 17, NULL, '2018-08-24 06:12:45'),
(50, 10, 17, NULL, '2018-08-26 02:06:53'),
(51, 11, 17, '2018-08-26 04:30:43', '2018-08-26 07:26:10'),
(52, 11, 17, '2018-08-26 04:32:23', '2018-08-26 07:26:10'),
(53, 11, 17, '2018-08-26 04:32:39', '2018-08-26 07:26:50'),
(54, 11, 17, '2018-08-26 05:18:42', '2018-08-26 07:29:59'),
(55, 11, 17, NULL, '2018-08-26 07:30:09'),
(56, 12, 6, NULL, '2018-08-26 08:10:09'),
(57, 13, 17, '2018-08-26 18:58:38', '2018-08-26 21:20:32'),
(58, 13, 17, NULL, '2018-08-26 21:59:03'),
(59, 14, 19, NULL, '2018-08-26 22:13:29'),
(60, 15, 19, '2018-08-26 22:55:54', '2018-08-27 00:41:06'),
(61, 15, 17, NULL, '2018-08-27 01:55:37'),
(62, 17, 17, '2018-08-27 15:17:56', '2018-08-27 18:15:24'),
(63, 18, 19, NULL, '2018-08-29 02:13:29'),
(64, 19, 19, '2018-08-29 11:25:55', '2018-08-29 14:25:45'),
(65, 19, 19, '2018-08-29 11:26:01', '2018-08-29 14:25:45'),
(66, 19, 19, '2018-08-29 11:28:43', '2018-08-29 14:25:58'),
(67, 19, 19, '2018-08-29 11:28:51', '2018-08-29 14:26:31'),
(68, 19, 19, '2018-08-29 11:28:52', '2018-08-29 14:28:45'),
(69, 19, 19, '2018-08-29 11:28:52', '2018-08-29 14:28:46'),
(70, 19, 19, '2018-08-29 11:28:53', '2018-08-29 14:28:48'),
(71, 19, 19, '2018-08-29 11:29:02', '2018-08-29 14:28:49'),
(72, 19, 6, NULL, '2018-08-29 16:19:30'),
(73, 26, 6, NULL, '2018-08-31 17:47:01'),
(74, 26, 19, NULL, '2018-08-31 17:49:32'),
(75, 26, 19, NULL, '2018-08-31 17:49:32'),
(76, 26, 21, NULL, '2018-08-31 17:51:02'),
(77, 27, 19, NULL, '2018-08-31 23:29:07'),
(78, 28, 21, NULL, '2018-09-01 23:46:27'),
(79, 29, 21, NULL, '2018-09-01 23:59:49'),
(80, 32, 21, '2018-09-01 21:27:13', '2018-09-02 00:20:50'),
(81, 32, 21, NULL, '2018-09-02 01:26:20'),
(82, 33, 19, '2018-09-02 14:43:17', '2018-09-02 17:42:09'),
(83, 33, 18, '2018-09-02 14:44:29', '2018-09-02 17:44:17'),
(84, 33, 18, NULL, '2018-09-02 17:44:21');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_categories`
--

CREATE TABLE `tb_categories` (
  `idcategory` int(11) NOT NULL,
  `descategory` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_categories`
--

INSERT INTO `tb_categories` (`idcategory`, `descategory`, `dtregister`) VALUES
(1, 'Apple', '2018-08-10 20:01:53'),
(4, 'Android', '2018-08-10 20:30:06'),
(5, 'Motorola', '2018-08-10 22:51:38'),
(6, 'Samsung', '2018-08-10 22:51:47');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_orders`
--

CREATE TABLE `tb_orders` (
  `idorder` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `idstatus` int(11) NOT NULL,
  `idaddress` int(11) NOT NULL,
  `vltotal` decimal(10,2) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_orders`
--

INSERT INTO `tb_orders` (`idorder`, `idcart`, `iduser`, `idstatus`, `idaddress`, `vltotal`, `dtregister`) VALUES
(2, 15, 1, 1, 6, '57.81', '2018-08-27 00:49:35'),
(3, 15, 1, 1, 7, '57.81', '2018-08-27 00:54:30'),
(4, 15, 1, 1, 8, '57.81', '2018-08-27 01:05:33'),
(5, 15, 1, 1, 9, '54.53', '2018-08-27 01:56:24'),
(6, 17, 1, 1, 10, '55.93', '2018-08-27 18:16:16'),
(7, 17, 1, 1, 11, '55.93', '2018-08-27 18:18:52'),
(10, 18, 1, 4, 14, '1358.21', '2018-08-29 02:14:06'),
(12, 19, 1, 3, 16, '2584.52', '2018-08-29 18:19:07'),
(13, 27, 1, 1, 1, '1358.21', '2018-08-31 23:30:03'),
(14, 27, 1, 1, 2, '1358.21', '2018-08-31 23:44:55'),
(15, 27, 1, 1, 3, '1358.21', '2018-08-31 23:52:45'),
(16, 33, 1, 1, 4, '1959.52', '2018-09-02 17:45:45');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_ordersstatus`
--

CREATE TABLE `tb_ordersstatus` (
  `idstatus` int(11) NOT NULL,
  `desstatus` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_ordersstatus`
--

INSERT INTO `tb_ordersstatus` (`idstatus`, `desstatus`, `dtregister`) VALUES
(1, 'Em Aberto', '2017-03-13 03:00:00'),
(2, 'Aguardando Pagamento', '2017-03-13 03:00:00'),
(3, 'Pago', '2017-03-13 03:00:00'),
(4, 'Entregue', '2017-03-13 03:00:00');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_persons`
--

CREATE TABLE `tb_persons` (
  `idperson` int(11) NOT NULL,
  `desperson` varchar(64) NOT NULL,
  `desemail` varchar(128) DEFAULT NULL,
  `nrphone` bigint(20) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_persons`
--

INSERT INTO `tb_persons` (`idperson`, `desperson`, `desemail`, `nrphone`, `dtregister`) VALUES
(1, 'Eric', 'admin@admin.com.br', 2147483647, '2017-03-01 03:00:00'),
(7, 'Ericmar', 'ericgarcia.rodrigues@gmail.com', 21993111119, '2017-03-15 16:10:27'),
(8, 'ThaÃ­s FalcÃ£o da Silva Pinho', 'thaisfalcaodaspinho@gmail.com', 21993111119, '2018-08-10 00:29:07'),
(9, 'Eric Garcia', 'admin@admin.com.br', 2147483647, '2018-08-26 06:26:43'),
(10, 'Eric Garcia', 'admin@admin.com.br', 2147483647, '2018-08-26 06:27:13'),
(11, 'Thaís Falcão da Silva Pinho', 'thais@th.com', NULL, '2018-08-27 18:20:20'),
(12, 'Elenilson', 'ele@ele.com', NULL, '2018-08-29 15:20:37'),
(13, 'Elenilson', 'ele@elenilson.com', NULL, '2018-08-29 15:33:33'),
(14, 'Edinho', 'edi@edi.com', NULL, '2018-08-29 15:46:22'),
(15, 'Robin Wood', 'ribin@wood.com.br', 999999999, '2018-08-31 15:41:00');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_products`
--

CREATE TABLE `tb_products` (
  `idproduct` int(11) NOT NULL,
  `desproduct` varchar(64) NOT NULL,
  `vlprice` decimal(10,2) NOT NULL,
  `vlwidth` decimal(10,2) NOT NULL,
  `vlheight` decimal(10,2) NOT NULL,
  `vllength` decimal(10,2) NOT NULL,
  `vlweight` decimal(10,2) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_products`
--

INSERT INTO `tb_products` (`idproduct`, `desproduct`, `vlprice`, `vlwidth`, `vlheight`, `vllength`, `vlweight`, `desurl`, `dtregister`) VALUES
(6, 'Ipad 32GB Wi-Fi Tela 9,7\" CÃ¢mera 8MP Prata - Apple', '2499.99', '0.75', '16.95', '24.50', '0.47', 'Ipad-32gb', '2018-08-13 04:36:19'),
(17, 'Smartphone Motorola Moto G5 Plus', '1135.23', '15.20', '7.40', '0.70', '0.16', 'smartphone-motorola-moto-g5-plus', '2018-08-13 16:29:41'),
(18, 'Smartphone Moto Z Play', '1887.78', '14.10', '0.90', '1.16', '0.13', 'smartphone-moto-z-play', '2018-08-13 16:29:41'),
(19, 'Smartphone Samsung Galaxy J5 Pro', '1299.00', '14.60', '7.10', '0.80', '0.16', 'smartphone-samsung-galaxy-j5', '2018-08-13 16:29:41'),
(20, 'Smartphone Samsung Galaxy J7 Prime', '1149.00', '15.10', '7.50', '0.80', '0.16', 'smartphone-samsung-galaxy-j7', '2018-08-13 16:29:41'),
(21, 'Smartphone Samsung Galaxy J3 Dual', '679.90', '14.20', '7.10', '0.70', '0.14', 'smartphone-samsung-galaxy-j3', '2018-08-13 16:29:41');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_productscategories`
--

CREATE TABLE `tb_productscategories` (
  `idcategory` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_productscategories`
--

INSERT INTO `tb_productscategories` (`idcategory`, `idproduct`) VALUES
(1, 6),
(4, 17),
(4, 18),
(4, 19),
(4, 20),
(4, 21),
(5, 17),
(5, 18),
(6, 19),
(6, 20),
(6, 21);

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_users`
--

CREATE TABLE `tb_users` (
  `iduser` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `deslogin` varchar(64) NOT NULL,
  `despassword` varchar(256) NOT NULL,
  `inadmin` tinyint(4) NOT NULL DEFAULT '0',
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_users`
--

INSERT INTO `tb_users` (`iduser`, `idperson`, `deslogin`, `despassword`, `inadmin`, `dtregister`) VALUES
(1, 1, 'admin', '$2y$12$YlooCyNvyTji8bPRcrfNfOKnVMmZA9ViM2A3IpFjmrpIbp5ovNmga', 1, '2017-03-13 03:00:00'),
(7, 7, 'ericgarcia.rodrigues@gmail.com', '$2y$12$Cw5UBuqECxEnY0XKzgW9xeRkGAvKaOXNQB45ovwtnOiW3AIDW4b..', 0, '2017-03-15 16:10:27'),
(8, 8, 'thaisf', '$2y$12$8u1R4YjEvdvO/1vMY48C6OD4XYgj9nOwLNPOQFuCPiX5Jp1sxT87K', 1, '2018-08-10 00:29:07'),
(9, 9, 'admin@admin.com.br', '$2y$12$oHlD9FugI7MfSjyE.Ta95e7WVXp.m2rV1nIzVrRjYdeDUHLBI0GZy', 1, '2018-08-26 06:26:43'),
(10, 10, 'admin@admin.com.br', '$2y$12$vef7Wn6EvKBTcI2VdUqjNOQghwV03rvQ7RPibSvwIS7lVmYCE6Xqa', 1, '2018-08-26 06:27:13'),
(12, 12, 'ele@ele.com', '$2y$12$06kJnaZPUgwFW15M16DGpOwl/1m2dIbgfX6dpgGaAf9jUoZmBM7gu', 0, '2018-08-29 15:20:37'),
(13, 13, 'ele@elenilson.com', '$2y$12$O.Gzvq/8ysbj4jdGpXtWbeEzpdcXv3BpBKYQAMNgRDISHDFu..lKO', 0, '2018-08-29 15:33:33'),
(14, 14, 'edi@edi.com', '$2y$12$FFy24EPQmNOQ63H.HfzFruiUzhTRYjM06ogd07N/iOYqsSKMYQic2', 0, '2018-08-29 15:46:22'),
(15, 15, 'robin', '$2y$12$j88fXqWD9eglyFfFBa93Te1cbrPdFKmnmnVfxuuJrKKM805EYNbaO', 1, '2018-08-31 15:41:00');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_userslogs`
--

CREATE TABLE `tb_userslogs` (
  `idlog` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `deslog` varchar(128) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `desuseragent` varchar(128) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_userspasswordsrecoveries`
--

CREATE TABLE `tb_userspasswordsrecoveries` (
  `idrecovery` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `dtrecovery` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_userspasswordsrecoveries`
--

INSERT INTO `tb_userspasswordsrecoveries` (`idrecovery`, `iduser`, `desip`, `dtrecovery`, `dtregister`) VALUES
(1, 7, '127.0.0.1', NULL, '2017-03-15 16:10:59'),
(2, 7, '127.0.0.1', '2017-03-15 13:33:45', '2017-03-15 16:11:18'),
(3, 7, '127.0.0.1', '2017-03-15 13:37:35', '2017-03-15 16:37:12'),
(4, 7, '127.0.0.1', NULL, '2018-08-09 20:39:20'),
(5, 7, '127.0.0.1', NULL, '2018-08-09 20:57:55'),
(6, 7, '127.0.0.1', NULL, '2018-08-09 21:06:10'),
(7, 7, '127.0.0.1', NULL, '2018-08-09 21:20:39'),
(8, 7, '127.0.0.1', NULL, '2018-08-09 21:22:55'),
(9, 7, '127.0.0.1', NULL, '2018-08-09 21:25:25'),
(10, 7, '127.0.0.1', NULL, '2018-08-09 21:31:18'),
(11, 7, '127.0.0.1', NULL, '2018-08-09 21:33:15'),
(12, 7, '127.0.0.1', NULL, '2018-08-09 21:33:35'),
(13, 7, '127.0.0.1', NULL, '2018-08-09 21:33:38'),
(14, 7, '127.0.0.1', NULL, '2018-08-09 21:33:54'),
(15, 7, '127.0.0.1', NULL, '2018-08-09 21:36:55'),
(16, 7, '127.0.0.1', NULL, '2018-08-09 21:40:32'),
(17, 7, '127.0.0.1', NULL, '2018-08-09 21:44:13'),
(18, 7, '127.0.0.1', NULL, '2018-08-09 21:49:30'),
(19, 7, '127.0.0.1', NULL, '2018-08-09 21:50:17'),
(20, 7, '127.0.0.1', NULL, '2018-08-09 21:50:30'),
(21, 7, '127.0.0.1', NULL, '2018-08-09 22:17:58'),
(22, 7, '127.0.0.1', NULL, '2018-08-09 22:18:10'),
(23, 7, '127.0.0.1', NULL, '2018-08-09 22:22:11'),
(24, 7, '127.0.0.1', NULL, '2018-08-09 22:26:37'),
(25, 7, '127.0.0.1', NULL, '2018-08-09 22:29:15'),
(26, 7, '127.0.0.1', NULL, '2018-08-09 22:39:29'),
(27, 7, '127.0.0.1', '2018-08-09 20:45:12', '2018-08-09 23:44:45'),
(28, 7, '127.0.0.1', '2018-08-09 21:01:25', '2018-08-10 00:00:35'),
(29, 7, '127.0.0.1', '2018-08-09 21:06:34', '2018-08-10 00:06:08'),
(30, 7, '127.0.0.1', '2018-08-09 21:15:54', '2018-08-10 00:15:32'),
(31, 7, '127.0.0.1', '2018-08-09 21:18:14', '2018-08-10 00:17:40'),
(32, 8, '127.0.0.1', '2018-08-09 21:32:53', '2018-08-10 00:32:06'),
(33, 7, '127.0.0.1', NULL, '2018-08-10 00:50:39'),
(34, 7, '127.0.0.1', NULL, '2018-08-10 00:52:06'),
(35, 7, '127.0.0.1', '2018-08-11 13:49:19', '2018-08-11 16:48:53'),
(36, 7, '127.0.0.1', '2018-08-11 13:51:19', '2018-08-11 16:50:56'),
(37, 7, '127.0.0.1', NULL, '2018-08-11 16:52:25'),
(38, 7, '127.0.0.1', NULL, '2018-08-26 02:10:05'),
(39, 7, '127.0.0.1', NULL, '2018-08-26 02:12:08'),
(40, 7, '127.0.0.1', '2018-08-25 23:14:32', '2018-08-26 02:13:45'),
(41, 7, '127.0.0.1', '2018-08-25 23:15:52', '2018-08-26 02:15:26'),
(42, 7, '127.0.0.1', '2018-08-25 23:17:24', '2018-08-26 02:16:49'),
(43, 7, '127.0.0.1', '2018-08-25 23:19:32', '2018-08-26 02:18:43');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD PRIMARY KEY (`idaddress`),
  ADD KEY `fk_addresses_persons_idx` (`idperson`);

--
-- Indexes for table `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD PRIMARY KEY (`idcart`),
  ADD KEY `FK_carts_users_idx` (`iduser`);

--
-- Indexes for table `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  ADD PRIMARY KEY (`idcartproduct`),
  ADD KEY `FK_cartsproducts_carts_idx` (`idcart`),
  ADD KEY `FK_cartsproducts_products_idx` (`idproduct`);

--
-- Indexes for table `tb_categories`
--
ALTER TABLE `tb_categories`
  ADD PRIMARY KEY (`idcategory`);

--
-- Indexes for table `tb_orders`
--
ALTER TABLE `tb_orders`
  ADD PRIMARY KEY (`idorder`),
  ADD KEY `FK_orders_users_idx` (`iduser`),
  ADD KEY `fk_orders_ordersstatus_idx` (`idstatus`),
  ADD KEY `fk_orders_carts_idx` (`idcart`),
  ADD KEY `fk_orders_addresses_idx` (`idaddress`);

--
-- Indexes for table `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  ADD PRIMARY KEY (`idstatus`);

--
-- Indexes for table `tb_persons`
--
ALTER TABLE `tb_persons`
  ADD PRIMARY KEY (`idperson`);

--
-- Indexes for table `tb_products`
--
ALTER TABLE `tb_products`
  ADD PRIMARY KEY (`idproduct`);

--
-- Indexes for table `tb_productscategories`
--
ALTER TABLE `tb_productscategories`
  ADD PRIMARY KEY (`idcategory`,`idproduct`),
  ADD KEY `fk_productscategories_products_idx` (`idproduct`);

--
-- Indexes for table `tb_users`
--
ALTER TABLE `tb_users`
  ADD PRIMARY KEY (`iduser`),
  ADD KEY `FK_users_persons_idx` (`idperson`);

--
-- Indexes for table `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  ADD PRIMARY KEY (`idlog`),
  ADD KEY `fk_userslogs_users_idx` (`iduser`);

--
-- Indexes for table `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  ADD PRIMARY KEY (`idrecovery`),
  ADD KEY `fk_userspasswordsrecoveries_users_idx` (`iduser`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_addresses`
--
ALTER TABLE `tb_addresses`
  MODIFY `idaddress` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tb_carts`
--
ALTER TABLE `tb_carts`
  MODIFY `idcart` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  MODIFY `idcartproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT for table `tb_categories`
--
ALTER TABLE `tb_categories`
  MODIFY `idcategory` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tb_orders`
--
ALTER TABLE `tb_orders`
  MODIFY `idorder` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  MODIFY `idstatus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tb_persons`
--
ALTER TABLE `tb_persons`
  MODIFY `idperson` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `tb_products`
--
ALTER TABLE `tb_products`
  MODIFY `idproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `tb_users`
--
ALTER TABLE `tb_users`
  MODIFY `iduser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  MODIFY `idlog` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  MODIFY `idrecovery` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD CONSTRAINT `fk_addresses_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD CONSTRAINT `fk_carts_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  ADD CONSTRAINT `fk_cartsproducts_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_cartsproducts_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_orders`
--
ALTER TABLE `tb_orders`
  ADD CONSTRAINT `fk_orders_addresses` FOREIGN KEY (`idaddress`) REFERENCES `tb_addresses` (`idaddress`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_ordersstatus` FOREIGN KEY (`idstatus`) REFERENCES `tb_ordersstatus` (`idstatus`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_productscategories`
--
ALTER TABLE `tb_productscategories`
  ADD CONSTRAINT `fk_productscategories_categories` FOREIGN KEY (`idcategory`) REFERENCES `tb_categories` (`idcategory`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_productscategories_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_users`
--
ALTER TABLE `tb_users`
  ADD CONSTRAINT `fk_users_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  ADD CONSTRAINT `fk_userslogs_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  ADD CONSTRAINT `fk_userspasswordsrecoveries_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
