-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.22-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for absensi_pegawai
CREATE DATABASE IF NOT EXISTS `absensi_pegawai` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `absensi_pegawai`;

-- Dumping structure for table absensi_pegawai.absen
CREATE TABLE IF NOT EXISTS `absen` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_pegawai` int(11) DEFAULT NULL,
  `jam_masuk` time DEFAULT NULL,
  `jam_keluar` time DEFAULT NULL,
  `tanggal` date DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table absensi_pegawai.absen: ~1 rows (approximately)
/*!40000 ALTER TABLE `absen` DISABLE KEYS */;
INSERT INTO `absen` (`id`, `id_pegawai`, `jam_masuk`, `jam_keluar`, `tanggal`, `status`) VALUES
	(1, 1, '13:30:11', '13:30:12', '2022-12-11', 1);
/*!40000 ALTER TABLE `absen` ENABLE KEYS */;

-- Dumping structure for table absensi_pegawai.departemen
CREATE TABLE IF NOT EXISTS `departemen` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama_departemen` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table absensi_pegawai.departemen: ~8 rows (approximately)
/*!40000 ALTER TABLE `departemen` DISABLE KEYS */;
INSERT INTO `departemen` (`id`, `nama_departemen`) VALUES
	(1, 'SCM'),
	(2, 'Finance'),
	(3, 'IT'),
	(4, 'Operation'),
	(5, 'Human Resource'),
	(6, 'HSSE'),
	(7, 'Controller'),
	(8, 'Marketing');
/*!40000 ALTER TABLE `departemen` ENABLE KEYS */;

-- Dumping structure for table absensi_pegawai.jabatan
CREATE TABLE IF NOT EXISTS `jabatan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jabatan` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table absensi_pegawai.jabatan: ~5 rows (approximately)
/*!40000 ALTER TABLE `jabatan` DISABLE KEYS */;
INSERT INTO `jabatan` (`id`, `jabatan`) VALUES
	(1, 'Direktur'),
	(2, 'Sekretaris Direktur'),
	(3, 'Manager'),
	(4, 'Asisten Manager'),
	(5, 'Admin Departemen'),
	(6, 'Supervisor'),
	(7, 'Programmer'),
	(8, 'tes 2'),
	(9, 'tes 3');
/*!40000 ALTER TABLE `jabatan` ENABLE KEYS */;

-- Dumping structure for table absensi_pegawai.pegawai
CREATE TABLE IF NOT EXISTS `pegawai` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_dp` int(11) DEFAULT NULL,
  `id_jabatan` int(11) DEFAULT NULL,
  `tgl_mulai_kerja` date DEFAULT NULL,
  `nama` varchar(50) DEFAULT NULL,
  `ttl` date DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table absensi_pegawai.pegawai: ~3 rows (approximately)
/*!40000 ALTER TABLE `pegawai` DISABLE KEYS */;
INSERT INTO `pegawai` (`id`, `id_dp`, `id_jabatan`, `tgl_mulai_kerja`, `nama`, `ttl`, `alamat`, `status`) VALUES
	(1, 1, 1, '2022-12-11', 'Fernando Sumarno', '2022-12-11', 'Depok', 1),
	(2, 3, 3, '2020-12-23', 'Kevin De Bruyne', '1992-03-12', 'Margonda, Depok', 1),
	(3, 3, 3, '2020-12-23', 'Ronaldo Nazario', '1992-03-12', 'Margonda, Depok', 1);
/*!40000 ALTER TABLE `pegawai` ENABLE KEYS */;

-- Dumping structure for table absensi_pegawai.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table absensi_pegawai.users: ~4 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`, `username`, `password`) VALUES
	(1, 'admin', '5f4dcc3b5aa765d61d8327deb882cf99'),
	(2, 'admin_absen', '5f4dcc3b5aa765d61d8327deb882cf99'),
	(3, 'reza', '44fa9eb827ef6e389b3969e9ac2745a5'),
	(4, 'superadmin', '17c4520f6cfd1ab53d8745e84681eb49');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
