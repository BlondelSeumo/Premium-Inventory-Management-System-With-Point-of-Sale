-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : lun. 17 mai 2021 à 17:49
-- Version du serveur :  10.4.11-MariaDB
-- Version de PHP : 7.3.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `stocky_seed`
--

-- --------------------------------------------------------

--
-- Structure de la table `adjustments`
--

CREATE TABLE `adjustments` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `Ref` varchar(192) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `items` double DEFAULT 0,
  `notes` text DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `adjustment_details`
--

CREATE TABLE `adjustment_details` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `adjustment_id` int(11) NOT NULL,
  `product_variant_id` int(11) DEFAULT NULL,
  `quantity` double NOT NULL,
  `type` varchar(192) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `brands`
--

CREATE TABLE `brands` (
  `id` int(11) NOT NULL,
  `name` varchar(192) NOT NULL,
  `description` varchar(192) DEFAULT NULL,
  `image` varchar(192) DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `code` varchar(192) NOT NULL,
  `name` varchar(192) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `clients`
--

CREATE TABLE `clients` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` int(11) NOT NULL,
  `email` varchar(192) NOT NULL,
  `country` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `adresse` varchar(255) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `clients`
--

INSERT INTO `clients` (`id`, `name`, `code`, `email`, `country`, `city`, `phone`, `adresse`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'walk-in-customer', 1, 'walk-in-customer@example.com', 'bangladesh', 'dhaka', '123456780', 'N45 , Dhaka', NULL, '2021-05-17 14:48:08.000000', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `currencies`
--

CREATE TABLE `currencies` (
  `id` int(11) NOT NULL,
  `code` varchar(192) NOT NULL,
  `name` varchar(192) NOT NULL,
  `symbol` varchar(192) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `currencies`
--

INSERT INTO `currencies` (`id`, `code`, `name`, `symbol`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'USD', 'US Dollar', '$', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `expenses`
--

CREATE TABLE `expenses` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `Ref` varchar(192) NOT NULL,
  `user_id` int(11) NOT NULL,
  `expense_category_id` int(11) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `details` varchar(192) NOT NULL,
  `amount` double NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `expense_categories`
--

CREATE TABLE `expense_categories` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(192) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2021_03_08_020247_create_adjustment_details_table', 1),
(2, '2021_03_08_020247_create_adjustments_table', 1),
(3, '2021_03_08_020247_create_brands_table', 1),
(4, '2021_03_08_020247_create_categories_table', 1),
(5, '2021_03_08_020247_create_clients_table', 1),
(6, '2021_03_08_020247_create_currencies_table', 1),
(7, '2021_03_08_020247_create_expense_categories_table', 1),
(8, '2021_03_08_020247_create_expenses_table', 1),
(9, '2021_03_08_020247_create_password_resets_table', 1),
(10, '2021_03_08_020247_create_payment_purchase_returns_table', 1),
(11, '2021_03_08_020247_create_payment_purchases_table', 1),
(12, '2021_03_08_020247_create_payment_sale_returns_table', 1),
(13, '2021_03_08_020247_create_payment_sales_table', 1),
(14, '2021_03_08_020247_create_payment_with_credit_card_table', 1),
(15, '2021_03_08_020247_create_permission_role_table', 1),
(16, '2021_03_08_020247_create_permissions_table', 1),
(17, '2021_03_08_020247_create_product_variants_table', 1),
(18, '2021_03_08_020247_create_product_warehouse_table', 1),
(19, '2021_03_08_020247_create_products_table', 1),
(20, '2021_03_08_020247_create_providers_table', 1),
(21, '2021_03_08_020247_create_purchase_details_table', 1),
(22, '2021_03_08_020247_create_purchase_return_details_table', 1),
(23, '2021_03_08_020247_create_purchase_returns_table', 1),
(24, '2021_03_08_020247_create_purchases_table', 1),
(25, '2021_03_08_020247_create_quotation_details_table', 1),
(26, '2021_03_08_020247_create_quotations_table', 1),
(27, '2021_03_08_020247_create_role_user_table', 1),
(28, '2021_03_08_020247_create_roles_table', 1),
(29, '2021_03_08_020247_create_sale_details_table', 1),
(30, '2021_03_08_020247_create_sale_return_details_table', 1),
(31, '2021_03_08_020247_create_sale_returns_table', 1),
(32, '2021_03_08_020247_create_sales_table', 1),
(33, '2021_03_08_020247_create_serveurs_table', 1),
(34, '2021_03_08_020247_create_settings_table', 1),
(35, '2021_03_08_020247_create_transfer_details_table', 1),
(36, '2021_03_08_020247_create_transfers_table', 1),
(37, '2021_03_08_020247_create_units_table', 1),
(38, '2021_03_08_020247_create_users_table', 1),
(39, '2021_03_08_020247_create_warehouses_table', 1),
(40, '2021_03_08_020248_add_status_to_roles_table', 1),
(41, '2021_03_08_020251_add_foreign_keys_to_adjustment_details_table', 1),
(42, '2021_03_08_020251_add_foreign_keys_to_adjustments_table', 1),
(43, '2021_03_08_020251_add_foreign_keys_to_expense_categories_table', 1),
(44, '2021_03_08_020251_add_foreign_keys_to_expenses_table', 1),
(45, '2021_03_08_020251_add_foreign_keys_to_payment_purchase_returns_table', 1),
(46, '2021_03_08_020251_add_foreign_keys_to_payment_purchases_table', 1),
(47, '2021_03_08_020251_add_foreign_keys_to_payment_sale_returns_table', 1),
(48, '2021_03_08_020251_add_foreign_keys_to_payment_sales_table', 1),
(49, '2021_03_08_020251_add_foreign_keys_to_permission_role_table', 1),
(50, '2021_03_08_020251_add_foreign_keys_to_product_variants_table', 1),
(51, '2021_03_08_020251_add_foreign_keys_to_product_warehouse_table', 1),
(52, '2021_03_08_020251_add_foreign_keys_to_products_table', 1),
(53, '2021_03_08_020251_add_foreign_keys_to_purchase_details_table', 1),
(54, '2021_03_08_020251_add_foreign_keys_to_purchase_return_details_table', 1),
(55, '2021_03_08_020251_add_foreign_keys_to_purchase_returns_table', 1),
(56, '2021_03_08_020251_add_foreign_keys_to_purchases_table', 1),
(57, '2021_03_08_020251_add_foreign_keys_to_quotation_details_table', 1),
(58, '2021_03_08_020251_add_foreign_keys_to_quotations_table', 1),
(59, '2021_03_08_020251_add_foreign_keys_to_role_user_table', 1),
(60, '2021_03_08_020251_add_foreign_keys_to_sale_details_table', 1),
(61, '2021_03_08_020251_add_foreign_keys_to_sale_return_details_table', 1),
(62, '2021_03_08_020251_add_foreign_keys_to_sale_returns_table', 1),
(63, '2021_03_08_020251_add_foreign_keys_to_sales_table', 1),
(64, '2021_03_08_020251_add_foreign_keys_to_settings_table', 1),
(65, '2021_03_08_020251_add_foreign_keys_to_transfer_details_table', 1),
(66, '2021_03_08_020251_add_foreign_keys_to_transfers_table', 1),
(67, '2021_03_08_020251_add_foreign_keys_to_units_table', 1),
(68, '2021_04_11_221536_add_footer_to_settings_table', 1),
(69, '2021_04_30_040505_add_devopped_by_to_settings', 1),
(70, '2021_05_07_140933_add_client_id_to_settings_table', 1),
(71, '2021_05_07_141034_add_warehouse_id_to_settings_table', 1),
(72, '2021_05_07_141303_add_foreign_keys_clients_to_settings', 1),
(73, '2016_06_01_000001_create_oauth_auth_codes_table', 2),
(74, '2016_06_01_000002_create_oauth_access_tokens_table', 2),
(75, '2016_06_01_000003_create_oauth_refresh_tokens_table', 2),
(76, '2016_06_01_000004_create_oauth_clients_table', 2),
(77, '2016_06_01_000005_create_oauth_personal_access_clients_table', 2);

-- --------------------------------------------------------

--
-- Structure de la table `oauth_access_tokens`
--

CREATE TABLE `oauth_access_tokens` (
  `id` varchar(100) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `client_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `scopes` text DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `oauth_auth_codes`
--

CREATE TABLE `oauth_auth_codes` (
  `id` varchar(100) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `client_id` bigint(20) UNSIGNED NOT NULL,
  `scopes` text DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `oauth_clients`
--

CREATE TABLE `oauth_clients` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `secret` varchar(100) DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `redirect` text NOT NULL,
  `personal_access_client` tinyint(1) NOT NULL,
  `password_client` tinyint(1) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `oauth_clients`
--

INSERT INTO `oauth_clients` (`id`, `user_id`, `name`, `secret`, `provider`, `redirect`, `personal_access_client`, `password_client`, `revoked`, `created_at`, `updated_at`) VALUES
(1, NULL, 'Stocky Personal Access Client', 'o8W0EuZWB2wtGYJ0sSLwTBAmNAZhYy7lDXMexTgO', NULL, 'http://localhost', 1, 0, 0, '2021-05-17 14:46:02', '2021-05-17 14:46:02'),
(2, NULL, 'Stocky Password Grant Client', 'v6TmqegNMl6XvT7Md957xPnAZGFf3G3jWAdZH06i', 'users', 'http://localhost', 0, 1, 0, '2021-05-17 14:46:03', '2021-05-17 14:46:03');

-- --------------------------------------------------------

--
-- Structure de la table `oauth_personal_access_clients`
--

CREATE TABLE `oauth_personal_access_clients` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `client_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `oauth_personal_access_clients`
--

INSERT INTO `oauth_personal_access_clients` (`id`, `client_id`, `created_at`, `updated_at`) VALUES
(1, 1, '2021-05-17 14:46:03', '2021-05-17 14:46:03');

-- --------------------------------------------------------

--
-- Structure de la table `oauth_refresh_tokens`
--

CREATE TABLE `oauth_refresh_tokens` (
  `id` varchar(100) NOT NULL,
  `access_token_id` varchar(100) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `payment_purchases`
--

CREATE TABLE `payment_purchases` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `Ref` varchar(192) NOT NULL,
  `purchase_id` int(11) NOT NULL,
  `montant` double NOT NULL,
  `Reglement` varchar(192) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `payment_purchase_returns`
--

CREATE TABLE `payment_purchase_returns` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `Ref` varchar(192) NOT NULL,
  `purchase_return_id` int(11) NOT NULL,
  `montant` double NOT NULL,
  `Reglement` varchar(191) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `payment_sales`
--

CREATE TABLE `payment_sales` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `Ref` varchar(192) NOT NULL,
  `sale_id` int(11) NOT NULL,
  `montant` double NOT NULL,
  `Reglement` varchar(192) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `payment_sale_returns`
--

CREATE TABLE `payment_sale_returns` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `Ref` varchar(192) NOT NULL,
  `sale_return_id` int(11) NOT NULL,
  `montant` double NOT NULL,
  `Reglement` varchar(191) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `payment_with_credit_card`
--

CREATE TABLE `payment_with_credit_card` (
  `id` int(11) NOT NULL,
  `payment_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `customer_stripe_id` varchar(192) NOT NULL,
  `charge_id` varchar(192) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL,
  `name` varchar(192) NOT NULL,
  `label` varchar(192) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `label`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'users_view', NULL, NULL, NULL, NULL, NULL),
(2, 'users_edit', NULL, NULL, NULL, NULL, NULL),
(3, 'record_view', NULL, NULL, NULL, NULL, NULL),
(4, 'users_delete', NULL, NULL, NULL, NULL, NULL),
(5, 'users_add', NULL, NULL, NULL, NULL, NULL),
(6, 'permissions_edit', NULL, NULL, NULL, NULL, NULL),
(7, 'permissions_view', NULL, NULL, NULL, NULL, NULL),
(8, 'permissions_delete', NULL, NULL, NULL, NULL, NULL),
(9, 'permissions_add', NULL, NULL, NULL, NULL, NULL),
(10, 'products_delete', NULL, NULL, NULL, NULL, NULL),
(11, 'products_view', NULL, NULL, NULL, NULL, NULL),
(12, 'barcode_view', NULL, NULL, NULL, NULL, NULL),
(13, 'products_edit', NULL, NULL, NULL, NULL, NULL),
(14, 'products_add', NULL, NULL, NULL, NULL, NULL),
(15, 'expense_add', NULL, NULL, NULL, NULL, NULL),
(16, 'expense_delete', NULL, NULL, NULL, NULL, NULL),
(17, 'expense_edit', NULL, NULL, NULL, NULL, NULL),
(18, 'expense_view', NULL, NULL, NULL, NULL, NULL),
(19, 'transfer_delete', NULL, NULL, NULL, NULL, NULL),
(20, 'transfer_add', NULL, NULL, NULL, NULL, NULL),
(21, 'transfer_view', NULL, NULL, NULL, NULL, NULL),
(22, 'transfer_edit', NULL, NULL, NULL, NULL, NULL),
(23, 'adjustment_delete', NULL, NULL, NULL, NULL, NULL),
(24, 'adjustment_add', NULL, NULL, NULL, NULL, NULL),
(25, 'adjustment_edit', NULL, NULL, NULL, NULL, NULL),
(26, 'adjustment_view', NULL, NULL, NULL, NULL, NULL),
(27, 'Sales_edit', NULL, NULL, NULL, NULL, NULL),
(28, 'Sales_view', NULL, NULL, NULL, NULL, NULL),
(29, 'Sales_delete', NULL, NULL, NULL, NULL, NULL),
(30, 'Sales_add', NULL, NULL, NULL, NULL, NULL),
(31, 'Purchases_edit', NULL, NULL, NULL, NULL, NULL),
(32, 'Purchases_view', NULL, NULL, NULL, NULL, NULL),
(33, 'Purchases_delete', NULL, NULL, NULL, NULL, NULL),
(34, 'Purchases_add', NULL, NULL, NULL, NULL, NULL),
(35, 'Quotations_edit', NULL, NULL, NULL, NULL, NULL),
(36, 'Quotations_delete', NULL, NULL, NULL, NULL, NULL),
(37, 'Quotations_add', NULL, NULL, NULL, NULL, NULL),
(38, 'Quotations_view', NULL, NULL, NULL, NULL, NULL),
(39, 'payment_sales_delete', NULL, NULL, NULL, NULL, NULL),
(40, 'payment_sales_add', NULL, NULL, NULL, NULL, NULL),
(41, 'payment_sales_edit', NULL, NULL, NULL, NULL, NULL),
(42, 'payment_sales_view', NULL, NULL, NULL, NULL, NULL),
(43, 'Purchase_Returns_delete', NULL, NULL, NULL, NULL, NULL),
(44, 'Purchase_Returns_add', NULL, NULL, NULL, NULL, NULL),
(45, 'Purchase_Returns_view', NULL, NULL, NULL, NULL, NULL),
(46, 'Purchase_Returns_edit', NULL, NULL, NULL, NULL, NULL),
(47, 'Sale_Returns_delete', NULL, NULL, NULL, NULL, NULL),
(48, 'Sale_Returns_add', NULL, NULL, NULL, NULL, NULL),
(49, 'Sale_Returns_edit', NULL, NULL, NULL, NULL, NULL),
(50, 'Sale_Returns_view', NULL, NULL, NULL, NULL, NULL),
(51, 'payment_purchases_edit', NULL, NULL, NULL, NULL, NULL),
(52, 'payment_purchases_view', NULL, NULL, NULL, NULL, NULL),
(53, 'payment_purchases_delete', NULL, NULL, NULL, NULL, NULL),
(54, 'payment_purchases_add', NULL, NULL, NULL, NULL, NULL),
(55, 'payment_returns_edit', NULL, NULL, NULL, NULL, NULL),
(56, 'payment_returns_view', NULL, NULL, NULL, NULL, NULL),
(57, 'payment_returns_delete', NULL, NULL, NULL, NULL, NULL),
(58, 'payment_returns_add', NULL, NULL, NULL, NULL, NULL),
(59, 'Customers_edit', NULL, NULL, NULL, NULL, NULL),
(60, 'Customers_view', NULL, NULL, NULL, NULL, NULL),
(61, 'Customers_delete', NULL, NULL, NULL, NULL, NULL),
(62, 'Customers_add', NULL, NULL, NULL, NULL, NULL),
(63, 'unit', NULL, NULL, NULL, NULL, NULL),
(64, 'currency', NULL, NULL, NULL, NULL, NULL),
(65, 'category', NULL, NULL, NULL, NULL, NULL),
(66, 'backup', NULL, NULL, NULL, NULL, NULL),
(67, 'warehouse', NULL, NULL, NULL, NULL, NULL),
(68, 'brand', NULL, NULL, NULL, NULL, NULL),
(69, 'setting_system', NULL, NULL, NULL, NULL, NULL),
(70, 'Warehouse_report', NULL, NULL, NULL, NULL, NULL),
(72, 'Reports_quantity_alerts', NULL, NULL, NULL, NULL, NULL),
(73, 'Reports_profit', NULL, NULL, NULL, NULL, NULL),
(74, 'Reports_suppliers', NULL, NULL, NULL, NULL, NULL),
(75, 'Reports_customers', NULL, NULL, NULL, NULL, NULL),
(76, 'Reports_purchase', NULL, NULL, NULL, NULL, NULL),
(77, 'Reports_sales', NULL, NULL, NULL, NULL, NULL),
(78, 'Reports_payments_purchase_Return', NULL, NULL, NULL, NULL, NULL),
(79, 'Reports_payments_Sale_Returns', NULL, NULL, NULL, NULL, NULL),
(80, 'Reports_payments_Purchases', NULL, NULL, NULL, NULL, NULL),
(81, 'Reports_payments_Sales', NULL, NULL, NULL, NULL, NULL),
(82, 'Suppliers_delete', NULL, NULL, NULL, NULL, NULL),
(83, 'Suppliers_add', NULL, NULL, NULL, NULL, NULL),
(84, 'Suppliers_edit', NULL, NULL, NULL, NULL, NULL),
(85, 'Suppliers_view', NULL, NULL, NULL, NULL, NULL),
(86, 'Pos_view', NULL, NULL, NULL, NULL, NULL),
(87, 'product_import', NULL, NULL, NULL, NULL, NULL),
(88, 'customers_import', NULL, NULL, NULL, NULL, NULL),
(89, 'Suppliers_import', NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `permission_role`
--

CREATE TABLE `permission_role` (
  `id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `permission_role`
--

INSERT INTO `permission_role` (`id`, `permission_id`, `role_id`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1),
(6, 6, 1),
(7, 7, 1),
(8, 8, 1),
(9, 9, 1),
(10, 10, 1),
(11, 11, 1),
(12, 12, 1),
(13, 13, 1),
(14, 14, 1),
(15, 15, 1),
(16, 16, 1),
(17, 17, 1),
(18, 18, 1),
(19, 19, 1),
(20, 20, 1),
(21, 21, 1),
(22, 22, 1),
(23, 23, 1),
(24, 24, 1),
(25, 25, 1),
(26, 26, 1),
(27, 27, 1),
(28, 28, 1),
(29, 29, 1),
(30, 30, 1),
(31, 31, 1),
(32, 32, 1),
(33, 33, 1),
(34, 34, 1),
(35, 35, 1),
(36, 36, 1),
(37, 37, 1),
(38, 38, 1),
(39, 39, 1),
(40, 40, 1),
(41, 41, 1),
(42, 42, 1),
(43, 43, 1),
(44, 44, 1),
(45, 45, 1),
(46, 46, 1),
(47, 47, 1),
(48, 48, 1),
(49, 49, 1),
(50, 50, 1),
(51, 51, 1),
(52, 52, 1),
(53, 53, 1),
(54, 54, 1),
(55, 55, 1),
(56, 56, 1),
(57, 57, 1),
(58, 58, 1),
(59, 59, 1),
(60, 60, 1),
(61, 61, 1),
(62, 62, 1),
(63, 63, 1),
(64, 64, 1),
(65, 65, 1),
(66, 66, 1),
(67, 67, 1),
(68, 68, 1),
(69, 69, 1),
(70, 70, 1),
(72, 72, 1),
(73, 73, 1),
(74, 74, 1),
(75, 75, 1),
(76, 76, 1),
(77, 77, 1),
(78, 78, 1),
(79, 79, 1),
(80, 80, 1),
(81, 81, 1),
(82, 82, 1),
(83, 83, 1),
(84, 84, 1),
(85, 85, 1),
(86, 86, 1),
(87, 87, 1),
(88, 88, 1),
(89, 89, 1);

-- --------------------------------------------------------

--
-- Structure de la table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `code` varchar(192) NOT NULL,
  `Type_barcode` varchar(192) NOT NULL,
  `name` varchar(192) NOT NULL,
  `cost` double NOT NULL,
  `price` double NOT NULL,
  `category_id` int(11) NOT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `unit_id` int(11) DEFAULT NULL,
  `unit_sale_id` int(11) DEFAULT NULL,
  `unit_purchase_id` int(11) DEFAULT NULL,
  `TaxNet` double DEFAULT 0,
  `tax_method` varchar(192) DEFAULT '1',
  `image` text DEFAULT NULL,
  `note` text DEFAULT NULL,
  `stock_alert` double DEFAULT 0,
  `is_variant` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `product_variants`
--

CREATE TABLE `product_variants` (
  `id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `name` varchar(192) DEFAULT NULL,
  `qty` decimal(8,2) DEFAULT 0.00,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `product_warehouse`
--

CREATE TABLE `product_warehouse` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `product_variant_id` int(11) DEFAULT NULL,
  `qte` double NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `providers`
--

CREATE TABLE `providers` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` int(11) NOT NULL,
  `email` varchar(192) NOT NULL,
  `phone` varchar(192) NOT NULL,
  `country` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `adresse` varchar(255) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `purchases`
--

CREATE TABLE `purchases` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `Ref` varchar(192) NOT NULL,
  `date` date NOT NULL,
  `provider_id` int(11) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `tax_rate` double DEFAULT 0,
  `TaxNet` double DEFAULT 0,
  `discount` double DEFAULT 0,
  `shipping` double DEFAULT 0,
  `GrandTotal` double NOT NULL,
  `paid_amount` double NOT NULL DEFAULT 0,
  `statut` varchar(255) NOT NULL,
  `payment_statut` varchar(192) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `purchase_details`
--

CREATE TABLE `purchase_details` (
  `id` int(11) NOT NULL,
  `cost` double NOT NULL,
  `TaxNet` double DEFAULT 0,
  `tax_method` varchar(192) DEFAULT '1',
  `discount` double DEFAULT 0,
  `discount_method` varchar(192) DEFAULT '1',
  `purchase_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_variant_id` int(11) DEFAULT NULL,
  `total` double NOT NULL,
  `quantity` double NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `purchase_returns`
--

CREATE TABLE `purchase_returns` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `Ref` varchar(192) NOT NULL,
  `provider_id` int(11) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `tax_rate` double DEFAULT 0,
  `TaxNet` double DEFAULT 0,
  `discount` double DEFAULT 0,
  `shipping` double DEFAULT 0,
  `GrandTotal` double NOT NULL,
  `paid_amount` double NOT NULL DEFAULT 0,
  `payment_statut` varchar(192) NOT NULL,
  `statut` varchar(192) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `purchase_return_details`
--

CREATE TABLE `purchase_return_details` (
  `id` int(11) NOT NULL,
  `cost` decimal(10,0) NOT NULL,
  `TaxNet` double DEFAULT 0,
  `tax_method` varchar(192) DEFAULT '1',
  `discount` double DEFAULT 0,
  `discount_method` varchar(192) DEFAULT '1',
  `total` double NOT NULL,
  `quantity` double NOT NULL,
  `purchase_return_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_variant_id` int(11) DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `quotations`
--

CREATE TABLE `quotations` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `Ref` varchar(192) NOT NULL,
  `client_id` int(11) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `tax_rate` double DEFAULT 0,
  `TaxNet` double DEFAULT 0,
  `discount` double DEFAULT 0,
  `shipping` double DEFAULT 0,
  `GrandTotal` double NOT NULL,
  `statut` varchar(192) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `quotation_details`
--

CREATE TABLE `quotation_details` (
  `id` int(11) NOT NULL,
  `price` double NOT NULL,
  `TaxNet` double DEFAULT 0,
  `tax_method` varchar(192) DEFAULT '1',
  `discount` double DEFAULT 0,
  `discount_method` varchar(192) DEFAULT '1',
  `total` double NOT NULL,
  `quantity` double NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_variant_id` int(11) DEFAULT NULL,
  `quotation_id` int(11) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(192) NOT NULL,
  `label` varchar(192) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `roles`
--

INSERT INTO `roles` (`id`, `name`, `label`, `description`, `created_at`, `updated_at`, `deleted_at`, `status`) VALUES
(1, 'Owner', 'Owner', 'Owner', NULL, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Structure de la table `role_user`
--

CREATE TABLE `role_user` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `role_user`
--

INSERT INTO `role_user` (`id`, `user_id`, `role_id`, `created_at`, `updated_at`) VALUES
(1, 1, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `sales`
--

CREATE TABLE `sales` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `Ref` varchar(192) NOT NULL,
  `is_pos` tinyint(1) DEFAULT 0,
  `client_id` int(11) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `tax_rate` double DEFAULT 0,
  `TaxNet` double DEFAULT 0,
  `discount` double DEFAULT 0,
  `shipping` double DEFAULT 0,
  `GrandTotal` double NOT NULL DEFAULT 0,
  `paid_amount` double NOT NULL DEFAULT 0,
  `payment_statut` varchar(192) NOT NULL,
  `statut` varchar(255) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `sale_details`
--

CREATE TABLE `sale_details` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `sale_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_variant_id` int(11) DEFAULT NULL,
  `price` double NOT NULL,
  `TaxNet` double DEFAULT NULL,
  `tax_method` varchar(192) DEFAULT '1',
  `discount` double DEFAULT NULL,
  `discount_method` varchar(192) DEFAULT '1',
  `total` double NOT NULL,
  `quantity` double NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `sale_returns`
--

CREATE TABLE `sale_returns` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `Ref` varchar(192) NOT NULL,
  `client_id` int(11) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `tax_rate` double DEFAULT 0,
  `TaxNet` double DEFAULT 0,
  `discount` double DEFAULT 0,
  `shipping` double DEFAULT 0,
  `GrandTotal` double NOT NULL,
  `paid_amount` double NOT NULL DEFAULT 0,
  `payment_statut` varchar(192) NOT NULL,
  `statut` varchar(192) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `sale_return_details`
--

CREATE TABLE `sale_return_details` (
  `id` int(11) NOT NULL,
  `sale_return_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `price` double NOT NULL,
  `TaxNet` double DEFAULT 0,
  `tax_method` varchar(192) DEFAULT '1',
  `discount` double DEFAULT 0,
  `discount_method` varchar(192) DEFAULT '1',
  `product_variant_id` int(11) DEFAULT NULL,
  `quantity` double NOT NULL,
  `total` double NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `servers`
--

CREATE TABLE `servers` (
  `id` int(11) NOT NULL,
  `host` varchar(191) NOT NULL,
  `port` int(11) NOT NULL,
  `username` varchar(191) NOT NULL,
  `password` varchar(191) NOT NULL,
  `encryption` varchar(191) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `servers`
--

INSERT INTO `servers` (`id`, `host`, `port`, `username`, `password`, `encryption`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'mailtrap.io', 2525, 'test', 'test', 'tls', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `email` varchar(191) NOT NULL,
  `currency_id` int(11) DEFAULT NULL,
  `CompanyName` varchar(255) NOT NULL,
  `CompanyPhone` varchar(255) NOT NULL,
  `CompanyAdress` varchar(255) NOT NULL,
  `logo` varchar(191) DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `footer` varchar(192) NOT NULL DEFAULT 'Stocky - Ultimate Inventory With POS',
  `developed_by` varchar(192) NOT NULL DEFAULT 'Stocky',
  `client_id` int(11) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `settings`
--

INSERT INTO `settings` (`id`, `email`, `currency_id`, `CompanyName`, `CompanyPhone`, `CompanyAdress`, `logo`, `created_at`, `updated_at`, `deleted_at`, `footer`, `developed_by`, `client_id`, `warehouse_id`) VALUES
(1, 'admin@example.com', 1, 'Stocky', '6315996770', '3618 Abia Martin Drive', 'logo-default.png', NULL, NULL, NULL, 'Stocky - Ultimate Inventory With POS', 'Stocky', 1, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `transfers`
--

CREATE TABLE `transfers` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `Ref` varchar(192) NOT NULL,
  `date` date NOT NULL,
  `from_warehouse_id` int(11) NOT NULL,
  `to_warehouse_id` int(11) NOT NULL,
  `items` double NOT NULL,
  `tax_rate` double DEFAULT 0,
  `TaxNet` double DEFAULT 0,
  `discount` double DEFAULT 0,
  `shipping` double DEFAULT 0,
  `GrandTotal` double NOT NULL DEFAULT 0,
  `statut` varchar(192) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `transfer_details`
--

CREATE TABLE `transfer_details` (
  `id` int(11) NOT NULL,
  `transfer_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_variant_id` int(11) DEFAULT NULL,
  `cost` double NOT NULL,
  `TaxNet` double DEFAULT NULL,
  `tax_method` varchar(192) DEFAULT '1',
  `discount` double DEFAULT NULL,
  `discount_method` varchar(192) DEFAULT '1',
  `quantity` double NOT NULL,
  `total` double NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `units`
--

CREATE TABLE `units` (
  `id` int(11) NOT NULL,
  `name` varchar(192) NOT NULL,
  `ShortName` varchar(192) NOT NULL,
  `base_unit` int(11) DEFAULT NULL,
  `operator` char(192) DEFAULT '*',
  `operator_value` double DEFAULT 1,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `username` varchar(192) NOT NULL,
  `email` varchar(192) NOT NULL,
  `password` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `phone` varchar(192) NOT NULL,
  `role_id` int(11) NOT NULL,
  `statut` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `firstname`, `lastname`, `username`, `email`, `password`, `avatar`, `phone`, `role_id`, `statut`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'William', 'Castillo', 'William Castillo', 'admin@example.com', '$2y$10$IFj6SwqC0Sxrsiv4YkCt.OJv1UV4mZrWuyLoRG7qt47mseP9mJ58u', 'no_avatar.png', '0123456789', 1, 1, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `warehouses`
--

CREATE TABLE `warehouses` (
  `id` int(11) NOT NULL,
  `name` varchar(192) NOT NULL,
  `city` varchar(192) DEFAULT NULL,
  `mobile` varchar(192) DEFAULT NULL,
  `zip` varchar(192) DEFAULT NULL,
  `email` varchar(192) DEFAULT NULL,
  `country` varchar(192) DEFAULT NULL,
  `created_at` timestamp(6) NULL DEFAULT NULL,
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `adjustments`
--
ALTER TABLE `adjustments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id_adjustment` (`user_id`),
  ADD KEY `warehouse_id_adjustment` (`warehouse_id`);

--
-- Index pour la table `adjustment_details`
--
ALTER TABLE `adjustment_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `adjust_product_id` (`product_id`),
  ADD KEY `adjust_adjustment_id` (`adjustment_id`),
  ADD KEY `adjust_product_variant` (`product_variant_id`);

--
-- Index pour la table `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `currencies`
--
ALTER TABLE `currencies`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `expenses`
--
ALTER TABLE `expenses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `expense_user_id` (`user_id`),
  ADD KEY `expense_category_id` (`expense_category_id`),
  ADD KEY `expense_warehouse_id` (`warehouse_id`);

--
-- Index pour la table `expense_categories`
--
ALTER TABLE `expense_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `expense_category_user_id` (`user_id`);

--
-- Index pour la table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `oauth_access_tokens`
--
ALTER TABLE `oauth_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_access_tokens_user_id_index` (`user_id`);

--
-- Index pour la table `oauth_auth_codes`
--
ALTER TABLE `oauth_auth_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_auth_codes_user_id_index` (`user_id`);

--
-- Index pour la table `oauth_clients`
--
ALTER TABLE `oauth_clients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_clients_user_id_index` (`user_id`);

--
-- Index pour la table `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `oauth_refresh_tokens`
--
ALTER TABLE `oauth_refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`);

--
-- Index pour la table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `email` (`email`),
  ADD KEY `token` (`token`);

--
-- Index pour la table `payment_purchases`
--
ALTER TABLE `payment_purchases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id_payment_purchases` (`user_id`),
  ADD KEY `payments_purchase_id` (`purchase_id`);

--
-- Index pour la table `payment_purchase_returns`
--
ALTER TABLE `payment_purchase_returns`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id_payment_return_purchase` (`user_id`),
  ADD KEY `supplier_id_payment_return_purchase` (`purchase_return_id`);

--
-- Index pour la table `payment_sales`
--
ALTER TABLE `payment_sales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id_payments_sale` (`user_id`),
  ADD KEY `payment_sale_id` (`sale_id`);

--
-- Index pour la table `payment_sale_returns`
--
ALTER TABLE `payment_sale_returns`
  ADD PRIMARY KEY (`id`),
  ADD KEY `factures_sale_return_user_id` (`user_id`),
  ADD KEY `factures_sale_return` (`sale_return_id`);

--
-- Index pour la table `payment_with_credit_card`
--
ALTER TABLE `payment_with_credit_card`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `permission_role`
--
ALTER TABLE `permission_role`
  ADD PRIMARY KEY (`id`),
  ADD KEY `permission_role_permission_id` (`permission_id`),
  ADD KEY `permission_role_role_id` (`role_id`);

--
-- Index pour la table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `brand_id_products` (`brand_id`),
  ADD KEY `unit_id_products` (`unit_id`),
  ADD KEY `unit_id_sales` (`unit_sale_id`),
  ADD KEY `unit_purchase_products` (`unit_purchase_id`);

--
-- Index pour la table `product_variants`
--
ALTER TABLE `product_variants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id_variant` (`product_id`);

--
-- Index pour la table `product_warehouse`
--
ALTER TABLE `product_warehouse`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_warehouse_id` (`product_id`),
  ADD KEY `warehouse_id` (`warehouse_id`),
  ADD KEY `product_variant_id` (`product_variant_id`);

--
-- Index pour la table `providers`
--
ALTER TABLE `providers`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `purchases`
--
ALTER TABLE `purchases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id_purchases` (`user_id`),
  ADD KEY `provider_id` (`provider_id`),
  ADD KEY `warehouse_id_purchase` (`warehouse_id`);

--
-- Index pour la table `purchase_details`
--
ALTER TABLE `purchase_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `purchase_id` (`purchase_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `purchase_product_variant_id` (`product_variant_id`);

--
-- Index pour la table `purchase_returns`
--
ALTER TABLE `purchase_returns`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id_returns` (`user_id`),
  ADD KEY `provider_id_return` (`provider_id`),
  ADD KEY `purchase_return_warehouse_id` (`warehouse_id`);

--
-- Index pour la table `purchase_return_details`
--
ALTER TABLE `purchase_return_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `purchase_return_id_return` (`purchase_return_id`),
  ADD KEY `product_id_details_purchase_return` (`product_id`),
  ADD KEY `purchase_return_product_variant_id` (`product_variant_id`);

--
-- Index pour la table `quotations`
--
ALTER TABLE `quotations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id_quotation` (`user_id`),
  ADD KEY `client_id_quotation` (`client_id`),
  ADD KEY `warehouse_id_quotation` (`warehouse_id`);

--
-- Index pour la table `quotation_details`
--
ALTER TABLE `quotation_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id_quotation_details` (`product_id`),
  ADD KEY `quote_product_variant_id` (`product_variant_id`),
  ADD KEY `quotation_id` (`quotation_id`);

--
-- Index pour la table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `role_user`
--
ALTER TABLE `role_user`
  ADD PRIMARY KEY (`id`),
  ADD KEY `role_user_user_id` (`user_id`),
  ADD KEY `role_user_role_id` (`role_id`);

--
-- Index pour la table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id_sales` (`user_id`),
  ADD KEY `sale_client_id` (`client_id`),
  ADD KEY `warehouse_id_sale` (`warehouse_id`);

--
-- Index pour la table `sale_details`
--
ALTER TABLE `sale_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Details_Sale_id` (`sale_id`),
  ADD KEY `sale_product_id` (`product_id`),
  ADD KEY `sale_product_variant_id` (`product_variant_id`);

--
-- Index pour la table `sale_returns`
--
ALTER TABLE `sale_returns`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id_returns` (`user_id`),
  ADD KEY `client_id_returns` (`client_id`),
  ADD KEY `warehouse_id_sale_return_id` (`warehouse_id`);

--
-- Index pour la table `sale_return_details`
--
ALTER TABLE `sale_return_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `return_id` (`sale_return_id`),
  ADD KEY `product_id_details_returns` (`product_id`),
  ADD KEY `sale_return_id_product_variant_id` (`product_variant_id`);

--
-- Index pour la table `servers`
--
ALTER TABLE `servers`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `currency_id` (`currency_id`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `warehouse_id` (`warehouse_id`);

--
-- Index pour la table `transfers`
--
ALTER TABLE `transfers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id_transfers` (`user_id`),
  ADD KEY `from_warehouse_id` (`from_warehouse_id`),
  ADD KEY `to_warehouse_id` (`to_warehouse_id`);

--
-- Index pour la table `transfer_details`
--
ALTER TABLE `transfer_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transfer_id` (`transfer_id`),
  ADD KEY `product_id_transfers` (`product_id`),
  ADD KEY `product_variant_id_transfer` (`product_variant_id`);

--
-- Index pour la table `units`
--
ALTER TABLE `units`
  ADD PRIMARY KEY (`id`),
  ADD KEY `base_unit` (`base_unit`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `warehouses`
--
ALTER TABLE `warehouses`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `adjustments`
--
ALTER TABLE `adjustments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `adjustment_details`
--
ALTER TABLE `adjustment_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `brands`
--
ALTER TABLE `brands`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `clients`
--
ALTER TABLE `clients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `currencies`
--
ALTER TABLE `currencies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `expense_categories`
--
ALTER TABLE `expense_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT pour la table `oauth_clients`
--
ALTER TABLE `oauth_clients`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `payment_purchases`
--
ALTER TABLE `payment_purchases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `payment_purchase_returns`
--
ALTER TABLE `payment_purchase_returns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `payment_sales`
--
ALTER TABLE `payment_sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `payment_sale_returns`
--
ALTER TABLE `payment_sale_returns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `payment_with_credit_card`
--
ALTER TABLE `payment_with_credit_card`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;

--
-- AUTO_INCREMENT pour la table `permission_role`
--
ALTER TABLE `permission_role`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;

--
-- AUTO_INCREMENT pour la table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `product_variants`
--
ALTER TABLE `product_variants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `product_warehouse`
--
ALTER TABLE `product_warehouse`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `providers`
--
ALTER TABLE `providers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `purchases`
--
ALTER TABLE `purchases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `purchase_details`
--
ALTER TABLE `purchase_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `purchase_returns`
--
ALTER TABLE `purchase_returns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `purchase_return_details`
--
ALTER TABLE `purchase_return_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `quotations`
--
ALTER TABLE `quotations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `quotation_details`
--
ALTER TABLE `quotation_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `role_user`
--
ALTER TABLE `role_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `sale_details`
--
ALTER TABLE `sale_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `sale_returns`
--
ALTER TABLE `sale_returns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `sale_return_details`
--
ALTER TABLE `sale_return_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `servers`
--
ALTER TABLE `servers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `transfers`
--
ALTER TABLE `transfers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `transfer_details`
--
ALTER TABLE `transfer_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `units`
--
ALTER TABLE `units`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `warehouses`
--
ALTER TABLE `warehouses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `adjustments`
--
ALTER TABLE `adjustments`
  ADD CONSTRAINT `user_id_adjustment` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `warehouse_id_adjustment` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`);

--
-- Contraintes pour la table `adjustment_details`
--
ALTER TABLE `adjustment_details`
  ADD CONSTRAINT `adjust_adjustment_id` FOREIGN KEY (`adjustment_id`) REFERENCES `adjustments` (`id`),
  ADD CONSTRAINT `adjust_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `adjust_product_variant` FOREIGN KEY (`product_variant_id`) REFERENCES `product_variants` (`id`);

--
-- Contraintes pour la table `expenses`
--
ALTER TABLE `expenses`
  ADD CONSTRAINT `expense_category_id` FOREIGN KEY (`expense_category_id`) REFERENCES `expense_categories` (`id`),
  ADD CONSTRAINT `expense_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `expense_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`);

--
-- Contraintes pour la table `expense_categories`
--
ALTER TABLE `expense_categories`
  ADD CONSTRAINT `expense_category_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `payment_purchases`
--
ALTER TABLE `payment_purchases`
  ADD CONSTRAINT `factures_purchase_id` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`),
  ADD CONSTRAINT `user_id_factures_achat` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `payment_purchase_returns`
--
ALTER TABLE `payment_purchase_returns`
  ADD CONSTRAINT `supplier_id_payment_return_purchase` FOREIGN KEY (`purchase_return_id`) REFERENCES `purchase_returns` (`id`),
  ADD CONSTRAINT `user_id_payment_return_purchase` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `payment_sales`
--
ALTER TABLE `payment_sales`
  ADD CONSTRAINT `facture_sale_id` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`),
  ADD CONSTRAINT `user_id_factures_ventes` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `payment_sale_returns`
--
ALTER TABLE `payment_sale_returns`
  ADD CONSTRAINT `factures_sale_return` FOREIGN KEY (`sale_return_id`) REFERENCES `sale_returns` (`id`),
  ADD CONSTRAINT `factures_sale_return_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `permission_role`
--
ALTER TABLE `permission_role`
  ADD CONSTRAINT `permission_role_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  ADD CONSTRAINT `permission_role_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Contraintes pour la table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `brand_id_products` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`),
  ADD CONSTRAINT `category_id` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `unit_id_products` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`),
  ADD CONSTRAINT `unit_id_sales` FOREIGN KEY (`unit_sale_id`) REFERENCES `units` (`id`),
  ADD CONSTRAINT `unit_purchase_products` FOREIGN KEY (`unit_purchase_id`) REFERENCES `units` (`id`);

--
-- Contraintes pour la table `product_variants`
--
ALTER TABLE `product_variants`
  ADD CONSTRAINT `product_id_variant` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Contraintes pour la table `product_warehouse`
--
ALTER TABLE `product_warehouse`
  ADD CONSTRAINT `art_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `mag_id` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`),
  ADD CONSTRAINT `product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `product_variants` (`id`);

--
-- Contraintes pour la table `purchases`
--
ALTER TABLE `purchases`
  ADD CONSTRAINT `provider_id` FOREIGN KEY (`provider_id`) REFERENCES `providers` (`id`),
  ADD CONSTRAINT `user_id_purchases` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `warehouse_id_purchase` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`);

--
-- Contraintes pour la table `purchase_details`
--
ALTER TABLE `purchase_details`
  ADD CONSTRAINT `product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `purchase_id` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`),
  ADD CONSTRAINT `purchase_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `product_variants` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `purchase_returns`
--
ALTER TABLE `purchase_returns`
  ADD CONSTRAINT `provider_id_return` FOREIGN KEY (`provider_id`) REFERENCES `providers` (`id`),
  ADD CONSTRAINT `purchase_return_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `purchase_return_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`);

--
-- Contraintes pour la table `purchase_return_details`
--
ALTER TABLE `purchase_return_details`
  ADD CONSTRAINT `product_id_details_purchase_return` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `purchase_return_id_return` FOREIGN KEY (`purchase_return_id`) REFERENCES `purchase_returns` (`id`),
  ADD CONSTRAINT `purchase_return_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `product_variants` (`id`);

--
-- Contraintes pour la table `quotations`
--
ALTER TABLE `quotations`
  ADD CONSTRAINT `client_id _quotation` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  ADD CONSTRAINT `user_id_quotation` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `warehouse_id_quotation` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`);

--
-- Contraintes pour la table `quotation_details`
--
ALTER TABLE `quotation_details`
  ADD CONSTRAINT `product_id_quotation_details` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `quotation_id` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`),
  ADD CONSTRAINT `quote_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `product_variants` (`id`);

--
-- Contraintes pour la table `role_user`
--
ALTER TABLE `role_user`
  ADD CONSTRAINT `role_user_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `role_user_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sale_client_id` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  ADD CONSTRAINT `user_id_sales` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `warehouse_id_sale` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`);

--
-- Contraintes pour la table `sale_details`
--
ALTER TABLE `sale_details`
  ADD CONSTRAINT `Details_Sale_id` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`),
  ADD CONSTRAINT `sale_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `sale_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `product_variants` (`id`);

--
-- Contraintes pour la table `sale_returns`
--
ALTER TABLE `sale_returns`
  ADD CONSTRAINT `client_id_returns` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  ADD CONSTRAINT `user_id_returns` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `warehouse_id_sale_return_id` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`);

--
-- Contraintes pour la table `sale_return_details`
--
ALTER TABLE `sale_return_details`
  ADD CONSTRAINT `product_id_details_returns` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `sale_return_id` FOREIGN KEY (`sale_return_id`) REFERENCES `sale_returns` (`id`),
  ADD CONSTRAINT `sale_return_id_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `product_variants` (`id`);

--
-- Contraintes pour la table `settings`
--
ALTER TABLE `settings`
  ADD CONSTRAINT `currency_id` FOREIGN KEY (`currency_id`) REFERENCES `currencies` (`id`),
  ADD CONSTRAINT `settings_client_id` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  ADD CONSTRAINT `settings_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`);

--
-- Contraintes pour la table `transfers`
--
ALTER TABLE `transfers`
  ADD CONSTRAINT `from_warehouse_id` FOREIGN KEY (`from_warehouse_id`) REFERENCES `warehouses` (`id`),
  ADD CONSTRAINT `to_warehouse_id` FOREIGN KEY (`to_warehouse_id`) REFERENCES `warehouses` (`id`),
  ADD CONSTRAINT `user_id_transfers` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `transfer_details`
--
ALTER TABLE `transfer_details`
  ADD CONSTRAINT `product_id_transfers` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `product_variant_id_transfer` FOREIGN KEY (`product_variant_id`) REFERENCES `product_variants` (`id`),
  ADD CONSTRAINT `transfer_id` FOREIGN KEY (`transfer_id`) REFERENCES `transfers` (`id`);

--
-- Contraintes pour la table `units`
--
ALTER TABLE `units`
  ADD CONSTRAINT `base_unit` FOREIGN KEY (`base_unit`) REFERENCES `units` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
