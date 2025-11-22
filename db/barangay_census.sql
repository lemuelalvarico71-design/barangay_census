-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 22, 2025 at 01:38 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `barangay_census`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `fullname` varchar(100) NOT NULL,
  `role` varchar(50) NOT NULL,
  `action` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `activity_logs`
--

INSERT INTO `activity_logs` (`id`, `user_id`, `fullname`, `role`, `action`, `description`, `ip_address`, `created_at`) VALUES
(1, 8, 'Lemuel Alvarico', 'Captain', 'Login', 'User logged in successfully', NULL, '2025-11-22 12:38:17'),
(2, 13, 'John Ivo Abadilla', 'Secretary', 'Login', 'User logged in successfully', NULL, '2025-11-22 12:52:04'),
(3, 8, 'Lemuel Alvarico', 'Captain', 'Login', 'User logged in successfully', NULL, '2025-11-22 12:54:19'),
(4, 8, 'Lemuel Alvarico', 'Admin', 'Add User', 'Created user: gapol (Secretary)', NULL, '2025-11-22 12:56:53'),
(5, 8, 'Lemuel Alvarico', 'Captain', 'Add Household', 'Added household: 544877', NULL, '2025-11-22 13:02:34'),
(6, 8, 'Lemuel Alvarico', 'Captain', 'Add Household', 'Added household: 50035', NULL, '2025-11-22 13:21:49'),
(7, 8, 'Lemuel Alvarico', 'Captain', 'Add Household', 'Added household: 50035', NULL, '2025-11-22 13:21:49'),
(8, 13, 'John Ivo Abadilla', 'Secretary', 'Login', 'User logged in successfully', NULL, '2025-11-22 13:30:22'),
(9, 13, 'John Ivo Abadilla', 'Secretary', 'Login', 'User logged in successfully', NULL, '2025-11-22 13:55:20'),
(10, 13, 'John Ivo Abadilla', 'Secretary', 'Login', 'User logged in successfully', NULL, '2025-11-22 14:03:29'),
(11, 13, 'John Ivo Abadilla', 'Secretary', 'Login', 'User logged in successfully', NULL, '2025-11-22 14:05:58'),
(12, 13, 'John Ivo Abadilla', 'Secretary', 'Login', 'User logged in successfully', NULL, '2025-11-22 14:09:45'),
(13, 13, 'John Ivo Abadilla', 'Secretary', 'Login', 'User logged in successfully', NULL, '2025-11-22 14:11:30'),
(14, 13, 'John Ivo Abadilla', 'Secretary', 'Login', 'User logged in successfully', NULL, '2025-11-22 14:19:02'),
(15, 13, 'John Ivo Abadilla', 'Secretary', 'Login', 'User logged in successfully', NULL, '2025-11-22 16:03:41'),
(16, 13, 'John Ivo Abadilla', 'Secretary', 'Login', 'User logged in successfully', NULL, '2025-11-22 16:32:11'),
(17, 13, 'John Ivo Abadilla', 'Secretary', 'Login', 'User logged in successfully', NULL, '2025-11-22 16:46:26'),
(18, 13, 'John Ivo Abadilla', 'Secretary', 'Login', 'User logged in successfully', NULL, '2025-11-22 16:49:27'),
(19, 13, 'John Ivo Abadilla', 'Secretary', 'Login', 'User logged in successfully', NULL, '2025-11-22 17:00:30'),
(20, 13, 'John Ivo Abadilla', 'Secretary', 'Login', 'User logged in successfully', NULL, '2025-11-22 17:15:38'),
(21, 13, 'John Ivo Abadilla', 'Secretary', 'Login', 'User logged in successfully', NULL, '2025-11-22 20:05:41'),
(22, 13, 'John Ivo Abadilla', 'Secretary', 'Login', 'User logged in successfully', NULL, '2025-11-22 20:28:46'),
(23, 13, 'John Ivo Abadilla', 'Secretary', 'Login', 'User logged in successfully', NULL, '2025-11-22 20:30:19');

-- --------------------------------------------------------

--
-- Table structure for table `households`
--

