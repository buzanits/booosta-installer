/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `webapp3`
--

-- --------------------------------------------------------

--
-- Table structure for table `adminuser`
--


CREATE TABLE IF NOT EXISTS `adminuser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `token` varchar(255) NULL,
  `logincookie` varchar(255) NULL,
  `comment` text NULL,
  `active` tinyint(4) NOT NULL,
  `usersettings` text NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `adminuser`
--

INSERT INTO `adminuser` (`id`, `username`, `password`, `comment`, `active`, `usersettings`) VALUES
(1, 'admin', '', 'Adminuser', 1, 'a:0;');

-- --------------------------------------------------------

--
-- Table structure for table `adminuser_privilege`
--

CREATE TABLE IF NOT EXISTS `adminuser_privilege` (
  `user` int(11) NOT NULL,
  `privilege` int(11) NOT NULL,
  PRIMARY KEY (`user`,`privilege`),
  KEY `privilege` (`privilege`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `adminuser_role`
--

CREATE TABLE IF NOT EXISTS `adminuser_role` (
  `user` int(11) NOT NULL,
  `role` int(11) NOT NULL,
  PRIMARY KEY (`user`,`role`),
  KEY `role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `adminuser_role`
--

INSERT INTO `adminuser_role` (`user`, `role`) VALUES
(1, 1);



