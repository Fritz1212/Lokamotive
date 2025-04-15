-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 15, 2025 at 06:41 AM
-- Server version: 10.4.19-MariaDB
-- PHP Version: 8.0.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lokamotive`
--

-- --------------------------------------------------------

--
-- Table structure for table `userpreference`
--

CREATE TABLE `userpreference` (
  `id` varchar(25) DEFAULT NULL,
  `interaction` int(11) DEFAULT NULL,
  `preferences` varchar(25) DEFAULT NULL,
  `isColdStart` tinyint(1) DEFAULT NULL,
  `embedding` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `userpreference`
--

INSERT INTO `userpreference` (`id`, `interaction`, `preferences`, `isColdStart`, `embedding`) VALUES
('user123', 9, 'jalan kaki', 0, 0.258682132351413);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `passwordz` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `user_name`, `email`, `passwordz`) VALUES
(1, 'yoga', 'slavs223@gmail.com', 'Shalmon12'),
(2, 'toper', 'a@gmail.com', 'toper123'),
(3, 'udin', 'retohebit@gmail.com', '$2b$10$AKu1El2belNTk65vYiiiyeDklor2lfTxKWwVAd9nsr82wGvZrF1Iu'),
(4, 'Fritz Yovanka', 'yoga321@gmail.com', '$2b$10$1zKycskb20KXPaHTpnmWmOIZ4j0siZTgTgSYnXHwrLhnBRN5.VVN.');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