CREATE TABLE `households` (
  `id` int(11) NOT NULL,
  `household_number` varchar(50) NOT NULL,
  `head_of_household` varchar(100) NOT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `street` varchar(150) DEFAULT NULL,
  `barangay` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `family_members` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`family_members`)),
  `economic_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`economic_data`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `census_year` int(11) NOT NULL DEFAULT 2025
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `households`
--

INSERT INTO `households` (`id`, `household_number`, `head_of_household`, `contact_number`, `street`, `barangay`, `city`, `province`, `family_members`, `economic_data`, `created_at`, `updated_at`, `census_year`) VALUES
(3, '145', 'Jose Rizal', '11435', NULL, 'Rizal', NULL, NULL, '[{\"name\":\"June Mar Fajardo\",\"age\":30,\"gender\":\"Male\",\"relationship\":\"Bro\"}]', '[]', '2025-10-29 05:59:47', '2025-11-22 12:37:39', 2025),
(4, '47', 'Mark Magsayo', '09657722489', NULL, 'Rizal', NULL, NULL, '[{\"name\":\"Anton Bruce\",\"age\":12,\"gender\":\"Male\",\"relationship\":\"Ugag\",\"philsys_image\":\"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\"}]', '[]', '2025-10-29 06:32:36', '2025-11-22 12:37:39', 2025),
(5, '454', 'Lemuel Alvarico', '0965722489', NULL, 'Rizal', NULL, NULL, '[{\"name\":\"Ogag Pogi\",\"age\":25,\"gender\":\"Male\",\"relationship\":\"Bro\",\"philsys_image\":\"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\"}]', '[]', '2025-10-29 06:35:16', '2025-11-22 12:37:39', 2025),
(9, '1', 'ading', '09950429745', 'mangga', 'Rizal', 'katipunan', 'zambo', '[{\"name\":\"ayaa\",\"age\":22,\"gender\":\"Female\",\"relationship\":\"sister\",\"philsys_image\":null,\"education_status\":null,\"year_level\":null,\"course\":null,\"employment_status\":null}]', '[]', '2025-11-11 05:42:34', '2025-11-22 12:37:39', 2025),
(21, '544877', 'Junior Kuling', '09657722489', NULL, 'Rizal', NULL, NULL, NULL, NULL, '2025-11-22 05:02:34', '2025-11-22 12:37:39', 2025),
(22, '23141', 'Daisy Mae Antenero', '0985545645', 'Kanal', 'Rizal', 'Katipunan', 'Zambo Norte', NULL, NULL, '2025-11-22 05:04:53', '2025-11-22 12:37:39', 2025),
(24, '231413', 'Daisy Mae Antenero', '0985545645', 'Kanal', 'Rizal', 'Katipunan', 'Zambo Norte', NULL, NULL, '2025-11-22 05:10:17', '2025-11-22 12:37:39', 2025),
(26, '23141353', 'Daisy Mae Antenero', '0985545645', 'Kanal', 'Rizal', 'Katipunan', 'Zambo Norte', NULL, NULL, '2025-11-22 05:10:42', '2025-11-22 12:37:39', 2025),
(27, '231413530', 'Daisy Mae Antenero', '0985545645', 'Kanal', 'Rizal', 'Katipunan', 'Zambo Norte', NULL, NULL, '2025-11-22 05:10:53', '2025-11-22 12:37:39', 2025),
(29, '50035', 'Daisy Mae Antenero', '0985545645', 'Kanal', 'Rizal', 'Katipunan', 'Zambo Norte', '[{\"name\":\"John Ivo Abadilla\",\"age\":23,\"gender\":\"Male\",\"relationship\":\"Step bro\",\"philsys_image\":null,\"education_status\":\"Graduate\",\"year_level\":null,\"course\":null,\"employment_status\":\"Unemployed\"}]', '[]', '2025-11-22 05:21:49', '2025-11-22 12:37:39', 2025),
(1001, 'H-2023-001', 'Antonio Dela Cruz', '09171234567', 'Rizal St.', 'Rizal', 'Quezon City', 'Metro Manila', '[{\"name\":\"Maria\",\"age\":40,\"gender\":\"Female\",\"relationship\":\"Spouse\"},{\"name\":\"Pedro\",\"age\":15,\"gender\":\"Male\",\"relationship\":\"Son\"}]', '{\"income\":18000,\"employment\":\"Private\",\"status\":\"Low\"}', '2023-03-10 02:10:00', '2025-11-22 12:37:39', 2023),
(1002, 'H-2023-002', 'Liza Santos', '09981234567', 'Mabini St.', 'Rizal', 'Quezon City', 'Metro Manila', '[{\"name\":\"Jessa\",\"age\":10,\"gender\":\"Female\",\"relationship\":\"Daughter\"}]', '{\"income\":25000,\"employment\":\"Self-employed\",\"status\":\"Middle\"}', '2023-04-15 01:15:00', '2025-11-22 12:37:39', 2023),
(1003, 'H-2023-003', 'Mario Gonzales', '09081234567', 'Bonifacio St.', 'Rizal', 'Quezon City', 'Metro Manila', '[{\"name\":\"Ana\",\"age\":35,\"gender\":\"Female\",\"relationship\":\"Wife\"}]', '{\"income\":30000,\"employment\":\"Government\",\"status\":\"Middle\"}', '2023-05-19 00:20:00', '2025-11-22 12:37:39', 2023),
(2001, 'H-2024-001', 'Ricardo Valdez', '09175551234', 'Del Pilar St.', 'Rizal', 'Quezon City', 'Metro Manila', '[{\"name\":\"Cathy\",\"age\":42,\"gender\":\"Female\",\"relationship\":\"Wife\"}]', '{\"income\":20000,\"employment\":\"Part-time\",\"status\":\"Low\"}', '2024-02-12 03:20:00', '2025-11-22 12:37:39', 2024),
(2002, 'H-2024-002', 'Gloria Ramos', '09223334444', 'Narra St.', 'Rizal', 'Quezon City', 'Metro Manila', '[{\"name\":\"Carlos\",\"age\":22,\"gender\":\"Male\",\"relationship\":\"Son\"}]', '{\"income\":12000,\"employment\":\"Unemployed\",\"status\":\"Low\"}', '2024-06-18 07:40:00', '2025-11-22 12:37:39', 2024),
(2003, 'H-2024-003', 'Henry Bautista', '09336667777', 'Mahogany St.', 'Rizal', 'Quezon City', 'Metro Manila', '[{\"name\":\"Bea\",\"age\":38,\"gender\":\"Female\",\"relationship\":\"Spouse\"}]', '{\"income\":35000,\"employment\":\"Private\",\"status\":\"Middle\"}', '2024-08-21 23:50:00', '2025-11-22 12:37:39', 2024),
(3001, 'H-2025-001', 'Julian Reyes', '09178787878', 'Molave St.', 'Rizal', 'Quezon City', 'Metro Manila', '[{\"name\":\"Lara\",\"age\":30,\"gender\":\"Female\",\"relationship\":\"Wife\"}]', '{\"income\":28000,\"employment\":\"Private\",\"status\":\"Middle\"}', '2025-01-20 01:00:00', '2025-11-22 12:37:39', 2025),
(3002, 'H-2025-002', 'Sarah Lopez', '09351239876', 'Ilang-Ilang St.', 'Rizal', 'Quezon City', 'Metro Manila', '[{\"name\":\"Nico\",\"age\":12,\"gender\":\"Male\",\"relationship\":\"Son\"}]', '{\"income\":17000,\"employment\":\"Self-employed\",\"status\":\"Low\"}', '2025-02-15 06:20:00', '2025-11-22 12:37:39', 2025),
(3003, 'HH-2016-001', 'Carmencita Mendoza', '09794227850', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-12-16 02:40:17', '2025-11-22 12:37:39', 2016),
(3004, 'HH-2016-002', 'Lapu-Lapu', '09520208005', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-07-03 01:28:54', '2025-11-22 12:37:39', 2016),
(3005, 'HH-2016-003', 'Luzviminda Torres', '09695732888', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-09-21 10:26:55', '2025-11-22 12:37:39', 2016),
(3006, 'HH-2016-004', 'Luzviminda Torres', '09776861428', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-10-21 00:56:06', '2025-11-22 12:37:39', 2016),
(3007, 'HH-2016-005', 'Luzviminda Torres', '09593341280', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-09-05 05:16:13', '2025-11-22 12:37:39', 2016),
(3008, 'HH-2016-006', 'Lapu-Lapu', '09691783223', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-01-26 05:13:45', '2025-11-22 12:37:39', 2016),
(3009, 'HH-2016-007', 'Rosita Aquino', '09910612651', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-03-19 01:36:00', '2025-11-22 12:37:39', 2016),
(3010, 'HH-2016-008', 'Marco Antonio', '09776041280', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-08-19 10:19:55', '2025-11-22 12:37:39', 2016),
(3011, 'HH-2016-009', 'Andres Bonifacio', '09924738317', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-06-04 01:58:39', '2025-11-22 12:37:39', 2016),
(3012, 'HH-2016-010', 'Antonio Bautista', '09155157163', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-11-01 04:57:11', '2025-11-22 12:37:39', 2016),
(3013, 'HH-2016-011', 'Elena Castro', '09814082364', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-04-24 01:07:58', '2025-11-22 12:37:39', 2016),
(3014, 'HH-2016-012', 'Marco Antonio', '09853151569', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-09-12 07:15:38', '2025-11-22 12:37:39', 2016),
(3015, 'HH-2016-013', 'Andres Bonifacio', '09912031972', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-05-11 06:01:27', '2025-11-22 12:37:39', 2016),
(3016, 'HH-2016-014', 'Emilio Aguinaldo', '09944476089', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-10-08 05:01:48', '2025-11-22 12:37:39', 2016),
(3017, 'HH-2016-015', 'Marco Antonio', '09771288635', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-05-11 06:21:21', '2025-11-22 12:37:39', 2016),
(3018, 'HH-2016-016', 'Andres Bonifacio', '09294932386', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-01-13 05:02:06', '2025-11-22 12:37:39', 2016),
(3019, 'HH-2016-017', 'Elena Castro', '09554109732', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-06-08 09:58:20', '2025-11-22 12:37:39', 2016),
(3020, 'HH-2016-018', 'Pedro Garcia', '09569591795', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-04-06 03:42:54', '2025-11-22 12:37:39', 2016),
(3021, 'HH-2016-019', 'Elena Castro', '09232169000', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-09-06 04:39:27', '2025-11-22 12:37:39', 2016),
(3022, 'HH-2016-020', 'Antonio Bautista', '09924747777', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-11-28 04:32:28', '2025-11-22 12:37:39', 2016),
(3023, 'HH-2016-021', 'Felipe Gozon', '09971271565', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-12-10 04:58:17', '2025-11-22 12:37:39', 2016),
(3024, 'HH-2016-022', 'Carmencita Mendoza', '09314374696', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-10-14 09:11:41', '2025-11-22 12:37:39', 2016),
(3025, 'HH-2016-023', 'Sofia Vergara', '09355516901', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-11-06 10:20:55', '2025-11-22 12:37:39', 2016),
(3026, 'HH-2016-024', 'Eduardo Fernandez', '09196889266', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-08-09 06:46:06', '2025-11-22 12:37:39', 2016),
(3027, 'HH-2016-025', 'Ana Reyes', '09486790238', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-08-25 03:47:12', '2025-11-22 12:37:39', 2016),
(3028, 'HH-2016-026', 'Juan dela Cruz', '09313413522', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-07-23 04:50:54', '2025-11-22 12:37:39', 2016),
(3029, 'HH-2016-027', 'Elena Castro', '09484226992', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-08-08 10:24:07', '2025-11-22 12:37:39', 2016),
(3030, 'HH-2016-028', 'Isabella Cruz', '09284217627', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-03-21 08:28:12', '2025-11-22 12:37:39', 2016),
(3031, 'HH-2016-029', 'Rosita Aquino', '09539816013', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-09-25 10:11:03', '2025-11-22 12:37:39', 2016),
(3032, 'HH-2016-030', 'Eduardo Fernandez', '09121763145', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-07-22 04:26:38', '2025-11-22 12:37:39', 2016),
(3033, 'HH-2016-031', 'Lapu-Lapu', '09697092588', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-09-28 05:36:00', '2025-11-22 12:37:39', 2016),
(3034, 'HH-2016-032', 'Eduardo Fernandez', '09364149299', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-06-17 01:39:52', '2025-11-22 12:37:39', 2016),
(3035, 'HH-2016-033', 'Ana Reyes', '09853236614', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-03-27 08:10:43', '2025-11-22 12:37:39', 2016),
(3036, 'HH-2016-034', 'Luzviminda Torres', '09495258003', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-08-12 03:52:36', '2025-11-22 12:37:39', 2016),
(3037, 'HH-2016-035', 'Gabriela Silang', '09413917900', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2016-08-24 00:29:11', '2025-11-22 12:37:39', 2016),
(3038, 'HH-2017-001', 'Carmencita Mendoza', '09861399718', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-02-14 09:01:34', '2025-11-22 12:37:39', 2017),
(3039, 'HH-2017-002', 'Andres Bonifacio', '09148373887', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-01-13 02:18:34', '2025-11-22 12:37:39', 2017),
(3040, 'HH-2017-003', 'Pedro Garcia', '09919796318', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-05-06 05:41:51', '2025-11-22 12:37:39', 2017),
(3041, 'HH-2017-004', 'Juan dela Cruz', '09239433584', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-11-13 10:10:11', '2025-11-22 12:37:39', 2017),
(3042, 'HH-2017-005', 'Emilio Aguinaldo', '09828115283', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-05-25 03:31:39', '2025-11-22 12:37:39', 2017),
(3043, 'HH-2017-006', 'Roberto Lim', '09547022902', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-03-08 03:39:57', '2025-11-22 12:37:39', 2017),
(3044, 'HH-2017-007', 'Isabella Cruz', '09917791172', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-10-23 00:18:27', '2025-11-22 12:37:39', 2017),
(3045, 'HH-2017-008', 'Maria Clara Santos', '09565731321', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-03-26 03:13:53', '2025-11-22 12:37:39', 2017),
(3046, 'HH-2017-009', 'Sofia Vergara', '09440293776', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-04-26 02:29:46', '2025-11-22 12:37:39', 2017),
(3047, 'HH-2017-010', 'Antonio Bautista', '09138184896', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-02-11 06:45:35', '2025-11-22 12:37:39', 2017),
(3048, 'HH-2017-011', 'Pedro Garcia', '09974379944', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-11-13 09:46:12', '2025-11-22 12:37:39', 2017),
(3049, 'HH-2017-012', 'Pedro Garcia', '09312262940', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-09-02 08:10:27', '2025-11-22 12:37:39', 2017),
(3050, 'HH-2017-013', 'Gabriela Silang', '09328478067', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-05-04 10:48:39', '2025-11-22 12:37:39', 2017),
(3051, 'HH-2017-014', 'Roberto Lim', '09245266802', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-08-10 04:24:40', '2025-11-22 12:37:39', 2017),
(3052, 'HH-2017-015', 'Roberto Lim', '09899093861', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-08-17 04:00:20', '2025-11-22 12:37:39', 2017),
(3053, 'HH-2017-016', 'Pedro Garcia', '09674275045', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-07-10 00:06:01', '2025-11-22 12:37:39', 2017),
(3054, 'HH-2017-017', 'Pedro Garcia', '09424717680', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-11-16 05:00:38', '2025-11-22 12:37:39', 2017),
(3055, 'HH-2017-018', 'Elena Castro', '09892808761', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-05-23 01:10:40', '2025-11-22 12:37:39', 2017),
(3056, 'HH-2017-019', 'Maria Clara Santos', '09452709823', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-02-21 05:28:45', '2025-11-22 12:37:39', 2017),
(3057, 'HH-2017-020', 'Ana Reyes', '09499244412', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-02-02 01:57:17', '2025-11-22 12:37:39', 2017),
(3058, 'HH-2017-021', 'Sofia Vergara', '09654766511', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-12-06 04:07:35', '2025-11-22 12:37:39', 2017),
(3059, 'HH-2017-022', 'Sofia Vergara', '09385098243', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-01-10 02:47:15', '2025-11-22 12:37:39', 2017),
(3060, 'HH-2017-023', 'Antonio Bautista', '09485515266', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-06-17 06:12:57', '2025-11-22 12:37:39', 2017),
(3061, 'HH-2017-024', 'Luzviminda Torres', '09235379866', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-09-21 00:40:16', '2025-11-22 12:37:39', 2017),
(3062, 'HH-2017-025', 'Andres Bonifacio', '09727082496', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-11-13 07:12:56', '2025-11-22 12:37:39', 2017),
(3063, 'HH-2017-026', 'Juan dela Cruz', '09138450239', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-11-08 05:21:18', '2025-11-22 12:37:39', 2017),
(3064, 'HH-2017-027', 'Ana Reyes', '09740336584', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-04-23 07:42:36', '2025-11-22 12:37:39', 2017),
(3065, 'HH-2017-028', 'Ana Reyes', '09950942579', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-12-17 08:28:05', '2025-11-22 12:37:39', 2017),
(3066, 'HH-2017-029', 'Eduardo Fernandez', '09964599574', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-12-04 03:09:57', '2025-11-22 12:37:39', 2017),
(3067, 'HH-2017-030', 'Marco Antonio', '09434982964', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-06-06 05:34:48', '2025-11-22 12:37:39', 2017),
(3068, 'HH-2017-031', 'Jose Rizal', '09870120227', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-01-08 04:51:17', '2025-11-22 12:37:39', 2017),
(3069, 'HH-2017-032', 'Antonio Bautista', '09457101042', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-03-06 10:29:11', '2025-11-22 12:37:39', 2017),
(3070, 'HH-2017-033', 'Andres Bonifacio', '09712584910', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-07-07 04:25:47', '2025-11-22 12:37:39', 2017),
(3071, 'HH-2017-034', 'Carmencita Mendoza', '09973642867', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-04-12 07:19:56', '2025-11-22 12:37:39', 2017),
(3072, 'HH-2017-035', 'Rosita Aquino', '09337344539', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2017-04-14 10:26:43', '2025-11-22 12:37:39', 2017),
(3073, 'HH-2018-001', 'Felipe Gozon', '09712618803', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-10-23 02:37:41', '2025-11-22 12:37:39', 2018),
(3074, 'HH-2018-002', 'Carmencita Mendoza', '09655514058', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-01-06 04:31:05', '2025-11-22 12:37:39', 2018),
(3075, 'HH-2018-003', 'Felipe Gozon', '09999016933', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-08-23 06:40:41', '2025-11-22 12:37:39', 2018),
(3076, 'HH-2018-004', 'Carmencita Mendoza', '09544807483', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-04-11 00:59:43', '2025-11-22 12:37:39', 2018),
(3077, 'HH-2018-005', 'Elena Castro', '09648215064', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-04-08 04:17:09', '2025-11-22 12:37:39', 2018),
(3078, 'HH-2018-006', 'Juan dela Cruz', '09270459510', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-12-18 10:20:17', '2025-11-22 12:37:39', 2018),
(3079, 'HH-2018-007', 'Eduardo Fernandez', '09935887983', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-07-01 08:42:52', '2025-11-22 12:37:39', 2018),
(3080, 'HH-2018-008', 'Eduardo Fernandez', '09715458434', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-09-20 08:23:04', '2025-11-22 12:37:39', 2018),
(3081, 'HH-2018-009', 'Jose Rizal', '09789046388', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-06-21 07:49:03', '2025-11-22 12:37:39', 2018),
(3082, 'HH-2018-010', 'Roberto Lim', '09461587416', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-04-22 03:02:55', '2025-11-22 12:37:39', 2018),
(3083, 'HH-2018-011', 'Rosita Aquino', '09768045598', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-03-08 08:29:13', '2025-11-22 12:37:39', 2018),
(3084, 'HH-2018-012', 'Juan dela Cruz', '09859334850', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-10-25 06:22:29', '2025-11-22 12:37:39', 2018),
(3085, 'HH-2018-013', 'Jose Rizal', '09866758957', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-12-25 07:46:43', '2025-11-22 12:37:39', 2018),
(3086, 'HH-2018-014', 'Sofia Vergara', '09281948781', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-07-09 02:09:18', '2025-11-22 12:37:39', 2018),
(3087, 'HH-2018-015', 'Luzviminda Torres', '09568600190', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-05-12 08:30:24', '2025-11-22 12:37:39', 2018),
(3088, 'HH-2018-016', 'Isabella Cruz', '09332278887', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-07-14 04:51:23', '2025-11-22 12:37:39', 2018),
(3089, 'HH-2018-017', 'Pedro Garcia', '09495315034', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-07-01 10:09:56', '2025-11-22 12:37:39', 2018),
(3090, 'HH-2018-018', 'Ana Reyes', '09727249342', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-06-08 00:57:05', '2025-11-22 12:37:39', 2018),
(3091, 'HH-2018-019', 'Carmencita Mendoza', '09187030511', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-11-28 09:50:20', '2025-11-22 12:37:39', 2018),
(3092, 'HH-2018-020', 'Maria Clara Santos', '09256961962', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-07-06 07:29:39', '2025-11-22 12:37:39', 2018),
(3093, 'HH-2018-021', 'Lapu-Lapu', '09654524822', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-05-03 01:08:15', '2025-11-22 12:37:39', 2018),
(3094, 'HH-2018-022', 'Roberto Lim', '09921641856', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-07-12 09:14:33', '2025-11-22 12:37:39', 2018),
(3095, 'HH-2018-023', 'Eduardo Fernandez', '09120543858', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-11-17 03:02:04', '2025-11-22 12:37:39', 2018),
(3096, 'HH-2018-024', 'Pedro Garcia', '09743812778', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-06-28 05:33:52', '2025-11-22 12:37:39', 2018),
(3097, 'HH-2018-025', 'Carmencita Mendoza', '09460786285', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-06-25 08:35:43', '2025-11-22 12:37:39', 2018),
(3098, 'HH-2018-026', 'Isabella Cruz', '09347543617', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-01-28 09:00:15', '2025-11-22 12:37:39', 2018),
(3099, 'HH-2018-027', 'Gabriela Silang', '09787977079', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-02-25 01:20:44', '2025-11-22 12:37:39', 2018),
(3100, 'HH-2018-028', 'Maria Clara Santos', '09478166466', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-11-11 10:09:35', '2025-11-22 12:37:39', 2018),
(3101, 'HH-2018-029', 'Lapu-Lapu', '09490861404', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-02-03 06:24:58', '2025-11-22 12:37:39', 2018),
(3102, 'HH-2018-030', 'Jose Rizal', '09576161623', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-07-25 05:41:14', '2025-11-22 12:37:39', 2018),
(3103, 'HH-2018-031', 'Lapu-Lapu', '09810419115', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-10-02 02:58:35', '2025-11-22 12:37:39', 2018),
(3104, 'HH-2018-032', 'Gabriela Silang', '09545628374', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-07-09 03:33:42', '2025-11-22 12:37:39', 2018),
(3105, 'HH-2018-033', 'Luzviminda Torres', '09146682163', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-07-17 07:14:31', '2025-11-22 12:37:39', 2018),
(3106, 'HH-2018-034', 'Roberto Lim', '09123402060', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-11-06 02:42:24', '2025-11-22 12:37:39', 2018),
(3107, 'HH-2018-035', 'Antonio Bautista', '09832959872', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2018-11-02 07:06:44', '2025-11-22 12:37:39', 2018),
(3108, 'HH-2019-001', 'Luzviminda Torres', '09326491273', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-08-18 04:41:38', '2025-11-22 12:37:39', 2019),
(3109, 'HH-2019-002', 'Isabella Cruz', '09180394175', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-02-23 07:50:31', '2025-11-22 12:37:39', 2019),
(3110, 'HH-2019-003', 'Carmencita Mendoza', '09784533743', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-06-13 06:43:38', '2025-11-22 12:37:39', 2019),
(3111, 'HH-2019-004', 'Sofia Vergara', '09731993553', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-08-15 04:40:41', '2025-11-22 12:37:39', 2019),
(3112, 'HH-2019-005', 'Antonio Bautista', '09483100928', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-04-27 09:56:33', '2025-11-22 12:37:39', 2019),
(3113, 'HH-2019-006', 'Lapu-Lapu', '09922216038', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-08-20 05:17:57', '2025-11-22 12:37:39', 2019),
(3114, 'HH-2019-007', 'Antonio Bautista', '09229876600', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-12-10 10:42:37', '2025-11-22 12:37:39', 2019),
(3115, 'HH-2019-008', 'Ana Reyes', '09280180696', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-02-15 04:17:43', '2025-11-22 12:37:39', 2019),
(3116, 'HH-2019-009', 'Andres Bonifacio', '09197687045', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-02-05 07:28:01', '2025-11-22 12:37:39', 2019),
(3117, 'HH-2019-010', 'Jose Rizal', '09361524969', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-10-14 06:40:16', '2025-11-22 12:37:39', 2019),
(3118, 'HH-2019-011', 'Sofia Vergara', '09140088666', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-01-27 00:52:33', '2025-11-22 12:37:39', 2019),
(3119, 'HH-2019-012', 'Gabriela Silang', '09452364025', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-02-03 02:29:02', '2025-11-22 12:37:39', 2019),
(3120, 'HH-2019-013', 'Ana Reyes', '09289368744', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-07-24 05:27:59', '2025-11-22 12:37:39', 2019),
(3121, 'HH-2019-014', 'Rosita Aquino', '09341360818', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-05-17 06:02:25', '2025-11-22 12:37:39', 2019),
(3122, 'HH-2019-015', 'Emilio Aguinaldo', '09467409086', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-04-07 04:33:55', '2025-11-22 12:37:39', 2019),
(3123, 'HH-2019-016', 'Felipe Gozon', '09289569850', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-03-27 06:39:27', '2025-11-22 12:37:39', 2019),
(3124, 'HH-2019-017', 'Antonio Bautista', '09686700553', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-05-05 07:30:30', '2025-11-22 12:37:39', 2019),
(3125, 'HH-2019-018', 'Carmencita Mendoza', '09954107088', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-09-22 02:40:45', '2025-11-22 12:37:39', 2019),
(3126, 'HH-2019-019', 'Maria Clara Santos', '09259885575', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-05-28 01:36:00', '2025-11-22 12:37:39', 2019),
(3127, 'HH-2019-020', 'Isabella Cruz', '09133237001', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-02-19 08:53:27', '2025-11-22 12:37:39', 2019),
(3128, 'HH-2019-021', 'Pedro Garcia', '09767242760', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-06-18 00:45:13', '2025-11-22 12:37:39', 2019),
(3129, 'HH-2019-022', 'Marco Antonio', '09360416040', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-06-17 08:45:28', '2025-11-22 12:37:39', 2019),
(3130, 'HH-2019-023', 'Isabella Cruz', '09916250907', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-02-19 09:17:31', '2025-11-22 12:37:39', 2019),
(3131, 'HH-2019-024', 'Ana Reyes', '09653637140', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-03-19 06:16:52', '2025-11-22 12:37:39', 2019),
(3132, 'HH-2019-025', 'Antonio Bautista', '09655945757', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-02-15 02:16:05', '2025-11-22 12:37:39', 2019),
(3133, 'HH-2019-026', 'Juan dela Cruz', '09210987417', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-08-19 07:55:33', '2025-11-22 12:37:39', 2019),
(3134, 'HH-2019-027', 'Rosita Aquino', '09554911319', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-07-11 06:29:59', '2025-11-22 12:37:39', 2019),
(3135, 'HH-2019-028', 'Juan dela Cruz', '09867779205', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-04-13 02:53:05', '2025-11-22 12:37:39', 2019),
(3136, 'HH-2019-029', 'Isabella Cruz', '09929891756', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-06-02 01:14:57', '2025-11-22 12:37:39', 2019),
(3137, 'HH-2019-030', 'Antonio Bautista', '09582357868', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-01-19 01:38:35', '2025-11-22 12:37:39', 2019),
(3138, 'HH-2019-031', 'Gabriela Silang', '09274145536', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-05-24 03:55:02', '2025-11-22 12:37:39', 2019),
(3139, 'HH-2019-032', 'Roberto Lim', '09416239994', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-11-16 02:38:44', '2025-11-22 12:37:39', 2019),
(3140, 'HH-2019-033', 'Felipe Gozon', '09427902497', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-12-06 00:44:57', '2025-11-22 12:37:39', 2019),
(3141, 'HH-2019-034', 'Jose Rizal', '09376151799', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-12-20 02:08:22', '2025-11-22 12:37:39', 2019),
(3142, 'HH-2019-035', 'Sofia Vergara', '09381504005', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2019-05-25 09:22:24', '2025-11-22 12:37:39', 2019),
(3143, 'HH-2020-001', 'Lapu-Lapu', '09153690679', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-10-25 07:21:57', '2025-11-22 12:37:39', 2020),
(3144, 'HH-2020-002', 'Jose Rizal', '09886409649', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-10-26 09:54:40', '2025-11-22 12:37:39', 2020),
(3145, 'HH-2020-003', 'Roberto Lim', '09194846221', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-08-21 09:06:49', '2025-11-22 12:37:39', 2020),
(3146, 'HH-2020-004', 'Gabriela Silang', '09843754616', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-12-18 03:12:05', '2025-11-22 12:37:39', 2020),
(3147, 'HH-2020-005', 'Emilio Aguinaldo', '09171175203', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-02-09 02:52:43', '2025-11-22 12:37:39', 2020),
(3148, 'HH-2020-006', 'Roberto Lim', '09895161261', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-05-04 08:26:10', '2025-11-22 12:37:39', 2020),
(3149, 'HH-2020-007', 'Jose Rizal', '09614138996', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-10-21 07:56:58', '2025-11-22 12:37:39', 2020),
(3150, 'HH-2020-008', 'Luzviminda Torres', '09373385860', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-12-06 06:21:46', '2025-11-22 12:37:39', 2020),
(3151, 'HH-2020-009', 'Luzviminda Torres', '09594911065', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-02-03 08:09:04', '2025-11-22 12:37:39', 2020),
(3152, 'HH-2020-010', 'Carmencita Mendoza', '09472724977', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-08-06 01:56:57', '2025-11-22 12:37:39', 2020),
(3153, 'HH-2020-011', 'Emilio Aguinaldo', '09473961188', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-08-21 01:19:53', '2025-11-22 12:37:39', 2020),
(3154, 'HH-2020-012', 'Antonio Bautista', '09329400084', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-09-05 00:47:38', '2025-11-22 12:37:39', 2020),
(3155, 'HH-2020-013', 'Eduardo Fernandez', '09621633489', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-02-02 08:19:28', '2025-11-22 12:37:39', 2020);
INSERT INTO `households` (`id`, `household_number`, `head_of_household`, `contact_number`, `street`, `barangay`, `city`, `province`, `family_members`, `economic_data`, `created_at`, `updated_at`, `census_year`) VALUES
(3156, 'HH-2020-014', 'Rosita Aquino', '09370767197', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-11-22 06:14:27', '2025-11-22 12:37:39', 2020),
(3157, 'HH-2020-015', 'Eduardo Fernandez', '09369032604', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-07-17 07:00:19', '2025-11-22 12:37:39', 2020),
(3158, 'HH-2020-016', 'Elena Castro', '09823305061', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-07-03 05:43:35', '2025-11-22 12:37:39', 2020),
(3159, 'HH-2020-017', 'Elena Castro', '09412184174', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-07-16 03:38:26', '2025-11-22 12:37:39', 2020),
(3160, 'HH-2020-018', 'Antonio Bautista', '09277388434', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-05-19 08:20:37', '2025-11-22 12:37:39', 2020),
(3161, 'HH-2020-019', 'Isabella Cruz', '09611370285', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-02-06 05:39:21', '2025-11-22 12:37:39', 2020),
(3162, 'HH-2020-020', 'Carmencita Mendoza', '09535736121', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-02-24 10:29:44', '2025-11-22 12:37:39', 2020),
(3163, 'HH-2020-021', 'Sofia Vergara', '09563500136', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-01-10 10:12:54', '2025-11-22 12:37:39', 2020),
(3164, 'HH-2020-022', 'Sofia Vergara', '09554428622', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-03-19 08:30:32', '2025-11-22 12:37:39', 2020),
(3165, 'HH-2020-023', 'Ana Reyes', '09494337635', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-08-14 06:55:26', '2025-11-22 12:37:39', 2020),
(3166, 'HH-2020-024', 'Luzviminda Torres', '09728219902', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-11-01 07:07:01', '2025-11-22 12:37:39', 2020),
(3167, 'HH-2020-025', 'Gabriela Silang', '09843640463', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-12-18 02:48:44', '2025-11-22 12:37:39', 2020),
(3168, 'HH-2020-026', 'Andres Bonifacio', '09946632647', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-06-17 01:41:20', '2025-11-22 12:37:39', 2020),
(3169, 'HH-2020-027', 'Juan dela Cruz', '09762898975', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-06-11 03:34:04', '2025-11-22 12:37:39', 2020),
(3170, 'HH-2020-028', 'Ana Reyes', '09996289573', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-07-26 09:51:21', '2025-11-22 12:37:39', 2020),
(3171, 'HH-2020-029', 'Sofia Vergara', '09517716255', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-12-06 08:54:00', '2025-11-22 12:37:39', 2020),
(3172, 'HH-2020-030', 'Emilio Aguinaldo', '09976028210', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-11-06 07:11:58', '2025-11-22 12:37:39', 2020),
(3173, 'HH-2020-031', 'Ana Reyes', '09485671217', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-04-15 00:40:04', '2025-11-22 12:37:39', 2020),
(3174, 'HH-2020-032', 'Juan dela Cruz', '09995213809', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-08-06 01:48:32', '2025-11-22 12:37:39', 2020),
(3175, 'HH-2020-033', 'Emilio Aguinaldo', '09935177556', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-08-12 00:21:55', '2025-11-22 12:37:39', 2020),
(3176, 'HH-2020-034', 'Gabriela Silang', '09821380735', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-04-02 03:54:24', '2025-11-22 12:37:39', 2020),
(3177, 'HH-2020-035', 'Roberto Lim', '09352990718', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2020-10-04 05:03:41', '2025-11-22 12:37:39', 2020),
(3178, 'HH-2021-001', 'Pedro Garcia', '09558976914', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-05-17 09:57:19', '2025-11-22 12:37:39', 2021),
(3179, 'HH-2021-002', 'Gabriela Silang', '09368888846', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-06-27 07:13:43', '2025-11-22 12:37:39', 2021),
(3180, 'HH-2021-003', 'Elena Castro', '09156867781', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-09-11 07:21:09', '2025-11-22 12:37:39', 2021),
(3181, 'HH-2021-004', 'Gabriela Silang', '09959134040', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-01-17 05:55:24', '2025-11-22 12:37:39', 2021),
(3182, 'HH-2021-005', 'Sofia Vergara', '09336563395', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-03-16 09:26:34', '2025-11-22 12:37:39', 2021),
(3183, 'HH-2021-006', 'Carmencita Mendoza', '09216949503', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-12-10 03:55:01', '2025-11-22 12:37:39', 2021),
(3184, 'HH-2021-007', 'Roberto Lim', '09386694881', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-03-21 04:36:51', '2025-11-22 12:37:39', 2021),
(3185, 'HH-2021-008', 'Andres Bonifacio', '09114027999', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-07-06 00:34:47', '2025-11-22 12:37:39', 2021),
(3186, 'HH-2021-009', 'Andres Bonifacio', '09655748178', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-06-09 03:12:48', '2025-11-22 12:37:39', 2021),
(3187, 'HH-2021-010', 'Eduardo Fernandez', '09383115007', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-07-05 09:28:38', '2025-11-22 12:37:39', 2021),
(3188, 'HH-2021-011', 'Emilio Aguinaldo', '09785743640', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-07-25 06:29:55', '2025-11-22 12:37:39', 2021),
(3189, 'HH-2021-012', 'Emilio Aguinaldo', '09564210303', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-12-24 01:29:08', '2025-11-22 12:37:39', 2021),
(3190, 'HH-2021-013', 'Marco Antonio', '09652861411', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-02-01 09:29:30', '2025-11-22 12:37:39', 2021),
(3191, 'HH-2021-014', 'Roberto Lim', '09416065244', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-09-04 05:38:26', '2025-11-22 12:37:39', 2021),
(3192, 'HH-2021-015', 'Carmencita Mendoza', '09769829914', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-02-09 02:14:20', '2025-11-22 12:37:39', 2021),
(3193, 'HH-2021-016', 'Luzviminda Torres', '09442129934', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-04-18 04:39:42', '2025-11-22 12:37:39', 2021),
(3194, 'HH-2021-017', 'Eduardo Fernandez', '09345872500', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-07-13 10:42:37', '2025-11-22 12:37:39', 2021),
(3195, 'HH-2021-018', 'Marco Antonio', '09389501315', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-07-05 10:29:57', '2025-11-22 12:37:39', 2021),
(3196, 'HH-2021-019', 'Isabella Cruz', '09473042365', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-03-10 01:28:04', '2025-11-22 12:37:39', 2021),
(3197, 'HH-2021-020', 'Elena Castro', '09575389224', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-12-04 09:03:47', '2025-11-22 12:37:39', 2021),
(3198, 'HH-2021-021', 'Emilio Aguinaldo', '09840223275', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-12-20 05:49:49', '2025-11-22 12:37:39', 2021),
(3199, 'HH-2021-022', 'Felipe Gozon', '09570438158', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-10-10 09:48:20', '2025-11-22 12:37:39', 2021),
(3200, 'HH-2021-023', 'Eduardo Fernandez', '09270441696', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-08-07 02:56:19', '2025-11-22 12:37:39', 2021),
(3201, 'HH-2021-024', 'Rosita Aquino', '09464062979', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-07-18 01:07:20', '2025-11-22 12:37:39', 2021),
(3202, 'HH-2021-025', 'Felipe Gozon', '09914823622', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-11-27 09:10:10', '2025-11-22 12:37:39', 2021),
(3203, 'HH-2021-026', 'Felipe Gozon', '09427395886', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-03-16 03:35:24', '2025-11-22 12:37:39', 2021),
(3204, 'HH-2021-027', 'Jose Rizal', '09251875632', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-12-05 01:11:55', '2025-11-22 12:37:39', 2021),
(3205, 'HH-2021-028', 'Eduardo Fernandez', '09629403474', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-10-03 04:42:57', '2025-11-22 12:37:39', 2021),
(3206, 'HH-2021-029', 'Andres Bonifacio', '09975176876', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-05-07 05:58:40', '2025-11-22 12:37:39', 2021),
(3207, 'HH-2021-030', 'Juan dela Cruz', '09789051048', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-04-14 07:14:19', '2025-11-22 12:37:39', 2021),
(3208, 'HH-2021-031', 'Marco Antonio', '09279322381', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-08-22 07:30:57', '2025-11-22 12:37:39', 2021),
(3209, 'HH-2021-032', 'Gabriela Silang', '09374086398', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-06-11 01:17:50', '2025-11-22 12:37:39', 2021),
(3210, 'HH-2021-033', 'Pedro Garcia', '09819993059', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-05-21 04:04:15', '2025-11-22 12:37:39', 2021),
(3211, 'HH-2021-034', 'Jose Rizal', '09849900706', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-01-24 09:26:07', '2025-11-22 12:37:39', 2021),
(3212, 'HH-2021-035', 'Roberto Lim', '09858947229', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2021-10-19 01:18:38', '2025-11-22 12:37:39', 2021),
(3213, 'HH-2022-001', 'Pedro Garcia', '09141227790', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-01-27 04:58:43', '2025-11-22 12:37:39', 2022),
(3214, 'HH-2022-002', 'Roberto Lim', '09162618889', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-05-16 08:14:09', '2025-11-22 12:37:39', 2022),
(3215, 'HH-2022-003', 'Maria Clara Santos', '09928664151', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-05-03 05:35:29', '2025-11-22 12:37:39', 2022),
(3216, 'HH-2022-004', 'Isabella Cruz', '09730301372', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-01-13 04:39:32', '2025-11-22 12:37:39', 2022),
(3217, 'HH-2022-005', 'Gabriela Silang', '09963988614', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-07-18 09:19:48', '2025-11-22 12:37:39', 2022),
(3218, 'HH-2022-006', 'Antonio Bautista', '09153340967', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-01-21 00:32:36', '2025-11-22 12:37:39', 2022),
(3219, 'HH-2022-007', 'Luzviminda Torres', '09870826923', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-08-27 08:57:21', '2025-11-22 12:37:39', 2022),
(3220, 'HH-2022-008', 'Juan dela Cruz', '09584191706', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-11-18 05:16:42', '2025-11-22 12:37:39', 2022),
(3221, 'HH-2022-009', 'Ana Reyes', '09173377884', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-01-27 07:31:15', '2025-11-22 12:37:39', 2022),
(3222, 'HH-2022-010', 'Roberto Lim', '09162647126', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-12-18 10:27:10', '2025-11-22 12:37:39', 2022),
(3223, 'HH-2022-011', 'Carmencita Mendoza', '09519045574', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-04-05 04:13:26', '2025-11-22 12:37:39', 2022),
(3224, 'HH-2022-012', 'Gabriela Silang', '09422069785', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-04-05 08:39:37', '2025-11-22 12:37:39', 2022),
(3225, 'HH-2022-013', 'Carmencita Mendoza', '09421150624', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-03-08 09:29:34', '2025-11-22 12:37:39', 2022),
(3226, 'HH-2022-014', 'Lapu-Lapu', '09148758566', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-08-27 02:40:03', '2025-11-22 12:37:39', 2022),
(3227, 'HH-2022-015', 'Emilio Aguinaldo', '09552130341', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-09-05 06:19:12', '2025-11-22 12:37:39', 2022),
(3228, 'HH-2022-016', 'Luzviminda Torres', '09875525820', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-07-17 04:42:47', '2025-11-22 12:37:39', 2022),
(3229, 'HH-2022-017', 'Juan dela Cruz', '09837233014', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-07-09 04:32:21', '2025-11-22 12:37:39', 2022),
(3230, 'HH-2022-018', 'Luzviminda Torres', '09829638033', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-06-26 09:00:33', '2025-11-22 12:37:39', 2022),
(3231, 'HH-2022-019', 'Roberto Lim', '09874839025', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-01-05 09:36:25', '2025-11-22 12:37:39', 2022),
(3232, 'HH-2022-020', 'Maria Clara Santos', '09322820017', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-10-22 01:49:22', '2025-11-22 12:37:39', 2022),
(3233, 'HH-2022-021', 'Andres Bonifacio', '09964008897', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-06-16 00:26:59', '2025-11-22 12:37:39', 2022),
(3234, 'HH-2022-022', 'Isabella Cruz', '09999931009', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-01-16 00:08:25', '2025-11-22 12:37:39', 2022),
(3235, 'HH-2022-023', 'Felipe Gozon', '09410394310', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-03-05 00:00:45', '2025-11-22 12:37:39', 2022),
(3236, 'HH-2022-024', 'Felipe Gozon', '09264785685', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-08-28 04:15:59', '2025-11-22 12:37:39', 2022),
(3237, 'HH-2022-025', 'Maria Clara Santos', '09868530889', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-01-22 04:51:49', '2025-11-22 12:37:39', 2022),
(3238, 'HH-2022-026', 'Felipe Gozon', '09414329245', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-03-12 03:07:43', '2025-11-22 12:37:39', 2022),
(3239, 'HH-2022-027', 'Antonio Bautista', '09326391925', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-10-05 04:45:31', '2025-11-22 12:37:39', 2022),
(3240, 'HH-2022-028', 'Luzviminda Torres', '09477180246', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-08-23 00:12:33', '2025-11-22 12:37:39', 2022),
(3241, 'HH-2022-029', 'Juan dela Cruz', '09613944784', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-04-03 09:02:13', '2025-11-22 12:37:39', 2022),
(3242, 'HH-2022-030', 'Marco Antonio', '09547169002', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-05-12 09:44:12', '2025-11-22 12:37:39', 2022),
(3243, 'HH-2022-031', 'Rosita Aquino', '09927811473', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-09-11 07:10:09', '2025-11-22 12:37:39', 2022),
(3244, 'HH-2022-032', 'Sofia Vergara', '09975305906', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-03-02 06:59:29', '2025-11-22 12:37:39', 2022),
(3245, 'HH-2022-033', 'Lapu-Lapu', '09211972401', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-05-09 09:16:15', '2025-11-22 12:37:39', 2022),
(3246, 'HH-2022-034', 'Luzviminda Torres', '09915384125', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-03-07 05:51:10', '2025-11-22 12:37:39', 2022),
(3247, 'HH-2022-035', 'Jose Rizal', '09151231775', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2022-01-07 03:09:53', '2025-11-22 12:37:39', 2022),
(3248, 'HH-2023-001', 'Eduardo Fernandez', '09821816979', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-05-06 10:19:56', '2025-11-22 12:37:39', 2023),
(3249, 'HH-2023-002', 'Lapu-Lapu', '09146930689', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-04-26 07:17:24', '2025-11-22 12:37:39', 2023),
(3250, 'HH-2023-003', 'Jose Rizal', '09312620365', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-01-20 03:41:02', '2025-11-22 12:37:39', 2023),
(3251, 'HH-2023-004', 'Maria Clara Santos', '09288002398', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-07-23 01:53:47', '2025-11-22 12:37:39', 2023),
(3252, 'HH-2023-005', 'Andres Bonifacio', '09721097432', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-04-22 00:22:27', '2025-11-22 12:37:39', 2023),
(3253, 'HH-2023-006', 'Gabriela Silang', '09228167608', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-02-19 07:18:47', '2025-11-22 12:37:39', 2023),
(3254, 'HH-2023-007', 'Roberto Lim', '09937982035', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-01-22 09:26:40', '2025-11-22 12:37:39', 2023),
(3255, 'HH-2023-008', 'Pedro Garcia', '09398163581', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-06-27 05:38:32', '2025-11-22 12:37:39', 2023),
(3256, 'HH-2023-009', 'Marco Antonio', '09731383977', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-07-12 03:03:38', '2025-11-22 12:37:39', 2023),
(3257, 'HH-2023-010', 'Emilio Aguinaldo', '09536211173', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-09-11 02:30:18', '2025-11-22 12:37:39', 2023),
(3258, 'HH-2023-011', 'Juan dela Cruz', '09597631728', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-04-13 03:12:57', '2025-11-22 12:37:39', 2023),
(3259, 'HH-2023-012', 'Felipe Gozon', '09638560594', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-11-22 05:49:24', '2025-11-22 12:37:39', 2023),
(3260, 'HH-2023-013', 'Sofia Vergara', '09677408768', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-06-18 04:42:02', '2025-11-22 12:37:39', 2023),
(3261, 'HH-2023-014', 'Sofia Vergara', '09341827244', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-02-13 00:26:57', '2025-11-22 12:37:39', 2023),
(3262, 'HH-2023-015', 'Roberto Lim', '09638699772', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-07-10 02:39:55', '2025-11-22 12:37:39', 2023),
(3263, 'HH-2023-016', 'Antonio Bautista', '09154772393', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-12-17 00:16:27', '2025-11-22 12:37:39', 2023),
(3264, 'HH-2023-017', 'Antonio Bautista', '09831292894', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-01-06 06:01:09', '2025-11-22 12:37:39', 2023),
(3265, 'HH-2023-018', 'Eduardo Fernandez', '09529981824', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-03-24 00:23:18', '2025-11-22 12:37:39', 2023),
(3266, 'HH-2023-019', 'Andres Bonifacio', '09847092048', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-03-09 07:04:52', '2025-11-22 12:37:39', 2023),
(3267, 'HH-2023-020', 'Pedro Garcia', '09389998839', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-06-12 02:44:44', '2025-11-22 12:37:39', 2023),
(3268, 'HH-2023-021', 'Felipe Gozon', '09438106857', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-06-22 09:06:47', '2025-11-22 12:37:39', 2023),
(3269, 'HH-2023-022', 'Jose Rizal', '09972848254', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-08-09 09:15:25', '2025-11-22 12:37:39', 2023),
(3270, 'HH-2023-023', 'Maria Clara Santos', '09295397688', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-02-17 00:51:27', '2025-11-22 12:37:39', 2023),
(3271, 'HH-2023-024', 'Andres Bonifacio', '09830355880', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-01-16 07:12:28', '2025-11-22 12:37:39', 2023),
(3272, 'HH-2023-025', 'Ana Reyes', '09198007708', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-09-05 05:35:14', '2025-11-22 12:37:39', 2023),
(3273, 'HH-2023-026', 'Sofia Vergara', '09497733628', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-06-13 02:18:39', '2025-11-22 12:37:39', 2023),
(3274, 'HH-2023-027', 'Jose Rizal', '09880791913', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-09-09 00:24:01', '2025-11-22 12:37:39', 2023),
(3275, 'HH-2023-028', 'Isabella Cruz', '09823047507', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-02-09 02:54:23', '2025-11-22 12:37:39', 2023),
(3276, 'HH-2023-029', 'Isabella Cruz', '09484501769', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-09-10 10:45:36', '2025-11-22 12:37:39', 2023),
(3277, 'HH-2023-030', 'Gabriela Silang', '09884412927', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-11-07 02:13:11', '2025-11-22 12:37:39', 2023),
(3278, 'HH-2023-031', 'Isabella Cruz', '09551969344', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-10-23 00:50:59', '2025-11-22 12:37:39', 2023),
(3279, 'HH-2023-032', 'Maria Clara Santos', '09244331191', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-03-12 06:03:36', '2025-11-22 12:37:39', 2023),
(3280, 'HH-2023-033', 'Lapu-Lapu', '09288738773', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-03-20 01:14:53', '2025-11-22 12:37:39', 2023),
(3281, 'HH-2023-034', 'Sofia Vergara', '09648821570', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-09-05 06:19:36', '2025-11-22 12:37:39', 2023),
(3282, 'HH-2023-035', 'Andres Bonifacio', '09351954524', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2023-09-12 01:36:47', '2025-11-22 12:37:39', 2023),
(3283, 'HH-2024-001', 'Eduardo Fernandez', '09715210546', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-08-22 01:57:03', '2025-11-22 12:37:39', 2024),
(3284, 'HH-2024-002', 'Sofia Vergara', '09895509153', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-07-06 05:00:06', '2025-11-22 12:37:39', 2024),
(3285, 'HH-2024-003', 'Sofia Vergara', '09356249208', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-04-27 07:54:15', '2025-11-22 12:37:39', 2024),
(3286, 'HH-2024-004', 'Antonio Bautista', '09255913385', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-01-27 08:14:05', '2025-11-22 12:37:39', 2024),
(3287, 'HH-2024-005', 'Eduardo Fernandez', '09620807320', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-11-02 07:48:45', '2025-11-22 12:37:39', 2024),
(3288, 'HH-2024-006', 'Pedro Garcia', '09599372660', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-10-09 09:01:17', '2025-11-22 12:37:39', 2024),
(3289, 'HH-2024-007', 'Ana Reyes', '09998491433', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-06-17 09:54:27', '2025-11-22 12:37:39', 2024),
(3290, 'HH-2024-008', 'Antonio Bautista', '09483688982', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-05-18 01:19:25', '2025-11-22 12:37:39', 2024),
(3291, 'HH-2024-009', 'Andres Bonifacio', '09845998129', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-12-09 03:09:16', '2025-11-22 12:37:39', 2024),
(3292, 'HH-2024-010', 'Eduardo Fernandez', '09545977614', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-04-18 02:28:33', '2025-11-22 12:37:39', 2024),
(3293, 'HH-2024-011', 'Emilio Aguinaldo', '09918405465', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-08-27 08:49:45', '2025-11-22 12:37:39', 2024),
(3294, 'HH-2024-012', 'Felipe Gozon', '09459298225', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-09-27 10:17:36', '2025-11-22 12:37:39', 2024),
(3295, 'HH-2024-013', 'Roberto Lim', '09749436018', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-06-22 03:12:30', '2025-11-22 12:37:39', 2024),
(3296, 'HH-2024-014', 'Luzviminda Torres', '09742510178', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-04-08 05:50:38', '2025-11-22 12:37:39', 2024),
(3297, 'HH-2024-015', 'Pedro Garcia', '09537587693', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-09-19 02:39:07', '2025-11-22 12:37:39', 2024),
(3298, 'HH-2024-016', 'Lapu-Lapu', '09595105777', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-10-23 06:24:53', '2025-11-22 12:37:39', 2024),
(3299, 'HH-2024-017', 'Maria Clara Santos', '09267825904', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-02-18 06:36:12', '2025-11-22 12:37:39', 2024),
(3300, 'HH-2024-018', 'Jose Rizal', '09451952056', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-04-13 01:59:29', '2025-11-22 12:37:39', 2024),
(3301, 'HH-2024-019', 'Lapu-Lapu', '09372649310', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-02-13 08:44:39', '2025-11-22 12:37:39', 2024),
(3302, 'HH-2024-020', 'Andres Bonifacio', '09980570063', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-02-08 00:27:04', '2025-11-22 12:37:39', 2024),
(3303, 'HH-2024-021', 'Andres Bonifacio', '09659939272', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-08-23 07:40:21', '2025-11-22 12:37:39', 2024),
(3304, 'HH-2024-022', 'Felipe Gozon', '09668941551', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-06-03 08:11:34', '2025-11-22 12:37:39', 2024),
(3305, 'HH-2024-023', 'Maria Clara Santos', '09134756243', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-05-05 04:02:15', '2025-11-22 12:37:39', 2024),
(3306, 'HH-2024-024', 'Andres Bonifacio', '09383871814', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-07-11 10:29:50', '2025-11-22 12:37:39', 2024),
(3307, 'HH-2024-025', 'Elena Castro', '09380532609', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-05-03 01:19:30', '2025-11-22 12:37:39', 2024),
(3308, 'HH-2024-026', 'Carmencita Mendoza', '09794884516', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-10-26 05:10:52', '2025-11-22 12:37:39', 2024),
(3309, 'HH-2024-027', 'Carmencita Mendoza', '09157052203', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-08-04 06:26:55', '2025-11-22 12:37:39', 2024),
(3310, 'HH-2024-028', 'Antonio Bautista', '09872614529', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-09-05 10:45:03', '2025-11-22 12:37:39', 2024),
(3311, 'HH-2024-029', 'Ana Reyes', '09249451448', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-10-07 00:44:51', '2025-11-22 12:37:39', 2024),
(3312, 'HH-2024-030', 'Sofia Vergara', '09643266659', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-02-04 07:48:00', '2025-11-22 12:37:39', 2024),
(3313, 'HH-2024-031', 'Luzviminda Torres', '09823419249', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-03-20 01:56:57', '2025-11-22 12:37:39', 2024),
(3314, 'HH-2024-032', 'Jose Rizal', '09566887464', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-04-06 00:13:06', '2025-11-22 12:37:39', 2024),
(3315, 'HH-2024-033', 'Luzviminda Torres', '09893805259', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-12-26 02:21:56', '2025-11-22 12:37:39', 2024),
(3316, 'HH-2024-034', 'Ana Reyes', '09517906561', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-01-09 07:17:39', '2025-11-22 12:37:39', 2024),
(3317, 'HH-2024-035', 'Emilio Aguinaldo', '09710615965', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2024-04-22 06:16:23', '2025-11-22 12:37:39', 2024),
(3318, 'HH-2025-001', 'Eduardo Fernandez', '09112715409', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-07-14 01:43:56', '2025-11-22 12:37:39', 2025),
(3319, 'HH-2025-002', 'Felipe Gozon', '09344650684', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-10-23 00:29:16', '2025-11-22 12:37:39', 2025),
(3320, 'HH-2025-003', 'Sofia Vergara', '09664754526', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-03-13 06:19:52', '2025-11-22 12:37:39', 2025),
(3321, 'HH-2025-004', 'Sofia Vergara', '09347251435', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-08-17 06:16:22', '2025-11-22 12:37:39', 2025),
(3322, 'HH-2025-005', 'Marco Antonio', '09456138467', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-12-14 03:42:07', '2025-11-22 12:37:39', 2025),
(3323, 'HH-2025-006', 'Lapu-Lapu', '09578979861', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-03-11 07:01:18', '2025-11-22 12:37:39', 2025),
(3324, 'HH-2025-007', 'Luzviminda Torres', '09694269619', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-12-11 04:54:45', '2025-11-22 12:37:39', 2025),
(3325, 'HH-2025-008', 'Ana Reyes', '09449819231', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-07-20 08:06:12', '2025-11-22 12:37:39', 2025),
(3326, 'HH-2025-009', 'Eduardo Fernandez', '09387164411', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-08-15 08:46:49', '2025-11-22 12:37:39', 2025),
(3327, 'HH-2025-010', 'Pedro Garcia', '09171345039', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-07-14 06:51:13', '2025-11-22 12:37:39', 2025),
(3328, 'HH-2025-011', 'Maria Clara Santos', '09613071574', 'Purok Sampaguita', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-09-02 09:08:03', '2025-11-22 12:37:39', 2025),
(3329, 'HH-2025-012', 'Eduardo Fernandez', '09917820500', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-06-14 04:02:11', '2025-11-22 12:37:39', 2025),
(3330, 'HH-2025-013', 'Antonio Bautista', '09543889164', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-05-24 10:25:28', '2025-11-22 12:37:39', 2025),
(3331, 'HH-2025-014', 'Sofia Vergara', '09478703985', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-08-17 05:21:33', '2025-11-22 12:37:39', 2025),
(3332, 'HH-2025-015', 'Luzviminda Torres', '09493848954', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-03-24 03:52:04', '2025-11-22 12:37:39', 2025),
(3333, 'HH-2025-016', 'Luzviminda Torres', '09327073607', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-07-27 09:27:23', '2025-11-22 12:37:39', 2025),
(3334, 'HH-2025-017', 'Antonio Bautista', '09313488810', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-06-06 05:24:13', '2025-11-22 12:37:39', 2025),
(3335, 'HH-2025-018', 'Juan dela Cruz', '09717494884', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-10-15 06:00:00', '2025-11-22 12:37:39', 2025),
(3336, 'HH-2025-019', 'Antonio Bautista', '09135834797', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-10-24 10:47:49', '2025-11-22 12:37:39', 2025),
(3337, 'HH-2025-020', 'Elena Castro', '09423585106', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-12-05 08:58:14', '2025-11-22 12:37:39', 2025),
(3338, 'HH-2025-021', 'Jose Rizal', '09315279799', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-12-14 10:34:12', '2025-11-22 12:37:39', 2025),
(3339, 'HH-2025-022', 'Maria Clara Santos', '09282282332', 'Purok Rosal', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-03-08 04:30:47', '2025-11-22 12:37:39', 2025),
(3340, 'HH-2025-023', 'Gabriela Silang', '09165605176', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-02-03 03:32:45', '2025-11-22 12:37:39', 2025),
(3341, 'HH-2025-024', 'Pedro Garcia', '09598932051', 'Purok Mango', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-04-15 03:53:05', '2025-11-22 12:37:39', 2025),
(3342, 'HH-2025-025', 'Sofia Vergara', '09222734935', 'Purok Lanzones', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-11-17 08:13:02', '2025-11-22 12:37:39', 2025),
(3343, 'HH-2025-026', 'Pedro Garcia', '09456792117', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-06-04 05:48:50', '2025-11-22 12:37:39', 2025),
(3344, 'HH-2025-027', 'Sofia Vergara', '09830365418', 'Sitio Ilang-ilang', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-11-15 02:41:29', '2025-11-22 12:37:39', 2025),
(3345, 'HH-2025-028', 'Jose Rizal', '09665272495', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-08-28 00:03:25', '2025-11-22 12:37:39', 2025),
(3346, 'HH-2025-029', 'Gabriela Silang', '09512849291', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-05-13 01:53:52', '2025-11-22 12:37:39', 2025),
(3347, 'HH-2025-030', 'Sofia Vergara', '09287524495', 'Purok Kamunggay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-02-01 04:11:45', '2025-11-22 12:37:39', 2025),
(3348, 'HH-2025-031', 'Maria Clara Santos', '09568729747', 'Sitio Baybay', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-02-04 01:07:52', '2025-11-22 12:37:39', 2025),
(3349, 'HH-2025-032', 'Isabella Cruz', '09873590393', 'Purok 3', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-02-19 07:59:37', '2025-11-22 12:37:39', 2025),
(3350, 'HH-2025-033', 'Rosita Aquino', '09859935508', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-12-14 08:10:57', '2025-11-22 12:37:39', 2025),
(3351, 'HH-2025-034', 'Andres Bonifacio', '09320899582', 'Purok 2', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-04-10 10:24:31', '2025-11-22 12:37:39', 2025),
(3352, 'HH-2025-035', 'Antonio Bautista', '09232878179', 'Purok 1', 'Rizal', 'Katipunan', 'Zamboanga del Norte', NULL, NULL, '2025-02-14 05:55:22', '2025-11-22 12:37:39', 2025);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `fullname` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `role` enum('Secretary','Captain') DEFAULT 'Secretary',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `fullname`, `email`, `username`, `password`, `role`, `created_at`) VALUES
(8, 'Lemuel Alvarico', 'lemuel@gmail.com', 'lemuel', '123456', 'Captain', '2025-11-11 05:35:40'),
(11, 'ayang', 'ayang@gmail.com', 'aya', '123456', 'Secretary', '2025-11-20 00:28:06'),
(13, 'John Ivo Abadilla', 'ivo@gmail.com', 'ivo', '123123', 'Secretary', '2025-11-22 03:41:45'),
(14, 'Jesie Gapol', 'gapol@gmail.com', 'gapol', '123123', 'Secretary', '2025-11-22 04:56:53');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `households`
--
ALTER TABLE `households`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `household_number` (`household_number`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `households`
--
ALTER TABLE `households`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3353;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `activity_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