CREATE TABLE `log_db` (
  `id` int(11) NOT NULL,
  `user` varchar(255) NOT NULL,
  `time` datetime NOT NULL,
  `ip` varchar(15) NOT NULL,
  `query` text NOT NULL,
  `phpself` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Indexes for table `log_db`
--
ALTER TABLE `log_db`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `log_db`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


CREATE TABLE `log_login` (
  `id` int(11) NOT NULL,
  `user` varchar(255) NOT NULL,
  `time` datetime NOT NULL,
  `ip` varchar(15) NOT NULL,
  `success` tinyint(1) NOT NULL,
  `usertype` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for table `log_login`
--
ALTER TABLE `log_login`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for table `log_login`
--
ALTER TABLE `log_login`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


-- --------------------------------------------------------

--
-- Table structure for table `privilege`
--

CREATE TABLE IF NOT EXISTS `privilege` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=17 ;

--
-- Dumping data for table `privilege`
--

INSERT INTO `privilege` (`id`, `name`) VALUES
(1, 'create adminuser'),
(4, 'create privilege'),
(7, 'create role'),
(10, 'create user'),
(3, 'delete adminuser'),
(6, 'delete privilege'),
(9, 'delete role'),
(12, 'delete user'),
(2, 'edit adminuser'),
(5, 'edit privilege'),
(8, 'edit role'),
(16, 'edit self'),
(11, 'edit user');

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

CREATE TABLE IF NOT EXISTS `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `role`
--

INSERT INTO `role` (`id`, `name`) VALUES
(1, 'Admin'),
(2, 'Customer');

-- --------------------------------------------------------

--
-- Table structure for table `role_privilege`
--

CREATE TABLE IF NOT EXISTS `role_privilege` (
  `role` int(11) NOT NULL,
  `privilege` int(11) NOT NULL,
  PRIMARY KEY (`role`,`privilege`),
  KEY `privilege` (`privilege`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `role_privilege`
--

INSERT INTO `role_privilege` (`role`, `privilege`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 16);

-- --------------------------------------------------------

--
-- Table structure for table `role_role`
--

CREATE TABLE IF NOT EXISTS `role_role` (
  `superrole` int(11) NOT NULL,
  `subrole` int(11) NOT NULL,
  PRIMARY KEY (`superrole`,`subrole`),
  KEY `subrole` (`subrole`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `token` varchar(255) NULL,
  `logincookie` varchar(255) NULL,
  `comment` text NULL,
  `active` tinyint(4) NOT NULL,
  `usersettings` text NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `user_privilege`
--

CREATE TABLE IF NOT EXISTS `user_privilege` (
  `user` int(11) NOT NULL,
  `privilege` int(11) NOT NULL,
  PRIMARY KEY (`user`,`privilege`),
  KEY `privilege` (`privilege`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `user_role`
--

CREATE TABLE IF NOT EXISTS `user_role` (
  `user` int(11) NOT NULL,
  `role` int(11) NOT NULL,
  PRIMARY KEY (`user`,`role`),
  KEY `role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `form_token`
--

CREATE TABLE IF NOT EXISTS `form_token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(255) NOT NULL,
  `created` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `token` (`token`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `cache`
--

CREATE TABLE IF NOT EXISTS `cache` (
  `ckey` varchar(254) NOT NULL,
  `dtime` int(11) NOT NULL,
  `content` text NULL,
  PRIMARY KEY (`ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `settings`
--

CREATE TABLE IF NOT EXISTS `settings` (
  `attribute` varchar(254) NOT NULL,
  `value` text NULL,
  PRIMARY KEY (`attribute`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Constraints for dumped tables
--


--
-- Constraints for table `adminuser_privilege`
--
ALTER TABLE `adminuser_privilege`
  ADD CONSTRAINT `adminuser_privilege_ibfk_3` FOREIGN KEY (`user`) REFERENCES `adminuser` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `adminuser_privilege_ibfk_2` FOREIGN KEY (`privilege`) REFERENCES `privilege` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `adminuser_role`
--
ALTER TABLE `adminuser_role`
  ADD CONSTRAINT `adminuser_role_ibfk_2` FOREIGN KEY (`user`) REFERENCES `adminuser` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `adminuser_role_ibfk_1` FOREIGN KEY (`role`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `role_privilege`
--
ALTER TABLE `role_privilege`
  ADD CONSTRAINT `role_privilege_ibfk_2` FOREIGN KEY (`privilege`) REFERENCES `privilege` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `role_privilege_ibfk_1` FOREIGN KEY (`role`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `role_role`
--
ALTER TABLE `role_role`
  ADD CONSTRAINT `role_role_ibfk_2` FOREIGN KEY (`subrole`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `role_role_ibfk_1` FOREIGN KEY (`superrole`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_privilege`
--
ALTER TABLE `user_privilege`
  ADD CONSTRAINT `user_privilege_ibfk_2` FOREIGN KEY (`privilege`) REFERENCES `privilege` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_privilege_ibfk_1` FOREIGN KEY (`user`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_role`
--
ALTER TABLE `user_role`
  ADD CONSTRAINT `user_role_ibfk_2` FOREIGN KEY (`user`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_role_ibfk_1` FOREIGN KEY (`role`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Table structure for table `compactdisc`
--

CREATE TABLE `compactdisc` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `artist` varchar(255) NOT NULL,
  `genre` enum('pop','rock','classic','other') NOT NULL,
  `publication` date DEFAULT NULL,
  `description` text DEFAULT NULL,
  `cdr` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `compactdisc`
--

INSERT INTO `compactdisc` (`id`, `name`, `artist`, `genre`, `publication`, `description`, `cdr`) VALUES
(1, 'Super Trouper', 'ABBA', 'pop', '2022-01-01', 'ABBA!', 1),
(2, 'Undercover', 'Stones', 'rock', '2022-01-03', 'Stones!', 0);

-- --------------------------------------------------------

--
-- Table structure for table `song`
--

CREATE TABLE `song` (
  `id` int(11) NOT NULL,
  `compactdisc` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `length` int(11) NOT NULL,
  `number` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `song`
--

INSERT INTO `song` (`id`, `compactdisc`, `name`, `length`, `number`) VALUES
(1, 1, 'Super Trouper', 180, 1),
(2, 1, 'Andante, Andante', 170, 2),
(4, 1, 'Happy New Year', 183, 3);

--
-- Indexes for table `compactdisc`
--
ALTER TABLE `compactdisc`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `song`
--
ALTER TABLE `song`
  ADD PRIMARY KEY (`id`),
  ADD KEY `compactdisc` (`compactdisc`);

--
-- AUTO_INCREMENT for table `compactdisc`
--
ALTER TABLE `compactdisc`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `song`
--
ALTER TABLE `song`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for table `song`
--
ALTER TABLE `song`
  ADD CONSTRAINT `song_ibfk_1` FOREIGN KEY (`compactdisc`) REFERENCES `compactdisc` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

--
-- Table structure for table `event`
--

CREATE TABLE `event` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `startdate` datetime NOT NULL,
  `enddate` datetime NOT NULL,
  `color` varchar(255) DEFAULT NULL,
  `readonly` tinyint(4) NOT NULL DEFAULT 0,
  `allday` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for table `event`
--
ALTER TABLE `event`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for table `event`
--
ALTER TABLE `event`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
