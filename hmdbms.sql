-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 04, 2023 at 06:36 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.1.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hmdbms`
--

-- --------------------------------------------------------

--
-- Table structure for table `contact`
--

CREATE TABLE `contact` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `message` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contact`
--

INSERT INTO `contact` (`id`, `name`, `email`, `message`) VALUES
(1, 'Tejas', 'Tejas@gmail.com', 'None');

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `did` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `doctorname` varchar(100) NOT NULL,
  `dept` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`did`, `email`, `doctorname`, `dept`) VALUES
(1, 'sandip@gmail.com', 'om ', 'orthopedic'),
(3, 'sandip@gmail.com', 'rajan', 'Gynacologist');

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `pid` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `gender` varchar(100) NOT NULL,
  `slot` varchar(100) NOT NULL,
  `disease` varchar(100) NOT NULL,
  `time` time NOT NULL,
  `date` date NOT NULL,
  `dept` varchar(100) NOT NULL,
  `number` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`pid`, `email`, `name`, `gender`, `slot`, `disease`, `time`, `date`, `dept`, `number`) VALUES
(8, 'sandip@gmail.com', 'raj', 'Male', 'evening', 'no', '22:03:00', '2023-05-04', 'orthopedic', '8764851231'),
(9, 'sandip@gmail.com', 'raj', 'Male', 'evening', 'none', '11:05:00', '2023-05-03', 'orthopedic', '8641253012'),
(10, 'sandip@gmail.com', 'yash ', 'Male', 'morning', 'none', '23:19:00', '2023-05-09', 'orthopedic', '8765472135'),
(27, 'ak@gmail.com', 'ak', 'Male', 'evening', 'fever', '20:09:00', '2023-05-10', 'orthopedic', '8765324261'),
(28, 'ak@gmail.com', 'ak11', 'Male', 'night', 'nightblindness', '23:25:00', '2023-05-04', 'orthopedic', '8765324211'),
(33, 'siddhu@gmail.com', 'siddhu', 'Male', 'morning', 'none', '11:20:00', '2023-05-04', 'orthopedic', '8754221532'),
(34, 'sandip@gmail.com', 'sandip', 'Male', 'morning', 'none', '12:59:00', '2023-05-10', 'orthopedic', '8765452131'),
(35, 'sandip@gmail.com', 'sandip', 'Male', 'morning', 'none', '12:02:00', '2023-05-04', 'orthopedic', '8765142522');

--
-- Triggers `patients`
--
DELIMITER $$
CREATE TRIGGER `PatientDelete` BEFORE DELETE ON `patients` FOR EACH ROW INSERT INTO `trigr` VALUES (null , OLD.pid , OLD.name , OLD.email , 'PATIENT DELETED' , NOW())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `PatientUpdate` AFTER INSERT ON `patients` FOR EACH ROW INSERT INTO `trigr` VALUES (null , NEW.pid , NEW.name , NEW.email , 'PATIENT UPDATED' , NOW())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `patientinsertion` AFTER INSERT ON `patients` FOR EACH ROW INSERT INTO `trigr` VALUES (null , NEW.pid , NEW.name , NEW.email , 'PATIENT INSERTED' , NOW())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `trigr`
--

CREATE TABLE `trigr` (
  `tid` int(11) NOT NULL,
  `pid` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `action` varchar(100) NOT NULL,
  `timestamp` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trigr`
--

INSERT INTO `trigr` (`tid`, `pid`, `name`, `email`, `action`, `timestamp`) VALUES
(1, 28, 'ak11', 'ak@gmail.com', 'PATIENT INSERTED ', '2023-05-02 01:22:55'),
(2, 34, 'sandip', 'sandip@gmail.com', 'PATIENT INSERTED', '2023-05-02 11:58:32'),
(3, 35, 'sandip', 'sandip@gmail.com', 'PATIENT INSERTED', '2023-05-02 12:01:33'),
(4, 35, 'sandip', 'sandip@gmail.com', 'PATIENT UPDATED', '2023-05-02 12:01:33'),
(5, 7, 'Atharva', 'sandip@gmail.com', 'PATIENT DELETED', '2023-05-02 12:07:57');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(100) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `email`, `password`) VALUES
(1, 'sandip', 'sandip@gmail.com', 'pbkdf2:sha256:260000$sWEFBrhRZYYovaEw$d57cf152a4baad8b37d6425f3771a51ea7e63d42cd57091f257bd05ced6198c3'),
(2, 'ak', 'ak@gmail.com', 'pbkdf2:sha256:600000$ykUD5OJgEHMMvzO6$079f29a083bfb92ac886898d4520601c2853174e1d939959ab67767e714c1552'),
(3, 'siddhu', 'siddhu@gmail.com', 'pbkdf2:sha256:600000$SYpZJPQjc2P97MWs$17bd50a9c2872c6f57183ccd6cf005b5deafe62499f419bda123ef338eee4a5d');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `contact`
--
ALTER TABLE `contact`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`did`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`pid`);

--
-- Indexes for table `trigr`
--
ALTER TABLE `trigr`
  ADD PRIMARY KEY (`tid`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `contact`
--
ALTER TABLE `contact`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `did` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `pid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `trigr`
--
ALTER TABLE `trigr`
  MODIFY `tid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
