-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: efit_macurex
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-19 16:29:17
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: vcargo
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `commentsid` bigint NOT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `notificationflag` bit(1) DEFAULT NULL,
  `orgid` bigint DEFAULT NULL,
  `sourceid` bigint DEFAULT NULL,
  `sourceorgid` bigint DEFAULT NULL,
  `sourceticketid` bigint DEFAULT NULL,
  `sourceusername` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `ticketid` bigint DEFAULT NULL,
  `modifiedy` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`commentsid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commentsseq`
--

DROP TABLE IF EXISTS `commentsseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commentsseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commentsseq`
--

LOCK TABLES `commentsseq` WRITE;
/*!40000 ALTER TABLE `commentsseq` DISABLE KEYS */;
INSERT INTO `commentsseq` VALUES (1000000001);
/*!40000 ALTER TABLE `commentsseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companyaddress`
--

DROP TABLE IF EXISTS `companyaddress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companyaddress` (
  `companyaddressid` bigint NOT NULL,
  `billingaddress` varchar(255) DEFAULT NULL,
  `primarys` bit(1) DEFAULT NULL,
  `shippingaddress` varchar(255) DEFAULT NULL,
  `companyprofileid` bigint DEFAULT NULL,
  PRIMARY KEY (`companyaddressid`),
  KEY `FKjbtkbvp787c5c9v4bb6lqy4hb` (`companyprofileid`),
  CONSTRAINT `FKjbtkbvp787c5c9v4bb6lqy4hb` FOREIGN KEY (`companyprofileid`) REFERENCES `companyprofile` (`companyprofileid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companyaddress`
--

LOCK TABLES `companyaddress` WRITE;
/*!40000 ALTER TABLE `companyaddress` DISABLE KEYS */;
INSERT INTO `companyaddress` VALUES (1000000001,'Melur , Madurai ',_binary '','Natham,Dindigul',1000000001);
/*!40000 ALTER TABLE `companyaddress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companyaddressseq`
--

DROP TABLE IF EXISTS `companyaddressseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companyaddressseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companyaddressseq`
--

LOCK TABLES `companyaddressseq` WRITE;
/*!40000 ALTER TABLE `companyaddressseq` DISABLE KEYS */;
INSERT INTO `companyaddressseq` VALUES (1000000002);
/*!40000 ALTER TABLE `companyaddressseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companybankdetails`
--

DROP TABLE IF EXISTS `companybankdetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companybankdetails` (
  `companybankdetailsid` bigint NOT NULL,
  `accountholdername` varchar(255) DEFAULT NULL,
  `accountnumber` varchar(255) DEFAULT NULL,
  `bankname` varchar(255) DEFAULT NULL,
  `branch` varchar(255) DEFAULT NULL,
  `branchcode` varchar(255) DEFAULT NULL,
  `ifsccode` varchar(255) DEFAULT NULL,
  `primarys` bit(1) DEFAULT NULL,
  `companyprofileid` bigint DEFAULT NULL,
  PRIMARY KEY (`companybankdetailsid`),
  KEY `FKjs2yklryolcxvy6j2cpnmc9i` (`companyprofileid`),
  CONSTRAINT `FKjs2yklryolcxvy6j2cpnmc9i` FOREIGN KEY (`companyprofileid`) REFERENCES `companyprofile` (`companyprofileid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companybankdetails`
--

LOCK TABLES `companybankdetails` WRITE;
/*!40000 ALTER TABLE `companybankdetails` DISABLE KEYS */;
INSERT INTO `companybankdetails` VALUES (1000000001,'Canara','12345678945678','CANARA','BB CULAM ','','CA110665',_binary '',1000000001);
/*!40000 ALTER TABLE `companybankdetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companybankdetailsseq`
--

DROP TABLE IF EXISTS `companybankdetailsseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companybankdetailsseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companybankdetailsseq`
--

LOCK TABLES `companybankdetailsseq` WRITE;
/*!40000 ALTER TABLE `companybankdetailsseq` DISABLE KEYS */;
INSERT INTO `companybankdetailsseq` VALUES (1000000002);
/*!40000 ALTER TABLE `companybankdetailsseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companyprofile`
--

DROP TABLE IF EXISTS `companyprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companyprofile` (
  `companyprofileid` bigint NOT NULL,
  `active` bit(1) DEFAULT NULL,
  `branch` varchar(255) DEFAULT NULL,
  `branchcode` varchar(255) DEFAULT NULL,
  `cancel` bit(1) DEFAULT NULL,
  `cancelremarks` varchar(255) DEFAULT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `companycode` varchar(255) DEFAULT NULL,
  `companylogo` longblob,
  `companyname` varchar(255) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `emailaddress` varchar(255) DEFAULT NULL,
  `establishedyear` varchar(255) DEFAULT NULL,
  `gstno` varchar(255) DEFAULT NULL,
  `orgid` bigint DEFAULT NULL,
  `ownername` varchar(255) DEFAULT NULL,
  `panno` varchar(255) DEFAULT NULL,
  `phoneno` varchar(255) DEFAULT NULL,
  `termsandconditions` varchar(255) DEFAULT NULL,
  `modifiedby` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`companyprofileid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companyprofile`
--

LOCK TABLES `companyprofile` WRITE;
/*!40000 ALTER TABLE `companyprofile` DISABLE KEYS */;
INSERT INTO `companyprofile` VALUES (1000000001,_binary '\0',NULL,NULL,_binary '\0',NULL,'19-09-2026 02:59:41 PM','19-09-2026 02:59:41 PM','CMP1001',_binary 'ÿ\Øÿ\à\0JFIF\0\0\0\0\0\0ÿ\Û\0„\0\n\n\n\"\"$$6*&&*6>424>LDDL_Z_||§\n\n\n\"\"$$6*&&*6>424>LDDL_Z_||§ÿ\Â\0x|\"\0ÿ\Ä\02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ÿ\Ú\0\0\0\0ó¥Nj\Æ‘\É\\²\nL[±Ø¸FQ¤\"!$HÀS%!#$$1«‚U\ÉbIVKIT\n\ÖTeešQž\í¤Ù©C]Q¦šÄ¦È¶Zb\ãu–\ÑsÙ±´‚½v\è>+¹z/9­\Ç\Z,y®X\×P\Þ0\Ûe>ŽKYšÌ’\00!y†–)’\Z$)bHB@ A\n\ÃPQ„·X–!$Ky\Ó[\ZF¢Áe7\ç·\Z¿:ÝŠ’\ÜÚšò;­\è\Êm Lj­Òœ\ë5·k\Öp\ÜRw¨\èÍ½\Ûm\Z9f\Ê5R\Æ\'±;q\Êô\'N[\æ-\rD\ÑJ,aa€…”\ÄV‹H¸¦yzYQ0Yh•Á£¬ƒ\n´¡B\ÂDVZ$Z$²¸,Œ,tF&\Ä^}SÒ¬0[¬“XÎ¬xq§\Î\ÊWu\æY&m÷â³ž\î¯Fiz\Ôe<û\Ý+\Ð\ëel¸‰SW\×\Î\â\Ö\éŽR=y%\ÙE›³\Ö\Ò\Û()lfZFŠ,V ,5„\"\×z•e\áYiJ²$0\Ñ@ÁtHP\ÈImqQÑ‘„QÔ²­\ê¸Ð®Á¨„º&‰Fw%¶š\ìÍº„R\Ù ô\Øõ\\K¤’h\çº\êC©¿6Ú¸ô*õ­K:ó{\én[\ãD>\Ï5²¸2–ª\âº.š\ìjªÎŒd¹Š\ÍJ`!ŽBPWQX„ŠXV‚\0Áen¶T¤`¬X¥¢\ÐD°)ƒ]*E[uó›5tgm\æ\ÃZ\çM\r‰m™\ì\ç\ÐF|Ú«	\Ó	uWk:o\ç\ê\Õ\Ð6kkmf\Æ\Ífo=dôpt$\ì\ß\çR,e\"ó¼=´¡c\ÕI+.´\í[Å]+j)H–Åª]Z(0\0‹$@À£H@õ°U•Xˆeim\ÌT(\ÓQ\ÊIl1s ¶\Õr\æÉ®\Ì\Ú9l\Óz\Ën{uK\Ë{sw\'S“ÐžŒ\ÂÚºye¹ô\ãÒ¸»¹5\ä\ä\ìÌ½1\Ñç «Ú‰(*nc$,g•ž« uf¢\éj`,kRWi+¨Á’„q\n¶-‹‡N2°À…]`–ee\"\Z-i©Jt\ÖÒ½\rOŒ\Ê\×\Ö\ÓFÄ˜\Ð×‡Nl£iuÈš§·‡k†*õ\ä¾&»?rzqNN¾ž©\ÒÏ©›npJL°+A§9]¹Ù±sY}U5`\Ób­lˆ\É\Ó-2\ÔÅª¥j\Z³ tRØ—Ê‹hÍª<Ü®Ir\èd°0±tP\Ò\Å\rc@%²&‰j²\Úó¥PõKYR2¬«QšÄ—L‹Ã­\ÉrKm•];a7§OEVI©S\×\Ó\æ6œzñÓ£Œ\ä\ß\rø¨m4óš­fjPm¨S\r–\Ê+\ÚØ¸e·\Þi\Ô\Ì\\\Â+¥2-´‹uC=,Q`ƒ0Y\\£Ê¶*\Ðk1\\CU`+-,W…l¥¤*%·\çln\ìÎ  \ÒWu:ÍŒUoÙ–þ=]Ÿ¡\ËX´›&ùË o\×^mY®[O™\×Àz|\Ý\éÕ®Û¯>#t­\Ü\ã`\îswœR\Ú\ØAaj‘dšFk³¥k*Xfó+T£­\Öf\æ«TÔ¤¡\ÔHõ\Ød2£)†£\Z\Ë`\n¡Þ©†Ûš	”¤ÁAtX\È@Ð‚B\Ô2P\Â)Ipn]:]_?¾e–ý9\Õ3­Fo›\Zª\ÇJÌ³R¼;²z9\ã.5q‡‹n.®U½¿)\è<\×\\`²­a¹\Z\0ª;‹sª\Å\í-f»s«óF±C\í¿N/0tN§?[­™)è­œÉµ,\ÊK\Õv\É*\ÛQ•™[¬ÚšˆI\ÖHjóQƒ\ê$\r`$J\ïÎ’)\Z\Ê\Û:¤²ô\ÆÄ•q\ëb”\Ô{x\êŽ}˜Ö“–\Ì\Öf³Nkª\íŠz\íx\×Bxõœ§L \Ú2i\Ê[c55\Ò3¡šŠ²û2ŒW²›V[]™Ñ½­…Ž\ÖT­Eš†x–\n\å\\µµi¶WV+€57\ÌÚ¬‹ŽŽ-8\Ö£?\\1ZEµo2\Ø$6-•\ÂX¦S–Áe\Ò\Ã:`2Ë—¹\Ï\\úºÓž¸Y^•=”J¶¸š™õ\ä¾\Î\Æn\ÅF7K\ÚÚºG–\æ÷¸Ód_#\rE‰£<2\Ç=y\Û\î¶P\Õ\Ø%I©mh\ÖH¢Ë¥\0¹„«Tl&˜i»œ\Û\í\Ïfu Ug=\ãd´FM–Ê–²¢É¼\ÙZ\ØA35\Üúk\â\ïÏ•­\é\ã4\åÓ¢\èL\ï¥^;ømrõ9}3b+Á¦\Ä\Öt²\ÓIKa\Ó\Ë\Ö;Zx\Ý&».\Òp¸\Ý\îK[\ÆRB\Õ\è\äŽ4‹*\Ô\n‡Q«zµ\Z»\éHˆõ°\ë[SÆ‘Djµ6c\Ðss‘}%\"\ítfµ”\ÝË¥™£\ãy\än\Ü\Ö\Ô+T\ÓLUc×¬¹®Ò‹ùX:f\çen\Ü\ÓN]Y¶«&:\ê§fNt\å\èóÒd\í\Í.¦\ØÕ›Ve¨2×¢\Ï\Ð<õ\Ã=zô¾ô\\jz|\înuwS¬Õ ±o]\Zj¯MW\ÙZYM‘\ÔF6”¦‘T2ªH¢‹E6U]±EO^¦\ÄQ*Z‘VÀ{i•\î \Z\í\ç7ŒÀ\è÷So>‰£6‚œöß¼ó\Þüú\ç4Q®ZZ\ê3ª n\ØM¸ucZ)dÆºµ\Ý=\à\ÆÌ–¡\éÌ‚fn©\ë\ÝJžº\ï\Õ\Ð÷Eºyrú9»ûç‘“~z\äSc\Þy[§‰kÔ—Å‹+K\ZŠõ\n	r_;\Ó\ÄrR[U€4‰JÀõ<‰F#\Å\ÊŠ®!*6¼wgZb\Î]­\ÑH±Š²\î—ö\Ú\ÓU›0K‰Ñ½«ÑŸ\\±,«\Z\îiÉ«\\¸:ôG\î?¦+v\rzr\îVŒ»};1ð\êMo[µ\Ó\Ð\ï<ýN?;…uó°×¸±Z¨Z\Ø\êPM:Ì²³`…ª=M«g°Ô¶›+„´J°’H…Z”À[~[¢$”–WA\\4Ö€öq\ìQ4\ÅzùýL~\îw´\ê,É§\rr¤=ùÕ¯=°\ë\Ñ\Ã\Ë]My:ú\æ£n:™tç²¬Ú¨\Þejú\Îa k=±»Ç¦œ\×\Õ.¾§?¡\è\Ï\"½x1ª9\Ý~s¹b³=™l9µ,¬\ÍJe¶UIª„X¢\0¤‚Pƒ(W™,–©!YF	S\ÙF©§S¯—Cw?¡4­f\ÉR»\èÂ‰¯%–PMqK/nu\ßF‹;ùw\ÐZ÷]Œ\Ô*kÇŸEWEõt\Êt\rVŒ\×S]ôš9\ê´)\Z÷sºó\Î\åõqcXñl£*l\Ýy\êŠð^e]™\ì¬5Z–*2²Š h,gZ–Eo¥æ°¦úÌƒbY‘t\"VXkˆF,Ûf44_n:d»m2Aæ–†nts´6³mzpK\È`=’\êï‹’þ^5\Ù\Û\Ä\Û\ÎÊ¬Ý‰Ê·N}0\ÝQ\ïŸK\ÏÝ‹\Z\æ\ç\Ñ_Gz«¨ã¾†\'u=>_S¾2bÛ‹:\ÃFº¸³ó÷S×D\Þ) B\"°±X‹A/¶\\o -W3Ê¯{•M75zó­\në¨•Ü©ž­I¬æŒ·ID†‹w\à\ègvjCžŽ}WD‹•.\Í\È\Ú\r\Ç\ëe\Ô\àX\Ë\ê\à,®\ÜÞ†N…\Ü\ìÇ¿“r:ts\évÑ¢[\ëg\Íj\äª\ÚúOJ3[Ã¡¬)wC‘\Ø\í1\á\écŒ+¥8Ü¹ô¯^y\ëu\ÖVÁ\0*{\06Zƒe\Ò=š½´\ãy\ÌPt›3Ò¢6vnLUYªŠ´\Õ]eñ,—5zò\ë\ÖK+u¹Û±½ù\Ú\î}Fú\ì@µ\×h\æ‚4\Ú+\ÏU«7«Î¶+Wn‹³q\Ó\ã±\ãN]µq\ÞXgtÏ¢›“jµg¢\ê\í\ï\\\éÃ­”\ÛY:\\Þ—lQ‹v)r£¯f§uzç’‹òõÅ•” õ\Ù`¶«\å\ÛV¼ø\ë]ø\×X\Ý^\nnv\ÛÍ¶Î¶Ž^\ìt\ÑR-:²3•,]\á]\ÞZZÈ´\è\ršsj®²]óŒ,5\êÅ«ŸK¶W~7m\Ùô5$‚9€\"\"¹¼\î§/\Ó\Â7Ž¦MË¥2\é©Pº%2\åZ\ã‚i¬\ër/füöð\éj8+\ésº=eX:ó4–p\Ð\Ñ6I\çy¾‹…\é\å”Á¬•Se½>W¢\ÇF\Ã\Ô\çc¦!z\ë\×(\Þ\Ö\Z¶sº|ú__G>u\ÊÅ¯/NuZ\Ýnœø\×sjmÇ\Ü\ëf5,0Wjôæ—»\çVt0\êÆ´YUù\é¢Ê¬R$\Ì‹“\Ø\äz8´-×–Þ·+\ÐLr²÷øJ\Þ\Íy…ß’Z\Å\Âj…½&³WzMu\Ü7\Ì\è\å=~þsº\\Ò‡K9k]\êø˜x>«\Îú8óM\ZRÅ¬³\Ðyþ\î:hÅ²¼t\å\æ\ê6ùž\'WñGG+X;4t¸÷l\Ûr\ã\\\Ü<\Ú\Î8\ë×’Æ–+YfuR\éª)uk2\ØöY\\º¹»5%\Ó;_\Ð\ÏAped˜\0F@0¬¼~\Ï¿?~;½½y?›ô\\|\éúü}\Zç®‚\ëmv.zU\Ä\ë%\Ç½óõvX?z®F*Û‹f\ãóº\\Ú¡Õ¹k£eZq…\äö1z¸ù¼½\\X\és\Ñ{§?³‡]\Î\É,\Æê£¢c‹WtY\Ç\èm€+fwvMù.y4\é¦ZK®³-\Ñyži¦\\\ÔhÏ¬\æbû\ç]:©¦GIuYI“]‹vz_e+,€‚a@V©\âwx]ø\Ûb?~=G\æûZá«·ul\ÏÕ¹\Í5U4r\\,Ñ“Fl\ïƒS×žýõ±|þŠÁ^¼š´»\Ñ\çjPA\åz:ñ\í\ç•É³7¯‡6\Ìü{Ñ²–\Öï®—guù\ïš\ÒÑ Jª.À¹\ì\è\êjó­’­g2%&ü«.ÙŒjt*©PP\éúoé„®\Ú£ÉªôdÑ–\Ý84Môb¦\0‹$\ÂI2ŠEWÁ\ïð{r²\Ä~ü:^‡\Íú;É±nÇžžr\Ê\Ç^:[/vã“£§\ç%\ÜpÉ¹[\'/_¢ùû\Ôb­Y´é£›\Ò\çjg’r»÷óúò´Úž¾L\Úòñô=\Z*\ÕÍ·\âûhiu\ÆW\Î2\ë#^N’W\É\ëq\ë{qž\æü/^ð\Úp²vF-\Û5Q]HCevôÁ§B³E—¬c\ÕA\Îô¶šs\Óe´_(¢\ÇŒ\"À\ïpºòk*>Ž;ú¼]Z\ã\é¸]?\Zû<ž½‰‹ \ëV•rs\é\ì£^b»C$óú+Bn\Ëm»°hÅ©TI\Ë].¡žw-6z¸ñòtpr\í ²«I»=*hl\nT§6šu‹\Û\rZÎ¾~\ì¶P\ïn³N}´™¬pl¬\Ñv\ÙÕ‚£uZ5\Ïeöu7\Ï\nt¨g\ÊU»=¼ÞŽ=\ZtUl\Ô(’e™\0@¼ÿ\0¯0÷\ã¯g?]Ï¥ó}.^¸\ï\êp¶kŸKGù®…9ž]¾E\âTõóô÷§\"\Ï/¦ú¯^]¨gfª­•°nzf\r3«^mÞ¿/?•\Ø\ã’Ê¬¶\Í8\Û:-FšE²¹k§]z\Ï5\Ýy&\æ\è\Ís¬\êV¼º6U©–,J¬°É‡mWC•i£~{uÏ¹£]<ý\n9õ2”½|}3&„7l\âE\ì¯GYyvY\Ü ñ\è$Š8]\Þ\'LfFOG\Zq\éÆ¨%æ“¬\Új76\ÊÍŒ¡b!¯=z’\Õòz-«M<ûTÀª†Y_3^\ì;}~\\\Ü^\çÀÕ¶ŽVKaª\ZI¶X§\'i¿|\íÏ£4\Õ›6ðÊ§Y²Ô³6EC@­\Ã\0‡Ñ—£¬j\Î\ÍÓŽzwÒ¹—S/(\ïÒ¼u\ï\æ®Jõž^vû\Z\çPƒ\Å\êI©\Æ\ìñ·Œuºz8Ù¿¢\ç®Xô/<=×Ÿõ8C¶–qg^µ\æ¬]\ßK\Ï\ér¼~Ž¥×\å2MÅœ\Ý\çsr£=“\Ä2z\rœ\î§\Ï\ì|þ,\ë\Ó~A^´ä“«9D\ìŽfùl5Y5‹-’ø\ÉGKd]ô\Â-a *)ZÐ´ºY\Üó½«›À\ËÓ–ªò‹uWEóUiÊ·;ò0ªtR\ÑvŒ—š«¼^º\ãL\é9]~Vó\ÍGOG;\ç;¡…™$´”›IQ¶‹\ç\Ò\Úú_K‡¡O—¶‰»=rƒS\ÏÑŸ‘zû<TÎ³IºG§òž¿\Êna°Y›\íš\Ï4“(\Þc›¢˜3f\ïLR\çl\ç\Ë4×Šj^´nZ\Í\\ˆ‚M\Ù\ÐÙ™¦½/o;\Ó\ä¬2\é¡\ë?S\äÕ•X\ï\ÌÀ‹~œZd\êhË«\É\Ýd™\Ð\ætùú\Ï0ôñ¯»\Ä\í\â\ì°>\0³—\"‚-\Êyºm£zôÒ‰\ç\ßzŒ[+•\Í\ßÃ»Kÿ\0Gž ¤ó>—\Îi\Ñ\Òû¨Ñ\Ã\n“³6«q¾%=Ž~±”={\æ\Ë˜%H\ÆYpÓ«3KTpk­W¿ Õ±ñ\èòv|w\ä\Üf¤ú9:D²ý85\âö6b\Û\ä\î˜\Ò\áß†\Î\"µ~®ú?\è°\Þ\á¹\Ó ”\ÈTdªYEy\Êm¯¥\Ý\Ö\Ço]\Ð\å\é\Îø\Øz8›¡°;¼\ïSœ\è\å\Ús\èÎ‰’XaV*\äÙn7V}+d¯¥¢\Ï3GªÃ¬ð\ÓuZ\Æsu…h9\ÕNÖˆÖ©UwT*µZùšúrÑ–\îÏ™«^mi!]F®\ÚÉ¯6œ\Þ\Æ\Üzü}€“™5\åN:ú¸W\èüç¢“¢\Òq\Øhb06±J\rJ.<†}9z\ÏMÎ²Ÿ?{²l\ãu\ä÷W£¦$0‚I\Ç/§Í®;£\Ù~Œú&ž›Š\Ì\ZÌº3¦\ãr\Äulö\Öc\ÍÒ£x\Ê\Æ\\À\ä+Uij\ÅT\ê©+`Õ¿«]½üµd\è\nÅƒ½%ó4úžsx+z\æû1mómdœ÷3\ßI\çaž®9ý?˜ô\É\Ñ5[\Æs\â&zóxZ0t½A\Ç\ëc^w\Ôv\Íý>/Wž²T/\é‡bE’T ’^~üõ\ç\Ý\Ëôg\Ó4\Ò\Øa¤¹\ì+-q\×!C-µ0)\Ï}Z\ÅLN¤RÀ’\n\n–„§ª:¸ƒN 0ªÅ€R@i¾\Ìî™©¹o\nôO>œÊº™1¿+.¯·<ž‹\Ïwµ:o]Üºn˜6!¾žoN¾†þ^)-¡›¿5\n±«Uw@2P\rA$‰Ó­«¯<\ée–\è¢ù§!³KYÓŽgz\ÔO;·G—d\Z‘B<Fªk¾«š\ã\rHC\0	V$6\ÙOCE½x@ONB\0I!3K–·v\ÍV&P\ÄÂ’a\Ý#\ÏA›uüün\Ó\ÈLº‹\Ç\\t\ÕZ§5\ÕõÅ¶\à¯X±LÎº6\ç\ÑC¤Š®•°+\ÙÀ`\ÉmômšMZúðJ²\×3/s/>¸×ŸZ\ëµ,I+²\ÅU±€H%†Q,Ý·§<z\È\ë\Äl’\"”\rµÝ-4H4¡¤$‘d’ŠÐ®2)\ècÆ¹IÏ®Ýœ \äy×z¢G“{.ªùD\"\Ã$¨–]Ÿ£^o_¥\Û\'#¯„HB \ÒJH\ê\Ú\çe\íÉ®^O4ž™O6þ†Y\Ä\Ó\Ñ]b«\Öo™„\ØÀ\0¬‹g”¸l\è°iL\"RD’BI	  €ˆÊŠ ®W;\Óðùô\Ã^\Ñ5‘uff¥Z\ëCSfziÓ‡l\"B\r@w\×7gcC95‰aIRHI H’$V•Z\Ü,¡/K)[F³X²%e\ÍVl‚´$²$!\ÈIšŽ\ZXÁ¥’H’B	!€6\Z®\Ì01\Z«\ê^.~\×#:¥ šVªš(\ã\Ôty½,‘\Ñ:;õjWd—2Ad€\È@A$‚Q¨\×D+R(]e‚\Äs\\W,uVa*I.Y\ÒÙ¨Ñ¥„,$¤@D2Mt@dŽŽz±Ù¤:9\Í\Êm®\Ï;‡\Òù|ô6c­w=µr\ë^Š\Z\ç£\Ã×¹\rfI$$€\"\n\"…I ”d„€01lT—%U\ÖL*A,®Ð†\ÕP\Íd\Û]²–	ABPZ\Ì\Ô,\Z.|ö×¼jR’\ÛbW&Šl¯\Êz¾¼…±3¾¡¬ù»M9;»\É\'^rH’HH%I@!”YX\È@H, Àˆ‰jY@²½d¶4 \Õl\Ó+¤µHu–¶»3Y•³©$ 0”’BAM´X^\Æ!¥`V\\‚Mó½M“Oš\Ì\å\Êð\Ë\Ë\ëb³\Î-“-•Ÿ?wö\\/K¼	&ñ$•¢Y*–Y„HHIZY$Pd\0*„FB@\Ñ+G]\åC­Ì¬º«ób:5Y2\å¬G•™[6$ *	¬•0\ÖIfV•\ëz¥\ÊUúsº\ÉFu\\K,¼™5F]¹Yò‰«6z\ßT\ÑÇ¯±¹[|Ä’È­U•Tõojr×¡\å¶!\Ò\ÙI’hHT T’ƒA.T¨©b †Qº«s¢®²\Ö\Z\\—W•Œ“BH’H\0@H€­\Ò\É°B\èòšm ¢\Ê\ß|\í\ÎõMk±4I3µÏ¦«<\Ö¯+=©\Í\ïrß¡dm\ä‚,[›Y°\Í-T7ê‡µ\Åy3© *’@	$VQQ\Ò\älUqB1…¹lšˆ\ê 2\Â\Êð\ÒI¡ C$\0’\Â \0€(V\Æ \èÒœ÷\ç+ oœXU­®\Ém*s£]‹\\^­ò\Õ^¿\Ç{\Î{\Ò\n\êZ°\\\ÕEµ\ïC}cne’E’@I+-!!e!2DVZTe¹­@:‘\Õà²¼\ÐVa…\ÉjVkPÉ—:£“Ð²ù&¹¨e²\0$°¬±‘ó©žüö\"”\Ö+©±-”²ÙDe+òþª³\Æ{\ß\í¹v\0\Íf«*mdU}z\ÍV\ÅMF‹3¦‹\â˜0J’BI$	L‘`*Š¬·!•¨‰ °*F,|½:²J¹w/Ú¼ÜŒÝ¼X\ë\Ï;ù¼}´.§v\êùŠ°Võ\Ù\"šŠ\ÊR–‘3£›Fk*õ‚a\Z\Ål\íŠIX\Â\"X¶y\ÏWÁ\ïr\ì¤K«\é\Ôf¦Ë€\Ñ,§Nrº],Î¤2Q$A £ ‘0$d‚ˆZ\å±yy³Ó¶xh½¼\Ün¦zPn\ë«MµÊ¼|Y\ë²\Þ¢\é\çó]>[ðöz?7\é¼\ÏN®O[‡5\ê >,Zž½BT¡SÁ‡+&Žm’»·‚\Éd¬IÎ…ˆeeW\0p˜ºYôs\ìªÉ¬º0²˜\Õ\ë6…tÎ·\ç³m¸\í\ÆôJLƒ\0\ÏNŒ\âSŽ½\ê¸I5\ØÍ¹vÕ¦‹:rµ\×ùö%\\}&=<\Ígœtž¼µô6˜.\É\Ð9¨±=>[\ë\í\åóž§\ËzŒwóW\×\Ð\ç\Ú\Î\\°\êp{mc\Ô\ÙEýüH\n\ë#.²d*Á!¥„gÑšÀ\Ê\ÚÌ²³-²»3¢L–:£\É\\t\n\Â\Åd6-W×¬\Õb4g²\È\Èõ•·FMÕ \Ã\Ìl¯oŸ\èk¯ož\ß\Öm\\‹œ÷]\Ò\å\èºœ\î¾|ýo=\èFó^›ƒörh\å\Æ\èr=6zy\ZòÛ¾[»X¬\Ûy|}©¼žn\Þmz¸Ž»»ü>¯.ù8þ\Ë\Æ\ï—WG›\éi\ì\rvkŠ£×¬V¬,€‚20\ÅYI\r›FkV\Ö«\Í9C1J…*41\ÑIK%vK	¬¢Ú–-‰ñ\ë¥Rü¶Ëº+Mr\ì·Os\Ïú9¯&…³{\ÌúijÏ²žž/\éü¯—«¡\Ì\êó÷\ÉÞ8[\ë|7§šò\îýð\Õ\Æ\ì\á\ç\ß=\Ý|š\ç˜ú\Ï75\Ä6ú.œ¼¹\ï\ä\ÏC\ÙÁ~w\æ\ë×Ÿ|wz\Z‰\ï«\ãöwÎ¨\Ò\Ä ¬†\0ºY*fÓ–À\Èú\Ã2\Ù4,:²$• pFƒI1\Ð,AjXf²\Ð5Š¶TT–W[nÍ«N‘Ë¿o™¿=\Ï;©\ç½Fzy_M\äú²öÒ®\'%-Åœûú‹¼\Õ\×;¸ž¯\É\ã öž+\Òöóòðû¿	z~Ï˜ÛŽ¯\Ò\æË¾\Û{y}o‹¯›\Ñ/ž3~ƒ/7¡\çõe\Ë\Ñ\æõó÷\æo]¬üò\ïQ\äúyýNÿ\0\ìu(\ébº›’Sel.kó\Ù«,vC-]³Q\Íh\"´‘\ZAž…X\"–5P\ë5\Æj\àkt+„\Ø\Ûpt1´ÁÐ¯=3\î\ävs¿™”\Ì\Ý^&¹\è C\ÐtxI®——»|½Ÿ	\ë< ­§žƒù\æ¤^Æ±~OUÁ\å\Õ7q;§œ#GN\r=F‰¿$Þ‡Ë¿+Ÿm=|Û½¯÷:Í¸w¦øø\r>ƒ\É/¾N_OX…Z\É$–‚\çÑ™%¹ôj3+½o1V*C,„cbEÐ«-\Ê%‹bB,2B#©T‚Á\Ò\ç\ì\ÎÝˆ\Í\âôy¼þ>¾O \àö÷\Î\Îoš¹»|¼vº$jôþg\Ôó\íW—\×\Ì\Ö4\ÓQ­·ó-KwŽi\îøFž®O ó½Îœy8ºØ¦úOÀ·X\ì\ÓÌ«:š²n\é\Ç/¸ð÷kŸº\Å\ã\è¹ô|k^z›õ€A²H‚$\\º²PÑŸEŒ\ÊÒ»­\Ù\ÒK$\ÒKV\ÌÀf™@°[•²)–	 AU\ÛM–\ÙI—¢¢cy¸¾‹\Îc\Ñ\Äô\Þo¨ž€\á\ëï—œ\í\ßeÏ‹Ç¿ú\í\ÝB\ç\åhÏ¾~Ÿ\'Ož«\Í\îñ/?O\æ,sÐ	\Ë\Ñ\æºmf±–½Yxz©£fÎœù½s\æ\ÙÑ¶\\[\\ºóv\×\Õó¹Š\éb,B¢\ä×’N=Z–µo-¯QÎ¬t²iŠHaDQH°[°+$†BºtP-”\Ún–UžgIf¼Mšñqôz]¾jù¿QŸŸ\Î\×,\Ù\Û]›{¼x\ëÀÁ\Ó\Å\×Ïºnœ=¥`¹\àö©·:¹–\Î>†·6®\ÞzyýŒ	–\Ãsy%÷F&µ1¹j×©\ê >\ïŽ€#4‰aFPd×Ž)Û‡^—=vÅ·\Ö\Ø\Û$iUŒ„Š\Âi`‹dS,¥‰\n`\ÐRC¯V·¯\ZŒ¦¹;¼^^®=¯’Nž)\Ð\Ö2vŽž>Œô\ßFz\âK\×Y	£4Öµ\"[£:MYô\\œQ\Õ\Û\ãô\â+\èò\æ:	eWcÛ›]õh\Þ:Uo§À–Àd\0 \ë`Ç³S§=µ¦Ê¬.z®ÎššsA‹¦4¾šP¤Xªë¬©ŠŽ¨)„\"›ª3X…z‹j\çHL\'½›Ÿnš±y}÷Ù“u†¬=<\Õ`¿&;\èÊ»·Ž~\Ü]S%[df´\Ù-Ö®Xs\ÜÜ½Wªþ\\ù:IËªmcŸº\Æ\Æñ\î/¾z\î\Ñ\â+%€’$„E°%xö\âZ­¦\ÒÛ¨¶\Ë\í¦\Ì\êÓ“öx—(]+5\ï$\å­ˆ–f¦¦˜™ÆTKA]wV™k¶¼\ï²kyC i/žk/ó}\n7›zp³›·•.ì‚‹ZšµM-ø-š×™®fÌ·\Ý\Úfù\0\ËÓŠ«%Àj3#JJÁ‘ ¤‚*YJX 0’4–œ{²\\\åsZ\é|tg·C#ŠH˜\ÜR[½œ#|€#Y‚DPM‰\ZR“«k2d\Ù\Ç\ã\×\Ó\ÙV­Ef‚’²ó.“—¥†‹5ËšZ«˜:#x\Çf™¬\×h7,\ê\Ò­\"\Å+b«%Êˆ5–*\Ã%2AU…° ‚T\ÍP|¬RŠuÑ¦L›ù¾¤`™\âJƒZÛ»‡G<ûü=3\í\Ëm\Ü\îm–m™\ì\Öl€ˆ\n\Û9G›\×\Í\å\×\Úôx½‹\ZI!$„‚»%QwƒXñHHa\Ø\ØÀ\çF¡YlTzõ”€\\³#ŒU¥„AT‹\"B„\"À,­\ÒÀ\Õh³§#\Íõ+ˆüû¯¿f±jK«L\Ê\Ôs_•ª\Ô}¹7.…\Ð.\éwˆ2@\â(Ï«)\Éz\ì\Þ=7S™«y\Ú\ÙÉ¥ó[@,ZZ­f	5a„6‹%\Ì\ØA”\É)-VS¬\0Œõ\Ø4…d’+†Y„’,A¨õØ¶\×baUr{òôùwõ~[‡©[®6]-\Æ\é«MI‡)\ÆÎšª}É¿›\Ñ:\émy\ê„FIR<W\ÌI\Ë2k–\ìöö\Æø#Ymj/JE³X¦[*¹d\ã\Ä \Ë$ \Ë$Šª\Ér•={ÀXlF•â‘ƒ	R2\Ù$€’H\0@´\ÛMev\\ÀÊ‹¢‹q\Ó_‘õ¾K\Ï\é7×¡§ulmhº«8Tm—R\Ú*Ž§7­gR«\Ó=ªK«E‘Öª\Å\\[1§6¬wô\â\ÛÛºñ\ïKE‹V\ÑKH70,h@„A–F¯Y®¶Mbl,­(¶»A$•U–\Âd€2¢S}=ˆ÷0ˆÀgwù¾÷\Ï\ë²\å|m˜k£Er\Åw\ÞtQ¯\Ëv9†ºb\Ä\ÏZ«º´­-®«µH3\è©8¡—|û]._[¦4oÏª†T®\å\Ê,²\Â\"B¦¤ @\ÈC$–¢\Óe;\Åb`™D”\ÛU €Êª\Â\ÈAÀ4\"s\è\ÏeŽrA\Õm3YòÓ§\Ï\ëgV\åÑŠ‘)ºg‘«;\ç-‹J\Õ~OV»U¼\ÏZ’\åJå²‡’—>œ\ÉË—i¹œ>œúŒA$„’W¢‚\Ö\Ïu†,¹` `”Ì­)’K«D¢ÊºsW\r`0)\rb4”`„ˆLe„Užú5—²».J°=ùW\Ê\Þ_ae~}\"ªª\ÚuŽR:\ç6\Ò÷Û“§“l½s&z„a%j\ëel\rƒ&Ìµƒ6\ì\Åþ£\Ë{\â\àFù‘%I\"D².k]\"b\ÉY,Š\Ã2´Ñ’Jµ\ÙE\ÊT\Ãx$2P®…¤@BŒ\0C,bTH\ÏS\r\á\Zá‹N=˜&«`|¾\ÃeV\ãpe4]F³Š\ê[¦\ãm=NwE®¹“5CE`\"º\Ø3\è¢Ì¥±\×C\Õy\ßEÓ’k2Id’I,©\é\ÖQZk\áRÁócI5$\ç»6°²6ñ!Š0”°ˆ4‘J0#+Dhò\ÈD²›s\Ü\Ñ÷†\\¼iÁ»\Ø2y=’\Ä|\è£&³ž—¦Ì§®¸\ß1ºu\Ë‹\×b¢²\Â\Â\0®¢\ÓuVQ‹v\rg\Ñõù½¼¤$’\ÃRE¦\Êõ•b\ÖBÍšI© \n\Êì®’»\æ]M\Ò0Uae†d’X\Z\Æ	Y =\Ùu”¶«µ‚V\åv\â%ž?dhsV«sô\Îz\ì­5\×Î‘²¬ñ,²‡_Ee6\ç V!F¥7R”bÛ“yõzkn¼I	F\0dk$’$®*%Š’–«YP&°ðŠ™L€=fh \ÈF,%Uzl«5•\ïb=Ì’\Ë\nq\êËž«mWxý„¬M97Š\Ð\Öf%nV\nô\×d\ÓË¹ 0@¢\êŒ\èú7žúÁÛ‹”(ñHbÀ¬[!D4L\ÂË«¬Žõ\Ý+B‚TS|\ã)±Š•’D†V\Ú\Üh¬±ƒA…¥\r$²&[3k\Â\Í`˜*DKhZóhÍž’Ä·\Å\ìŠ\é©^]9ušè¶¥\Î!\×!$€\în\åô¹÷½ •Hˆ²iº˜££\Í\êoCh\íÆ‘r4„‚YlT±,Pò\Åc¢Uµ¦t¹®Ë¬ ‡|á„@•#e–¡”´ia’Y\"‚“F²+i¬Â²Ù¦ªÏ£9F{i\Ç[,Wòú–·¯Y¯5ùªª¬¨ F\×$™i²Öš\Ó\Ó\åôó\ÒõX	•[IŸ~®}Dƒ¿!lR â‚°EW–+3,¶LØ²‹+¤¦ù–Sa’\Â„i$¡Å„x\Ù\Ô2K!YER`)š\Èh5’°ƒCÛ­oLµg²\æšmN]\ï„p\î•=:•\ç»2%OX\í³\ËT´\Õ]Žnù«,GšDŠ\ÉR›kŠ#½\Ïzú/\í\Æ,0CÂ¡`ª\ã”[!–)¡`½0!— \ÂC™Q™¡E’U°™c,2K)³=•,9™\n(¾\Ùs\éi•‰©\ÞW.¬u[\çôº5x\è(z¬\\š3	#\Ùm†e$‘kœöµ®\Ê\ì\Î\âº!]ŠW\ÑÁ\Ü\é\ÈÜ¾fIRHB\"\n\É!y4U¼S.\Z\Ír\ÒTÖ´TÖ™P¹•I2ƒ À‹R².c\Ö\ãÄòª\ëB\å:³U\×}&MÖ9ôy=(¥ª±3_œ9´\å\×>Ä“\ZŽ0@9IoB\ìº1\Ò\Ê\ÝEWQ»<¾¯^-\"\ï\rJ\âY*%‘H\Ðˆ\èV\Öh,b °‰1A’h\0P-Œª,(+\ÖX\Ò\ÑI\Z¥b,dI+¨c\r:2\çm`/®œúùö2ª«uD\ÈÉ¾}¢Ãž\ÅvŠ©! &8uç¦’%	\nºšzXvv\à\r\âH‚\ÆMf\Ö\Îe\ÔøÌ»jÎ…Ï™µM•£I\Îe¼R\Å\"¯\Âù@M˜\\µ±$Z‰)¹d\ÉÄ°Ä’= ¾\Ü\ë(\Ð¢üš\Í9cñô9)Ãº\à×P$[\r)D|û\ÑO.’B „\r\0va\Ó7¹ó\ß4Q\Ñ\"°:\Zó\è\ï\ç\Í.Mó2Eb(`R¤\ÕU”–\0\r%HðHâ”’H€%C	Y\r\rJjÜ”kl­\ÚY!€7YWjL×•#’¬]43ño\ÇN­4}=¼\ÍM‰‹Jœ[q\Ü\Öñ®{e\'.¬\"¸!¨\Èe\Ûn{¦\í¢«)¯£\È\ëöà±“|\ÙX­B\Õ‰b\×rk(A$&UŒU‚Y\n\å’\Êå„©\î²+g¦U\Íx\Æ\æHh¬Íª\ÅI¦RB\ÈF1¥Œ¸\Ë<Zg–ý\ÔiÍµ\ësD{r‹\Ð<þŽjµ²]-6\Ñ,ˆ®\n\Ó@Í¨])´QsV½l¤5q§§\Î\è÷\àT\ÍóVX\É\")„(®\Å2Ø¡Í‰\Z4Q„6­™F4\×\Z«Ì¶YImeX\ÙegCK[¢\çN+X¨lf(i …¤?w\r£«;Ë¾\ã—\\oV}\âf\ér®d‘©}\ê\Éo.–19¤\ÇP\ËAP\Ð\"TX\Õ\Í[+\ÔE=Igo:ºG\n\Ì\Èa$2¬iH—G%V4€d$Š\ZÖ½d©šÊ’D6Xg¶õš‚º\â\Ú\ë]f\ÅYc\àrò\ÃR¹8\èx<d–02˜!§¥\Å\ècz9=l¹\ß,Y_NbHGNŒ»œ\Î……®‰!%:€šV\ÙU’\Þà´¶%zªü\×w¿šÕ”\Ù|¢\ÂÇ¨–\Ä`\È`	 Š4©j\ÑP²\Ó[%†°Zs¢\êL«fšª,!²Fa\ÝU\å9·¯/¥\àòÀd¢I!$€t^œ·s\ë9ý\Z$i¬§¥\æuyzm\nÜ»\Ñ	ß”²Áš¸8€\"€“R\ÛCM\Ç\éð:ñ*^]—›S\ÙOOiw‰\Ó/®?µ:“œl\èŒi™\Ö\Í	IcX…€Ú©—” \ß*–±R=%\ëŸ5Ï—\×ó|´š\ês–,†D’HI!$€’X\íš\ÝUƒŸM¶g^}¬\æ£\Öò¹ƒ\\ ‘dŒ€€3,\0º\nºòy\ïW§\Ì2¦	!\í@5]‚/k•–{{ü©î§‹º\Ï]<¤=XòÀõ\'\ÇP{š¼]G¯\Çæ¤½lyb‘$HH„’I!$„’H@A!‚t\ã\ípô\ÒÖ§@0 t–)´ô\áKX3X¤H¦HE0”\Û\Î\Ô\ç\Ö\Ë\éóI !€\È@\Ê eˆA$2„’BI\"I\0£ˆ@X¢\Æ„K$ †	$„@I!„€šû~Ç—\Üdœú©ˆ\Ë$¶fØ§·œ‚&€i`±1šZÍŠW\Ì\êsu9ROOœB	$ƒ!¨D\n•I‚I !”!\"\Ã C\0cT…H$‚\Ë*E0\ÑHD„‚!$„H	!„’\Zú\ÜÞ·›Ú‚Á\Ëu\Ùa@Áa\äxI\"„’«y4€$8K\'§\ÎD”i	$\ÉHI!2\ÈI $€i*	 I$$†Bd$2B	$‚BId:=	<žøòcLdfÿ\Ä\0ÿ\Ú\0\0\0\0\0\0!ùûýz¯\n[e:ƒ$Á\r\0U€GBƒ¢b³\à\Ô\çZ³\'jb\É]\è†/4\Ê\Ùp½ˆ®\Ø\n\ì\ë’\'œˆTy+dßœ5¢U‘p45u6\Û( +W“	šÁ“\ãSŒµþ™È¤q=\ß\"ý\ä\é†ò}L²Ïœ.Î¿µðO\ÐÒˆõú‹r%ñ˜\Î:\Ì\Æ\ãil±n;\ì@k&—	¶Î‹fØÁ\ê¸÷Z°7h´«.Ì‹	N´ªs?\Ü\Û£°¬02­\Ëà¹ƒ\Ý\ÂE7¥N¼y‚\Æ\åŒ\àEŒ_\Ý:¿\Ð?=kô\Êa¼\rö\Õñþ\ï\0\ã¾\Ã©”õE+\ß0¶z\ç|ýñšóT\æÈ\Ç 3\Â3\á}¾€\Éô\È{\ÌAnppû\Â\Õd|U\Ï\Õ1b6!Sx>Rl…I\Ç%`¾ŠÁ\ï«Ã‹W±\à\ÚX\â\áYgj¨@Ë…\ì¤;¸\Ö<9Ü‹ô_R\\Wº¯}$,`.×ŒVK1MU”­Î€G\Öð\ÄP\à\Z\×Ö™\Õ(\r\Ä×\Ì\ã|JAf£	\Ë$¤L­¼\ëWø=2±Ç¡’f\ê\ÊI²CªüK>P|&2<®Ai \É\Û#¿lK;þÓ±Y=\Ýkù\n$>\í32¸e@÷=s\Ï[\ï\é®rÎ®Qö\ZK\×’f&\Ôz\ÝuT”40õ«ð\Å+aX;\Ôá¿·½7\ì\á6\Ï6e\à;rñ{/f\ë\Æo)¼Rl–jKwŸ€ª\×5«H™ñª;RJ˜5_ÿ\0\Ò\ÑÎ¼ø\Èa9Hˆ\Ø`\Ãm½,‘ü\ï6r÷?‹¸\È\Ýt`sušöñ¯ø\í\ÎoÅ¡©*Œ\Ü%\Zkô®VDô‰“T\'ÀœAoa‚\Ó\â¤S=\ÞY¼†’¤M\Ú<¡²(]xÔµŸÑ–.¿<k\æ?÷\ÓnnrÁ]\Úöz­-±aðô\ì+\ï¶r‹¬\É.3[(Û¯}­$¤º%(¥\î\n´B\â0U\ç]\Öú’I D2KQ,j¢N•u¯OYwa$Š@ö\Æ]\Ð\ìkE6{u4­\Í\äZL‚V|€ö¢1ù†\ÚHa\î–¨\è\n5Am)P\Ú\îÿ\0\Ê\Ð\ä-†“³7úB°˜#¶ª÷{YU\åÝ…Æ‘5\×sôPÏ‹\ÜA …Ÿ\Ã)¨]\Ø\Z³V(gWœ%š˜À#¯‡Cú\0\áIü©\ã	\Ëj“˜š%C\Ù(\n¯”\Í)ú\Ü.} s\'²õhü­}‰Z\ç¤\Ø!‰1r\0W§Žj\Å\Ø0<[\Ò,™º0\Ãp\ËH‡2\Õ8z“D\äIHÜœe\í¼U\æj’9\Ðx¼$\êµ,¿Ò	ó9[\'ˆE\å™@W\Ê\íÿ\0\Æ&“5×ƒ°zvÇ¡¬¹y~~™ñ† i™±iŸ•¡\Çx^\Ô\ïƒ‡Ì·]œþLpý“¼ÿ\0X!\ÔZcl\ä?¬\Ó1±M‹1d\Úù¬l\î¬L·lñ9p:¶e‡ú7\ÄÔº\Äa!4iû\å\Òl§˜s˜\Ñ3\ã¤Z\Ý\Är¶Œ—ý2¬\á\à-¦¢9ò\nlŠ\ßZÿ\0\èo£ƒ«…À\ë\êù«›d\Î[ˆÍ”\"§5Ã„™{5@\Ét•IýÆ´A\Ö\ØE‡\ä\áD\ëb÷^¡\Ç \Ý\Ü^õú\0%X\Í\ÂL	\ÖVa\Ê\Ôw‚9˜.\ä\Ê~\ã_j’\Ãô%s¡\æ\ç\ÂÁ\ØM|½@j‘l*\ï«_\íü1\ÜN»aeHA\È&\ëa•f±ð\È\éM\áý\ä\ÆÁ\êøP\â\êD†ùÇ™þg¯\ÞU»œkm\Ü\á…tQZšÁ,O\Îò¢F<\ê„\\oÉ€$\Öf\È`U\'¡º\às\Ã³\Ó\Ì«Ã‡\ìtýfûÂžrKra¯£\æ.NTTeœ©Á\Ø\Ø\ÏP^3ù#\ÞI7\çeœ\ç\Ò\Z\å+­„ùi;\Ø\Ã4d\nA\Ä\É+$„\Õ}\Øõ«›j•\ÊÄ§·\â.\\;U4\Ûÿ\0=ƒ‰‚\æV-L±dOXhóú\é¹Ã¥\ÆG2\Ú\n|kB?÷t‚€\Äaö\à·A\é(Žþ‹¹\×Al0\Åd…½‹€´þµ|&®ô®û¦úV\Ó5\é{Ú—\ÚU‘¬’\ßJ‘©Ö–®eiw/K\ë¸N\åFJ|:>qŠq¢p\0 }¤\0\Ü\×l÷,E\ný\n,¥\Ëb\Â\Ùp\Ñ\Ú\íÍ‡é´‚\á¢\Ä9»IZpþb_Ï¹s¶›–\"÷ò¨¹\Òj-g%\\øÎ—l=\Ì\â\Å]÷\"N:³&8óyAQw \ãp¼\ä_Ž¾…|\"f­ŸU#t\ÝHnMÄŠSqgá…=©\Ê\ä\×N¯dp\Ø[\0ƒŽ\ßm£Nz\Â}5\ÙNqˆ\"s¸p\\FXI•\à­h)m\rf;.‰\ï½f³š)öpœW\àrŽ3Tûÿ\0¡\ØJPqó\ÉG‹¨ýws!BP*Ÿ…\Ó\×\ßG°k%†!\Õ}þ\Ã\ïh\ï°ú,V\í±Z(\Ã\í\èý\ê\ç•X\Í\n\ÔB!Cy‹Ð—\ãà«\Û\ç™\Ðöª¶Æ\È\ËT¹\Ö=@3HTp«%j\ìÞµ&€€¶º¶ú e\'Xf\'K=\ëU%_wµÆ“	¶\Ò\r\èS\Ï6:\"n\"™\Ïõ¥^\ï„ÿ\0_Gvt›‚¯£Á­ÿ\0\0 HGû,¹O…sA˜ž§¯·\îð\Ù\éô‘‹\\ƒt\Öa†\nDb\Çr\Í,óÈ¨:[\ß|N’Z\ã«a2B9_B±.²i\Ì1\Æ˜€M=±>1M÷Á‚\Ö\å³ýZŒv%ºp¾«-“y\È~™xƒUò7£\î…#müw÷\âT@œ\×\Ó=Ý¤V\Ù\Þ]\Ýl& ~\æ\à\ãƒ\Æ\Ø6ü ƒ\Ñ]½cq)_\Ò\n\ZQ{¥—y¹Õ›,i¤m”\Ëb\0Æ¹0ŸM\í9\îD²U»M˜Igf½\ç;5§ÿ\0©ñ±¹\Í„I\ç\0µP¾\Ãj\åø\'p?µÍ¢\Î\ÍÜ±91	\Ó#ÀQ(ß¹\ê\'Š<\Ìr›‹\ÙÖœ\ß\Ú=¥O-\Ô\é©\ã®syk	q\Ñ,ð’Ì±\Ö/uM‡\×nHHYµ˜\íx½B­úX%ñ\ÖDN[’þ9O\Ö1V\Îa[\ïµq\î\Ú\ïžkŠ=yk,º„\×üŒÿ\0¯ŠSZ\Ð\Ö0|\Ül‰1\Æp9®Ðv¡´=<·ƒbD3\Ü>zª$ñ¾’Ó¥£¥¾ü\Ít©\ë‹Op]?5&	&¡¹5a¨¤ž#\Ò4È¶oÓ²£)®eW¾¢\Û\ÃQÀ_+\ÉÁ„vl\ãWvÓ›Žö\Ú\ã\è¦üy\\\Æ`–\ëI{Ê‡1P#Ù‡\ê~§€™‰\Ðzy\å_wŠOWå’„k\Ós\çRf´ü¥@\Î x·Wg7¦aAÁhšuF5røi‹T­\ç£Î—\Ã.ç–\Ì1\ÙY\ë\Ê\Ì=ñ–ùpiUI\ä2ˆg\Ê\0€n\'	÷™y\â8ö\ê¨\ÇL‰6À\É\ì&]Z²8)‡,ÿ\0[K“q\Ï3SN‰Uú–c0\Ú6\ÅH(‚\É\'º\'è¹ž\0Ö\íÌ—\É	Ÿð¬­¤ýš¤\r\ëŸ/#º\è`\çj +œò¯@Š$±+± \Ãóˆ1Ff¶£¶›&\Ëò™³V¹mºO$\"3\âÂ—×²¨ø¦9o\×¶Õ£5{\à>‰÷c\0/ÿ\00\ã‡\ï¡v8ýø\'žùÀƒ{\È\\ÿ\Ä\0ÿ\Ú\0\0\0\0\0\0Unw3´cMº£‡\Þ,º‚\å+_È¾btƒr™ \î?¥±³vg÷¨\0\ÒRšpF\ë²\éR¹UM§»¢,\é\íiÀºðDŒ{›iQ:¥…ˆµ›_œ¯Z¦U¸óz½bùkK£±‰p\Ñg\ÃŽ\á0\ZKõ&´›™?´¯‹1!\ê3j•ð€o™c#\ÎwÕ\Û÷‚¢Ž\íZ6À\Ì/yEH\Ô\éuXò\êS8“\ë±ü›\Ø\áF\ÑtQ©\î)ô<(ˆö\ÄU„\î¨\ÓÛ·Ð¡2“6`FDcÄ \Ð+$n\Øy\î\Îsüý¤YP2Fü&\ê\Ía9¢J­ÿ\0\ÎA\êI¡Ž\ï-#¢œu\Æ\×\íH¥4\n©“[£\Û\Z6*;°+±\Ä\å»*§þOD\ËY¸>œúuß¬\nz}\ÜekM~¾Î³²2ñC¡Ô—tkB\êp6V¥‰¡Œb¿û\ë0\ê¨\ruqõ\èš\ê¨\Ó|­Eþz›Æ¿ªKhB‘\\ü\Ó¸}_ß®ü¸.@x÷´6F¨ +Ž\È\î*§v9yˆ°²—§MŸ± `\'=@\Ó\ÎnnœAæ°¾hfg¿h.œ\ê®\ê5\ßó\Ú\Þö\êhšµq\ØzÈ±•aE\ç\éE~¶r‘©\â\0^\Å9S\×>m#­\â{²\Ðk\èøbýC®eÑ™·¢ÿ\02]LÂ„\ìc¡õ\Þ\Ï\Ì\\}cøð¥7\Ð6R™gºb[†\ÏN^óve@N®hü\ÒF\ÖBõ\"P‹X/Bqx\ÜB»v÷L\È\ËSFmI¹>3AŒzOnN\ë÷›Ø‹]†\êJÂ´!Wx«BŒJ/Ž‰(X\ä\ß›ý}\'\ÄbW©­\Æ\Ó#ŽA[ótje>¢[2\ri\Z‰¨@\É/T¿öÀN\ÕZ¤²\ì,8,¤\ÆXø–GpŽ¢ù\èEFpKª\ÒXo\\Fô)ü\í>z˜.N$]\ëb»°ûž¦X\ëQá°’\äe‚´@0.‰ü…ß‘«@Is£»ƒ»\'\ÛkY\Ñ\á¾UÏ¹6šw:¬Ú$Cœ/ó\Ø!ƒ^òÀad(ZSò\ã1x}Q\n›\î€\ÔCG!\Ír\Ù7«\éùb\é#\Ð=K2Œ\ì5ô\è†Åª\'\'q•$,\Üÿ\0ö¢ÿ\00%4Ž.¤¦\Â(JœP`%\Ër\ÆD\ÖOšï»†\ÅY\Ët—–k%~³\ÐW\'©8;´\\$mu\Æùý z~|(m\Ð\Z.§\'²‡œô^ó#þ)b½$±ë”®H	~Œ.\ÕÁ\î˜\Ð¼Œk:oe\nPþ¾{`®I0U>\'\åQÄ‘;\å’ò€\é[•\Ï\0‹x)’vÂ¤\ÒÉ›Þš¤¼2±\ä†\ì)ž3]\âýH\î\ZG¶Š\"æ¿»»T©™Ï•\ã†9‘Å¸›4üf@\ì\ÞMT\Ô8®{½iŽ{~–\ßVõ›i–cVR }F\'ª`¦-[„ƒ\Ðó=U¼üB¿ºv÷I\Ë\ÑÀjA\Ø\ÓÁOXl\Ù{°\î\n\Çõ\ë\Õ\"§ÎœŠU8œÁ·µ\Õ|OIq)L\ì4\Æ,¡6O‡ \á\ÖKþ\ÎWü\0‹AzKReÙŽø#f\Üu—HEk\ã(Û†3¾s	¤ŠC±6ð\Ô3T\Ð.¯2AûY‡¤Ó\Í2\ÒN^iF4Q>f½3°9\n«d»’²¤\ì\Ô\ÜÍ¶¶5¶oð\"…†¡-ö\ÞÁiŸ²&‘GðYR†¯žY±\ÉGþeJz_!B\ê(\ÑO)>A…‘‡$\Ð\á\ëH\Õ\0qxú}òDø$ù\È(û¨\â\Í\Ü¼ÿ\0U\×ñû\0û?XC\á:*\ãE\ì¹~/m•\Z†\à÷¶»@_Ru¿\ÑMQ1aúøC\ä\ÓùG\Å‚\Ð\Ù03\Çb I[*4û$\Â~.\Ø.\Ô\ÝòŒ™h\á·Þ²4©5\å¼\é@]™\á)\ÝT­öG\ç^2‡À12Œ´N„–ù\×[ý”®:\ízøN\Ë]ñý\Z”ðE‘~61FaKbšSB]•‘\É\á9½\Ñ/\åuy…!ÕŠ]¨\n®‚¦\Ìk2¸½5Ÿ²KWQ²B´Ô¿tÿ\0ñ4&ü(\Ýø}+V\Â\Ý;5ú@\Õ\é\Ð2\Ú\Ô\ç3‰Vx…8\Ý]n\Ë:(Åž\îz`\Ø‹¬,¾/U\î<J \Ð\\\Åa5Q\é\Ù\Üßž\è3ð6ü1²…@´\æ+ª&ŒAk\r\Åb öJg³\í\ë|\Ã=¼(\ì\Ï\âÀa\'Ä¤,H>BJ©d\ê\ÞP\Ð!\án÷\Ù	\æpŠ§TŸ? N7¹\ÚEŽ›\í\Ùÿ\0ø\Ò\ëY§9ý~þý‘‹X0w [yR\èò÷Y˜ª`˜…\è•\áø^<;[K\ä\Ã6 =Y6h§p|ÀÀ‡\ÆOüI\âºÁû\Þ.¡Ki\à%`fû1Ìž©ZH\æ\ÙHoœ\Ø\ÚE…i;¸mCª\Ù\áø\î\ÃjÍøøIx°ø”\é\ÃXuú5+j4‘¡\Ì^Ló“)@\èuÁVW\Ôd¾€¸ôº0jU¸\Ê\Õ8Sûyòbt¸“÷`¯r¸«%2\ä(¢\îfn&\Ö\Ü3Œ.\0\ê3I1\ÕhÛ–s(\Ù÷S$Ì¥\Ñ\äˆÇ‰§gýŒA3XpŸqPgQ@µ˜ñsP\0‘E°xVF\"·M,Ó«û…-”\Ö\ÝØ¶\Ú\Í\×·Qß3yŸÙ„@Gß±²\ÚC\Ä\ïRþ\Zs63ž¡\"Y\ä>»¼\æ\ßdùð¤ò³( •y\ÇIÚƒ¨(d9G \îN\\\æK|ðx\í£zzq“³¾>‹–\'žeYù\ãƒq\ìÖºIeª{4~™U.HeD/m“j¹\Ô\äy£V\Z‡Á¥—4Ž\èpM\Î\éþ&Zd±£\É!$\'©ksÀ\î{Dñ†ü›\Ðµ|÷\á´¯¬@L°\â/¡¨ö–yS\Ñ)rU¡-ò—®\æ.]2\Î\àc\'\'\é}¼¬·°3>>‰\n\àúX(.5S#f ³-\ÈÁ‚q#\ÏQ<—Û²\é\ÒB½¶Pml\Z\n‘Æ„r?5t\Ý6ÁDGÿ\0¿‚¾\í\éC;¥‹¨‘wÒ„\äQ®KZ\Ë\åü¤*¶Ã¾\à–@N\ìùD¥%\îi\Ñ0o\á:L-«o>	5ør°¸†·\ÔW*E\r\ï\Ú\á.ÔºˆË˜Jº–|ZE\ÜS/T\nF\Åv¾¶)Á® *({¨±\ÌN£ƒú¹_%Ù¬,{‡_•\Ø|fI9ÝŸ@\ì‡\â*·’(Ð¨›®ù€M@q™.UÁ\'Ò–W1ä¼€·\Ö5÷F\Ñ\Ñiv¿‚B\ì\Õ]¥¾\Â\âg{“\è0œó›\Ý^©\Ø\ÔE^a\Ða\Ú\æ\Ä;sÏ \ì\'™ŽF	¹¥\ëˆ7›—óf?z½\Å\ß\0F ÑŸS\×<	LQ\Ö?\æNªÙ´\Ð\Ä)¸œD=L´yˆ\ïµ~\Å$E*²HjC§X\Ìÿ\0\àž\\¨\Ì\Ì\ã{\á)\îj4òxx\Þ÷ü\êNóÜ B‹Ì˜†Ç¦\Ò|ÀT€\Â\ç=\×\"ûûž\Ò\×8[bc?\0u\ÐxÄ·ó,€ì“±Š|¦\á¤ü¼‚%&a5\Ùô?û\Ï\ÝÀŽ7\0¾(ÿ\0È‚ü?Á\Ø^õ\à\"ÿ\Ä\08\0\0\0\0!1AQ \"2aq#B0R‘3r4Cb$‚¡±ÿ\Ú\0?\0\Þ¸M\Â:\âFLù\Ú\ÔD0j\ëP(³\èg$Ë¨\Ê\Z£¶\Ñ\Ì@EžLÍ‹~7\nhŸ3hD\î„\ZpS!\ÈI,{cM‹isÇžñr\å\Ê	Æ .\ÓD÷¹ƒ\ê\åõ¹üMûñŽ\Ô)ªª\í/S\ê9\ÆxN9™s\æEˆW\Þ>mI\Ëô\à\à<\Ô]6W\Üò8™tù‘\é7{\ÇÓœgvJ<\ß&\æ}N,˜=\r\×\È\áb\ÔjF%\\zC´ycD\ÏSp­\ÅO¼…›ü\Â ?‰u	¿z\Õy€,	€ô¾z\Z\îv\âmwrÇ°ƒ\ZŠ\'“,B¡»šŒnVÕ¶µU\ÅÇM‹“¼I<ó0¾\\ˆlzhÂ„\ÃýFB*þ²>£pjRŽ1\ãtö,;\ÌxµXñdÝ”^\ÓADÉ“.¨c\Ä1ÉŽ‰,je\×\âÄ e0š5\\Y\Õ]¹B,25\Ã\èl\åÛ™›&kV»‚Ç•PÄŸWž;D$\Ô8•¬=-ƒ†\â\éB3‘@\ÂsRù‚q<@ 1\Èt\0\æw£\Z,m Y4&GlÙ—\nXlf¥ò\é±c\\‹³5~¿&3\ÅoW\\\ÆÀ\n3 $2½Ÿa4ø1¢›U\0òDµ®8€`V\Ç3>“!$\Ø\n\Ò\×\ÌÓ²dVÇ’˜ö¿7\Ã0\à\Ôj5*\îª•¸™r^>µ\ã+{À EÅŒ\ÆF@G.aMfE\ÜP(\ã“\ÞnLj,\Ô!y\'\Üö…Cp\ÜÀ¸\Ö\ëÉ›xµ–À\ÍÀŽ!³™¶\Þ\Ð\r\Ô$W\à<\Â\Æ]*T0\Ñ5n%p.E\Ô`\Î\ã{Rˆ»·U\æ6@<\ÇÙ›xSsú”ôðö¶\ì.eW\\…\ìUL:\\aK>Rû½üB˜\ZÔ©<E0\ãM\Ê94&a‡b\íôž÷2\ä‚\âÀ \ß\âû\ÄÃ”i\Ýs0;¹¦Ì˜ðLª_`=ûA°bW8\Õy\à¨ñú•´\äQ\\Yš½!|•\ê9ý˜œš\0\Éó9\Þ)\ÅWiJ±\âq±*\Ïz\"	»\Þ	”¿\î0/\Ð~\Äó\Ún2\èM\Í9® ¸ûŠ¤m“\ÞB+\\Q,|\Êr\'>lA\Êm]‡x1±\ÂÀ\Z\íf],˜1-QO´\Ç\ÄXb\Øki\çõ\ÍÌ­™\Ög¶\0 k\Å\ÔT\è+\în\Ì(p&%”×ƒ\\\ÔÉ°ý Y¦\È5D¥˜to…’ÍŽj>MC1ª§ÿ\0*±=-Qs\Î&5\Ï\0 sÉ@tø,·\ç“q ¹¶\çrKÍ ö›Z¼O\ît*Y> œK> ¿&m\æ•Ä©F\n1À˜p\ãF,n=\ÚRŽ\ânþ£\Ô*#)´¸c\ê1€öÜƒUùš¼ŽT¹\È\Ãñ4ú\ÄB=oòRÚŒ˜Ÿ\èq“i\í\î ;ý2§–#\rI\È\Â\ÕWÿ\0Ùš‚w\â“\è<\ÍHR\Ð7>\Ñ3\ê@\ÇV±Ú¨NYA¢	.\Ú\ãó=,;\Ðö+\Ø\\\"s±c`Š‡\ï–£¶‰¼W?¸Ê¹È¸#¼²?À¾\Å\Ô\\Ér-8±UA*G1\Çp¢‰ý`m\Zÿ\0ø™PÇ†\ÄC{¨ute²Œ\ÜS5Ë†³´	›D\ç;f\ÄÀ1*H=˜UN\n\ÚcúG­–\r‘5Xñ\í\Äø\Âó\Üùšmf\ÚTV?Ÿ\Ï;ª3p ¨?™„«»n\äL§\Ò\ÉIÚ»C…\Ð\ëda}„Wú¶\íhû[\é\ï\ï\Ì\nŠI¡»¼\È-H\r·ó>”¶R\Ù@1r\î`£\í2)Q¹X/¼R¤¸‡´õ;PýÀ.m\ÞGVa\äŽcý\'–ö‹—R2°uMŸ\âÀóNz¦$_2\Ì\É\ë–M…B\ß\Õ}\çhE\ÆP\ÇÈ´¤¸\0šª*¨\Í\Ã%9tX©úŒö\Ñû£aÛ;\Ç·;e\Å\È\àñq3cE\î´?\Æ[¶”?\ä\ÄqmmÖ§‰)e^);\Ä@\n½ý\êe\Æ\ÌÀzƒó¨.\Ð\àpf0È·\ï$ð@Š¼±4}¸Ž\á±\â+«ö‡·k—C„\æe{ôŒ:‡Vr\ÉxÇŸ1ò¥°~[\ìþb…<\Øç¸œ/\ê+\0ƒ6\ß@¼‰m\Ë@vŒ¨Ú­÷A\â\\)\æ\è\ÆûAKÁ{2”\ß>Í±¾?¤ŽDÃˆ\â\Æq \nÃ²=\æ¬Äh~\â}¥«Aš\ÔS’ù¨XU2*šóf\à&\ìkS\ÕQd\ß3LNJ\n„Óƒ²š­Š\ÊM©üJtûA\Ó	\Ý_A\'\Þ\àÜ«cš\îÜ¥op ÁÄ¾!¸ˆ*–\ÈKÑ±\Çh­½iR¿qò>4ÿ\0´\ÎOû`]\Ê-\ç˜s*Ú¢’o´L´i„±B¢\ÃF\Â\È5*+\Ö	\í/)\ÏÈ¥ƒ\ïP¨\Ô|ª•~`77\ãÝ³p\ÝWW\Ì/T=\å_\ê;˜\Üò´)plšJ–§Š3úŒ…³\ãi¡=0\Ör¥³\'\ÌËo\èR@G\Þjô\ç\Z€ÌªO?I”¼Aö$DÓ­«q`ðDÁaT\Çlg\éb\' v—ScÛ´Ó†¸m\æ2‚—\ß\Þõ(Ú»eô1ò¨\ì\à\×p93\Õ\Ç\êm’&\ê•¤\éß³qbc\Z–g$ÁœUŽþó&b\íT\Ðfm›Yhù£nM ·\î\â\å* TQ/°¾a¦ö5a±…ñŒ½Á£\Çr«º®ø›‡óœº¨õ\0¢fGÆ¥7I4(]Jö€\Z\æ2„„Mpc®\çQ»ø‚ª„\Óá±™˜,\æCµy3\Òõ¹*T÷\éÀzz`|\ÍV*\Ãz·T&›?\ÃËŸ«aª¦\à&Ž¤x£>#€\äU¨ˆ\n”*2½´€f<Ê¤3.\åúSt\Þ7m\äùƒ.?X/\Ô\Z§#¡Á›pÿ\0\×\ZÁj™K:\Ê\Ó,ª½ªzDv\"DCˆ_¡=;a™³%ó\Z\í(ó\Ä\Ôaw\ç~\Ð=§!\Æ\ÓdL921PqÑ®óx\ZŸN˜1ú‹W17\ÅLyÅ©±pÀq\Ìa¸òF\0\0{	ˆaÉ¨Þ™7\Ü-}ˆ…”š™›:·Ó‹_‘]’\éªÈ™}R»ñ\ÕÕ•ðb0\ÔaE`UˆþD\ZÀ\æ5ù\0\Ì:\\6Tb§‚MZ’‹^ów\Üº\à\ÕTÀ»…”þA¸Tl´\ßT€Y™±:’ §n›2Á‚\âbÇˆ6ÁVl\Ì\Ù\Ñ\rUµA™²\Ú\Õ~\"$U\àMœv•6M„-@\Â Dt®\ÜÌ¸›i™\ã\0\í\äš\í2j}5o\Ý\n–m%òMJÀ\Ê.\É¦ 1%E Ñ¨B>FÚ£“5\Âý±|-Sp¼³T¡S:‚üq\Ú\Ñ3&ŒHrls4ÎxöšÉƒd\Éôs\ís*vµ\í=\Ö\ØòQ¹“&jÙ“ò;ŸW\ÔG\à€lD\\i\Ñe‡œR\Û\ê\ä‡\Ý\á H›„Í)¡\Ö\Æ\É\æcPb©óP‹\Þpež\"òa¢š5\r\Ä\ÚH™°‚£÷5˜lbvvfý;n:­\ÈbµH\ìy…w\Õö¸š—c“v&P­Cò\"\åW±´Š¡lx\ì\Ø\ægô\Å ™‰¼¬»J\ß\0xƒ÷3Y€Zñ\åÕ‰\àØšRN ·o¦€›‚\Ö\î	™v1&*8<G<O “X\ëôf,ŽMj¿<\ÂNÁ\Çñ2†c\Í(3R\04L³\ÈÇ¼rB\Ü[\Üo\Ìe*,&cR|A\Ä9*€~%_2§x¢ŒcòLó\á\ÍL˜1º\í\"gøN7+·Š1—h´\ÏëœŠq\ç+G‘\â­1Cª·w1\ãT\ÞÛ¬rb\ä\Æ\ãp½MB\án]nbq½B*m¿˜>f¯u¦&	Œ(\ì&f[\'i<\ÄÃ›Ü˜\Èa}Œo«&2{7c\ÞA\"¦*ª„A\êƒ\ØLN}J\çžb\Ñ\Ç\Ì\Í^À~L¢¸‹\á@X‰R\\t¦‘\ì€;E[‰`P©¹Ç´*¥‰\ç\ä\í\Ì&*òL¨fEVtlIa\ïö!\Ó\é™\Ød@\Êyþca[\æö§\n.cwS*\ËrIð&l»œ”L\'û‹küˆ¤\ÌÀp2ö¾ý¦O¹¿sGB\íTÎ¼f]7ö\Ï3FO§M\Üt²¬.ÿ\0ƒ0\ä\')ÿ\0bY\Ç2+71oÉŠ·• øŸZŽy>ó\Z=’\ÜË D¢&\Þa<J3\Z\Ä\Ã\Ú\Ìjx›;APóˆ{— L›OcÀ‡&À[\íô”ÝŽó6Vj[\îiþ#Þ¦1dL`9\æfÿ\0\ËFVõ1n\"71$‘\êRk´\Å\Ã\n€\Ü\ÅJ9\à\ÏQ}\æ[ +™ˆ•nyüL&Ó‰Ÿ\Í\ÌEHu\í1be“¶ø¸,D!ø>\"Š›ÀÀ\Ý‡K€\ÂD±._\Ècq3\íõñ–_z™pž\Ðr§Ža\'ž9ˆY\Ô\ÙüJ¬€w¢&G¡t\Õ\Úg$ ¹¨\ÐamA\Ô¢\r\ï8Á•	¶S€\Ï]›´°ðnba´˜‡\ÔSg˜©Sö, ˜>É¨b®@\"b¦\Æ\"¡nr§\Í\Äf€X€Nð\n\èH…À‡!¸3A’\ÄA\ÐÌ‘Íµj»QS\Ú0\Ì=\ÌP	‰I&½\à\Ä,eÿ\0\çÈ™]\Âqc\ÃLzT\Ê\Ù[h4\Ó]§Ë¹ˆ\à\\UË‡$n\ä\íˆKœuŒ©~kÀ”§\"`¡„ûF4\rLd\ï¦œý3?s	¬Ÿ\ÌÀ\Ä(=\à Í¼\Ü\Û\Ì	‡-C–z ˜\Ï\Å0­ÁÛ¥L£ƒr¬;F ˜Gþóâ¹˜®E>.bú±‹™“j7‘=-N\Ìï……\n,&¥Fm-˜\Ê\äós6Ÿ>OFÀ¥ö0\Ä\'#‚˜0²e,|Š€C\ÞWÖ¦`?L\Îhž#1\Þ;w˜ø\")\â}g´\íTõ#e\â1s\ælzMJ&.;ƒN`À\Â.<\ÆMLMk\×3“``\Ü8„Ù¿>gˆÿ\0qè§‘4Œ!\Ì\Ì>ƒd:”~Ú¨\Øu	¥\Ô\"33•;73K—W‡.$\Õo\' ®€`X€ƒ\Ü\0‰þQ\èdY¦<	˜}Ffm­0g·\Ø}¸˜€\æ¥T\"d cc’`\Ãpi\ÐwŽ¸„\Ñ\èMYý¡\ÈþDf-1šh#v™“‚nn\â›ø0ô\É\ÜÁŸÿ\0°³(´iõŸò¢<Mª{‰°{B‹\í6*\ß÷}I4\Ó?\Üfu%ŒÁ~°£1qüô\0MQG\ä\Äzh®\íö\Ä\Æ\æ¬\Æ\Â&pq˜¹˜L<f4\Ü@—gs~D`=\ãqx2\Å\\š›\ê>;\Ï4kž¹G\Õ\ÐO†Ÿ\ì0‹S0\â¬Yr\× P8\r\ï\ß÷$\Ú\ì‹\â6+\È÷‡{Øˆ\äˆV\Ì\É\ÝfšgQ™ü\Ì†`\'\Ú\ÔG¶o\ÄÜ¼r&³²@9˜ò*­\ÌÅª(C˜lw\æj³†b\æb\ÊT‰8`(\Æu÷‡*û\Í÷\Ä\Ì\Äb©ˆš\æj\"ù…h~\'yS/\Ý\ÐO…Ÿ\í\Ü¦DtÀ€%†\ä\Ì\0‚\êA,2\á³cDa»h\nq€Àý™Jø€\å£Ym\ÆdÇmW`\á\Ò\Ô\Æ\Ï\'a4\ÍÈ™þ\ã3T\Ãc0?™ö\à\Ì9lžc=[þfLƒ&0}¡3\Õ*`\Õ\Z\í3¸\äÌ€ŠŒ´—\Ðm»Áý\Ì\Ú\â&\î& I™‡Ò \Ìc\Ä\Ï÷þ\0©\ì{Á\Ë÷t\áG\éaù€q2\âl˜0•RÀ]\ÞiÐŒ\è½ó»p\ì&©ŽFR \Û\í*ßˆs›\Ôo˜0ƒ\ÑÃ:°#/+k(\Ü~ \ÕQþ\ã*?i¦\î&nó0˜¸\Í˜ü\éOþ3M\Íþ\ã¤\ÌZ\nDxE‹‰Ž\áJ\ï\nY[¼@¯Wúr{s0\ã(Ý§\ÑG3Ñ¹ŸºDå€™\"ü\Ü _ûô©›¼>~ø\Ô\èceðH3¿¨ƒq\ï\Ï15Y”Á®\Ö.z\Ìq³úKôö s2jU‰fÄ¥«#™›Põœ@=}\ÐòaöM7‰žf2À\Ê\"\Ú_ÿ\0¦\á›÷\Z£U@\Äk™‰ûf›\Õ\Ï\éX5¯i(T|@Á–\ãL32Û¯\ê\n„ù<\ë\Ä\äÜŽ†f€tøaúž	§u`\Øß•n&<KŒ\ä¾X1Q2®M\ØQ\Z­	ÿ\0‰>£\Z\î\ß÷©¯\àÁ‘\Ý\ÙV·\ä\È(þ\æ\æ$#(½\åLzD¸\Ì6\Í>Eº±3d\ÇW¸LÚŒ^ó\áv;Ž&C¦w‰ˆS¼xÄŠ\0ñ\í;‰S´\Ã\Åû@HŠa7\0DÎ€U@9˜O\Ô#5*[Š\r³P6³c“Ey£s\Ó/_†Ÿ\ï0ü@f\'”Y\ãtÈ§d,\Ã\ê{f4õ\ÅP0\é2œX–¾\Ð\à\Ï\é5\É\Ê’›\Z Ç™˜\åd\"ò\\\É÷®Œ;Ì¹¨E\Ä\Èc³«™oÁ˜ØŒ‹SIG³0†2’e0Sp‰¶¸ö¸Ì±²b®\Æ\à\È|c¼“J!Wô \Ì\Ë\ØÃ“25\Ã\Þz\Ø9\rÍŽÃ¼mF•F\åÀÁ¼±2¿¨O\ÒöL\Ü¡À\ä\Þ\Ã—9\ìhr0¶X\ëµ\Ù}Œ\á\æ³\×Gc¼ˆ\Å\ÌÃ±ƒP\àw0jò©°\æ\ã\êó5‚\æp:\Þd\0’1!\áL\Ís;\ÄÐ·ö\Öû\æÒªeTXrnI\Ý\ÌÅ¶}#b€c	S\0ú\å`¼§^\æ\áË¦»¸¿\Û£ÿ\0ÛƒPo„ž¾\ë\0±5÷²~\ÌB¾:g$Dõ^\Ù \Ôe°3ú—öú£|¬¹•h§\ØL\ÉL\Õ‰‹K›:“ndø.µ¹b|VK f?‡X\Ãq´¯¾\àÀð\é\Ú\r3G\ÆV1c_q\åˆ\Z¹3i2ˆ›nu1¢\é1°»0h±W™ŸúM2‚üsúl˜\Ã\ã\0ƒEä¨ž¦2x(³V\0\Ôežš#ýõƒ´\Ô\n7.s9\ë|\çs ü\ÍF\Z[˜¾M£Éš\\‹XL0ÿ\0\é÷„T\Ü!b<C\È\ä@ª\ÍS\Ò \Â,Xƒð\'¦³l\Ø 2f¾«šp_\Ìb‰ñœŠú¤\ÆO\Ú|;lÍŒžøŒÛ¢\ÜÍ}?¹ªÿ\0\Ô\åÿ\0\Èô\Òñ\"ý³Q\Ò\åõ^\Âgƒ\ä— 8ŒøV—“•‡\ê\ÇFƒ(ÿ\0Ë£÷\è`™\\¦KDÃY‚\Å*GA8®ñœ,É˜“Á€\ÜŒ\Ò\ä,ƒžÑ‹QŸõÇ¨\Ój7RU>€úy²øv\à\ÏHs\ZšœJý\Ír\í\ÕdýôÀk6?\Ü¦¤q	…\æ\ã˜\Þ\'aU\É\ÍSù¡|\áš˜±ŒxÀ‡A\Ñ	þ˜ÿ\0\å\Ñú™©ðbš6\rA\ÃpbkM\ÑuˆÙŒ.OAÃŸ&2*cÔ®CL\ä~;ø½PÉ“\ëOc\ÌÄ¸‘1€x€ØˆDÕ°(k¸\"|@V¡úc5‘?q{L\âñ˜\å„\ÍøÁ©\ê%\ÕCDq1ý‹úô\ïa\ç4¸@\È\æ¥ñÒ¡\íŒ-d3?)(\Â\"‰…N!\"\Ë%€\ÌÁˆ\ã\Æ\ï\æ6 Mò¸‹‡ &œ\ÆP5ˆ úNI\îDø¢\í\Ô~\ÇE\á\×÷\Ø…¡™\Ôl3\á¿ø[|H\é²\äÿ\0>&p®·!\ÆF\ß\ÄÀ˜†\0O&¬\ÆÈ…‰\Çu1}‹úžˆ9/Áñ8\0	}\è>\Ç;L=\èL¡}6óPEÁ`Åƒ­ôhô»>·ø\ê&:\ãöš­,\ä&\Ä…ñxú,ø\è\Õó1´Ká¦¯qÃ\'}¦§\Â~$¸´ø4Ú‡eiÞ”¡#\È?˜\ÃP\Ì~š3o\Æv¿0\à\Ê\ä‹;\ÌiH¢ þ\Ø\à=.\Ðbö/B`‰>\Ó&ff ø07NbAò\"34ú@ŸSò`\èL-\Æ0\Ã(§\Ä\Ú@4\ßÁ™1\åT9‡KŽ\ë\á\Äñ\êŠóM‰O\êõs\"ƒ†®_x9ƒ ‚!úO\ê!\àL\ÌY—p	S>Œ’];ÂŒ¦ˆ\"\0`€qQ˜\Ðf7/\Ç\âcÂ˜\Å(¨\\†	0Ÿ–¥MFœ²\Ú\Å\Úòb\éqœ‰´0\n<?u@yƒ¥ôVÿ\0\".ð= Q\ßÌ©]\0‡7\î¢3Ø‘?úhðóúÿ\0p‹ o÷D\Ð \îI‰‰}\"´c\Î¨Ï§‹\ÄÆ D+f.8\Ó\ÌË‡0%JùŠb‘¥ˆL	„\Æ1Œ¿–¥E„O5\Ã~%\\\Û%–Z ƒ\nó;EB{À° M³l\Û*m€Ee\Þ*¥óÑŒ&Ê«*ˆC\Þº½(Â›	\Î=\â¸ƒyy_-|\×Eh¨#À`	—\Ðu\à!„ó1Š¾¨EµL|«N€q&O#™Šþ`j\0•Qò)ˆo«À`<Gó †;\Ä°š˜\×É„ó\Z›E…<M:T6™¶Ñº‘\"A/™’/G†‚Q\Ä1¢ý\Ðp³\îiT!\ï÷G$DúE\ÌQ@ADQP¨…eF\â:0E@zd0qþA€K\è\Óú£vŠ±»tX~öƒ\ên1¬1¨^„\ßA\Ôôz7Gkƒ¿FùA\0\èf>ðô~\Ý?y”QP@\"\Çj\Üf¸OJ•\Ôuza€Ë—¸¬Ó \ä«o±\ÇyPv‚T©P\Ì}ú\ä2\à™*asEb˜\Çp¨Tƒ„  \êHšpM\Ã\Z–\"\rF·(\ÆÛ¶†j\âB¤ù\\ÿ\03S¢\ÄPŒT\Í\æ\ÌÍ‡&\\t>®ß‘4\êú}n$qF\á‚\ÐC\Æ9\èc\Ê\ëˆ\r¤&,Nñ×‹;ÁÖºŒÊ –<~!ˆ)!\\\×\âˆ¯¢25Ú \×j³¾\ÌX\ÂþL\Îu‹)Í‚\Z£\ÃÕ¸¶Zý\ÜÉ§\Õ&›\îû{‰£\ÎÚ6@Ü°M.fÃŸw\'š3\â¼>\Ä\Öq«Ó¿\à‚(„t0Ä•\Äha¸D‹,YÛ‘/pŒ½F«\0v]üŽó\'\Å0)¥Vc2|W [L?É‡\â\Z\çk\rµG~\">°\ãõ7†x\æ¦7\Ô˜¯\ê¼\×`f«VšvUd\'t\Ôd)¦.ª8®ƒ8kÿ\0.j.6LG2\å\ç\ÛÉ¨Þ»hsoN\Ì¾\æ9-ðµ>U„q¿Fßœs\à\ä\í\Ì\"c9N§Å‘üL\Ù.‹ó¨\Íq,ºV^õ\â!\ÜþX½T\ïÑ„`:Š€p ‹T\äÀDe\æ`\Í6©\Ñ÷]÷X\é§ÆŸF\ë5sR\ã‘]q©º\ã÷4Z#1m¦\ìMf]ª-\08\á\r»LA<©ŸC\é\ã\Éþ\Ö\æ_©£ý\ãš\ë\èòc¸-mC\ßó32g\Ó>\Ò\r©¢&—\á\Å}E¦,d`Tc\Î\Ú3I¤]=•$\ÜÃ´|O%)\0\Ü§\Æ\ç@=Ny\ìa\Ó\éút¡{\Å6bˆ:†$1£O@:\"ÀaG‰‘ ™oÄ“µ\Ö|[\í7\Ã\ê_\á‚û„þ\'Âžð\ä71ñoÇ‘oºÏ„¯—>8Ÿ@\Ú\\ øš\Z}.1|m©¥_\éWR;W‘\ÒÏˆ «£4ztL™\Ý[\éº1¶õmƒmX¦9÷±Ë›w#mq\Ñ³Y¥[m\àþ¦MN»\Ä\ìG#ˆ¹\Æ‚8²&\'GPÀ\Ø>bÝŽ‚†cñh\ÆWK‚\"ô\Ý.a\áÈŸC·Qþ\r5K\êi_ò·>þ¦‘\ÐþGüÏ…\áËœ°úBµ\ÜLzUÅ²\ïòhv\Ì\Û3cÊ…‘\\O…\ãÍ‰2Š£\ÄÚ…X\Üs1c\\JX\Ð\íi´\ì\áA,y rf,\í—+!¥ú~\ß\"\"\r3\ê[–)DYš|‰ª\Ä±ñ}ŒÍ¥\ÊA²\Ûf¬jp8˜±«»Ÿ\Ê2\éY	$‚Aþg\ÃSbd\Çþ\×0+XüÁh\"\'1¡‡ ‚	R ™¸\É5I\ê`Èž\âhØ¾™wŒ\Ó\á]2±g¼tÞ…k‚*bEÄŠ‹\âjN•h¿\'\ÚnE\0Ÿ~&›8\Ê\îE5\àM\é”\åÄ¬Aƒ\Zb]\ÏaûL\Ê\ÛE®;&aÓ¶-I\È\È3P\É\ëjTž[¡ú€;\è”`4JŠ˜ðj[jZj´™Ù—)f\ïG\ÈüM™1iÐõ2‚\Óm\Ôdö`Ye\Z/\ÌcC\ÐA\Þ €Á<ô\Ô\ÄÅ—.F\\C­\×s>q”zI\×4\ÙY\Û\î\È÷\çmxR@Z¹€£€â±™±\æ:€ä€vš,H˜\Í(òjcÓªgl»Í·‰«Ç‰\Ó{‹\Ø	©‹*\ä\Äh€&O‰¿õH€€À$ss> r\ãp;©Sü‰ð\íZè¹¢\Ó5\Z\\\ì…1dO4f\r{\Ær\ä\á\r€;\Ìþ±lKŒqcqüA@s¨‡s˜‚€\ë\âË›¦\ãX ƒªÌ‚Ôˆ¢k+Ly¶ù¦™\Û\äÃ•\Ô\íg\Å\Ì/¸\Øx€\Ú\Ã\Þ|;z\àpOŽÙ¤Ë“*\åW£µ\Ê\Í6\'Ä­¹÷\ãð&¿>\Ç\ÂÉX&\âf\\\Åñ0\äüƒ±\ã\Èq{Wmƒ\âj\Ó§”\0Š•>L\ÒkUða%	6ÿ\03:\íÏf“Q«o¤fò\Ñ> ø2:fSØ¬\Ëñœ‡Œx×“Å™¡øŽ§6«¹Oj›A€@eõ0r!QªWQuS\Å7sQˆfÀ\è|‰N}&LL>¤\ãù\Ä\Ó\ZªeC¹XšÐžš\ê´\Í*œ1£ý\ÌLÇ¨ô=Aï˜1\å-§\Þx°j6RT“\Ø\rÑµ>›3)\ä\âZý‰¬øŸª ®>¨wž\ä\Ô\Ò4‡\ÆÜŠ\ÓW§\Êuq±^÷S+<\â\ÈPis± bk\ÆMŒ´niAÅªQTCô\ê`\í´{3	\è\"Á¸=}zg?\ÓjY”q‘oñb\Ð\ëFúz\à\ÏKKjHK«—.oˆ\0n±©529rË¸ý\ä>sA\Ê@¾\Ì]m}Fc\ØóT®=\Ãÿ\0lŽL]R	%T~LÂm\é\ãõJ\Ä\Z¬ù˜crª¤ö¦§a\Æ+.S\\i™Sm.C»µ™Ÿ.•r‡b\ÕmÏƒ1!Ò¾B­½3Kƒ\à\\¬€µ›³Q>ÁúùG\á`<c\Ã\n\Æu^\æ°N`¥tÿ\0 \"\\\×\à9ô\åG\Ü\rˆø\ßK•J5X\ï.\\ýÌŽE\Ï\éñ\é\ç\Ü\ÆÀ\à÷„9Q\à`6\Õ\ÅÇ“>0q\àEi†J\ÊÛ•èš™0³\êQ2¾\à\Ëô‘0¸‚I\ÊT\Æ8Tý\áV”~h0\åÉ˜²cb\\Ûœ\át]3Â¹6 \Òk\n\"F”’#\rq¾…¡Z\ÛI¯\\y1®!M4Zmv:B«¶\ï˜€(3/\Ù\Ø\èó&Li\Ü\Ç\Ô3X^¹QA‚oü@\ç\Ú–%\ÂÜž„\Âx1q\ä9#(6À˜±P\è\î=¦¿!ô\Z‰\è\ÆÍŒ\áÈ…úc¹\âaË“gH6¦.Lsb\Ø\Û¬TÉP\Ùq6$·E¨Ë°±\\`¡0\èpc\ä\Ç\Ü\Ä\0U„A;Ê¯’\á–v7\Ä0\âÈ˜ˆ%˜X™u.Ý¸„\ß&‚ ùu\Ù\Û½É©‰ÿ\0¶¤ûBa<W8\Þ6x\Ú<~\â\áÍ±W}qÉ‰ð\í;ý\ê[öbü?H V!—N;bX1¢öQ\Z7E‹\0\èz—lP`QS\â0\ê4ùI¡DF£\È\ìz˜5™T&\ç»÷˜õ\à¶ÝœÁ«\Å\ÅØ‹Ÿû„õWÁx›‡¸ž¢¸MQŽ\Âc\á \è«q„®†1‡ ‹(\ÃAóy‚\ÔZq—#\Ï>ûôÁ\Ù\Ä\"\\\æ4\Ä\ÛG6“…\Îðo´m\Ön›¦ó\îav÷1	°n1öˆ·…O\â\ÐŠ ¥\ÇhL= \èzyƒ¥A\Ð@9\éñ…Ý¤ª$\î\âh”cÜ‚‡\è\Ür\01œ\ÜGi¦Ó±\Ü\í\Æ\èqª,\Ê¦(T¹pË‹fwm©§\ç\nþ¡ˆ\ài¾oŒÐž‡¢\Ät=\åX½>\"…´\Íø˜R˜Ÿ\Ä\Ê|C\rHO¥¯ž\Ñ[3°Š¹œö\èC\áùK\Î™x2\à\ï\Ò\åü†‚(ã¡\Ñg? ‹*j…\àqø‚€1\Ú\ÏDŒ\0<ƒÈ˜¹&e6\ÃÚ¥ó€\Â n¦\Þ3û3+\îs\Ô|\Æ,\Æ „ôný=A¦Qx\Ûõ3})û†\Z™›!\"\Ú!p¼1¯a¾õ.oŠa<EŸhD\äc\É~\É|ÀnTT=Lc‘»ôƒÐ™q{A\Ñ\Ï\Òf¨\Ñ#¢Á\ÚL\ã\ç\îª‚yüGrG\ÛP\Ë\æ+M\ÜD<\ÜË“(¦hI\n\â\îçŸ‘{À%CLc˜;|\ÂL&½ \í\Ó\'\Øf \ÛŠ\"ÌŽ¶vƒ&A\ØL›q	·žƒ˜±\'‰¥Ç·ûÁ\ß\ä\Æ †1„Á1/ú1—YŠ8‚T\Íÿ\0l\ÍAúEA\äõ7\Ä\ÚGs9€t¸³\Z\î!f5Ú€A\ÔD\\/	¾Š¶DABž¬a0Du\Ô\Z\Äÿ\0©©o®\'1;Cw3`„\n=kŽˆy˜~ðbö –ac93i€Lk\0\ã¡\é\ØK\ép´\Ý“qC\Ö\ZÁÌ¼¼Æ¼À(C\Þm›…»J§\"ðôY„^E›xù\0`I°G91¾SÐ˜Z\0¹ C\Íy­3\Ç\å\ÌÄ°öž~L‚²7\îh³Lº³wA\Ñ`\è\Ì\0…¬\Ì+ò˜a1š\ÄX\Æ\É\Í\âoZaù2¹˜\Än\ÐKA\ÜÃ¨\Æ;Y‡;Â£]’gˆ:T\ÂHu0tZ1³.\"\Ðù/¡1š3\Z@ À&k4\"\Ù3üLø«ý8\Óñp‹\Z\Ø\Û\ÚPL§´üˆ¤Ž\"^\Ñ\Ô±¢)&\"W[„\Í\ÓpŽðž˜\Ç1TKQ\äFÎƒ´|¬ñV ¡\0\äOˆ\äß©j\ì8€A.\0L6Gx¹Q\Ö\Öeñ/™¥[³\íå¾˜€Z\Í\Â‚¼\ßO@ \î›LÉ‹†l¨! Œ\Þ\Âfk\ÈO\æ,f1Àk¼&ûJ\â	L\Ó(¢‰P	´\Ê\è;ÀhM\Ót³ò\ÔÀ³h” IÛ¥MS„\Ód\ÌQÄ¨\"(\n 0\0aã°—\ÄaOpö\èD\Ó\í¬	‹6\Ü(D\Û9•\nÂ†l0$\Ù=9\éÍ°«Ò‰D$Ù”Á•ŸzP=\à‰\Ñ\Ø„›”ù€\Ô~`7Lô/\êôõ\Å`{Â‚R\å\Ë8œt$9Š \0\'6q\ÙyŒY¹\'¥°ó1¹S\Ï\"k1\ïwB\r+ƒ\ÜA…£ce\ï1yœCs‰BT±\Ï0q&i¶!@\Òâ˜­„J•\Ð\\º”x€–1V–lÃ²ó	v\ï\0	£\0‰0K4\'x\êTZ\Íð˜L ‘\'¿¸‘XlŒ&v\áXÊ¦n›¥ˆXOPM\ì{M¬{\Å\ÇµQÉŸÂ‰N\Ý\Ì	6\Ô&\ã´ÈŒP…4b\çpi¹˜›žMGPƒ}_\"n<\ÎO‰\Û\Äk´/\Ï\Û€{ÍºA\nG\ã\ä¸\Z›\Ì\Üg&&(1‰µGxsc^;\Æ\Ì\í\Âñ	6`\Ç6Ž…‡KQ7šö\ë©\Ãþcù˜\ÛkK¾™²\ÆXË³\Þ}BX÷¥\Æþ%’LJ[\"€/˜\0 YR¥J•\0L`C²{\ÏM˜¸DTXB\ÕŒ\Ü!fùn\ÄËcLoW,U\Ín¡\\„Suß§xj\å\Ã8ƒ˜\'Ã±ý\Ù\èF\æ£ü@\Äwrû\Ë_0\"™\éˆm0©š\0n€N9Pwhs\äb}£ù\ÄÊ›\Ð\Ë\Û\n†v!q‚\0Œ¼Í¦0>ðPóÒ´\äx‹\ÌÂƒ$_aò8›TÍµ\Úuófž¸ö3\Ö\Æz\Ã\Ø\Ï[ñ=c\àC•Œ$ž\äŸõ<Oˆ¾\ËA\æ»¶\"o#…?É\ì6f\î;CW.€xlyšA»P‚ü\Â:_Zù®\Ñ \és\ã9¶\ëm5\éˆ2o®!¡\â3ð\0¿\"¹µ\á\Ý\í9ö„~&©\Çô‘\ÏO¿Ñ®¦_K—ò˜OŠ\Ù\Õñ\á@‹¹O$G-\àˆC\Æ*m\â\"hƒ†`<£ýS\È>a\0Ÿ\ÊË®p*¨EmÛ‰l]¤\ÔÆ€­\Ïÿ\Ä\0;\0\0\0\0!1AQ\"a 2q#3RB‘¡0r$Cb±%4c’ÿ\Ú\0?\0¹Si›L£Õ˜_‘J0\Ëd\Ë\è!¨3,c’X\Ð\àLY¶:’,Ë¹5Vcf;%(Q\Üù0œù\Ü±±c\ÄTdk; |LÙ¯ŒX\Ê%ñ÷€l\ËoDž~{\Ï\ä”P\â‹LXq;ð~&?ÃŒ`6^Añ\ÅÃ“K4ú­†ÉŠ›*µUø¡\æcõ\ìYôùµ;r°!qªö¹¡Ô¨÷qû`‡B¼š\0\ÌZs.ÿ\0\ßõ›\rä¾ Yð¢m£{A„rHZ†úT\ÛP‰]7@a³ù¼t¢ð\'x*Ð…\ÏoŒRV`\È/i—½C—&|\×úx È¨Œ+\ëe6fC¬\Õ\äEn\r} ð*6€¡|Š\Ç\È!Í§wÇ·‘w<òœÀ£’(	‹F\Ì\ì\Èmo\æzBj† \á\Ó\çò5©¬Lÿ\0\Ã¸ùi‹\"¨ðv•ÿ\0\r4\Ø1bÄ¾þ§fRû[!úG\Í\ÇÄ£!\ÜûDy-Y AŠ£.\î6óy•R\å‰\Ä)p¡›f\Þ/¡ü B:\'´`A£=\â\Ù4&˜q³°öaõ]³d\nn¾b(l´€\ÕñM®x˜\ÔZ²\Ðù™Ý™†Û±\æm7\æâ’¤\Z<LZ„»“\ÜT\Ê§[\âi5\ï•ñ\æW\Î[”\ÚN\Ñ÷3¿U¨\Ô\í\Ö\çÉŒ\Â\ßs5Ï§9k\ä.M±\àü\Ìù4\Ê\íMf\ïh\ì\'.M	Vn\Âdm\ÈH\"\È\Õf\èK\ç˜6üÂ¤À›\Ä\Ü%¯“m\n1G<Ê•\Ç\ä\rRúg˜`\0÷ˆBƒ±mŒm\ÄUöŠ„ø˜÷`Ê \\û\\ü;¹»\Ò\Ìl¥\0n\æMFP\ÛUT÷5L\íŸ#µ\Ú\Ì\Ä2=m[#µLJ­»&f#ü\ÔmJ¶Pp‚*»y™÷¾OyY¼%\Û!]\ìx\ä\Ó{¶“1fÚ¼*ˆ)\Ü\Ø<‘´\Ú¾ð—*\0O½\Ô\Z3u±6ô“\áD¿´\"0^*\å	P,tZ\ØX‡&\ã0‰ü¾\0ø€°\ìg3¥CC\ä\ÇÈžð\Ýú–©¦=[¦|v¼Ç)Ë¼~¡\Ç\ØÁ¨}£zpDE\Ä\ã—3\áx4OyŸ\ÈV+‰6Ž\àß™‘\Ã\î\'¹‰J’Ä…s\'³\ÃYù‡P2#€~.Ä¬1o°4f\ì\0X\\Š/0Õš\í	$òg\â5@V\0U\0!£w\rÀ\æªo©»\ÏBY¸‰¸™ü³À&\áPxG™RÀ… \ï ¨n)¡2\æw\0Àñ;ÀÂ€ƒoµ‹7XS›¢x‹þ’]\ÌªB„|™—L\î§\Û#ƒ`1+­2\í±¤p\ãÁf‰tø\ÝK3ž\â¸…\Zm^L˜Ç¸s@“´YY”n$¨¯‰\éY=9}4@F\Í\îs¸rlx\nR¾1G½Ù€\í$¿ˆ]\Ë\ïº?i\î\æ\Ø÷d7sRú»Ažƒo`@PÜº—Sƒ6ò\rÔ«\çx&P¡\0%@¿xŽ\Èm\ra€Å¢@¸\Zµ±$L_hð\ë_qW #\æ`FWV4\ê9«™ŽWmrLÇ«\Æ0\ãÅ‘IPX\î.`mÛ–\áÿ\0\ÕDq4\ì\å\\™¥ôœº\ìÁ}ÿ\0a1z7¦gd\Ó oki\ÛÀ±ñSÒ½T©®SŸ. k\"‘U]\æ¡}¾ž	\0ü\ÏHÇ¡\Ôzj\rB¡ou÷± 7Š‹•^ÁÃ‰Mw\"2Zo¤]P˜÷§\ÕÈ±\Ç™˜’\Äój)¦­ý ,À©\nŠO‘\Ç\ÌF…e\Ü<¨C)*@\â.\ï\Ï\í;M\Æp|FR\0<s¨ŸZð§\ÌöðY·y\Û=ÚÀ©B/²nšú`\æ\\A¹\ÇÁÁa°’;\Åö{©A`ðg¹aw!Ù¼ún\0¸<}€c~&Ü…\Åý\æ“\Ô[J\ì\Ø(\0óDLZP9Fvõ\0‹›Þª*ˆ*)Å‡R\ëŸ#\åÉŒ°&Ám¼W+S\Û=®h\nû°\åñ[Eÿ\0¼l\Úsõl%¿µ„g>Œcb\í²	Œ\ãf5PÂ‡\Ô/‹ùP±¥\ÆF^ðw€)<´Ù…¢{Iµ@o\æ&4{?Ps+=\É?hoµ±ÿ\0x\Ë\\\Z€¨›Ÿ0´˜—ô*W0\Æ6˜w„,%˜\n@˜ò6\'¹> {Ì®\ËPüE,MA™w(\n~`­ |\Êe 4\ÎBAŠ*\Ø3°¡4\Þ×¸\ØRM_¤þ1ewuZ\à\Ýñ5ž·¥Ã•\Ø\ß\é=æ­”\å-\\=?]ŸN¹ub,7\Ú.\Ç{‡ø(Âª;º…þÚ¹™q»h¨aj@\à˜U\ÕÊ• ˆL\"ó!b€¼Q…B]¯ö˜\Ñÿ\0¨¨\ìÑš˜\íoö\â.& 3\ÌtmLù¸D²!ŠhTÙ’\Å@1Œ<c\ã\â”‘k©Sc\Ö\à§ok® K³GˆM0rj\ÄX1˜‘÷¶m-\ï¼\nÀ]ˆØ—\ÚO’.•\ØÆƒv©.J%ª\îa\Öon1³x¨¤Y\" \Ø×fZ$ˆªã•¸º•S³  ü¨C‘ZÊ¶ÿ\0¿˜ù0¾8µùûÁ\Â1\ÜÛ¡ç¡˜ñ“\ÝHø\'ö÷\ìf!§f§\ÆÝ»Žc¸vª\0\Ùæ¯ˆ¸À¶Í¨\r†ý®n®„6‚/L]\ã°+l\äx\ç˜q‹©F3\åB³‡°ˆ†¢\0ófó\Ú/ˆO¬T‚>\Ó¤\'o?0Ø¹›-65R\n&\æ\0·h\åU—±\"V\ÛO¤‰…ò\Ñ\ÚÃž÷5õa\0Q¿î°Œ£õ+÷I’™¬XŠ¬­g?\Ü&Lkd¾ŠO•\æy½¬—“+c\Ú6ñ\\\Ü\ØJ–4\Ô8²e¸+}}\ÜÊ»l\Ô\Æ\\Š.j\âlF\Ì$Yc\Þ¨\\ü\Í\×	„À\Óz\Ü\ß\ÌWš|Ê·jý\â\åHa@ÌˆŠ	c\âU\â\ßÁQÀ_1Ò€1Ñ“†z)\ï\ÄP\0\înrMGl¸ð\ìd {>¯›X \Ä8«\ê\ÉûŠž\Ê2#U®\ê¿\Üq1k\ßz¿ˆ\ç\ÚrÂˆRžF!p\ær,/\Å\Í=`b#Æ‡‚n\ç¸\×[\èÿ\0k\n3qc¶Áù\æ\\^Ff\àv¦0¹‚\Ç\ÜÐ„Œ\îõ¸\Ýp&4b.\èMŠœ\Üf„\Âzn—Ll\"\Ù=ø¨˜‹2üMÀvï¶®Yˆ\Ê	\ìŽ+\Øó\Ú2•±9QÜ…ŠK50\â\Ý\È\î\×n\É\Üþ•¸&úhó1v\0¹ø‹\Ã@QL\ê\èw\îL91¾>H3\"Ž\âÈ‰˜\0-ˆ¨…·#ƒ\Z\ÔlTl´bœÎ‚\Æ<ƒ÷\æõ\í®<™™F\å|ób2]\Òöƒ±+‹ˆ¤÷ƒ´c	\Æ\é}\Z	P7\Ô\\¦\æŸ;S\æ3â†ž˜Cú˜ãˆ¬\ë¾\Ø\ØPÛ•X²ÿ\0´8Y(–\Ïa};\Ðµ\Ì>\á&˜ÿ\0,†\Üˆi„\Z4:?e`.\Åž†\0¢\î\ì\ÎñY”\Z›ƒ\0k˜½âŒœ6\ëû—\Ìm2r\ÅþV\Ö.1}ÀuòyŸJ!¦.C_£Ý³Pe/\ÒOcñ-\ÃU	0´<À!ypu\Üø\éPq+£X˜½K\"X=ˆˆ\×~f1Œ!ÝˆóG\âQ\Æ+´dW/°l\çˆ\È\èh‘ó0û\ÕH\Õ\æl\Ç#=‘\ÚA\âiž˜\í\à\Ç}\ÌLK(\ÄbŽJµ§¼\ÚUy\"-Ô¸	k\Þlý\áWõ\Øý£©Qƒ\Û\ævn[qþ\ÕK&ÌŒBƒ\0Z*ö§´QÅ˜MFn—ÐƒS˜!\ë\äô\åô\Æ\ÌQˆ\ìT©\Çy¿2ª\ìr¬ \È\æ¹ü·*£~ixs1\ãd@ýQ·l#wÚˆ…*a^L ÷ø\ïô¯#¢’~ñ°•$xŒ¤5T`Gn›Wc~MTŒòw@T76c{i\Ø?d!%,˜61\à>#°\ìF1‰‡´XŒ\Üt2ÿ\0(j\ê¼\Å\ïn\Ä\ZùicÁ\æ\êdF€LxÁ*Xp¿¤@\æ\'°1\î£=\Ósµ¬A¹\\{Yj%Z1ø*/¹¡\ï,ý<\Ïe\ï´Ue6¯iðy¨E*~Gc-\ß=\âŠ\ì,ü\Ì×¹Z\î>@OanŒ:m&ÖºT©R¿(ˆ.aq2+LNM†î§“ŽB¡ký\Ì\rhO`DÈ¬¶{‹˜ÿ\0Y\"clŸJ(\î8?—Ã‘E+ˆ¹Á\\v\ßRþ¨3‹\Ê\Ôrl~ð‡´f¸<…4Ã¼¾8\ã\í2µWbÌ¼Ù™8c7N„L=¨ÁŒ˜1	\ìÃ†£c\"\ÔLSZ\Ü÷”}ÁDq\Ã}\Ä\Çj¡L=\ã[ð<\ÃCg\ÅT|›38_öðbª1Ÿ\åb\æ\\KŽ\É\åf-^-›[½\Z2\Ã\ä qk\ÌV\nŽƒ´ÿ\0½\ÎFAFo\'ˆG\ÞWûŽ\ÆTƒ2þž\×\ÄÈ¶³(™DBx©|J›`X¸n0c¨Àœ\Æ£,lpô`ýB š¹ˆ¥V †\êT\Ìc3/Ó\Ô\Ä\Ö\ë\àÌ¹0ÿ\0%rdÁ‰—;{Oc8z¾G\Äl)\â\àTZ$v…Ñ“ˆ\Ó\Å\àŠý¡¡e»@/\Ì(6žLhÓŽŠ¶gµUŠM\é	.£\ä\Û¨OÄƒ\Ì9ÁñŒÍŽ˜Ÿ ˜)YK]\\´{>¢DQ´U\Øñ\Ðö—\ÓR+,\Æ~µý\æbÁt\Ä(5¿¿\ï2’[p(ý@Œ˜Ý“h\Û\ßÁ2\æSbcf5AB\ÚfN\Æ\'\érÈ”€Ç†1)lŠ&E\0C—l}C·!{‹}3`Éƒ\Zx1FÙZ\Ã\Â\×VT\ÚK\ãÿ\0+nµ\ÓZk3Do©x\î»\ìZ™\È\ì`vù\Û\æ+´¹}¾\â\'™—±‰úDT\Ê)}\ÌnD2\Í\Í\îf?:\Ú\ÆE\ã\åU=„L\ÆûL4\â63\n2d\Ø.¢œ…ù \r˜Ç‰Dµ\ØJ‹šV%iP‘úl_Ç‘.ÿ\0.¿ú¿\ân¦W¨Ý¬\Ò`-J\îo\ïB\êb\Ê\Ø_&&ðm~\êf=N§;e8Uv¡«\'¹˜õ\Ê~—!\\w_ˆº\Ì\'³¬ÅX\Ð0\â!\äÌ£ƒ1þ‘\ËE\ÌV¶a~‘1\çi¯™ à¸ŒlG\ÆY¬ž&}({¾D\"‰\âip2¨-(L¸CNÀž\"\ã?co‰\í‘L+ü\ë™V\Ä\Ò©€4|Dpü‘M\ævOOP­\ãö\ÜL9±dõÍ“0F\ÅA÷L\ÖdC\ì\å\\ŠûIW+÷šmi\ÒiuYò\âs‹\Ý\'/6{Q³.¨¶6@=ý\Z\çVòpc\r t\\šaýAˆ\Z\ïkº\æ—W§s—&O‰°\åÙ‘b.¬D6 ôNó ˜ÿ\0H\é˜\ÓW\Ê\Ìgùó&>\"bú}¦,gcðe\\ö\éTŸ\Õ4<	ŒŠ$™‹&\ì•Y1¾ž\â.Ï-}³)©§­\Ìc´\Óp_›•\Ë\Ög5\Ôôõõ)ûG¹§Ô¦Ÿ_®/‘vÍ¥\Ï\05ù\Ãh2±|X8½³{šz^%\ÖhtË•—nÊ¹±Ÿ\î¾ \Ðd\ÓûY—n\ãs÷\àÌ‡[­\Ôzv\\d/Ó–Ç‚™—6ýj=³Œ°aýÛ¦ö\×öèŸªd‰úg‰œýiÿ\0\æÿ\0\îŽ9\í\Úö†\Ë)‹,ƒQš¼À÷\Úo4P\'aÁ„60Ñ»\Ì÷À\ï2\ä;\Ë#\Ì\Æi¦œþ¨\îö˜wvð\Ë›j’{p7¨öH\Ü	¡e§©\Ä\ê-ñ«-Ž\×\áÓ®—3{H^\ÑÁ™}3C‘‹:\Ó5n¦\"\æM%Ï‹\ê2”Áœ•4&Ÿ@Pk©tG]\Û¸šOK|@b]Sœ¬c‰À¢Ÿªd˜ûA5©#qœ\ß2v_\Úan€\",$L†b«¹©\Ï\Ø]O\Æ.\Úk¹—1f¸™Èž\ê°Ls3À^ð\çWp·Û“0\å§»nþ“\ç\àÁ\Ø~]x\á#\ÏRÁ‘B\êp¹q}J~~A™µO­](UÛ±.WI=„Á—N‹­ËŸa2(ýš„\Ôitòû+ŠŽ\È\îO\Ã\àÅ‡l»†6™ÁQ\ÜÑŸ\ËUlør¾\Ïar¥Ÿ™\ËcF>GEF\Ü8™1=v37> \Ó\äøš¼9ZS3#Œ½\î¸\æ\Ñf6\Úb›r&f0\æ7Bf$\×\Ì\Úx\Ø\àJŸ´À\ä\Ý\ÂlMO\nf0¬\n—6\Ä\×ø™qaÇ“o!wGoxv]¿&zfS—6=\Ê\Ì[v•n …P|\Èf¸-O\Þ:\ÍNúwûÑ\ãL«Ç·€#\îQZN4õL\Z\ß\Ûe¥&\èÁ\êW«É¼VFÀ\Ë`‹\ÛÁ‡Ô´Yi ›\ÞB\ß\ÚI±6¦Ç™_n—e%fœ)?a	 þ™ƒ(\rBƒ\â*¨= ©‘AS5œe38\Ä\ÞRÂ¡*\ÚšŠ­q0¹\"\Ø\ç‰\ì§÷·ü	±\ß\Ôß¹þ‘\0&5¢aš¯\Ó2\ãÖ±\Æ\ØröÜXpoŠ14ž±‘N,¾¢§»!@j>.ip*ª²PZ«•Z¹^E\ÕP7ƒ??¸Lš\â;7üDmÈ§\ät\ÖKü\Æ\Z€Â©ð#bC\àC¥\Ä{¨™=;M‘J¾% ø©‡\Ótx\Ê\íÂ‚»qT(\Äö˜\r*´n‚d\ìf¹šf?\èˆ%\Å4nq„ö´ T\È[\Ä\Üÿ\01c°\ÍY¬me¯\éÙƒc\Ù*.ýˆ\ã\Ë_ª&,ž^2qE\ãa¥°öC0E?\í\é«þ‰†/\émbÃO™\í¯÷@‚ÿ\0TU˜«M;Ù£a3\êð`#\Üj¸=cF<´XÒ›\Ú\Z\æ£V_1R¢cÌ¡6\Ô÷R{«=Õ¹(a\Þ\\xµ\æ?´#²\ßx…„\ßP\å38f\ÆIŸŠ\Ê\rPƒW’ë‰‡ñYÜ„\ìa¨F)›€;XaÃ¨\Ì@\ã\í4\Æðcÿ\0´t\ÕE¡‰\ÊÊœJx€\Ô÷ýÆ¦—U»8\Ü&2Ç°Y¨l\ÙÙ¼\\¨f_\ë\ß\ÊÁ|E³(À€ù€m\ìawp\ç1³“BL9L\Ý7w1a\'“3c\nÌ–¥…LxÙŠ\Üô\ìLšfaÜ™\êxœ/B\Ê\Å\ÂdZ‹ƒõÿ\0\Û4\ß\Ð\Åÿ\0h\éœ^\'†c\íP\Ê\ê;\Å<L\ãw50a)Ÿ_™êººEÂ§¿y]r\ç/\í^\ÝLX\Ã\ãýŒÏ¦eRÑ•„2 ‰‰›\ÄÇ€È„T\"\ÄË§]\ìj&4OLu|ypl\r=K/Õ‰+•Á’dsSBWüM1¼\ÏÛ¦_\é¿\íiŒó\ÑVm„\Ø	\ã¦%\Ê#r\é?h\Õ\ÒLÍ‘²d,|Á\× þbþ\ÐE=©¥ÿ\0PŒ Š0é±•\äLžž•¹Lm(¸¸\0Š€C3´|HÀØ™p\æ@J€~\âí‰‘\ÃS|\Â\Ì\ä»\'\ÌóL \îpf“ú	ûtqô7\íO\×\0š¹bss•4D\æ{tˆ\r_j²Ÿ\é\æÌ¯É“½1ö\è ˜\rdÿ\0\à1Œ\È9†¦hL\Ô\æ33\Þ&<î‚ƒXA¶&-F,”.Œ\àºWÁš¼?±\èÝ\í\Ì\Â\ÌøŽ¡g¬h\Ð3i6\á=\êA‡\Þ=sq†S—€{ñ¨\n\à\\<ï¿¶oý=Œ\ä±\'¹ü‚7e=1ô°U³0–÷Rüø„M\Õ\ró5\Ú\Ë<˜L\á€1\ä\Ì*˜\Ì\ZÌ¸…\0OR?\êIW…ÿ\0\ÕF¼\Æ\îf>2)™\0\Û=O¾Ÿ\"\ãB\å¨ŒÐ¦£(ü¶\ÑqŸ\ÚT¼\ÌùpÒ¼™‘†ó\Z·#ò7aû\ÃÁ˜ºQ\Ü\ÆpÌ£\Å\Ì8\Ôs\n\Ã8¨ý+¡\í\" ¶ 	ª×³\Ú\ã\á|˜y•\0³À—\Ô\Ù{3À•ñ+’{Ø…}-X©_\Ë7T\Î	8Z6E Z\Æ\ØZÈž¾¤tqô¯ý\Ñ\Å1˜®3\ØÙ„Àf›Z“\'oV[	\ÃP\Ã\ÕE±\0Lþ¢£Œb\Ï\ÌË›&Cl\×\Ð\Âf1\æ*T¨?%\Í>zjsû”9aUÀò:£«\ì!ra2­a~C´ýš3c»\ák—ù.L|£\Ôr\ÔC\ê‡\Î8}I?´\Æõ1\ãP\Ê\Ä\Õ	“+¹¶ba2¥C\ÌD¸¢ œ˜L&iµD¨V<‰™·æ¡€J„t4;š‡\"øŒ\äžL¿\Ìa„0“\Ói0$ LU€@ ü\à\Ç\à@lCaA_pW™u/\í\r+Á›ûa2ÿ\0%Ë—7MÐ´&1—rÀ„ÀI„q\Ñº	pBz1\Ì|@)`ý·´\à\ÌY\"®|\Í\Ã\Â\Ç\à\n†esúa3ž·	ü§¡¬$\\¸OŒ8†$©ºM˜\'\ê‡ô\Å\ánd–h‹¡ø¸{\Âr\0ha\ér\åô\ÃÑ£eô\Ä#C\Þ ƒòy\è\æ!\íýpsS#ö\Ä\ÅiL³7L\í\âayº\\¾‹\ÔþFñ0ˆÝº(‚†Æ¡7\ÐF?L\î\æµ`6\Ó\ÄpAx0\Ã\Íc$ôs¹ 2\âˆ!\èzÑ‰‡¼a\0˜\ãv•\n¯\Ét!=D\ÈiLO\Õf;\\O\Ô:7h9Dý§!L2\æF„\Å@‘Et\'òÑC6\Ä^#v\è°u2\á†\\\'(bô\Ç\Þ\\3^0<‰g\Û\ä\Ã\Ô\ÈI1Af*Áù¨¸hz±Dy´žÀ™I©Ó\Ïø3£ú†]À`\"\âj½+[¥‘8«$rC\Ò\á‚	”ý&˜\Ä…\Â9¾\ÄG6«	EL\Èeô^Jˆ¤žšG9\nFUÆ¬É¸º?JÀr„À± c|\Çõ\ìÛ¶\á\Ó\â_ŠY\éþ«ªA\ÖZc</\ÑB\æ“U§\Õ\â9Q‰\Ü|5™±jý+Rø©Fÿ\0ˆ;C¸LLºƒ‰r¥G<ˆ\Ð\Æ\è\Í\\^¦¢˜retE[-\Ú\' \ê\"«fÄ¤÷¬\Äþs©8q`]\í5Q½Ò´8†]FF\Éð™¦m!Ë¦\ZLIµšÿ\0UEÀÚŸ]tk¤{?`³O¯ô÷õF9\0\×r3\ÕtXô^£¦|\\#05ðAš\Ý*\êô™1y\"\×÷Ÿ\ÃB“Y‰¸ ‹\Ò(\è5˜oô»‰TOF2ú\Ó\'h1{Å‚r£þ£1\ç~¢¦#q\ÐA\é:öLn1p\çŽf?\á½K_¹›\Z\Þ\æ/\áŒ\éµW^_Gô¬+´\ãVbhn3*z?¼pG&K )7S.\raÔŠö\ÛÚ–ýEg¦z[\ë‘ò.`›MOOÓ¦OR\\9÷\"\Ô\×\"~,~1´¼ß¶6\Ù\àÌž«¥\ÓjWHøk°\Ý\ÅŒ\Ú$õM\'µ}H\ÊÁj„\ÃKüA’»21“‹\Õ\Óíž¿\æ­®‘þ\Ìú‘4y\ÉúI\nß³	ƒ\éýK3:Xý\Äô´Ù—\ÔT‚ºy3:\íË˜|9†É—A2ö‚!£˜:1£Bg)¨¦\ÄV\Ú\ê~õ-nT\ÐcÏ„¥P°G\ÌôŒyuºŒ\ï\îl¥ºVg¦b}GªdÇ“;‚·d\Z&Œõ_V:{\Z*‡v·\î;\ÏH\Ô\äV\Æ\Ùrnf±ºc)®Wgð¦m¹³\áþ\å¸±\ë_¶ ÿ\0Éž³—ðž§§\Î\Æ\Óbd:¯S\Õ6\Ô\Ü@\à|4\ÈúMn/u\n\âÁUªÅ¥õµ\Ê\ä\ì	\ã\î&£0ms\ê1ö÷wý\îz©\å\×*+¢¨Sbjw7 &üŠX\"¾\'½®Ï§Løò0€¤È¯1=I˜f÷ƒdf­ šPfA[…Ù†Š`‚e‚/x±GBz{F„F>f7\æ4\ÄF«ø}\Ç%ñü5”&µ”öd3ˆ˜Ï‘‡øiüKŒN7ð\ÉCüM6«\ÙÏ€…cƒsø›}>\Ãý-ÿ\0\ä+\êXO–±=d{^«œ\Zz‰_Rÿ\0\Ã\Ê\íMø1ýý&¡\Õ\\«£UŽ\'ª\êò\ä\Ó\é*s`fy—µ‘V	\0°¿ø¹«\Õi=…]>¡ \î¾f,9r¶\ÜxÙ\Ø\\OJõ!=¦Q\çq©ƒ\Ó5šS•“U­gˆøjN C\Ô\ìnj0>\'(\êU„n.\ÅJ¸Dd‹\Þ$X:˜\Ý\ZVT\ìD_©ô¿^}3vÊ”\'§7\áýK\ï´ÿ\0ž\'¯\'±\êZ|\ã±\Úþgñ«O™1\"5\äSÿ\0>, ‹B&oSÉ©Ò®œa³@\îIL2i5220¦/Èž¿¨\Òjr\áË€ƒ¹~¯›ž\îU8\Ê1[pšŒ\í©s•’‰­\Äv&{>¡®Ç‰ò\ÔPb@\0	ŸH4¸q\å]\Ïõ¬ð§öŽÿ\0øŽ\nMr‡\ë5˜rz~¥‘2óV5Áš_R\Ó-{úvs\ä\ï&zn]«6-0@\Zˆ\"zþ§\×\ãÌ¢ƒ(#÷\×òœ¤\Î;>-þ#¦Ú®\Ñ\â\Âb˜ü˜;Àbs\å&q n†a7Žz~sƒ[ƒ%ð_\ìg«cö}C#/bCó5ºÌ¾£™”*W1¹Ã^\ì«\\\Ô\æÉ¨\Êù[Éžœž¤\Êë‚¥ò\æ„\Ú\Ç(\\ùY•%N\ê¿kô\r¦Á‰\Û©cÝˆ\çü	ø|ºU\ÓjU•Í‰¯\Ô\æ\Õeöñ\0q\0UY¥\Æ2¹\\™¶\"‹75:\ÕÏ¢Gd#j\à|\Íd:§úu\ÏÀ0><~©‘µ‚Àv\Ü&§[£gØžœ¾*ø4fƒ\Ô1.$S§öÓk\Èü\ÏY\Ö\ä\Ô\ê\Ý	1±59ONÓõcv_ðy„\Ô\é\Ì~8ø€\Ï\å÷‚ñ \êa†&œ÷±¹«\Ò\éõz->¥³\Þ\ØWfzvŒgLŒt\ç û¶=GO e|¶3\n\àwUc“{š\0UG\\\Øñ1*A\äM6}2\è=¤_\ç»5=[RùµNFeP\0¹Ÿ\Ô[6‹›\Ú\0%}S\Ó3\çLþ\Ö&\Û\î°ùU¦ÉƒTS a¹‘}\æŸ\Ñ1\rL…X\älfƒpDôü\átúŒ,\Ç\éeuÿ\0\r=s\ÒÝ›ñXE\Øú\Ä\Ðúž‘2{šŒ\Ü·pøš¿Z\Ò\È4ø>§ZbE	¥ü&\ÍC\ç{}¤\"ý\ãY8Ï“\0T\Ç6\ÄüþO˜ \ï1Ê•6\Ã	†ËŒ\í \Ã=$F›Q¤\ÞAz	¡Ç¨ËƒY§\Ä\ì¯A€k\Ä\Ö`öv(²o\ê{¿«\â+8Ê¦Å†žºqf\"Õ±w‰\êš|\Zlšw\ÂŒ=OP\Ô\âÔ¾\"˜B´õ\ä\ÏE\Ñ6\\:¤Í…¨\í«5:\'\Ò9ñžð\ÊfTË¨Âš£¨ß¸|‰\éÙ³¾£	-™ØŒ;*‚>&³\Ò5Z½™•i\íòVi˜d\Óanö‹5ú\r{¥.~rfDÃ©Ã‡&›\Â{2¼\Åü5§^r\çcCš\Ô}C‡Añ#T°I›œv&~ñ„® w•Rj,¾¦\Ðõ®`0 \ÐjN›U‹/€yš–\Z/TÃ©R=¼¼šø3[\èys¶G\Ó\æ_o+£ó4~ˆžöSŸ0¬,7¨ž¢F³W›&S\Z‹?·6‰µ‡OD\ÒiT\Ð\ä\Ì\ÚuÅ®ƒ…š‹\ê\Z ê¡©\É\ÙUB3\ãUtúF¥\ì†ž—\è£Hs`Û\Ñò\"…U÷šõÿ\0\îý˜\'¦\ë0.>U\Ú\'\à\ÔÏ¨UûØ…&~?Fª\æJ13bl^êµ­]\ÍF\Üú7£añžq\r‚GCÌ®„ñ“X´ ³*\Ã®žbp\Â7M]~Å¶£ó´\Æ\É\êþ–\Ç\'\ìH±P\êµ:­C€\áj\r\\›K\éT‚r²Orniqh™\Û‚pª–¾c\é4‹™0+õ\nùšeFP\Þ\Ò(&\ÇÝ›kŸê©¥\×õ¸Ö‚#¹\ä}*Oi¨\Ê¡ÍŸð\Ã\'\ÖHû\ÏÀ\ét\êÙ‘\Ü)6Ibf‹Pš¬œ\àÀ,Wõ÷Lrd\Ô\æÇ—²¯o~fb{\à8”!°Œ<•\î&c\ê#Y‹\ZdA‰\Éÿ\0O`&»S¬Ç­8+*lRî™²ý\Çò43¶žOD‚\\LNühÒ„&\\¹pwÀ\'¢\ëI­Ú‘…4Ç“·†\Ç`ðjeÁ‹ö0\âS·½\nu™ýIñi=¼jT›`xÿ\0²ŒøWVŽ\Þ\ám¼qö“›+ºÌŒ[\Åvÿ\0i­l\È\ÆS&WnUC\ÇÉ˜õXñ\è²\äÃ„#£S¡ùšVosVŠô›r×ƒ5¹SœEÜ»«|P.6}>(U“=\Ý\Ô\ãÉ—\Ôq¶Æ±Jÿ\0$A\ê^–3>A©MÌ ñ=\ÏFúX\êÇ¸vû\æ\î?ªzC\æÃ•µ?V;ª¿3\Ô}G\Ñò\Þa™ýÀ”6Ø¸ù»1òoòTe˜xñQ\è“™?Jñó1\èñ­\äÍ££2‡\Ì\Ú>fÞªœ‚/§\à\Æ\Õ`Ù‡\'e‰‰\Úk°kµž\ã•ôûJ\Çq&þ™\è˜SñxýÀ¤„%EL\Z\\\Þþ,Ž¤\'¾ý–ˆ?$üMFN<š–ÄŒ}Ý¥]j\Åx\æ6Z.›8Ë\ÞD\Úûûbf\Ñ\â\Ó\ç]V¯6RK\í=¿iÿ\0‹z~rc&vu\nKüQ\êú\ÌüØ¿Ú¼L„·rLnðôXEÊ¨\rô#¡­p\r\ä	§ôMV}3\êPˆh\Ä\Ð\ãJ¾LQB„=ha‡ •*hñas\"ýl>ð X‹—BF*\ÎÊ ?¸OrúD}V—\Ü\Èþ\Öû<À\0Gõ\ízñ\Õ€\0\ë~¦\Çÿ\0\É?\ì#z–¹»\ê_ý\ã\ç\Ìü6G?¹‰ôxÐ˜ \èD\ÐË›\ã5\Äza?…qgõKõ=\Ü\ä©‘ñ³&E§SL>\èz>4;¾Ž\Æ6–Á`g\á²1¥£Kœ\é˜qdò†loƒ6·ÁƒC\ÙL\Ó.ÀL\Ëú\Ûò3Tw¹}D^9ƒ§?Ë†DOþj±®»PŽ{¥\Ï\ãM-\'ªŒ‰\Û:©|Ê„G¥†Œû€H˜R™x¨VT\Ø> EøŒ¼µ|š3\'©™‚TU€A\Ñãž‹ÿ\0@ˆ\Ý?†}Eô\ZÓk\éO\"\ç«zÆ£ÕŠf\Êl§\ÓÚ¢L	\Äeò¯\n\ÔIn8˜\\û\â\Íó•\0•P0¯Ñ»‰˜\ÖC‚?hW™¶mŠ½Ttx\æ\\Y|ô#òTh\Òç§½g#\åL\ÆH\Ä\Ã\å\ÄÄ¾z°E}\ã@£™§\Ì_ß¡A6Íœœÿ\00\Ä7Ñ…ˆV¥@²¥t“\Ù\è±z4\â‡ˆÑ¡žžkS÷‡À˜\Å/C±\æQ©¦þ •Œc\Ñc5\"œ~\Âc®:,K‚\Ó!\â\Ìº:˜\ÂBh\Î\ÝF3÷ŠC\æ\àPanfUP¿HšdR\ãS­W¬Ê„CÑ¡Ä¾\á75kõ(u\î#\n—.¦C\Ä\È\Ý\0†\'\é—\äN`¦Nç®Ÿú¢iF\ápF0ª…\Û\íb\Í\ÌIü\Å=Œ%F˜±\â<°ž ©¹G<By—x½2˜\Æ\ÏSa<\ÃÊ€C2\Ï=4\ËüÉ¥¢\Ä\Ã‘¾D\\*8b&0€ñ._J¨\ÑMM[\î\É_—!†E\Ì\Ý(Ž—\è`€JŽx1\ÏA4«l&œ}Ç¡\í7ªÁ3p!„ô1£šÌ†Ü˜z˜\äÀ°$\0	qž„sfzQ&d1\Ï0zhÿ\0R\Í8¤¼\æð9	ˆ\Ô\Ã÷Œ!\ê\Âeý&7\ä0Ž`Y`BÑŒ\ÈüKüƒ“+¨6\Æ\àGncAhE\äI‹…Œc1fù¼À\ÆÅ™v€ý§Ž­3¶\Ô&_[†7M\Ä\Å®\à\ê \ï;À X™™üBa‚\Äô\Ñy\Ö(¥\ÏE\é\ç¦xPýº;t\ÖLõ==nBgy|õ¸°@\"ˆ&dxÇ§s“\æzZ\æ\ØK\â9‹	¨Û°ƒNþhEÂ¾f\ZöÀ!\ïOP»”´0}0\ÏS#’`\ï\Ô	\â@!\âd\Èf„À&<E´b\0€[¬ô•þ£}ë¡‚4\Ý9šcú„\"‚f`,Ÿ\è±#¥õ¨v\0L™.ú\Ô\n`C**@ )\â1$Í¬{ºw=\âbD…£›1{=;µ¦[\îyž:P™\rAP\Ô`j\È#µ5­D,=¿(é˜±&m0+@$	Í°,\àBÑŒ~&\áAP\æ›\ìC1^ô_“1­ haŒhL\ÌI‡ 0=„†UaA5†óÿ\0ˆÇ¡—.{Ff\Øl•*WK\0FxZ;À\æY… œKš,eõ8Ï‰p“	™\Ú\ØÊ†T^*\è`3Rœ\æ3Ë‡‘7`a.3ñ,À`aB\Ó|\ß7\Í\×	ŒÒ®,n&-ó\n™\éh?¦f¥\'¥ž›L©§j5óWN\ÆjùŽ~L#\ê¸:2\Æ¯m›aS(\Îg2Œ\na\àFbaj…\Ì\ä\ÅÀO-\ÄW°‚P™1\áx3G¨\\´­\Ï\Æ\â>ŸˆH¹‘3ó*PüŠhˆMÒ¦½\æ5 Œ±–+@eËœB&Ø¸Ì ¢;óJ&.ÝŒP‰\ØK>L¸\è¨T’L<\Ð1=\àP`€N\Æ»3´\ï\Ð®;³´a\Ð»Ž YRŒ\Úf\ÉJ&\à!\Ë2e]\Ï.,`Ú½„/7ÁÑš¦1Cq\îf6P\ãp±\æ6—-¬Ï…\ÐZ‹˜‹0f+\\õÅŠ\00\'\àB|\Ì\"®\Ó;n\Ê\ç\ï\âW\ä ˜m•\rùª„\Í\Ì{EÅ‘\Ì{ó\ÕEQ²˜\\Ážˆ¬\Ðb^\ç“M&ý6?´Ê»–Fº`\Ä\Ùrª\0\Ù\Ç\Ä\"\0‚¦>†f crMq\ržG\"nü÷ˆ\\O¤Ï£\âoQ\âÑœ\Ânw\"­A‰ÿ\0h1 ?0“_70\ä÷žþfdº3iº©\é\ZWM\Ùhž\Â>Ã <OJ3´&\ç©æ ¸‡žL\Ü$7yKòaP{U¾!\r\à\Â\Ì;‰\î\Ù. eø„¥M\Â„\Îbas\Ùb\é\Û\Í1 ûÁÀ\àWý/±\Ç\ÞQj\0s1¡TPq‹\â+¼O“\é\Þ%ý\Ì\ï/‹=ªg\É\î\æwù?’úY›®\Æ{¬l|‘=Ž(0ƒL\ß\Ü!ÓµwiÇ–ð\éý\Æ.ù€\ÙD¿úc¼ô„÷d\"öˆA\îCŒ,#	¡Ä¯¼P*+\âjn™\Ï\Ú*:_\ç=?œþQ\Óø6…›p³\Ç\Äþ¨\î„\î—ö0Us\Äþ\\ú~g0¼\Õ_\á²}@ñ\Ûò˜ýzÔ¯ú~Žv\è,Lb•\ÅÀW\ï- 2\ác`C(M‹ñ\n)B+\Ä0ÿ\0\Ð?œ~S\çô|JÞ›Š\ï\Ïÿ\01ñ4£\r\\.n§ÿ\Ä\0@\0\0\0!1A \"2Qa0q#3@BRb‘4Cr¡$S‚±cÁ\ÑñP’\áÿ\Ú\0\0?/µ»\ï½C\Ç	Eœ	.™Ü¿ËŒš\îX\éš\Í,µ=<ä“¹;$^\ä]Š*\í’\Ó}‹‘ð\Æ\ì…E}É¸tˆº›¶(7-<œ!\Ö\ã\Ø\ï)^\äbºš.J“lj\Ý\Ç;>#¸\áS\Ø\Ð\íÈ¤®9Áô¤\Òô¬)øY%6Pð§vU•\äx¿nv,i4šÉšel\è\ÏL‰ùŸwI\á\Ê\Ý\Åóqdø\Ê(\Û4Id²Hm\Ëb=ž™j½È§b4®J\Ñ\àsnZ·³É¨(\'}È¿BI\ëD*\n¤µlN<¢5 ¥Á*\Ñc­µ®=7Ù”ª\éw;[ô5LŠý\Çfh§GVŒxB¬I$Q…¿\ìVQŒ\ítn]—‘y‘vn\\&\Æ\È\Ô_\å>ÿ\0L–R\Ê*\äÍ‘)\ß+—5\n\é\Ý§\Ú2«…´\Ä\×!&Ä’ž\äñ^)Êœw\'N[\n”uØž\ÓØƒ\×Eß’I\Å\î$\í{\\V\\\ÓJV³B”U\×C\\Pª¡N?¸Œ£nIn\Ø\âq\ÐzGL³\îØ°‹{z|‹—,X\Û\æK)$\Æ\"ö¾M\éF¦Ç•#V/”xÙ–d\"™:‘†\ÑØ©OM\ÜJTT\ïv[^\Çi?R>}DeFoÜ•Y)Z\Ö\"”¥\ã#N.:b\îT\í©»4.\ÎO\ÅrXzSü;Ÿgþ¢1p\æj+§(š©>\×BÄ•\Ù\Úl*¶/	\ZIC»\á/–„hKwlò\ÜQ÷6ù/sŒ\Ú\ïð!ó\ÜÝ‘…£vUª¥²E:R›$´»1\Ø\èiV\"\ìv“h»\È~³\ÚHœtý\nues]I\ËQW±\ív$¤¶Œ\È%Ô»}©K\ÅJNBS7\ËVÖ¶[\í%\Âl´´j¶\Ùi-Ü¸´å±¥3²9\Z_¡b)ð?&\ï¾û›d‡šDavTQŽi\îr\Æ\\Œu\ãyØ­4\ÛY}¢”h$–ä›–\ì§\î?6P—CÀ¥¹\'vXµ²\Ýtª8Š¤\Ù\Órq\ÒRª¡\nO´«º\ä7\n–‘I\Êÿ\0wÿ\0%YWRñÁu\ÖD\ë(ð·#)7»¬h5S\Ñm§)¿\n=<òP\ÅN…\Ò\\“\Å9SÑ¤\ÔjYXi¬\ìY–—¡º\èk.x‡©Š,w¾\åÐ¡)+¬žo¿µ„_8\Ù‘WcVyò\Í\Øv„lFN7¶V\Ê\Û’„LŸ9S[’ó–¥w\É\Úû\Zý…U§Ð«7¥3[{”:Ä½¥rU¸#\nŒ•;\"›p©\rú˜\Ç\ã/bWð¡öö¾ÇŽKôž¢”k5G†‹¢»\Ú75¨-£f9_|ôÛ‘‘“DgÈžžwD¡µãž¦j—©ªF§\è)š\Î\Ñ\Z\í\èY	I]\\\Ó\îZ&\Å\Ò\î\ß\äE\Ê<5\á\"ú²Òœ‰m°\à$h¸\á\à)þ\"1ñ–j¬&\Ñ\Ë%™aB=KE^°}’¨B.O\Â*n_R6Ý‰i‚\ÞD«9lB“D(¯Õ¸\ä¡Q[‚µW}—\"Œ&vq¿[‰jf¢œ¦£\Ôi\Æ~4F\nu,•‘Z–‰Z\é\Ñ>v\ã¹Ji\ì\Å-#”f²ÙŽ9\î_Ø¼i÷~‡Ýšcû‡\ê\r&™i½¶,X¶v-nõ:nl—†ñ°–j7‰§aš\Ú]\ËØ•\çŽ‰¦\Êó\Õ\"”©Ø“ñ²¤#\Ù\ÆJ\â–Ã³B\Ô\Çz\Z%:V#N§e£Q?g+ö„üÚµý\ÊF˜Zó{—W\ÙªSr—©(\ÚþÄ­-$¬\ì7(¾’ªø’k\'\Ê>û\ØNÛ¢M\Í\î(\ÏÐ•\ï¹TŸ–\r…u\Í9d‹	n+I\Ü\äb¹\ÈÑ¾ZMd\Í6,\ËH\Ü\Õ+[¦{\ä‘|¶/\×%’-—h\íbý\ËŒ™\ÙFb§³#\"D]‹u;Ii\ÒFœš¹qT±¯k©\î]­\îMÊ¢\à¢\é\é\Ñ\"p\ìÝºB‹ô5B¤§‰ö*VL•O))>MVC‡‡TY\Òþc¶™88I\Å\å*’•®òÀ|B¢\Ö\Æ?\âTªB\Ð.\"\å\Ä\×D6š÷\"\ÍKª7EÔ—¹\Ã\Ü~Ù¤ýG­uŸR\ËÐ’ŸC\Ç\èi—\í\Z— \Óò\à»\ÊÅ–O(ò2#yX¶W\É{¢‚ð\ÊO|\à—¨\írž÷4+Ý“nö\Ê\Âô!M_vS„%{ûº›ðU´k_ô²ti´š*R²ºG¦J:ˆR¨ö\àû=¹d’¹\Ù\Óxg/cG…2^NW\èJ0¿˜n\ï5l’rvJ\ä¡(\í%ca\rw.Å¸Õ…$\Ö\å²\à\ÔÈ±Ç¬NÑ¬½N\Ò~§m!T”´’v\ÚQ³\Ê\ã\Ê\Ù\\¹bù®Is’\î[7g“\Ê\Â:”¼\Ì\æDb\æ\Øödc®#O­\Ë\î¸%©•(©û\"ø}+\rZ~Í•/¬F¼—\éC«Qò\ÎdŠ«Jž\ÏfCWg\È\ï\èBNœ\îN­:’\Ô\Ñ(\ÏMiÿ\0b½8Â«Q½„\ìP©Cµ‹©£\â5°óp\ì`•Šue	]¬\ç+\Ërµn\Ñ/\nV\î,™Ž)u\"¤öH·Fv/E\î!nˆÉ§rZg¿ScA£nE)Ó–Ã¨\æ\îþGóŒnR\ÄFq\Ñ\Èù\î[»{I2n\î\å¢(ÁŽž’\Ï$÷0ñS›¹OÁVj\åK9˜Y\éÖ˜\éÞ—iõˆz\r\Ë\ÔJz.*\ÍyMr\Ó\èI_nI\ÂN7ô\éj‹\Ýt4^#Ùš\êZÛ‘mGqÈ‡Ži>¥L-HJÖ¹ˆ¯¬’+\Ë’pÝ•%ªWµ…\"ù(·Á(\Ê<÷iU„bÔ¢6®\ìu$\"5g\rm»Ši\ì\ÎÃ¸\ÖWM\×&º~ƒ\Ð\Í+\×;Š7-“6\Êù[.Ë”\ÜwÕ’%•ªJ\çiN]4—·;Ÿv\ËY;2	«ŒNÈ…IÇ†GK•ý‰AôDuð\Ó%p&ô¤Ø¡k	I_©P¯gº%©K\áš-;_\èv²QÓ¥2+\ÃÀ\Öì§´“h\Ê\ÏØ<%\í\Â1ÁB>Id\Þ\Å<E8Gjj\åZ®r½¬]–k:©\Ï\Í;4h\Í~¢´©\ÊW„l!‘¬\áÁO\ÚC_h…h\Ëq\Ù\ËbÇ±{lÇ–Æ±IÐ•%\ìö\ÎV°“±fh›\ÝD·r\äZ\ë—B\Ù<5HEJ|Ø±}„\Æö œ¸F”liô%crþ‰’VD,\ähzˆ¦Ý®Zpõ±\ÚJû§Q\ÇT‡´ú3\Ën¤\ä´ŸŒ¬FJp°\ÓrŠ—÷\Zpvrú1\Å\Û\Ì[r*\ÌZ‘i\"“Ã¸}\äw0‘Â¶\Ô\Õ\ÌU(Â«\Ñ}%:5*_Ln7\'\áô7³\'\'.r°“oc°¨ùØƒ§¦pLð7\à‰%nr\Ã\ÂR•µYšQ¥4£;\çrV{¢\êqµ·\Ê\Ù,›“\ä£\n.ú\ä\Çk\æ®:vW¹\nÒ†ÉŽZ·ýÛ—\Ø\ß)T“V¿s®T\å\à‰ˆ£\Ù4:SÓ©pj;Ft\É³5\\ò1Mn\Å-õ!\Ôu\"ESlr“ZS!NN\é²2Qvd¥\áò”\áÃ‚ŒT*J\n\ê›.\ç,žŸFi—\"Ž\"Ü•°š´RúÁS¾š\Î\Ìûc\â…O\îbñ=²µ¸0˜z“©N¢\ã‚S”¤\Û\ç&mÙªO©ir\Íú2j]Y\Ê^Uqª\æ\èë¹¯\Ø\Ùðvv^o\à‹]Nu,öE‹e±¶W\Ë{n*›Z\Ã\î](ð_¸‡é¾¡zY\n²Œ®‰U”\Þ\å\nÎ›ö+*m\Þ+6Ô¹#\ác\äD\ÑX‰‹„_‰\\—Š^\nl\n\é\ï±\Ø\Î.úEâ”‚\Òæ†õ\\ô±OÁ^Q*\ÓM\Ø\Õ\"ž1F	X§ñ,E5iD\Äb\çUŽµfºØg\Ùrõ«VQg\\¡K_\ê;;róLL]¤G´\Ñ\ÚR\ÒõQújvwe=\Û\í%Mkj/bœ0Ö»â¼¨\ÕR[\Æ$¡S–Ž‚9%\r=I,”\Ú.˜\Ó4›£kd†9^6\ï\ìX±d‹¡E\Í\Ú$ \á+<\î®_r\ï.D‡¯\Ô1q“Ž\Â(RI;&IT_ ¡%ª\ÍØ«GTo\ZŸÁN•J‰6\Ø\èv[ò‰\èUo\ê4¬)2·L“ð“\Úb³da·C·‹zgK\ÄON¥\å\ÙbPt=H.\ÒV”4û\Ø\ÅP§JŸòJ\ç.£¾h\á‹b§\rÕ¸\ë6¬\ÍB¿BÌƒŠ–\ã”?LHÎ¢‹½e•™Ô½òf\Å\Ío¸óI¾„\ídX·È³7[£~¹ô\î\ÚI\\Œ5Ž*;2ñ5	]0\îµX\Ó[\\\Ã\Âx,R§>%\Ô\Å\àu§8KCðúñŠžÒ°ðØ¨¥(Áÿ\0r;mQ\Ê,­Fû)M•)N2-3MNKjC^´n®t\ånN\Öqw©Iµü¨ðj\Õ8;´?L[14ªVŒœbþ…\n’ü;Ø¯AÒ—7BŒ­{wXžTû7\æf˜¿,©ôBj\ëP\çƒÓ´w÷\Ø\Ýõ#‡º½Í¡\æ\"Ôžì®©½:Y%¾\Å\ã\Ó+\Êù]-\ì¯F­H§-7$\îù§k¼œ,¯šR“²C‹\\å§©º;Ç¢#§¨²E\ì5\Õ“E\ì\î‡y1$2\î\ÊU%NjH«‰”\ê©H‡\Åe\ZzI|GU-7ä¡‰‹†—2t\é¸\ï¸\åF\n\Ëc\év’\é-™\Û>,F[nOt7±m\ÉS•øŠ‘*\Ò\ÓÀ\å)=3V0Ñ„v\'I\éðrbcI\ëði©q\ÊO‘\Ê\\1÷”[;9/B5%‘}\Í\Z•\ÎÁù£¹\Zt­v‡¥±´¼­–“Ý±F\ìZÖ»fŸ”¦­/n;9=c=Ÿh¾…X(\î¸|\Z]‡\Z^\Þã™l¯>.lj§§_¢§\Ë4›½³„\Ü8&\å-\ÞNNBg%³°ŸBJ\äX˜·‘e\ÊcwyAÚ‘\×rvf»t.\Ñ\nž\ã\ÅUÒ£©ØŽ*pc¯)J\ì•xµÁJ¦û•*ø¶#;\Ç\'\É8¢U¥B+³­bŸ\Ågú¢OJd\'RV´‘<UZ0ý\ßCZ¬\æ\ä\â\Õ\Åt\îT”¥\ßT\êZö!úŠqñlWV~SuÁ\nµ¡\Çœ\Þ÷#\Ûq¥Í‡I¿6\Å*\Ú\çcN\×rN+û\Ém¬i\ÓÏ¡k•÷géµ‰R\éos³{7\Î\åŸA\ÅÇ‘\ßJ²-5\Ê4?CH ýM>ä¼¼\r-dB\Z•\î7–šj<\î!µ÷\î+‹\Ü\Ù1w,3ZÒ’-vhH‘´ C›\×SE7\Ô\Ñ6Lxz,\Êpš[¢H\êC\ÊW\Ã\à$¼.\Äp´\à¯\Z…L?i-¬³\â¡m;\ÇÖ¦­8Ê•ªÐ¾Ÿ	+m”]™7w{;±‡º*\âc/\ÒF¤¢ö%Vr4I”\åÙ½÷<.NVú\"•®\ì8o»ó\É9\Ê×Œ_º;N¾†´+-ýÞ\Ñ+­(Ô¸ö\Zõ\ä\Òù\êXŒ)Á]sÐ•7)nŸ#ƒ¶”\ÇF7¿¹*~\àQÙ¶(]\nK“Lôu\ZVÿ\0\ï.y-¦\"Œ\\w¶v\Í\èÓ°“|h½ÆŠv\êUq\Ú\Åó\ÜWb\ÃÕ’ò2†rn/c\ì|n?¤\\\Ù\Ä\ì¤×„’³#%qöCn•9¥»%95g”7‰_\á0š½7f}“J´õ/sü>v¼*‘X\Ú\ÔN«\ÃL’F*…HSI\ìŒ|Zg±R*m\Ó)BŒ¥iðý–\êWC\îiy\"\æ¯R\ÎVT,¬­\èj½•\Ç+G\ä¨Ô’W\êiÀ\Ö×¸\ê=;\Z\ï\î®6\å\ì9t\Ûq58\ìø¢þ£”T¶ô°«½6~¥\ãÓ’ÿ\0ÙŠI\ÜV—?Àü©{‹“ö\'»t\ètK¡R\×\à©k\ìS\Ó)x¸+8\ßÁÀ¸\ãƒJ\åò¶|n]±œ‘¡Qô$¬\ì\Ë#I»’Ž\å*ý›\Ýþ%ECƒ\í\ÐsŒ¢ŠX¤«Ô¿R­»y[‚5\\$\îT”d\Ó$­#\Ä5rœ-r‘	KIoˆÐ‡\î\Ä\å/ ,M¿CD+Aþ»\ã&º2Ti\ï\Ú@\ÇÆœe\à-&¯\èx\êY\"¢¨¶žvË¶û»X°¶5\\P•÷0\ÐñnIOE‘À\æ‰K›ð^J+\Üs\Ú\Äy›óÁ®\î\ä•\ß7\Þ\Å\ì9;&­7õ5\Z\È\Ë\Üß‘\Ûc‘O{X©¦\Éuf\äRm\ÜN\×E\íû\\w¹7½‹F\Êutt9‘-º—-¨Q\Ó%\ÐjÔµ{Ý¶!”üÄ’Øœ\Úû‘Œ{2ñ„\âÙˆ”eQ8¢´\ÇkN\é\ìiw)ùy4©‹D^\Å/ˆa\êÇ’¦…]\×>£jeª%B¡JŽž	\ß\Ô\ÇA\Û\ÅUÐ­ Œœ]\ÐôTWs\Ü\Ñ\ÜB¹N:§ba\Ò\Þ\ÝE\Êð—’º\Øs¿KI¨“W%·\Ô\í-\ÓcR\ß\Ð\ãuÁ«\Ônö\à]K\î^ýE\â|“‹Kr\î\ç$¶eò§WJf¤Aõ¬xm\Î\åö!¨ß©k\ÜÕµ‡Á\r¢ÈŠ)Eq–\ä¡(ù•ÄˆY4\×%V\ÛW%UöV*Cî†C\ÌO”I\ZE9Gk—\Þ7+\Æ‹D\ì\ê1H×§‚ú½†¤B\r@m§®\å S©\ÙNqœ7>\Û(KÁrŒöš#\n57‹\Ü\ÃÎ­=¤®½Jó¥5Í™]Õš”Sº4¶\ì4“³\ZY9_4\Í\r[ß¡†¥¥6ÿ\0‚\Ò\ê\Î	ýF¬ü\ßÉ»V\Z¼¹9c‡;\êFc\çƒÜ\Ðzÿ\0G\Üq\Ó\Æ\æ¶Õ˜ö!+2¬/OQ%f²à¹«cWúŠKw\è…wk’Ó·&ˆ\Ûi)¤I«Y¶\"\â \Æ[b\ì\Ô\ÛZŠ\Î\ãpPÛ’\å\æ\ÊT\êUô+©%¥ˆh˜—(yJ\Z©œ\Â\âG»\à©m[<¢j õCbC\Ë\Z\Óñº&\Ío„0õŸ%,W’£0ý´6—‰û)m%cNƒ“Å«~I$º’ƒK++\n\×\Üq±NšE(xg·ÿ\0¡þ›1Ù³þI»\Ü\Ôøbò\Øl\æ\ès½®=®Y“V·\Ð\éqOkß µiñõOÿ\0\Ñ3Ð…\Ü-r¼R¶\Ý«\"¡\î5¥}‹ð½\ÅÁ¹m]GGƒL\ç\É5ilmcôŸ U!\Ù\ØZ-J\åöD`\ç;\"©½%·Hµ¶q±MU‚¼Jµœ£fˆŒOq®	p²¢Ö’P\Ó9XŒ\ÜaºØ—7%-F‡l´K³%qñ—\Ûggª‹±F\ßU2¥,,®\âôŠ‚¼j˜:õ4\ï$V\ÅRktIÔV\ãŠÑ–¤\ÙQZL\×+V#\r\\w4\íÉ‡¥or£ý\'išŸ«±©&¥~\ì\Éî‹‰Û©{\\\Û\Ð_Cm\'…–GŒôô#·bj\Ü¥ýr\Â\Úó¿\í+6\ß\ÐôøMBŠ\Ê2\å\Z…3´\Ø\×\à\à\á¯kŽ”yL«\ÙXÀhñ&U¤£Uú\ët˜›¹¨Œ¬\î}¦WC©9\ËÂŠ‘­£\Ä!‹‘OMŠ¶²¶T4\é+xwF¸ºc§-7[‘\äž\Â{p;®J^F1ñ•:Ÿ¦¤HÓ¥¼l¬<-%¶‘aiqb–šõ*\Ó\ì\í¿„©Zü*\æ&sœ|£‹j\éd9-\Þ\ä|f9;\îRZ·\"\åaôC¼Š{{!µ¿¿$¥nP´¾¯.\Í.X”U¶\à\ïurzR]K®ƒ‘s’.ûe\Ý\ÚO*.Òˆü\Ì\äú\ä¶‹\êM4ýÅºllShS¶ý\ê\ZØŒdJ2Q\äq\Ú\è\ÃSvn\Åkº›²s½5J”#N÷\Üð\Û\Ü\Óu²#…R‡ÿ\0c\Ã×¦®·EY\ÎJ\ÌYu/²%\Â\Ë\é\'¥\Æ\Ö*EÅ²•}1Ü©mwDúQ\ÅÌ¦ö±,\ëa±Z­¯b\Ø\ÚnÖ¹öû+Ne<U6Pœe\Ã+SƒWeYÁmš&\Ó\Ô9\Ê-\Ä\Ó9½\ÓL\ïq\ËW$a(¢\ïþýNe\èNj(m5}[›\ÊÛŠÛ«’ð\ìk·½\Í]b‰¸\Úñ\ë\Ê™º\ÍÅ¿SV\Ëû\nV\ç(/¸›68)\ÔO¡gl\ïc´»8{•\nI\ÉXY\ÂZYSL¤œ’U#\ÂC… \Íµ\ìP»v\Óq7´´G(r™‰•ÒºµÅ“G\èC\àL¡¤Išqó¨\Þ7À¥±µˆÃ¸\Øòûm\Ã}™CNOKeZªÇ„*œ¸º0ú/\áÙ•!9Cy\'\nd\çR|+\"¼t\Ô(\â{7Á®tü*æˆ©rR§\'\íÁi[q?/ÐºÕ¸¶\äù{y%h¡x‘o{¾—QE\ZM\Óòem“\î.;\äys”7þ\á¸\ß%\Ë\íš)\Æò±4Föä£ª\r³mRŸ)”?Uˆ¥\Õ\Z]ZºWLWš4\âS¥\Ø\ÃnO3ß’QšØ­Ÿ—HóK\î÷%²G\Ã\ß@¾¥N­+\èEýG	D\Ýed\ÐÕ˜ò«	Sk]?\äÓ†¨½\éT’{õ(\Ëuª\ê9F\Ñe\\;“\çqÒœy¨b!g¨…:O’t\Ý7³Øµ\ÚV!EYY’w‘4øÉ½\Ë\íõ\Êû[û÷³\";ý—©fMG˜ÿ\0(w\Ø[½\Ïô\Ú8\Í2\\÷H¾\ä\'~¿ýdö\Ê,\ã+XŽÓ¸¼LoLˆN\ÃI]§·¡%\Ò÷+¨Â”QN§cú³FSž©rMµR\Ì\Ã\Â÷lr§%fWð\Æ\ÒW¨Î™kn’+~\Z#â‰…~3Ž„œ½	j‘k\Çr\Ä\â¬Y¢Ÿ$²¨«´”‘[±’\Ýi‘N“”|5\nnµ?2¹Bp™(­%kGr¥W9q±‰\×(pHW\Ú\äe	El^1\ëü’\×\ÉN\ì\è8\Ü\éb\çMŽy<&¦)p_À\ÑÁoBö/\í“/•û\è¿Bû\r\Ýfø…»eŠ~¤U´™¥Á‘†½\Ò\'\ZŠ\Ä~ö+WBŽ\ïTˆ\ÅE“zª²ú#u#\ÇR­âš½¿ô<®º‹\ÈRÁºôF­9=¸0­Dø \ï)XwW.6M\ÛsR¾Ã§6v2;!W\Äa×‰]\"Xª5l\ÜEBœ•\á+­	Y\îRj÷q±«\Ã\ÉRõ_±¢*·Q4¸)¸)­Kb¤p\ÕxØ8\Â)tE•ø³\'ö5lu$†²k\Ü\ÒýK/R\ÍÓ¨\Ùq\Û+—ùK;\ç\ÐB,õÔ¸*M\êN\Å)BªÜƒT_±*ZÞ²œe¬+›¶\ÊtoQ\Ì^iH´z½\ÌK–‹5üŒD‘OðÙ¯¢šOƒVœ\Ö÷!¥\ÚQ1“Ð”‘Fª«H¤\íRd§K‘œ»–™#NÄ\âýMt\ê+1\á\Õ9ñ±\ØmzR5Oõ#\r$J\Z¢NžŽ\nWÐ½\Ö\Üä¥¦0\àR”¯ÿ\0¬§¥\îI4ò¾Æ‹û„o¹§Io¨ö8f«ô¹%}òi\åüw-ó\Óo¡\rˆI&ˆQŒ®\Ð\ïJ¥ú\n¥\âö0\ÓObJ6¹úFö°ü4\ì6’ú/;Í•›Œw\Ý2q‹|‰5\É\Ã)µ¤‹û‚‚r{‘Z\'\ìU£Nt\ÈU\ìCµó?Qk½\ËøFF/U\ÎÉ¸\Z\åÅ†Ù©”\â¥?2\í=þãƒ‡Š¥/©N(\ßIY“ñ¿b~‘<dü1²5Y	ÿ\0ú%\Ë:6vnK“D—CO©cR;Bùm\èhc\à±\ÆV\É!#³f’ÛŠ\Ò[\ä¢<‘*3ä ¦ü¦%_\Ï2šð\Ýxy˜÷‰úHFó*H«v´¢”4\ÒHvtš*\Â\Ò¶´‰\Æ\ÜpPò²	ö-Š´Œ$\ã%i\Ú §\rHp”\á´Hj¾™!\ÚÃ–\å4¥\à¨\É\Ô5›£5~=I\ÆU\Ï/t;Kx”\'Ñ‹‚¼nJ)\"|’V’+qq\ËbŒž”\Óú’³wE\ï±m\ìjR|d®HyýÑš²\ä³\Ë@£¹ ;$[\Ô~‰\n+sH\â8%»è€›±‡­=0ñ\Äû¬E2…8«\ÂE:z±5°\æ\'h¶j½\äBž\×yv±\Õ4be\âV\èSÓ·B’Žö)ÿ\0–Ÿò)ª\Æ(\íõGI9½603Œc¹‹©Fu`×®\æ*T<.õ%fŠ\'\Ã^\Ò>!ø\ìieu8\é‘	J„\ìü½\r™8\é•\ÑJ\Òú‘\àªL¸šØ”vD£o¡\Ç\èvŒ\\·r\â{}øeòyX±¤\Òt\ä¶\åˆÁ[ƒA¤\Ò8l\Ø\Ð\Ð\×~š\êR[\ìTQ}-\"0\×Kc³4\ß|™5y\'ecE\ì‹1t\Ü^¢i®HðI\\¡\ÉA}\Ô\ãõ!‚r•®Rø\\t\ï-\Î\ÊÓ”}kö-¦„\îJ2#\rŠQ±‚­\ÙÉ˜\É\ê¨\Ø\înU¤\ïxÄ´H¤\åOipL§\É\á*’$®Ê«©;ÿ\0r\Ë\ÔpY)[ \Ùq«fÄ‹…\Í\èi4Š\Å!D°\âI¹aÄ·yI&a\ã9nIFjÒ¹Jô›\Øì—™ŽÆ’Æ’P»64šLTWf\ÊþTD‘EøŒ’fQ¡-W1X\Å+:gm+\Üx‡\è,\\ôZÃ›’4\n„·*\î†\\Œ•‰¨\É{‘’{2^\ìS¨ˆTV+U\ä”\ç\è}\ë\êJ\ë#–\Ð\Éq•“4­7-\îmoRû½‹\ØØ°£r1#š…Dt\Ì\Ò%\Ó,I!Ä¶v&·\ïB\×\à\Ã\ÆR{mb\Êw]M]\ãÉ‡›‹\Ñ!f\ËoÜ«Qeud\Ñ	<\æŠŠ\ÝH\Ò\Úó\à©ög\r\îa©º•t\Ú\ã\ÂÁJ\Î#Ž—n\ä¹\"‰^\Ã\Z ô±\Ê\Äõr\Ô\äˆSñrR„t•¢®5”\ÈùšþI/A\ß\Ð\Ú\ã²Ò½J’\â(ö?ú,-ù,´ðiM\n$l‘²D%¹.DiFÈ¹:–\'ˆ\"v\èvó\êv§iqýH\ÊùJ7\îõ)CÔ¥U\Ó{¤g4\×\'ŠMÿ\0q\ÅI&/“Œ‹L\"‡œÁ»9“­³‰i(Utª\ë\'Š\ífŸe]>\ã[‘D\Þ\Ã7%Ok‘\ÞB{2<”¸+òK)ùX\à\Þë §û‰\Û\Ô}G\ÌR[ŸF.T®æ‘¡\ßÐœUö\É4v©u%ˆ}\ÛL§\\uw\Ø\Ô9u*M•^í—f\æ™>†ƒC-ae5\ÜW!\Òó±FöWc¤\ïx”jkðÏ’>§\Ê\Ç-‘E9‡óHkvX±l·7.Ë \Ý\Öt\ík\Â\í•TS)pW\ä\Énaö{ñ\Ã14\Êý\ÃzY}™©i\Òr;\Þ\Ö\"\Çs	\çW\î\ÖZ\ÇRÆ¦x„\îFú’,b*u&;D-K¢5\É~“µ]P­Ð²#°\É\Çl\ìB7Ž\Þ›ôþ\å)ô‘R–\×\\”\äø—\Ê\ÆùDH§\æ)y˜\Ö\ì±bÅ&“I¤\Ò[bÅ‹\Ú1‘¥5s¡.òR+’•Ù‡ð\Öið\Ñ[o$¶ô*Òœ/\ÕZ\è¶WöF§k˜8x5zšLDu=‰z\nŠ;T\ã\ÔÔ½\"E²P±6MŠ\Z¹\è•ý§RR´?\á\ía=2º~\ä\ÕHy­\ÐYt9C\ç:h?R0¥%d\Åu´•\ÑK£º#¿O•Œòd9!É \äÑ‹¢©\×ipó±bÅ‹\ÍÄ¯M¢‹¼É­ˆŠ\ä†D§\Õ*-‘‹^\ãb~\\º\çÐ£4\à½U|Ì±w¾žœ·Á9G}\å?ý³ý¨„\å7mšS~\ä.ŠKlŠ\ÄüÄ–\âR“Q\Ò\ä(Ñ£N¥-KSºn\âXxSµ¯º\çsv\Ê\Õc(¨E\'dB\×8“ó\n.NÃŒa·,QRŠ¶Ì‹ºÝ¢Ú¼^\å	\ÉKMDNžJsR_+øbHr`Z\ÑcC\\5.VX:Js»\nmZ\Æ\'\éOncKô,XhyGi\ÉZr—”%\"¹,¢EpÊ†&?t\å\èb!kõ\"¶C:\ä—/*úeQž…e\Ë!zÒ5´LMG÷Q\á«ý\×t\Ý\é¥m\ß?û(;\âc9K­\Û1\r?vF/W±FD±Q)“€­m\â^?°V¿A\ï\Ôðú‰Q*«H¥Á8\îGk¯FF*\ÞÌ§)S\ä´*\"\ÞÕ¶ùX¯\Ãb\Ê”\â\å$‘BðŽð6h­5§s\0üV=Jšmš–‰¥\Ô\ì\á¦\ÍF\ÞRx*2^…z2¥;1¢\ÃV¨L¦\ïð.JEn	e—:¡$b!\Ù\ê¹I$>“D¥+$i”v”N$Pü8\å(‚s»%\no”=qò\Éÿ\0sDb.+”h>¥(’‰2£Ü‘*g\Õ\Z`hˆ£\ì(¿CA%’+-®PKIP‰õD£jQqý·)\Ê3…š)M\Å\é!54[\åb?\r‹œ ad£Q\n¬}\ÚS\á=Ïˆ\ÃL\á/S‡sñjh\Å\â*\ÑZ}z|#ÿ\0iM\ê¡ \ï®\"—\Þ\Ê>Â«V8™Gw\âQ½5/A\åW\Ô\æ$|-ƒ©H­Á<¢P*-\îAlc\è)\Üt\ÜI\Çs¢\Õ/\Ô\Ê\ÐRCRŒ¬\Ì+û¿¦m‹\è‰S©\èv_RFR\Â(\î\Ë(‘,VV¹1\å\Ù\ÜT=ˆ\á\ÅF\ÝH’‘/\Ãe9mc“¬=†ôÒ‚w\Ý¤µ!\Æ1©Q§!55•_ðØ¹\Ê&ñ\"]En\ÍTùº>#\Ó\×ûLû“²Uõ¹ú»ÿ\0\Ëü´~…J±§)pP«\Ú×©%Å¬++³¾\ZGL«¯	OÈ‰¥\"·ò‰@¨¶)pb\ÑQƒ\×\í\êU_sMznT\ç¿ \î¶0\Û)±™Ø¡l¯r1ˆ\\“,J”¹)\Ôõ\"\ÓË¡\"D˜È£÷}©/\Äþ\n·U4ò¶<\Zv^„k!o›E»µ¼Œ\ë”J2\Ó8²8ŠV¼™ÿ\0O;=‰Ve¡=\ÙðÚ‰\'%(\Å+J•\ìˆi\Äa\ìú£\r†\ì\"÷\"ûHN\Æ3l+:dÈŒ\é•\"¯”–H O‚‘‹[2·”’m;Ž)ý†Ú‹÷‘¢\ê\æ\ÍQz1,X\ØrH­]ðŠ\ä£\îD”´“zŠˆ‡(“Có\ØRqdj\Ü\ÔI’ò\áýŸ¨‚\×W\ê\Ò\'7­\Ë\Üs\Õ¨”«^™I©®\ë\ïTò3õe\r\ç‰en\Îµ\Ê»=*\èR”]\Ó&»·ˆûn\"\ër¦+Z¶\ÅUJ?B©%dŒ.7²\ÚF+\Û-+Ž\ë\ä\é•\"§”˜\ÄP%ÁH\ÅðÊ«\ÂD\ÄFôbÈ¿úz~\ä§+la?YDA’d¤9•j”ù¹	\ÓH•xÅ’¯«q\×*\Ô#QG™!ÖƒýD\åq¢.Â™&<ú\Ë&_alŠ;^µ9\Z|%%-;Þ™îˆµ	û3~Œ\Ü\Ô]½?+œDJN\Ö(\ÏU5–>Zpòx\Ìt©ÊŒÕ½{¸ó¤Tò“Š‚‘Š\àŸKj§$/òðöºÊŒ-\âõ\ØBdfk‘)\Ùwe(pU\í!Â¹S_U´Ø¡_\\m-˜Ùˆ›oL–vqõ#zŠV°\ÕÆ‹—K)ù¡¡«AG¬·EÁ%¹‡}	\ÆÒ½‰«\é’)½³°\âx^Æ¥œ¸\'\çb ö0˜/K\Ë]Tž…\Â0”\ã*›¡ahþ\Ô,Ÿ„Ž\Õfµ\É.…(\é¢\ã\èað”/.¥O‡iWR+`gN\Z“¿vY2™?)1ˆ t)rbx$!rZ\Õ%Ä·D¯FW£z‰ä™¨”‰H¦µLZ¦\Û©}õ\Z\í¸\ë\Î{i³U¯–¦Rª\×$j—¿u[#IN	\Ë\Å\ÂÜ•\Ûr}I-\È=2)\Î5\"?ºº2š·Ó¸ó±¥÷\ìTüF\"\ä\Â|\ZŸ\Ù?ññÔ­7R÷‘Zn2¥n¬ÿ\0Q}þ¿©Z§cBë¡¯]û—l4Ÿ±m»’É”\ÉyIŒE\Û\Ö\æ!lK$TŽ¨©/2>\î´w.\Â:®\Ýú\n\Ïu›$É»\ìB\Ô\ã\îv«b¥YI»÷þM-¥QJö\'Nn\ì\Óc¨—\Õ[L…K÷aðê´š~ƒÀU£0øE\å½\ÌF2M\Ãm‰#M·)K\ÄVƒ•3Û§¿q÷Ÿ\Åb.A\ìC˜”\ãÿ\0Ooc‹¯sþñŸ5÷žhÿ\0¼ýq#\Ì\ÌLu\á¥bŒm‡_\í1[\á_\Ð\éÜ›5!\Î$+Au%‰§nIÖ‰\ÚDSE,B‰öºv!‰Ê•Ê”­\Ôy\"¥\'{Ç’\ÊT\ã«\Ð\Óo§rdU\ÙV·˜S”¤’Œo\êTR©¿Q_\Ô~\ìib\ê\ãBÿ\0ï¸ˆ˜-¯\"2½\ÇÁG´\Ñ÷…{v“·©\")”+\Ç\Ë&SVùxŸ\ÅbI\ì)Z\Ä>\"•+[{å”ªörL­ŽŒ=¸w*\ãa\'O\Ù\Üx\ÚZ¡¹e-s\Ü\Âb£+¦ú“\Ä\ÒIøŠøˆ}•«ô:;hzŽjÜ’\Õ\êYšM%‹b$˜¥f>s\\¬«\Î\Ü”•Ê«À\Ù96\ÈJÛ”\ç©Û«\á[Jri\Â\íuR\çØ¢­y\Î\Þ\Ñ;=\ß\â5ý‰Òö§o\äö\Ûû©\'mý…\r\É-²rð­\êCNi¾»\ÇA¶ŸðV\ÇGGƒ’\\nmcJ\Ð÷\Ô\Âbö´ÏµQý\Ç\Ú\èúŸk¤<d=±·\ÙA‘w\\wqŠ!”‹\ì\\¹~\æ\Ç\Ó7—e$ù¡q\Ýy,¢S\"c	sÜ»4j\äV·95•UzrúŽ\ä)_¡G	M=W# Ui¢¦!=‰TD\ëm\Â7,X±(XÈ²3\ì(\Åhz™©¥÷Ö·ü±º?¥\Ëù€\Ý¬”°\Çk†ý§o‡ÿ\0¶}¦—ý³\ípÿ\0¶}¯ÿ\0Œû\\¿aöŠÏˆž)\Ë\ÊBúû¸\Ï\Ä\"Q¿	¨\ÔjF£Q¨¹r\å\ÆË¼\Òð\ä\"‘LgB|÷ üV\É\å/#\Zû\Çõ(Àµ‰ó\É*²]Ib\Ýú£b–W»\Ô#®¤#\ê\É\ÏUIZm\"T•÷mŽ\âF¾\åJQ¡š4¯CO±(¿BŒe~\n7Uw\ïc¼ùH¡È¨\Êq>\É3\ìµ³T;\n‡cS\Ð\ì\êz\Z\'\èiŸ¡i\"\å\ÑÙ³C\"¼$\ÖH}\ÔR\"bü¤ù\ï_{+†J•\ìB)š*#Kc„½1’\é—Qš·\Îù`#ø•j·÷]\î8¶(;òJ¸¨ŽœN\Æz£B¤ ¥À”M1#¥>(¾ö?Î„H¤Œ½#B4Ä´»>\ì½!ºc\ìý£Ð’¸¯”\ÖÃ¬Ô¬C\ÈT\Éw²…j¸¥Zœž\Ò1~B¯˜Y]\Z£\êPõF¸~\áTR[;—Í‰ø‹n:W%†~ƒÃµ¾“Lº¢Tö.t7\ÏP\Ùq³\áV\ìq~\ÌÖ—Sµ‰\ÛF\çl®K·l\Ù\ÛJ\äq;Y•¥&ù#)zŠþ¢$ü‡‘2\å\Ë\å\å™B[”*J0\Ø\íj\Z§\êx½K2Æ“I¤\ÒJ;ó3q•WŒ¡½4TC\ÊoJ¹<l“\àûl¶\Ô>\ÛTŽ*¤¥f\ÊTa¤\í§F¬œY?ˆ×š\Þgk\Ô\Î\ÓÝ¢÷;Hz3´\ì;Xÿ\0\Û;þ2ž*\Ò\Þ^¢be\ÇÈ­\ækqTI&vË†vý.T¯\Ñ\r\î÷5\Øo\Â6¹.j.\î\\½\Ùð¹}\ì£\ë½+OŒ¤\\~$BnT†\È\ÈÕ±+2\Ée\ÇøFðó±c\â(ù\ÊQ!\"Å‹,X°\Ö\ÅM§\"\äSEe\ã0\Ñj•¢1š½y»šM(\Ó)kE8ý\Ú1K\ï\'õˆ\Ú\ã’ô.½\r_\Òkö<^‡‹ö–—\í#9[ƒZh\íwCQ*®\É\\©^\Çn\ï#µ\êkñ¯þ\ÉKr\æ®\rVdž\å\Ä\ÎD¶0“\ÑZœ½\ÌOB ØŠJ\î\ÅYX{\Ç-{£.\\\Ö\Íva	¹ñ*2Ÿœ\Ãp\ÅòZØ­ø’\É;£M\ëD\ÓÁ]l2rÒŠ\ÒnV-eaSGfŽ\Í\Z7EÁ‰Œ_{?¨‘¸£¹¤Ð²,X±\Ùø]º\ÕÓTÓµúš\ï\Ë5õ~¤\åx¡¶\'\ÉsÐ¹\Ôl\ê7¾Q‹-’õÒ‹ö*ÜŠH¹AøŠû²Q\Ú\ã¶W/’ü3ø]\Üáˆ™O\Ìaz‰,X·uðW{,¡´.EÞ¼KðW\à‘ˆ¨GLJ\ï»Cð\"cb\".~E8\êo~…Zr[Û¨Ò•ö%·v{’mŒ}\ÆòHHŒD‹N_wôÿ\0\ì›Õ7id6Dž\åË—#!K\îÙü\î;ð„Tde\âF\r\Ü]\ë{–‘«Ô”•™Yýä²§=Tîˆ¶¥tG7[K*pW•Š²\×;\î\á\ßý2úÿ\0Å„/7È£\ç$‰Q\\[ù14´föbDŽ;¶#1\Ê\Ù2›\ç\Ý¹q\Ê\Ó\ä¹<°}\äGð¤|?ðwøLER”o4a–.\í‹ek“§d\ìUó\Ë,-gNN”Š*óù¶T~[‘++{	þX\Çþ+ˆ­Ð»ð\Úiû“[\åR‚¨…Aßa\à\ï§Ô\ØqÛ\Â\Ùi,i‘cIb\Ã\"\ìk\Ú\ÏûÀÕœSrŠOù#ðúQ»FÇ\Â\ÔòM¦T£WÏŠ>¥I¹w‘Kð\ä|?ð;¸¿ÂŠ…/4~¦\Ì.\î\ÆÅ‹[3µYe_\r­*ó#Z\Û>HJø¶b\ê¨ÀyQ³–[½€Þƒ>!ø‚º|žR\Z\Ê.Æž¨qEj1}	EšM\"¦(,F%²°òd\'RŸ–V#‹\åO©Aýü-\êN*I§Á_*Rö\è\Æ[c®V!”|’>þ_»Šü)©ÁOÌŒ?™	w¦ì´X…x±«­Œ_\ã\Ï*SðýÔ±\Ä[wc]\É\é\Ñ\"¶\ïü7\ÈÏŠ«T…\Ð_\"\Â9X°‡º$Š”\Î\Ï\Ø\Ðmš‰\ÆLc\ÊB\Ë\áÔ¼S©\é²\ÊQº\à–„ú4<;\\ŸÃ¤•\ÖâŽ˜\ÉInEl\ËCG,‡þ\î\â?B*yHraŸ†$g~™¤I,¾!Œ\ìÖ”}ª¥ù0ø\ËòQ“\Òc¿\ÌO*•mIJ,\Âø§vWj”e/Q=MÉZ·ù\rò\Èø£¼Å— ¾E?.WÍŒ|;\ïX±$XI¶’\ä¡O²¦£Ü¹xú§Nj\ßû*\à,ü\ã:K\ÅP\âG\Ã\×\Ü\Ë\ëÝ­øo)ùH˜W÷qòŽ\ïØ“\ÙeñÊ»#³£%rmSŽ”b]ê¼°\ï\\•6\Î\ÅPšwð˜ªŽ´\ì¸4ôù\rýG\Äü\Â\è.ý<-I-O\ÃVi¥hI·\Ôy\ß&6K+f»¯+0˜m\\¹\îÈ±a7Ô´ðtŸ\éþ\Å?e\Ô\Ñ!\Æ^™\Ôò3«%\å„òDñ\n\å%h\"¢CW,\ÌT>þDbµ\Ø\Â\ÅÁ\í1¶Û»1?ŠòŒiªºh¨õ ´«\Éøo2>/2GD.ö=­Eô+Uue\ìE+;wSÆ—\Í\Ãaw\×5ô_&Å„…r\ì\Û\Ð\ÓK\rÁW\rWK²¹:¢\åzl~V#þ\î&¢$13Ž\ÖZ“eÊ³j;rb\\õ7\"ò¹J¦šz‰bªJ\\—¸©\Éô*¿›œ·‰‰|Ÿ†ù\ä|al…\Î]Ý§	TvŠ+ø0ö^ƒª\ïhÿ\0rM8®\ê%ó-\èP\Â\Û\Å>}>E²±a!eb\Ù\\j2\å>„©\Ò\ßB¯ÀŸúu¹-jñ\"¤(\ì*L\Ñ$N«½‹K÷\éj|‘£ú\Þ\ÛXû3õ!(\Ó\äûg±U¦öN;|¯‡?½g\Åe}Ž¹/(¸Î\n•¢¿’Ÿ\Ã`¼òl„#²±‰¦\êQœW6Ø„NË—.1ü…•:5*qÇ©NŒ)ý}{\ÌYØ±b\ß*\ã¥\Æ\Ì\Ä,U+¸ø‘öú\ã\ÆWZœ³µ©û™\n8Šœ\"¥Lä‡¨»IxE\ÉO‹|¬û\ã\â]N¹.ñ–„«\ÎËŽ¬„#¨Çƒ¦x¼6ý¤\Õ—L˜\Æ\\\Ô\\o&ûÐ„\æü(§ƒŠ\Þ{³\éò,X·Ï¿©[	\ë‚+JŠ¢ÓŽ\åIÁ\Ó%(\éL\Â\ãc\Ø\Å\×NÜ­8¸«d\Ë	ma\ÙXƒ\Ù?•„üc\âsE=j¾X%/†KýYb…8éŠ²\î<«`\á=\ã\ád£RžÓòr3a\çrý\ØR«S\Ëž\n+y»Š\ÉY,\í\Üo(þRö1˜~Ö“\Ó\É(Z©Úš#GK\ä][ebÅˆ\î4R_vG“‡Úª1»¦[r–S\ËL\Âü*0ñU\ß\ØV[/“rxJþŸ¡SWô´\ÉSª¹¦\Ë?\Úÿ\0°\ÆË£P”¥\Ä$ÿ\0‚8\\L¿E¾¤~/\×Q0”!\Òÿ\0R\åò·u¼\Òü›\É3\â8v¼qþMnT\Ñ%.¦‚\Ã\Êè‚¼Ê±\Ò\Ê\\/•O\ÏXj•ø\Ùz”>†¤¼ºŸ«ùv-•\ÍF£g\Ñ\Ziþ\Äi§û#ý\ný(\Ôj/‹w/l\ìX_“y\"\ÊQ\Ò\ÊøgM\í\å-tvK\Ôp‰Q1ÅšrT´Š/o“G^§M+Õ”pTiomO\ß\çØ±b\Ý\ë,[º\Þvü³\Í+¢i>’½\Í\ÝyK›I‘Ø²-¢\å\'¿y\'\'h«”¾R[\Í\éE,-\n\\GWùK,X·rÅ³\Õò\×\ä$\Ä2ó}Gi+3EÒ—·C´gl}©\"hVd]¤.r‡\Ã\ç-\ê;/B:tÕ¡~Jý\Ë÷v6/•Ñ¨¿y~U’~\"$Š|Q¡]?R¦)¸¶b°Ó ÷\Ý>\é\Íô\ZC\ìð\ë2ž‰Cr\Ö%7¶P„ªIF+s„§G\Þ^¿–¹¨\Ô]65\Z»Ï¸¿ \ßvgR<)ùInTVŠ5\Èö”%\ê·C\ÄLu\'\êj\È\å6Ü¦\È\ÞM%\Ë0\ØxÐ…¿WWù›|µ“\Í_9÷UXˆ“!\å1Œ¯KEY\Ç\Üh±­¹¥ô:\î/ö>†´{i-\ß›±a¯»¨_9¸²¨!pH&^\ä\Æ|Jª¥ê‡“ð\È\êJ\Æ—oR4ÿ\0¸’I%ùÖ†»\ë\'šÎ—u©—C©\å‰9$‡ÁñÞ”_£,h/r\ã>Kj•?…ùó˜û\ë\'’\É|\ç\ÏzD¼\ÙÁu\'#©“11\ÕB¢öî¾ˆ\Â\Ò\ì¨S‡¶ÿ\0žcï¬Ÿqw\ßy³¯qe3®QD‰2\"%±n„Ö™5–öð\Ü\êT…YGÀ¸\ï6j._ò\Ìy¼\Öo5óXûõ¢8D\å”E“&­#­^§\×)[@®\ìQ‚§JœE\Ýl“5\ZBy\ß%ù›\ï<\×\Ì& ˆòI’b\",\ê#\â\n\Õ\ïê²½Ñ…ñ—õ#¯vCrù¡|«w\Ùlžk+4.û\î>òÎ ˆ\äˆsÜ‘ñ5\â¦ò‰ð¸\ë\ÆC\Û~\ë$û¶,XHKó7ùŠ‚\É\äˆ÷ñH}\Ô_¾I†õgüe\Ù&_$…I¤Q-ù„‹|\çój÷#\Üf\"ŸiJqõCºv#&|\"6\Â\ß\ÖY,\ä\ÉB„¿*û–ü“ùK:\å\Üc1\Øy¬Lô\Çg¸Œ0´Wô\ßû\ä\Ä\ÆK&Q_Ë¿›u\ê:Ô—5ö¼?ý\Ä,m\Z¿\àÿ\0•¼ˆŽ>¦µ{Z\ä+Ó©)F<®\í\Ç\Þ]Ê\Ô.\ëQªI/R*ÑŠôY>ò{(;mùwògR\Õ\ä\ÉüF?¦ñµ\ß[\íu?{>Å‰|ÿ\0\ì_«û¢U¤©\Ýk»¸´\ßvkÙ­+,û\ïü^oœŸ\ÈY\Ô\î¬\ï\ÝÀ\Ã^.’÷\î>D\ÎKte‰”\çt_ó—ELT•YB6Øœ+\Ë\Ç4\Ê”\ëZ×‰IG¶Ž­–¬›Kv<Eþ¢*\áaR«I¶\Þ\å|\"TõÇ¤U\Ñ\èb°½Š‹N\èÁ»b!\Ýc\ï.\åL–q\î%\Üø,5bœ¿lryId™\Î\\žI—\É~V\ÙJ½s4K\âÿ\0J¹<ey½¾…]^	\Ý\ÞË©‚q”ž\î\æ*q…\'~¥\n“µX\ßý6\ÅRk{õ¿òaq}¯†^oý˜•|=_¦_«\ât\ß]\Ñ]^Oö\åŽña”½\Ó(»U¦ÿ\0©w_}fÉˆ]\Û/\Üø>\î´ý\í“\ÎK$Ç¹¨¨\îR¿$\ç\Õú•\ë*Q»/?,?\à¯[m5FSœô:\ÒJ\Æ%\Æ3jm\r5\Ê{ðað^+\Ôþ,U\ÃJ•xvNÚ®b¥j¶’RðXÀ\Í*o£1•cRQ\Ò\î¬aðª1\Õ\'»‰‹\ÂÆŽ—+)\ÏMHKÜš¼&½™\èFN2R\\¢2U)&º\Ä}J—–ÿ\0\'k13—Ë˜³E²L¾Igð˜iÁGÝ·\Ýc.&I\\d]™_\ä\Þ>£\ÄQJú\Ñ?ˆA/n<}oHŸo©¦I¥\ìG\ÖKõ^\ÄñŸv\Ü#{rP\ÄÆ¤.öw°–Þ£Q\ël±\èÁ¥R7\ê%\Ôôùô#´šŒT¿‚¥I\ÊÚŸð&\ï\ÉF³\íiÂ¤öŒ¶f7J¯rœI\Õq\Ã8¯\Õ2‘ýJ[Ò‡ûLzÿ\0§U”wŠ÷G~\Åt¼5\ÚkþO‡V\Ù\ÒÁSi\Í{²\r<ÿ\0±\åEÞœ²\î>\åûÌ˜³Eó¶w\Ë	8Z+úo9eq2q\ë”d)\n]\ÌF7³–˜¤Ï¶¾\ÏWf\Óÿ\0ƒ\í\Õ÷\Ü\í+T\êØ£6ü)4÷F–\ïdh”#úða¨Ò«¿Ô©ƒ¦¥ø–Vÿ\0’”i:3§N[\Ûs‡¨\ï«EJ\åkö54óa\Îo™2–®\Î:Ý‰¯\ÃT`tº\í[g	Ó¬œ_7>N¬µnc0•&\áô!„®\Úû·cEF4t¯b¾Ô­ýf\Ë/©†w\Ã\Óú\ßò\Õ2 þ\êŸûQWñj/\êe*]¶®©»\ê:u#?Fb\ãj\Ï\Ò^$aªSX\'®\Ýv\Ëï‡¥ôO¼»¬˜³¾Iw¬%d—¶lY1\äžU!b,¸˜žRò¿ \îS\Â\â]º.w(\Âzdª\Æ<• »hÁ+j^&R£Nœ|=LCÂ«ê¶»\×\Äo\îP¡:Òµü+©CN‹º½\ÌzûÕ¿\è0µv½c•®¬IYµ\îa\èSú_pŸ¤Œ\Ú\ÄRG\ÄW†œý‰\âeN§ƒfº\â¶\ï\ÛH£ñlT‰\ë^\äñq\Ä\á\Ô\é»J/t8k¡[}ô\ê0\ÞY/ò\ÑþLS\Ù\ê\ÝôH/\Ô‹N4cGt¹!^Ue\'/1ð·à¨¿¨ø¬	\Ýq>Þ¦\Þ.#	\'¦´lýJ5¥¯³¥m|ûI-‡”¾[\'\ÜBY\\±l\ï“\î_&‡’g(š\Ò\Ë\åž\"žŠ•7ý\\}L\æ\Ôõ]ûˆ©)j\äöez4\ßô˜\ålC÷HÀ¯¼œxð˜zn=/›²7Ò¯\Éñ%\á§\"„ô×ƒþ¬ñqÓˆŸ¾\æüºß†\Ìto†¨R–š\Ð\ÔM-º¾Ä\Ûe:j÷D©\Ê“‹Ø¡(.\ÓT’N›D*8-¶bc*\"sœŸŠMŒ„\\\ç¦•\ßQÐ	¸\ëR~§Â§UU\Ìvb(5\ÕnŠ´œ7\é–ð\Òw\Ó0õ;JJ{o\è<¥òVR\'\Çq\É!,¯\Üy¾\ã\Í2kR8e\È<þ\"£\à–\ßS\áÓ½\'F#´×©õ0NøxûðÔ§/c/ú˜\ï•W=>»1Ñ¾\Z^\Û\åM\ê„e\êˆ+#\â1û\È?\é>þ\êKúŒmj4\è\ÍN\\­ˆ\ÉjŒŽQQi©8ú6|&«Ðœ&·‹\ç\êbh:3p{®ŸBV\Ôôðrù#MÍ¨£\ìÞ²1¸zt=?­\'\ÜM®ð·ˆž*:f\ì¼\Å…ª““R²}\n´û:³‡\ív\ËŒ«†•\âö\êŒ66†%x^þ™K¸ûò\'\Çv\ÂY\\¾v\ï5ò&®pEyca®ƒþÏ‡N\ÕeU–:+¶w\ëe	Gßƒ\â1½¿FR«\Ù\Î/\ß:‹T%To{ž¬:þ—b\'\ÄvT\ß\ÕŠˆT”ñUn\ïiYg\Ð\Å\ÎKM¦\Õ\ìWÚ«÷>[³Å¨ôž\Ç\Åkk“öð˜\\\r|FñV^¬Á|=Â­\ç\Ú\æÃŽ‡û¬T¡†“\Þ*\çÆ¶­J+Ê¡±C±\í¡\Ú\ßE÷;?ƒ%\åOûŽ—\Âß–„ÿ\0¹^Ž\í\nN?\Í\Ì7\ÚhÁªPvú©ñ\n\Ë\ÂÝ¿±¥Rw¯–®A^I!(JÌ„\å¥fŒ\ÅT\í\nû?\Ü;[ä¬¤Tã¸»«\ä4\Ëü†I\\‹)²i¦Q½,D¦vy|E~¿ƒQý¡\ßõ#Xz‹\ØØ¡=ti\Ë\Û<O\Ýb*\Ù\Ûý˜OˆR\Ã\ëN\î\çø\Ý?ûL©Š£‹Ã½\Ç{¬\éÂ£‹\å\ç(FœG…«Kv¸\êBN2R\\§rŽ\í_|\Ú\Ñ-\ÈB0ŠŒxEJ‚¼™)Z£k÷5\ß\Å{˜¬\rJÒ­÷šn²\ÃW9ø\áª$>!„ÿ\0N‚þO¶\Êþ\ZT\×ð<n%þ»¤úM˜­ô\È[UNU\á©&¤c¾\Õ\ç‡\ãöø7OrŽ.½x\Ïø\è`±\Ôñ7V´ý3b\î,¤T\à_¸\ãst_+÷$6KÔ ÷C\Ë\r3rO\ÍmŠS\×JõF6.Xyû;¢•M¡/Fl\âý\Z+Ï³zz\ÜøN3\\])~\Ñ<Nz±1Ÿ\æ4þÄ§9»\ÉÝŠ\çcV>hYi¯O\ëgü•¾+KD¶\\¾^ð•\ÓtT§	Óœdö’%2’ômÇº0•7®Q[\âs·\ZL6\"”Ô¥4\å+\ìWüI\íÔ¬ûL>\Z^°±Ž\ÝP—¬Dc¦ýsR’\âL¥9ö‘Ý¼ªFô\ä²À\Ë\ÅG\Úc1\ß†\'\Åý}J\ÔjQ›„Õ™N¤\é\ÉN.\Í<R\Ä\ÑR\ë\Õdû\ì«\Ð]\Õó.;1\Ç+ŠY2Y4a¼ö%—\Äazq—£>;\Ñqý¬”uE\Ç\Õ\å\Ù\ìÊ˜¼EM¥Q\Øl§+MªjvO,\'\Â\éU\ÃFn^&C\áT—3ez8xÒ”\çé…I\â)\ße¨«‰¥Mo.„ü\Ï\ê*U9TQð§»(Tt\ê_SW(Q}ru,£\Ëf\'²\í_g\'$Eµ\Ã\ÜÝ¾L.\Z§g¼\ÝLT4\Ô[ò®R©«—\ìŸþ\Ê\ÉOJwò\ìU•\ê?©Fš\î}ž—£>\Âß—_ö!‡\ìyN\æ\ÅJª]r\Â\ÊÒâŸª\Ë…Ž&“¼]V”\éM\Æq³0X§†¬¥ú_™	©EIp\Ðû\ì­úH‹5óYsQ±bÙ¼\émU\re^\Z\è\Î>\ÇÃ¥jó‡¶XÚŠxš­q¨£…­Y7;þ.\Î3£-\Ú}Ï†\ãû\á?+\ã\ê?‰\Í\ÇÂ­fbñõq\íè†`\á:N¤ÿ\0‚XºJ\Ê4om·*»Ô›µ·\à¡Rg=^=Î¶*Jƒ¥\æ\äP“\áøn\Z5··•\îv\n\ÑKh®‡\Ä\é(:V÷0òñ\É«¯	%§‰•£¦£0\n®©\ÊVR0ê‚”\áyyf½1\\j|\"´Þº5¹‡ú\n´\ä\àüz¢b?\åMµ$\Ì?ùz_\ìY3\â˜5Z–µ\ç‚\Ë\áµ\á\Ü?kÿ\0üŠüÄˆ»‹\æÛ¿!\å\ÃL½\Ò\Íh¡Šÿ\0\Ïþ‰­Ðªõ¯(\ÊøP£F—\Ô\ÅM\Ú+Ó:²SV|Ÿ\ì>\Ó÷¾›¡‡Z*Rk~R<EZ»6­\ìP†·\í\Ô\Â\'\Ù%«k\ÛøE*4\å75-£>¦.\Ï^\Üke´%M:\îŒ\rxP­ªjñjÌ¥ˆ\Ã^\Ó\ÕnªJf£\å{\Ç\è|ª†+KýHzP\æG\Ä+v±\ã†)i’ežk˜•t¤º	´\Ó\\˜/ˆ\è›r\ÝË“Šuª)qbŽ&t\Ü7º]\n˜§FSœ6r¾\å*:©Mõµ\×ð#õa(¿\è.U\Æá©»Jª1¿‹‹…¼¼¾}U½,†.\ëÊ·™K$»\Ús¶W\Î\åû¬bBW‡\Ó?ˆ\Ó}²kõ¢­%ö7SV\í\Ú\Ä\ÞCê·(ùpðB\Åc\'}þ\Èø…RµZ¿B›Jpo‹•\èaþ\Ë9*k\ÊN.\Â(Ô•7±…)S\íi¯ªô1•µVž—µ\ÇÜ ¯U\ÇNXjV^8rS–š°~Œ¯:r’ì•’E[Ê“^\Ã>\ZõÆ¤z\èk*\Ô4\î¸\ÉV¨ºŽ½F¹\Érˆc$¤ ¶:‘\Åb#Õ’^ƒ­UóR_\ß::õß†;z˜\\4pô´/\åüšþdDY!\çØ±l\Øó£-3úç‹¤ª\Òkª\Ý„°µ©j»\åÙ¦`(a\êCS\Þ~„\êÓ£á·‰ñU¥M	«_þ\n–¿O°¨Ë±•+\ÝZ\Ñ1z}\â\"Te3ˆ•	_˜¾QV)FsO/†\à\èK¥*i\É\ßs	:T\\Û§}¶>+J«	Á[\\n\Ñ	8\É4`\é\áñ8z¶\æJ\Íz‹Œœ_)˜ZU:sªù…\Ê\ê•Ô¡ ¬´\Îhø\'ù‰ÿ\0´ª­R¢ôo)Pƒ\éc\ì²ý\Èû/õeaR›ý\"\ÃO\ÕO‡B´šG²\è/„\àô\ÛEýÊŸÃ¿,\äŠ?\n\Â\ÓÝ­O\ÜI%d²}\ç–#˜HE\ÍB\Î\åþMË—\î1\àd^¨\'h:½\á’^)/s]\ÒpŸNBñÿ\0¨Ÿÿ\0„-\ÑµÅ„b§$Ýº·qKNT®¯\Ð\Ç\à\ÞZ¢¼bM\Ù\ï–†¥…¥?\Ò)(¹¿\ìb£\ÚÒ \Ú\Ù\Â\ßØ©NT\åi#W³Ÿ<•\è\ÍIJ\ÛO†R£IS]moÐ­(v\ã\Ö\Â\ÂÂ½Uµ\Ì=%‡\Å\Æ+¤¬c#lM_®xw‚K\ïnÙ‰xm»ûŽ7¾“ø»·ü˜lJ÷O¼û\Ï,W1 ,–[‘O-_’dˆr2šµ8\çñ\ZW‚¨ºrV^+ú”\é02§Vƒ£>-%N\rE\Ê\×\êX\ÄbaF/¡‰ò¯©|:×§\ì\ÙURœ4T\Þ\æ:‡a^T\ïu\Ð\ëü“ƒ\Û)o¡þ\æciª¸<3\ê®Z\Å7÷jn\Él½\È\É\Ùûˆ¤\íZŸû‘Šð\ãS÷LøŠ¶\'\ê–Vn\Ü£RRQŠ\Þ\×7\ÏÔµ›F\ÛO\ë\Þ}\ç–+ô#”D‹$\\\ä·\É\Û\ä²D<Ä¤—\'_L\å8\Ê/ª*Rn]Œº;\Z5º#>\'cí˜Ÿû¬¡,Ez5l\îºx\Í\Í\ï\êNz\å\ìR ž\Z¬­º³GÃ¯­Yu%UvòS\Û\ß\ÐÇ¯\Âwn÷(EJ´{_r8HJ—iõ~b®³£¯—~ž‚¨¾\ÅõS%9\Ë£µ¢ÿ\0“²†¦\í”SgBû¦cüðŸ¬Lm)\Õ\ì\'\Þñ>Éˆ_\éð*u¥ú[·±JŽ-¶¢šÛ©<%xó`+;yWòV¡*M]§ô!RQ½®Uƒ„\Ü_+¨œ}­ó±¤¢#’\ß-Ü³ù‘\ÔkSD»Ÿ¢ûH\Î?«ÿ\0f6ŸkBd¼^Y›ˆ«Ãªf\âgr\Ó\Ý*J£ôö(Ñ•I{aªuÿ\0\ÆP_fœ:»\ì«Ró“’Ý˜½Uô^\Þbœ\'†{;JÃ«ˆœ\'¼œzš¤\Ò\ÝØ¥özûñb1ƒ¥7¯Ä¸Y\"–«\Ú<²4¨\Âý¬÷]´Ñ‡’Š+Ö•Wy	\ât­=¥‡Z¿¤8¾¡)VƒjR’Rœq›\Ówü›ú²†­exØ–´#)=%*+R\Ððøz’ø{_ê¢—\áC\éóq ‰“Ì¹rùØ·q“\Ê\Ç©.\åz]¥)G¯B‹\Õ\n´¤\í\Õ}QR•\îÑ¢W¶–S\Â\â\'\å£/\ìG\áX…s²ö*a\Õ\rm\êai¾\Æo÷lŠ³û\Æ\×*[2\îRr²\çy2œ\ê[U¹»5\ÇBZz¹+;J¥8\Ë\Ãè¸¹ü”Sq­o\ÚA\ÃEE%»µ…E\èŒÜ¢“4`\áú\ÜÊ•­¦\Zl}Ž£†­Jþƒ)\é\í!«‹«•¾\Õt\è8é±Šu][ÔŽ–aqªö”ÿ\0N\ÅI\ÊoT·f§aBU_YX\ÇSJ¢©,÷#RQ\âM\êÝ¤¡fü§\ÃÝ±+\Ýˆ\àµNòzŠ;Ñ†ý>C\î\â¿A±BÉ—5•ñ´h¯‰üfz¼Û¿b\ÆÆ®ô†Ró\Ã\ê>\î6–Š\íô–ùRª\é;\Â;úˆ—úŒ§\ÛUo™%\Î\åJuUµ\Çršš„5t\ßû+\ì\í¶¹¿Ô\Õ%\ãÙ¿(¨\á»®÷]	*\no\Å\']ü)\ÛÜŽ.œce‡…\É\â\ê\Î.;Yú\"©;\éW·&‹«5Ø¡MK¡/rT»*5£ýjÇ‹·¡oÚŠß‹?÷d°Ž\É\Ó\Ä\é.\Â””¦º˜j•m^\Ã;hR¥IB\Íþ¢XšuðÒŒ\í/.XªÐ©\Z6\è·(TT\ê\Â~Œ–#9]\Òweé…­mö_7\ÌHä˜„\"ùW\ÄQ¤¯)‰\Ê{RV^£»wo+w\î_¾\Éüñú\ån\æ+\rÛ¨Û”Nq¿šœ¬þƒV–Ûˆ¥/tÇ¥¶!©\ÇÆ’f2¬¢ô®-¹=i\Æ\ê%js§+N6!	\Í\Ú(ûw]º\Õ\èiz­\Ö\äþÏ„QŽS\êT…\Z\Ô{jKK^d`Šª\ÛxóþJIý²\Ë÷2¥Mxy\ßÌ¥f<T#¥x´\Ú\å›\ãs\ì\Õ\ß\èg\Øq\Ëù?Ã«ú\Äÿ\0¯\ëü:¿¬Eð\êÿ\0\Ò†\×ý\Ñ?\Ã*þô†Oþ\â?\Ã?ùà§€Pž§+ü\Öb<\ÈB…•\\E:K\Å\"·\Ä\êKjj\Þ\ä”\æ\ï7s³4\Zr¹di\ZfùX±b\Ý\Ù\Í\îµ\áB¼œ\æ\Û<*µ\ç\'\ìŠ=Ÿh\Ô(¹}Jjtû8\è[ß‚w¼7ú˜Úµ/¡¥cEYa¨örÓ±•¨Âœ\åªhÁ\Ê\Ôk\é^+zt\ê7®­™Zœpøˆ\Ùß†c(TN\ÒRh\ìûõ\í)t0µU*‰¾-f)\á)I\Îo¡	\ÍTR\\”ðµg»\Ú\ä0”c\Ò\å’\á.\æ\ß)•¹Eˆ»ˆLž*>YSV~]‘Ë»\ÝüË³Q©‰xž\Ñ-È¶R&t üúwžý\â\\Ä«úªVö)$±5™\Ä^‘_û7u¾\Ës+\Ô\Ôb+Aá¨¥-Ñˆ©Nµ(KýE³(Ö•\Ý(†\'Ë°ñÜ©QÔ›“\êR¯ˆŽÐ“úž.«»Rd~UódG\áô—šM¥NX®\ëùm£Ÿ‹‰.F‡\êŽ\Ô\ÄTž»F~~\å‹w\"f\"¦˜\Ùr\Ì?\àSÿ\0nK¹R¤U-ŸŠW\'Ù§\n­ô\Ù‚sÓ»w\"{¤·\è\ÑöZ\Õ\ä\ì?‡ÿ\0òÀþÿ\0\Ëÿ\0øt?\î1`(Qö<?\í\nŠhI.\ä\Ùo“q2lh’\É?½¨½ÿ\01\"§$\ê)T¨a\áb\Ý\Ép\É\á)¨T«;\ËÂºŒ-¹\Æ*\É\r›ÿ\0ü\ÉHCD¢2¶Ø™?“ˆb)»7u\îC\â\Ô_X†&„ø¨¾lŠ®É¿AË–ae\â·ô¯”\ß\È_!¸¿\"óš&Šò‚km\ì^û÷gg\â°\Óiò}¦µ7\á¨\ÑŠ\âcú¯õ)|Vs½\àñ8u§!|Gúµü†\ê!bhÜ‰\Ú\Òý\è\×ÜK\Ô\ÕT:ýè©‰¡ÖŒf?´ð\Ó\àE)ZTe\ì„þD˜\Ùrý\Õò¥\Ü_g^\äÑ\Úpú¯qD°\ÐÑ‰šsVîˆ«Á\ÜH\Ây¤½‡A¤Ò½\è(šQa¤T\áý\åÁ£þ\ÄR\à™¬\Ô_¸\Ø\Ù~òù,}\Å\Ý-‹ž\äÑ…\Ý;{‘Œ¯Àò$P¢:h±Ù­#ø4\ÔK“q_“\ïSÿ\0¢Å»Ì«\å—Ð°žÛ”÷¡GýˆÃ¾c•\Å!K&K¾—\Êc\Í~FDE›(R„Ôµ.SK³š\Óú^V!9²‹]K¨\ÊN\ä\ë\"\ã“0?Œ¾ƒù¯\äŸ\Ð\è>\n\åh±zd»‰‘cbÅ‹,%ò\Øó_\"\ß&Bl\Ãs?\à—•ý3‚L|•«(§r²…\Ù.L\ãÀ}\ë\ä\ÌO\áÈ®Oc\nïƒ¢ý²§-Q\Ê\ÃB\Ù\çbÅ‹-óóY¯›!‹¸\Ì?ý	»B_L¢„,˜\ÉS#\Éöi›§$a\ß\Ó%“\Îù³ør,\É\\Àÿ\0“¥ü\åI\Ú_^\ãD_\ä›qg\ß\Êcq”¿}D­B£þœ »Œbó4vT–\æ¦U›{ó#þb‘\"Å‡šyH­øsú\Ùð÷ÿ\0Mÿ\0›\Ê*òHŠñ–-šüƒþSùL»±ó\ÄÆ»a§ü	%“E)6_•”¹)ùÑ…_õ1ú1Œó\à¸É®F—+/†~EýHF^ ¹Í¡¢/òò]\Å\Ïqü¦H]\ÙŠ\êt­~¤WuŒ…EN®Ä¬\Ý\ì8›Ü†\ÓF|Cÿ\0ia+ga’…\É{\åð\Ïõhø[õ\î´=„þsûñù\Ò\à|¡w.„WŠ\îvC!†\ì‰piw\Ìøo\âOý¹2Å‹\ÉX•‰•\á\ãoÔ§B£Z´\ì|=ýü\×ôˆ„t\Å.ô„þk\ï2:G\êve¼sÿ\0vv,ò–Z\Ú\Ö\'\Ð\Ôý¹ð¿ÄŸûs²,2Å·\ZI‡m%\n\é\Ó\ÒRœ{hÿ\0&:ª®û\ZÜ¿\Ìd»·Éù6\Î\ÙL\\±f\ÆT\ä\ë\'\ïš\ÎEÊžkr²4j‘?\ìn|;ñeþ\Îÿ\0\\¥Á$W†¨¯¨©£´Öƒ÷0qóK%\ÞhÓ¹Ð¿\Ëd»\ìþc&G¸\ÆUK¹<=B†–Tok\n\ã\ä÷‰ðÿ\0<¾Ÿ&\\*yXŠjZ“÷(GM8\ä¾D²¿ÊþGNú\ï2b\Ég2¡Ó½<©Km\ËDœ÷\äK\ÐøžAw\Z\îK‚C\ä²0ð\í+Ó‡¾O\ä\Èy/\É½|·ù)w$O>¹ÌŸqd\É2\â\Ò-\'„zE6`%z’ú6_\'“$I\r»³\àð½i\Ïö\Çÿ\0y?\Ç\Ý]\é1þEw6uLOlª\ï2o¹¤I^†\ri«ü	\ï\ßy2C^9¨Mú\Ë\å1\åbÅ„»¬“»ëŸšÉ³¨³\\ªº\ÉË²§\ìv‘(\Ó}\r´Jrh·Lºu’+yÿ\0ƒ\áŠ\Ø:~ûü¦X±bÅ»\Óc%|\Æ6Tb©eP|÷Y&<¯J¼öa\Öl\ÔýJû\è}syoé›¾L‘ˆý&i\ÃQ_Ò¾]‹ù{ü–G\æ2L|‹¸ò˜ù\Íg.Xò\Ôý{°ó\Ç\ë\Ý\ß7“&V[G\êAZ^\ß:ã‘¨¾l–K¹rù\Ç\æM’br\\	ðK½>F7²¹©Üƒ¼bý…\ÝCÉ“!\ru)\Çú\ÖWù75\ZC™¨\Ô!l—\Ê\\w­\Ýlœ†!w%ÁúIõ$.\ãc\äc\Ê\å\Ë\ç‡w£O\è&[¾É˜j\Ä·q¾\åû÷5\Í!\"Ä™Ê¶JCbù$G¹!’#+\á\Ñ\ëÉŒ‘ð¥½Wô4–-òu\"1,2o½rýÎ¿)²Lo%\ÝHc\ê2\\\É\å&1»|¾/×¸Ç½²—&|#ý_\ã;\rù,(‘ŽrdŸ\É]ä»·$\ÆòK¸ˆÄ°\Ç\åg¡Ô‚\Û&2Cd‡•Ë—b¦`™µê²‹=\Ù™ð©Z«ª\ï[¿b\Äc›d\åò—qw™)\r÷‘$IòK\Èt–\Åò‘\'”žVgf\ÙÙ£B-•\rª\ÄB\ï1’0\Ò\ì\êB^\ç%›d¤7óWy’\å~òM§l›&\ÉYþ™v1±Œ˜Ç•»–,\Åt\Ó\ïm“\Ï\Ð\Ì5NÒŒ%\íÞ±n\êY²R$þj]ù±¾ôi¶F	d\É1¼ª»•<±E5¸ò\Ø\Ù\ê3I¨Ô½¿BÆ“I¤§¼#›\î<¬S¦\êKBþJIB\Ñ\\|‹,[¹9]û,X±bÅ»ó\ÏsDŸAQb§\Ül“Ñ²d\Þÿ\0ÁÇ¾R$63RŽÃ‚\îø‹²‹Ù¬\ì^\Ý\Ëe‚§jzÿ\0q\Õ|\é\Èo¿bÅ‹-ò[\âŠ4¯N\í\Ç#P\Ù3ÔŸ”‘\Ë#\åÉŒllb\ä¨\ï7\Üß¹Iø…ò\Z¾Þ¤c¦)z!-…ódi4š\rƒI¤±oŸr\æ£Q¬u\rl¾m_)òHB.\\lc\Å6óqKº¶iˆ½ûôªôÿ\0¹\×ç¼¬X±bÅ¾ceË—F³Y¬r\ÉG;—%¹.Y>J¾¥òcÊ´\ÒJ&¦_-&£Q\âõ\ÎÂˆ;\Ä\é\Ýfü\Çþ\'\\®\\\Ôj5\Z\ÍEû¯òW\Ê\å\ÆË—/š]Ë·ÁgumòŽ\ÙOtq+dˆòM\ê“}\Ö\Ò\Íó¢öh§•†»˜%÷³ÿ\0nM—/•\Æ\\R5š\Å3Q¨”Ë—/Ü¹r\åË—.\\¹sQrù¶>\å‹w-r\Ï\ÐkØ¶U\ä.r\è\\«\æ.1±\Ê\Ô\ß{J6>‚L±Oi•›Í˜ø¯\è1Ë½¤q8.\\\ÔkeËšf³Y¬\Öj5\ZF¢\æ£Q~\å\Æ\Æ\Ëå¤·q+©dºF¢Qô\'«Ð©\"+)\r•9\É\å]ùcß²/Rù­\Ò²y³øS\ÔY…ˆ¬í®8–ùW.\\¹r\åóY,›†òP}M=Ä›\á\n—¯q\Ä\ì\âù;(\Ûb[7r®›j\ÅÉ±²O|™Ô›¼žHH¶n\êiY<¨½¬D_N\ã0ª\Ô)û±Œ\ÓòK\ïX±o‘a!\'”˜\ÙqE±$»ªŸ©²/\Þg\Äq’§ˆ”#ûMr—R[õýJ›AÉ±U™öŠ—#QOs…&i4šYcn\æŸr\Æ\ÙC’%–V\É\ÜÁÖ»\ìŸM\Ök+d\Ñn\ã_*Å‹,X° Ø¡”\ä9d£\ÝTýM\æn[+÷+VŒz˜º®.r¾\ßþ}>\ä¢…—\Ä*[M5üŠ6¥)<”œ]Ð¦§\rŽ\È\ÐY\Zû\Ö-š\ËÃµ‡õ\Ïþgÿ\0ò,[¸\×Ì±aDT\Ëe9Ø“\É,\íqRõ6C‘v\Í>¥\Ë\ä–W18˜Òƒ“f#Z´Üµ …’õô%.Ö³o\Ô\Ä\Ê\Ú`¾¯4\ÚwE*Š}wô\Ê\ÂE‹,‡#S}2\Ö\ÊR¸ˆ›g€_y7\í›\ï¾\ã-òli,²ºA\Ôce‹d¢Ø©z›#Vw7f’\ÙÜ­YB-˜\Ü\\«\ÏúPŠa?\ÔÇ†’òUþ\ãj~h\\Xº}SEZñt—\ÉE(­r\'-Rrõ\îa«:¡Q+Û§©*úÛ”U—¡\ÚK\Ñd\ån¢w\Î\Ì\ß\ÐW4£\ÂF\×…”ŒüWô/ó¬X±bÅ„%‹š‡P\Ö6ò³-’„˜©¤\\r\ËQ¨\ÜKº\ÉHøž+ý8¿®H„ô\Ê\å9\ê\Ð\Õ\ÊÔ¶\à§Zp\ÚÉ¯Fb+Ð–(\ÂÓ¿zŒc\ØÅ³M?B\Óf“l®_6\ÎK{ä­“c0K\îŸ˜òK+-Ü¸\æ9>\å²\çR}E¡\È\Ôj5\î.æ¢®&?4‘‹øµ\ï\Z_\Üm\É\Ý÷0õtOÙ—$®V¥Þ„uI!$•	ªü÷4£c\ÂllllZý\é\ß93¡B:hS^\Ý\Í_\"Å‹w\î6û¶b§&*Q6C\ä97\îX\Ò[&\ÊøºTWŠF#\âÓ•\Õ5e\êN¤\æ\ï)_%\Ý\Ã\Ö\Õ/‘ðU‚‘85\ÝÀ\Ñrnf‚\Þ\Æ\Ùx…SJ4û–÷,h¿QS±²\êBi¶¯“\ê©ú²\Ã|\î_\æ\ß+\ZM&’\È\Ø\Ô9Žc™wžå„„‹e{ñ´hù¤b>/R{SV%)M\ÞN\å¾BzZhE8Ü›\Z\Õ\î\Z\n\ÄðšM-\Í\Í\Ë2\Ì\ß\Ð\Õnƒue\ìv>¬ŒTZ\îV«¢7þ\Æ\ã5`\Ôk-KÔ§Š¡Yx&˜\ÇqLR/•\Í]û—5\Z\ÍF£Y¬\Ök;C´5—e\Ë\çbÅ„\\zpW”‘_\ã4c\äñ¾)‰©Ç…\r¶÷2”¬\ì2ÃŠ&¬(ß†a°®ú¥üel\ÕÍ²¹¨¾[g¹l‘‹­ªzWC\ÜNI\Þ,¥ñLM>^¤Sø½	ùÓ‰\ÛÐŸ–¢;K~¢5Ñ¬\Öv¨\Ôkgh\Î\Õ´N\Ò&µ\êk^¦¸¤N\Ñz¤N\Ò\'hkf¦\\¹¹¹cIl\î‰\âh\ÓóM\"·\Æh\Ç\Ë\â+|[S	*“›¼¤\ß\ä!$\ÑúK)ER\Þ\'\ÜCÐkùª>§hjy,®Yšm‹#J,]8\\\\•\ç\ÙÒ“:’{\äó¼½Y\Zõ£\Ä\Ùˆ\â#\è\Ê_§/2\Ò\È×¥>&Mu;QVLºeƒB4#IcB;4v\'d\Î\Ì\ì\Í\Ò[-Hzq\æH©ñ\\48w*|j_¢L~*®\Ãmò\ïù:{HŸ”Ž\ì\Ý\ísLA%\îhGÝ‹¸Ý‹÷w/•/+\ËQ·#§\ËUª®*Hû^#þ\ã>Ùˆý\ä~%ˆ£!ñ‡ú¢Sø®\\»\ÅPŸF¸z›z÷6\Ë]hÖ½IW¦¹’\'ñ4\ÔEOŒ\Ñ^T\Ù?‹\Ö~XØž3>j1¶ù˜‹Ô‘Fž\×Y¦Â•ü±e.M\èl\\ß¡¥õe²\Ó\"\Òô7ô.\\º5¢R£²*O\\\Ûõd¹üŽ\â¯Z<Tb\Ç\â—ú‚ø¦-uÅ±^\Çø¾\'\Øÿ\0\Äz!ü_\è‰|Gÿ\0Yö¬Gý\ÖJ½g\ÍI\r·\Ë\ï\Ûò\Ô=\Æ\ÑF•\è8¯Axx53[õ.\Ïw\è]±FE»¶E‘·¡¥³;Q‘²\ß\å¿\È>ý¿1‚ücW±a¿c\Ã\îYtbŒz±\É\'´s\Ø\×©\âb«6\îX²v1R}Ÿò>>[üƒ:\ç\×óx/\ÆþfYú\Ê\ÞÅŸ¦V¥#ž£Ô™¥‹=\Ï¡\ãý¦6ñH}>[ü‡§q~oeU·ûK§\ÂfË©¨ñ	1%—Œ\Õ#\Äý…b\ë\Ð\Ôj^¢qõ<>§ƒ\Ô\Û\'^œy‘Žœj\ÃnŒ\ê?\Íu]Î™?\Ì\à\×6ú\"ð¸\Ý/F}ß •øEôt5\ZYlûH.£«\é\Äò\Ø\Ø\Òi#\nkô•©\ÆTg·±\×ók¦o“rÿ\0’À%y’_µ\Û\Ì^?µš¾¦¨žcÿ\Ä\0)\0\0\0\0\0\0!1AQa q‘¡±0ðÁ\Ñ\áñ@ÿ\Ú\0\0?!œ&…¢r¸œ\äd1¦\Í>‡\"+úsl\"21_ðb}1ðhI±\Ê\r\Ì!Þ˜˜\Ëb2E¸Ìž\ÅÉ±\nD×‚\æÐ‰‚@“lµ*6\è\ÞÉŽH\Ë\Ìòj\ÒBˆ9¥J*#§\å#0!óò”ý–\å\'\ßJ•\ÅôXb\'³3°¢\Ãwø/7}ž\ÒüŽH6\ß91«¼±%\nt,ž\Ì\Ç\Ù+\Â-lf<\r2»\Z\åd˜—–c|¤UŒð†¾-¢©„6 ¨Û¦`¦\á+ \ÎkûÁž\È\ÎY3\ÓM\ì¯a\Òûª0¹ü#CJ™\Ò‘tK»¼‘Žm,n…$1¿¡U­d\Ù\Ø\åV¡¤É†—öWØŸ€\Ðz¸_°öp\Û\æHOŠ{&\âV†Ï±diô\'’¡p\Å\Æ\ÂÀ\Ô|:*!ðJ!²‘G±XH{)ˆT}À–\äò,½<,Ú™\ãŸû4É†¡e\ÒF\í•\Ñ\å“\\1ÿ\0“+~$!?h\ã\Æ\ÇðY\Ãú)?\æ+!\ÓdÙž)”AT? \çD¤|\ÆÄ¡fe\Ù±jð´.†mðCd®M\Û±>Á2-bq	SœSÚˆ¥–o\\B\É_b&\å³,!›\ê\rÊ•‹¨NI1Šö¢ù—ñ\Ó\Ë–P·/\à.ð,\Ó\Ç\ämhºÁl05-\"¤!´‚\ìcþ‚\ïd‡\àŽˆùÁB\'±¿CŽ\Ï`ý\Èg‰‚\ê\Ì‘†ö£žÊ ™±(-p\Ädˆhm	sÒˆ[K\Ãl%8³¡SBm0¬\Ø+¸\Z\àö&…\Ñ\ä\ë¤8/Ff…o/–\ÖK\ÐXqüø¯ù\n\nñ\Ïy3’\áÿ\0(5ü•\î\Ø\ç˜Vaš\è~·¡ù\Â	SÀ¢i¦C¤\Ü\Zh\Þ\ÄLcp§\n\r\Ã-\Ó\Ìi‰ž\ØðÀJˆMLjpð¸\\72‰ðˆµ64\nŒô°´\'HAt†T\"Ñƒ\ê0‡\Ê34¶ˆH\Ï	\ÝÀ\Ð,•‚žd5(q\å‰<{t1×¡þ¥ö1X¥õŽ‰ˆ²N<žÖ·\ìÁ	°^<NlJh{ùn^‚¥Ov	Z}80\ÉoÁ´\\6&X›£v¹ô2\è¨ö u^E\í\Ò´!o„\à\ßûš·“\n>B\n÷*@F1”Q*G n\Ô$­ŽÙ†\ÕiA\ï/²\ÑM\ËºB¾›ò\Ö\èb(3x\Úð\ÆO\"™Iú2vEQ\Ä\ÇFˆv0*$“¦D\ë=´gT–²$%~˜?\æ s°\Û2\Ä\è¬­p(K\è[G´\Éw\ÆõðšcÐ¼pÁ{„&%[	½Š®±o…Æ¹b†n`j!ö¶7Ã¼‰¶N\ßB-¦\n™v±jF(=ö¶9\ìÙ©±;\êd<\á\Ý0b¬¢%³4\'kI\Ð\ê\Î2®Á@K!”§{	\Æ.‚\î\ïjŠ‘w\Ü\Z¬x/—zÏ¾	$\ÑGü„zéŒ¯?6=TAlŒv2\â3LÁ‘’¬¡\"?#ú2{S\ÎŠ\ÇÝ¡?P}‹±²ò ’X\ÔlD\Ú¥ƒˆN†¥ô{\rF\Ä3³>\ÓGm2$/<»Aº\"\Â&´_’©±6\Í\Ù\Äd:g•\Z\ÓF¬¿E9Ç±\Ö¬o¢þÇ ©£\n7‹9\n¦±\Ìt¾:d®¡lÃ…\Æ\Ñs&FŒ\ä\Ûr•òO.L§Õª=Eø3\ìðA‰ñ\\–¥ô(‚´7F(\Ù\Ã!\ÙööAg p‡Œi=‰\çú	–p\Í\Ù=cH_9	\ïP­l\ÈÑ˜Ñ4Ê‚¬!¬Cn¶G^£¥³7F\\~\ÃnL)D`;Du· Ü‹E¨8ý£ûO¡wEÝ…´ž8CSôQDô\é\í\ÑúC\å\è;\å/Ù±^\Ö\ÌøÀó³\ì\Î&|³=(B\áBK³\É]žË¨¸\0M\ÆDß‘÷˜)\î‡tL¯‡Ð— ×”ï¢¡„bðl6!g\æ/ˆ8\êÌ\'L\Õj12]°\ä÷\ÃO2d$.eŸ‚ŠhG± XTZ»}‘¢8úH\Ò\î\\:\'ˆ6Ù±^\ÉGCS£\Õ&P“oÀŽù\Ø\Ê7D\àòl¥oCú\Û\ØÞœ²!\\5V\Æ}L~H†+ôDœcUJmŒO%—\íCK™<l!¤ød*ß¢ª<\ä\ë‚IŠ}ž\ÃNŒ±\n/\'jR‰Žˆ\Ó$K&{&F;Â‡ŸA_\Òg¡›\Ô\Ù\ÖÄµ÷C»¡Rªý	ñ\\V­¾Ž“g”S\èHv\Æf`&ò6ËœÐº°ð[*DŒš6ˆ\ê\r£\ÛB	ý†77J|b3\Â\Õ^¡mBA˜¥\É\r“h\ÅX¡½l»\Ü;D6\\Mm ë±®™”™:\Ö6v1‹#!\ÏfŒ½q¾\ÌJ:.8\Ã%\Ï\"È‘gC	Yl\ÂS¨?¦9š`œ\'²\ãBSAž8h6†ßƒ¤=l€\Û\íˆ¨š²\Z¿A\îð1<ö˜‹›S	ÚŒb£õu—L\Ê\Ñv¶,MTô%¤¨\Û4\Ã5ªiL¼&&[½Žu§mj]C \Ëò\"¡1›L\ìZž\r\Ô\ãV]\Å584iG²Ž\r\ê]3z>…£±d:cŽZ\á±\\Gº–[H ó\Ã\Ã\È\Ù\Ã7­ “\É:\Zúœ…7Øk-b{Cu\Æ!\rŽ\èß“Ã†9ƒDB­,X\ÌfIkü\0\Ù\ïöyNò­ŒnŠ ð}A—\ÅyW‘ºÍ´ü\èühA\í!#O¨\Ù\ì{‰®{þQ\ZB|\É\ìuO²»¥\î\ÒJXi‚¢›	™’N(C4\Æ\ÜLE\à\r\ä\ìG\Ãfa2™¢V†‹cPkCõ\Èm6GÀ\ïB\ÂIü1•š:^ª‚YL\ÞQ\Ñ(\Ð\í*~:)ÀÈ˜˜\ë\äixR*½Cr\ÙS\Ù0\Î\èþ‡_Kf²£ÀÆ_z=$‰k\0ûR1\Ö\Ý\Z=\è\Î\íÐŒD\éEúAVCÁ¡Škhz˜‹‚B	\éf1{”-\ÔF ;öž\âa4Y¶%Á:Þ¶5°HFœc: “By©€\Ï[\Î\àÉ\é\È\æl„]†¶š$L\ào¡ž_N\Í!r˜Zhn©’2Û±oi\Ñ^E©’³Yô>\è\ër˜Ÿ\í$€\ØØŒ«®©žZA©ö/‡TS2c\Ð\Ðg­BX;ý?^š\r\r\Ò\Æ0²\åúemþ¢¬\ç[¦t«A¶­mÁ»\Ão¼7y#}˜2ˆ™‘#CÎ¡!¤\Ôû\ÝhK%…{zD\ä\Ô\ëˆþÑ²­ú\n<X÷!£\ì\Êò5†\ÛC§Œ?·Â…‘\á\Ô\ÑQ©ºIB!9Y2’-\åEQ2\ÊJ:aÛºG½¶2\ÍvˆVBL&dt\Ø.™F2Ä©µ±¯pyŸ‰™¸\"­†iµM.r=2\ã\äg.\ÛG®¼¢\Æd«\ä‡L­“\á¹4W7\r•‚Qÿ\0\ì<I½\Ó{¹\ã35\è\r*ø“\Ð\ÇqM”Œº»F\ß\Ñ[Q•{fAÏ¶3~B„FS]Ù±‰C¢\Õ!žs²}\Ô60BX™ù(”w2ø\âQ\Çdm‰Møš8-Ù‚\r3¤KL’x\' »\nÇ¢\ØÈ¦\Ä[\Â\ã\'ƒ<»g\Ï\äÎ§ðð&ú¯±/§7\ÙE\Ò\r2À‹“Zú[\ÂgC@\Ü+°ÌŸ²3nš&¾E\Ù#ûŒ9c?f|\\\å¡%6+£‡“†¸7 ¦Ñ¡\ç¢<\Ð\é¢\í÷\Z6a\Z‡‚9òÁ}R\ÊÁ¶4V\è\ÒjdN„ÍŒb!ŠA´\Ô4Œ\ÅE¯\ÉOH|•¼&Q¦ô}BL\Ð\ÇNµe\"}\Äôb&:ò„\Ç\Øô1q–<\í<hÇ¤gÞ‡3\ì\Z\âkN®§=•\èY²Bhn\Ý\ï‚\röx`¡FBhJ—Ñ€t<\Ò½sò=\ÙØ–P>Tðš÷3;Xª¬ø!ašh\ØhøM!†$\áX¶·\àJ\æN\ÇI$\äo92©\nO)!öM˜µ*ü“WCF\ÈE2k±\Éfo¡\Ë2øU\ã‚˜–GŒú‹‘Œ³lj´8Fw9BÅŒe\Å\ÐM˜\äd-’\Ø\í”¨\Ì\Ù\ã=²ð.¦Yo,O{\'¨Y°n1°iDZ\Õð\Éx\ZlD\Ëò\"\â‹9\'?\ä—\î&\r¿@Š\ì5ZE°Àð\Í1Q.ú?\ìI‘m´M	ò*\ï‡\àg“l]*!ªü”\Ã\Z\å„H{ðPù\Ìk´6ù¾\n˜‹…‚BNû(\ÊT¨!“›X.®\Ãg\Çø!;{c˜\×\ìTM\äÀ~„Åžx)ûöA>…\àp\å‘›T\Z‹B%z d8\á™vcX`ƒú\ÊcJ!¥b1Œlo…2\ÄýQÓ£!\ç\æ’7=€¼†úlŽ*„z\Ëéš¡\è\ÄòK2ò‡\ê,’*ûlþC\ØE­“\Ñ\ÆNm¦}\ZE\ãh7mÓ®M{\"b¾Šªßk‘—l{È’U²¯b¯\"©µ\ìx5¯br™ŸC&_².THvöü¡\'v!»‚§~EUz\ÖW¢r…0Y\àß‘\æ95\ì}+\Ñý•U±¨¢\ì%N\ã\ÅC:\Zßˆ\ÞÌ‚w\à\'’H{eH­E=húño\Þv^}°B‚\ØðE0›x\Þûa¥\'Xˆ¼8\ÜryC\Ò9ôdK~˜\Ìz#f…\àCa?}—EI\å\Ë\'F\Å\Þ&&dBÄ†ˆ±‡üƒ8×‘\Ì\ÞzÁþ\ì1&™»£Eq\å\â\r#¦ü½!OPY\'–½­©‰ûH°\Ùö\Å[g“ ›§WÉ³¦\Éi—¡Vö÷\èHEô\Ì`XL\Ä)0!f\ÉVÝ¦¾_ôˆh\ÓK\íK\ÎmôW‡C\É6üö\ÊjšÐ’…3FaC­\Z«–\ÌD¹ò0‰“KLi8\àdAw_´X\ÝºN\Æ\èm”\ê?Eñe\Ðûsl¢•(,&Œ\ì¾a¡}„VO\ã*\Åv)/‹£Zo€\ÑS\Ð\×P)£¿\"\ÉQa\Ê¥aU7@\Î$\Ëlc7Ã‚C\Ù0Aro†\á+OO/\Ð\Û\Õ[ð5„©°‘0\Z\ÈÚ®ƒmƒ\è;<\â¿\"S\æ~2,ÿ\0f\ÕQ/%\å/&\n\\[\àXÅ‹£&T]u\ìó\08Þ†<I3Ã±¢™¬Ñ‰kÀô©\ß\à(cöf\ç–gµn›E¢%\"\É\ìeWC!KU#³ —­¢B3,\r²á‘Š\à•\ä­X‡ ‡\íB\ég\ÜX99Ü¨SE\Ä#:š¦}A’m±Œ¾–°%±²£\r\à\ØR*iÿ\0gÁD÷\Þ\Ësq·\ç\èY\Ý3\ZC\"9C\Ç„×ˆLô;zTun³È…¶šuÿ\0ôzŒu\ê\r·¯M<Ô†5A6uGEf\Åj\ß\éÈ´}Ÿ\Èðm\Ï%O\Ã&ô6v–ð\ÙùEµž©ö)o¢±¦PKNµ\ìò2òýB¦\ÃüX\ÙDýOX£ð<9²”ŒBŸ@B.Å†+I].MQi`\Å¸IVdT=ª\èg\rŠh3Š_‘RjNTt!¨I46`Šv0\Òpw”3°˜š¦/pðA\Z¦O_µJ_†:˜	\í×¬—\ç¾Ž5´t4&al\"6\ÇGy}\Ä\Þ~Š©	ÿ\0bÁ˜HW?±›W^^%µ]vn¬\Ëð‡Ký\"ÿ\0@\Ù¶-5^ŸLD„\Ñ5ÙŠ>˜•\ä—BÁµ\n\ÌUf\ètŽ)\ãzb\ãi\à\Û\Û¢ÿ\0°¥¬(\È:\à<\ïžM1.YN·kRwJ\ØDœUWÒ€Š\Í\ÈöV\\t)1>\Å45ˆzŒÙ“\ê\èvõ\ìÁ?f5…+\Ú\Ze’ö$\Ñ\×ð$\ã(X†™ZX+§K\Ñ	¼xb\ìq¼k\Ð\Èo†\Å\Ör·F\ÆdQ\àUdf\Üh­ô\'4o¨K,mB”žû\n•¦«zº*f<¿½TT\Ó¡\Ø-~‡‘§~\Æu\ÔwN²\áÿ\0¨\ï	ªK\Øõö}\àU\ïoð,ü»ƒm¿Ñ‰N_Õ†¸J“\Óûg‚ê¯¢¶Æ˜\éD\à¥\Êþ™J»<2…e\ìö-\ïB¢\Â††;¿\Ð\Òœp2¥ƒ›Á£\Z\"¤!”j\ni“	“¨Ü§m±\r\èTc¤Àö%\âˆU\Ò\ÊÐ§¬K\ÐEœ;‡“\ìb“\Ã?Ð“b\àZ)þJ\Ô®¿a\Ö&H^N\Æj­\ìh{µ¬‘®\ÃõµÁ„m\\˜•‚\Ï)\å?FXyfA¦V®\ÆHQµŽ´%¢;\Õö~µ\à{\ÛYCÿ\0¥%±r%HdN6°ýj<†V}•¥\Ç»\ZMû†l7?h÷\rÊš—\Èe1”7~Í³†\×\Ñê •¯°U+\Òh§\ÇY7\ÓW•\Z;OO\É\æ`Ÿ\ï*Y[˜­\ìX\"\ße†Y:†Ð¼—\èU\é®–EÁ–\ÇÙ­\ÎMzcKx†O\Øü\æ8‹˜\Õ4l#Gö,CM	FDØƒ%±»‚S\ìw	ø§\è`É¼‹µ\ä\Ì=èœ´A{‰IÏ¡]ñÀšÁZ\ìje¢P\ÊkB¦\Ý$\ê÷Ð•ß¯\è\èM~(\ÆR\Øiki1L\ÂKcI\ç\ß6)•¨™¶4Ùž•y\"»X\Ê24±?\"´éˆ©‡~ÍN*ö˜íŸ‚Õ†\ìú0/¼õø~L\Ä>™ùFiÁ®«(˜¿\"•®\È\çò4–³‘¾Od6©›4#\Æ14º-v0¢›ðKW’E˜Ø&4\ï-ö{ñši`»Ðµ\Äñ\ÃA0\äL\È\á\Ã\í3õ	\Þz1tvF/\ÈúŠbK¡Û§œ%Õ•\ï¦%V6ŠL“¢\ê9e‘Yûä·¤1IHLk\Ø\ÎÇ¼Až\Ðr¶m^rˆ’\Äß…\äx‘‹o²KÆ‘²*eZµ…;±ù&¶Èžœ^_es\àB\É\ZOc¤J=5¸,%Lw¬þ„\â&f6þ\Ý3g\Ð\ÞtTúÐ¢\éÒ€öÇ¹\æ/ø.O²¨MF6\ßüÈ¼’\ÉÖ½¢Ó¬÷\Ó\Zzµ}þûû2Ce]	\ØÔ‰~H·´ƒADf2À’LŽ¬R?isß€22\çóÁ\èO;`™.¬ˆÄ…ú\×C<C\×^Ka‰\ëuöGa¾$}f$Möù77°n«†€d\n‹t±¿<½~‚yVA4\Ó$ˆP\ÚõW\ÓJy<X_ð\Z£Œ¸&¶C³\ZO(A_ \É\ä+½\ï\ëÀŠšoC\Ã\Í<Å¤S[CÈ¼~À¡X‡Q_’\í¹Z.´¨gì˜§öC\Üt\ÇmÑ¶F•+4§\äyOÑ’m%‡‘\Ó‘7\à\Û?\0üu‘j	‚uk\"jlV×ý~•Q3À}±O>\Ç\Õ\ï-ôÇ£\Z²ö°=´ŽB¡\ÎG\Øâ¼™øP‘9hI´ge\n¡\Õb69‡3\êŽ\Èú+u—‡Œ\ncJú)¡\Z\äy \Ü\Ú\êˆ{{31¿dc\Æf5\á\ã¤¶ô\Ùsb\Ê\èd\éMô.y=\Éy‚›§³3\Úct¦™\ÉZ)”÷±ø+,Oò;i\Z‚]L¦`i\é¶6ŽðY}Ø´{0ÿ\0<dšŠ\ÌÀ\è’\Ú\Ùx\rQ=€žj=’=\×bC¢7/²~\Î$Ü‹nNôô\Ìñ›\ÇFz;:¿§\Ç5ô³\Ç\'¥ªbû¡\ÒT/\ÂÉ¦„=\Ä`ø¥\í\Ý±\ß\ã!¶¿\n)Ž¥6‚~LD_<\"Pô\rKV…õóà´³r‹\'\æ\Íú©´Ú‡o\Þ\Éý\Åø7¼Q£©µ3d2N¡ð‚/\r\ä£KDgÎ½•·H‘?\ì\èIdLð/\á\ãû¤ž†ƒÁS.ýð\ÄÍ¸h\ÑÇ®ÿ\0\Ô\\VWOgfbEû‚)£ðR(~Š\ÌP{c)‹¶a#˜\Ðñ,‰\Új;\ÝJ<\ê4?òfø‰5’‡†$O\×Ñ­\Ú&\Ç@Ó… \Û(Tò=	\nÿ\0+T\ÞlN\0F\ëGZ\É<E<	K‡‹r\Ã=6¿¢òU„jd1L3)a>üx\ÏôŒ…\Ó\è­}‡\à‰½~ÿ\0£(ŸL	\'Ÿ¶]\ì\ÉI¿¡¤\r~P\ïj6\ß\êS*\×\Ñ\r9Š<¡ªUw\ÐþvñtYš+GGBpuÿ\0°ð#ô™¹þ\ãˆ\"\ïÈ“\Ý3´\ÜDe”-¿Œ¥†=·¢<¶6²\Óg\é\ìeD¢p£+¢™³#‹À´\Ô:Y :\Å\ä\ê#i\æ)}¸ý\Ô–?¾N˜\â°\Ã\Ï\è<\ÚQ«¥tO>*\Ñ×£`;=ÿ\0\àªü\ÌY¬Î‘Lß‚tò6— †ï½ˆ˜D\"Yu…iûG¦Ÿ±ò\ØA\çö,#)ƒ]‰“\à\çŽ*>>\ZQ\à.N„I\åŠº©\æ©\á&`¼ cK/¢\×~†>A±ðL\Ö-ZZ»\Ö‘10³\Ù\à\ï\ì¨dÀ—ˆ	E °)\rò\Âñ\î\nCª2i1sã‡¹“K‘óec\ÉM~Çµ“‰³«Ñ­{À¶®¡•X\Í<&\Æ\ïI\ÏÔ™Q·›ô}AOù2*ŸU—\ÕÐO\ÃôRy\Ï\Ð\Ý\Û\'ØºX~2~‡	ýZ\èü1=Œ²F$›\íˆ¬¨Nõ\ÃLðŸ\Âø.\Ì\n’•mUô\ÉH£=xg|‹›PÃ¿DüÍŠ½”5xÉž\èÁ\Òt}1‹BÐ¢†&žî£¼ýøºž*\ÂD\å:\Ü>\Â<ŒI`\Ï\Ãø£¦ˆ²M=[S\Ú+²x?Kø\rI\Ôh\èb‘52\ØòúŠjKj¤zŠU„k»¨\Ûì»—f}	R¢ZkÏ“I\×ôD»Á¿üM\Ï?œ\Ô\r½Leù7\Â4T{x/\à\Äy—†\Z\ás\Ù\Ö\Ëb<,7_¢,*1xN„\Æ\Ó~I£T™\ãa#\Ä³\Ò\Z&w<Šô…«ª=\ï¡Få–2·ä¥¨ýÍˆF»ž\Ñ\ZòN\ä\ÈÁ8D¤’0\à~¦O%µ\nûFf\ìá“€#[eŽrý™¢\Ý\àe=\ä˜¤\Z\Ù\ÑVr±\Ö[s)¢¶Jµú¿ú[y \Þ3±)^^ŒªpºdeŽ\Òp‹(S)\ßý.\îyK\ß\ÃOc\æ#¤Hl\Êþ±¸<Vød#aŒ\ÑN1N\é©D\ØÊ’$\ë\è\ì}ƒ^³\àX\ïþ‚\Ò@N\ä)\Ó¦°\éƒ0Šm–Sô*\ã\"újÐúû\r.¬¦<œƒµ™\ÜÑŠò\×9b­^G\ê›aÙ†ü \Ø\æ\ã\Øø_¿l•¬µ¡\í­a:\ÎÅ’‘}¦¥t¦+†‚¥ñ\äsƒqW#\Ò/²ŒðCB¤\Ñ„ÿ\0u®úoc$ð\×x#z\ì˜Õ‘4™„÷¶/UØ’\rôJ1õ\à#\ì-tüú\Ê&¦\Æ|Lc\îGAõ†f»‹elB-\ìŸv[C3+b\ß(‚\Êúd¼­R,‚\Æø±¡øN´A9¬¡\"\Ü\ZNWV©š´š\ìò\"·ˆÊª1_g¡¯\Ù¡;\é‹u±\"|¢·ZtE*5µŽ-ìª°òH¡ŒF¸cƒQPy?‚°T\Ä5]\Õuö\"Hü‹¹šcnRË–O‘¯‘ªm\Ö-\r\ßBž5FN56šø2ð\×ý:¦°9‘%™Z>´\ÆÑ˜(o²6	H\è\ÙC\Ñt.¾‚	N¿2¢CZš#e„_ü\Ã+Z!E#\Ãô%¾‡Ÿx\é	£ÁU¶—~Ht¡=Ñ“aýŽT‚µ4‹¬:}dHjÄ¨¥F:‘|\rH;G©Á€ò\ï(ˆ>\ZdO~Igfõ\ìdMÂ” d\Ï\äÇ†(ñ|\"K>\âF¼\ãúœÂ³:!l\Z$ÆŠœ¨£Š™F!±L#A\çN\rIX\ë\Z..\Í\Å?\è#\ÇIÁ{vØ»4„J\äx¢›ý…”òû“‡³Zn­´Œzƒ™€Wò#%\ØÈ·-`u µ\Z`\ÒEõ\rp}QöL¥Ùºk3_±¡ñ›\ËE3ISÀ\Ãt\'b\å‚Òœ½ü^‡œa‰M#>\Ê\Z\Í3ƒ\Ò-\ìs­0NÏ¹CDc\Ãj3ð7\â=\"e‡$\àL„\Å@‰}\ï¦.¸\íSö²§³5\ã´2En‡Q\ï%w\Él\Õ\ÈÝŽ\Úž†þ´$†Ð™\Å\ÙtÈ·\ìÙ£c&+f\ÖxI\Òýa¹g¸·\Ù\Øa:\ì±mSO\Ê„\ÆGJ\ÕG\êˆ[\ì‚k³û hü„o7ðö?Ž`QDˆ4ü#7\ÂF}Š|\Ç\Ðú\n=V!½\á•HÛ‘Ñ›	oÛžE\Ãg\Ókþ\Å\ì\r~\Ñ–W€)Tö`\Ó6þ‘TdŸ\"½ô7\ÎFaW\ÙvÐ¤\na•š6\ÌPšxc%\çØ£±°1zŒHý>/np¨Þ‰¥\äüß¡9WB°±-4´Ç”²%8gcø®&æ†¡§Ð\Ø|Nn£A Ix\Ê46;pr“‘‰¾\è\îioB2®{\ê##¤\Æ\Ì\ÐW[\×C“ZD\é²L\Ó\Ô`’6ñ8l™\ÔA`\å0d~Fe ‹–ßƒ\íŒ\nw8%q\ëá®‡„|¡\Ý\åod-JLÀö&\é]=ôcW„*Á\Éø‰9`þ;š‹ˆ¿\ÄGn\èRHú\à,bPò=FDL\ÌÑ¸ljnv6(J\Ä|g\0\íg·²\rd‡–%¡§ˆ´]$´ð±M¬Œ´a\Ú\Â	i$ŸÀÀ¸:XÐ¡kÁ\ìÏ†Wx¦jù\â£}’\íV™´©‚™[òA²ë¥»Vº&[y\ÛeQ¤¥Düˆy\áµ{d¹\n°]”~GŸ¦9‘jô¢¦ý~ô(¿ƒùo7\à\'ð\Z†Ñ‡ø^2\Í\åR· q³²§¢TL¦¾]q{}@\Ö}¶*ÿ\09þÁxx\ã\ÙO#E\Úò?O\É\ß~\Ìi\Èób\×(FÙ¸\è?![þÄ‰§\ì]&…\ß‚,\àŒŽU¤]*<ˆ6d\Ó\ì†\Ê	§B3\Z;Î‹\Ñe‰ü\Å„-ÿ\0\ÑnŽ“w…­‰²”?þ$\rÆ° XŠ’ˆ›Bºì„¯\ÈeUÀ\ÔôŸöNŠ–ý‹£\âK\ì‡\Ï\Äø\Ù\Ìy\Æ\Ñö\Ü\ãó^ø¥(£]£î©Žd\éSu_Ð±°³‰–&±¦¿\r~³¢™;«\ì[±”\Ô^tþqªzG¨š\ìÈ´xD\ß´Y‚§Bñž\"\×a\àd\Z\áô¦n‰^¡‚Ž¤5\Û\Ù\á\Ô{ª“Á‰\íG\ß,/	Ñ°ò~Œ\è6B>–Î¢BŒ&±Chnß€–­GFø\Ð\Ï\ÑSª#·cQ\ìTšöip!\Ô\×Á®I\'¡œVyÿ\0–\ê˜%ƒo$\Ö$\á_¬\È@Ê“ýˆ\Ç\Êq01¨¿cúþFt<\0\Ã\Íl\Ç\"ˆx‘NySa„¨\'€´\n\Âq–\Ä\Éq[Y‡\rA¿\Æiþ¨a4t\Å\ì@Œl0ZO1w\Ãù|ÿ\0\Ø-ˆ\ÜÉ’B\Ð@§~ÅŸ\\W¤²÷_®aÀ¾§ Ÿe’ ô=±\Ø&K\É\ÓÁòØ \Ø]µ\åmñ	_\ê\Ë,šVŒ\Ä?<U‰\Z>‡\'À¾£\Ù,\Ò\Ú5ª\ã(\ë¡e;šH,so\ÐÊ¾\âr}™\ã`\Ð\Õ\Õ\Óð\æ§r7®_ô£\r\\2ND~HÌ™õþÅ£qnI?b¾[•A´g¢ŒŠ±…4\Ä\Ê\ÓH !²-\í£\nü\r\â6Åª	7;ü››¡œB\Ë#Oü¥x,¿ú$A0ðŽ(-!¸,\ØÏ\àÊ²\ÛeX`Ý£a,”Yc+\è\ÕF\íQ$\'‡ \Â~\"(\Ç,\\¯£xtA_úŒö+\nG\ä\"Ï¡g\Ê¿\Ä\Ï\è\ßb7dð\Å6ÿ\0\Æ#jE¨D™\éðf..‡¥o6¯L8\å>\Æ_s0³†\ÆNg|7rnn„\ãP£DcôO\Ôoù*¦<û\Ç\Ñ\Z0~NŠJ\ä\Ø5¿¨o=	­a\r!Í±ûi~K±\Óôx“Šˆ\Ì9+\Â°$c\Æ\ï¡gòšB^ùœr\â•\Ù#ô€«\Ñ\ìp\ß=»\ï†\Æp©õ\Â}¼\Z/¢´°O™ —ð\Ú!\Z\ås\Ã\ß\r¼Ûš¸{‹¹ð±£SÍŸ†&K\îqø£ñ\ì»y5ƒ\çDÁ\áH7$û“údžË/ð·h»\è–4IhN±ñ†\Ã	V\ëÁ2¯\ã\Óè±”Î§\èbþZ1|q£ºbl{\n¼Œ\Þaö\Z¸SpÊ¥›\åó	§\Ü,š1K\àXögK’3ú³e&0JK(m\rð¸Lñ\Þnøll‡¹°\Þ.‘˜ ¿\ï\àB²š\ìU\íf2‰ç¢(\Ù\ïü‚R2\ÞË¾†¯e\É[žö0Ì„i\ß\"¤1>\Å“’)W\èi’\å\n\áù†b^\è6^`»e¿EqRP7·\Ì\Ó\Ç­1ž4l#\ÌYÜžÁ¡+À\Åg†Æ³\Âû¢‡\å\ï†+\Ö~m\Årú\æ\Ø\ÝpAø½†²ø?\Ô_´\\4}úf\é\éB\Ð\Ðö1óFŒd„…\Ûlh‹­š­EK\èð\'ù1$†Ð’Ó¢\"\Ñø@\×E™òiü)*›.™\ã\"g”†h<I\Ô6L†$\ÉEu”\Ä\Ë\â\\>°\Ã\íË‰—\Ø5ý‘e\àdC\ìC*˜¿ \Úü\'óÿ\0\àj©qý\rMð·_¡\Û\ÃI\ì«cŒðsCc*ª˜Ÿ‹üHŠ\"\ÐÙˆð\é–~Ä¦HÁc¡Ôƒ\Ð\Ùõ\"“oq/¡ˆo±\'fŸµò)\ÈRZ¶þF^{À\ÛÉŽ\ÍFe¯\ÐZ\\-›Ik¨ý„* \Ì\ïj\Ë?)\ÕÐ¦nS&jZ\å\äô$<#!ž­E6\Î\Ý&ªA0¡ŠÔ¼¡\âP\ê.\ÆTú‘¡¸\à\\”M´eù\Â\áj@„	‘u¼\á\îH-WƒÉµ|d*CW‚]ŽW]Ap¶\Ýù£c9–…X™7¸j\ÔNV‹:O³KüG´”\Ð^Bñ‚L\É,F\"d[C\Ô[“¾•ÿ\0\Ò1­}!Š\ÅCÎ“&\Ñ \á–24¢ta•š˜4†G\î:Bf1\rÇ¡òô`Æƒd|3H¹¨S‡\è>\ëy\ZèšgV\År5‘¡,Oƒssd&W\åy\Çjÿ\0Y’¨x£¼‰R+\èF?’0™­“\Ûy<\Å]³\nÁ^¨Cdµltò%\àÓ³y!\"	”L˜\Ú\n:ö&n\rÞ¿	uó\Î\ãû=±£ÿ\0uüGÔ£ðN``Qgn\ãø)\Ðaô$‚Rx ‚	òO‘–Y\àt\×8¢\Ç\ÂÁ›#@˜D=pŸo#<,Ð·ó‹l÷þ\Ï2D\à4µ\'™\rÊŒf\íbLDLy\\R”ôA~†ª«¨\Æ)ƒ\íº+¤-aš[i\è^À‡@¼x\áQ\Ñ\×\ä\r\"Ñ¸\ÙŸ‘ò‡¯ƒ\îžùÇ¥‰#\Êc_#°\ÕÁ92‘ˆH\Ø\Ù!p\ãLº/¤ƒq¼\ê<¡)ð\ntiÅ»\r™\rþM t\ÆH\ï±`ðc•(\åTŸa\ÆE/DA¶C#L!m’J.8S©¬\Ô+:$E\ß\ØþaM©‰\á~£\ê\Zôõ\ZÁÂ¶3\êœ’12>L{\ä\Â\Ë\è#%7ÀÁÚ›˜òqW¤\"¿“…\Ö:)³4Txl/Šƒ\ÏX\È\ë\Þ\r0´„\ÓF,¨ûÀœ¾žÄ”\Â*FÊ·û\Ó^FmAõ	\Ä\\a\í\á­;¤ö1»ÁyŒA^~³\"5Šv\\V\Â\Ä ž%Nv7\âd™?„¢\Ö!¤¯Húz±Y‘›F<# ‰\îg\'\ï~#\Ü u0\Ðo+•2–d,2g\Þ\Ça°Š—þA\Å\Õ­:\ìOKCW\æU\ìH‡y\\sG‚¬öf?ù\ÐžÓ—\ë\"Ÿ!&>4¡J_CQ¢4&^r\Ën=Q¢\"$œn8)³•_8£\Å\ìh!k¡\ï!ƒ‘]´Y\èG‘p˜¯”~¸‡eL¼##2\è¢BYS\ÐJ]žJ^‰l½Ÿ±eZO\Zº‚-{?¦!·ù÷F…&v±ù1\Ó\ÙCk=\Ú[ÁŽ\Ïy:§ÂŠ¼“Ø² <4³úx4óM\n\Þ\Ëºñ\ìÁt6}‰–˜‚¯\ä›\ß&¾\"„!B¡p\Å!‡±\"C(ÜªI{\Z\Z,ó‰=ŸÀ\ãÉ‚‚Lð/\0ŠH\â™÷›ögj—a\ì\Ø?rk³¹½ÿ\0ï³¼að\"1¾›	\ìd+I\n6õ\ÂRC\ZŠ\Ö\âýšö$¬\Ù\Âlø\"ù*`h9dL\Ú6#ø/ò74(µpQ\\ˆ¸„\"\ßi“-•\ç37di“HH„\Z?„/\ï56\áH_‰H¤²:ª\ë5\Ñtm=–Z\\k\Øò/¥ø6y\ì|$Ž›ðO\èôBkE´\ìð_…ir`\èü;\ß\è98‚A\Z†A¿\Å\\2CU\åðµ\É\"l b	™\ì¶!\ìSŒ8\ì¬u\Ì4 \ìBŽ(=0´2\r4‘%ðe¸OSa\ê‚Á¢¯)¡	þVFÁýŠÖ³\à{½\ZQÞ¾Œ³È•žÈ°öˆ›À’\Ä`„ˆ„\Z<6¿\ê†\ZÀb!0¹›E\Éxcxƒ\áðœmP…_’ªà¸¤|Œj™C˜ð?”S«S=\èuø…&lÈ‹l]\Ûgc\'Á„$Á9‚\rôN\Ù\Ô=\Z~”ýŠk±7“M—²\Z²n4z…§ðw¸S1q´_ò\Ä+/\Èÿ\0Y;\â\ÂaT7¥ƒHž\è—OþF>Ž†#¡\ï†E¬¼E\Â\Z;\Ðþ®[!‚ô gôBþ_G\Íœô=«\Ð\î†)1ô(Dø=!g\ãð%ñL\\<)„(4û6†z*Dn£fS|ICÀ\\\Ëô0ƒF\ÆqÞH5¢÷oe\ÚEe\Z–ÈƒgBwLŠ\á­Àþ	ú8\ë?ž_\à\Ñr†Tm:dš-¯ÀIöp‡kh>µ\à\ÑqvÉ§\Ï$‘xloò ¸o¤§è„ˆ;D6o\ïŠ<18œJ!\äB	‘ˆY\Í\'ýƒ‘\Zð\ÆWðX›¨\à§¬E\ìYG\è\rÿ\0pþ\Â6\âÁ².p‰\Ò\n\ÛI¡4;¹bÌ±L–\ã\Õ\Ô\'g\"X]”\Ð`‡5/¢|Põ\Ï…²N%\Ê!¿\Ó;=¡W‚2†b\Ñ({‚+\"À\Ø\È0ø¯\n\Î!)ÿ\0?|A¤, \ÍtŒRxÞ™8—³0}}¾+~‘m‹™\Ðýô,dòO\èÖ•¡ý\0ø±	ö]F}ž\"L\ÏWL\Å&‘>–\Â\nv\àõò‘¢\ÍDUµd\ÄE\ìmøX™²7\È\Ð\Æ3\ÏK\ÇƒU\ÃÀA¨’™!«/\ášE_¡š­y\r]	÷8þ(\×\î7ñjQ;’h_\Øêƒ•û6\r³¡Š!\r¢;‚\Ö\ë#;\ì\îb\\¿Ž±*\ßZr¸H\ÚE\×þLÕ´¯E=62%\ãz*<\ÃE\åqó¢b\Ñ\×\ÙOE	Z\Ñ>\ÆN\Ï\"B}\Ã\ÝþL›AnDŒyÀ¡±7¡bˆ”§‘S,\Â*˜\Ô3¸?š:†ô<;ƒl\ÛÈª¡4˜®Áp\Ì#\0¹Ÿ<{u5B\áYq×—\àU¨J›ò¤+ü‡¾\Íp5\Ä\çB\Z ™´’·¡³ôð\â›d\á8.A\r\"‹e\È\î\ÅWñ!\'t»B%A‰”\à\ï!H\ì¶XdÚˆZt#k.¦Œ›%i\n\ZƒF)|­|fG\à ¸5H\Ñ\Z\Ûi%ð°„ô´ZH\ØÀ&£]\äµX\Æ6Í¸dEbdœ6R”Bs„ò\Z5|œ\"q±„!EA.a8¬ö3?€\Ù%q6¶\Çò1\Ä7{(LUi\Ü]\âˆÌ v¾$\×0o£.%Å B\æˆ!¨‚°bzÊ¼ù1„\à\Ã\à\07\ÌrK}%.\'!Ÿ844.¹!™·¿bC(\Ç\ØÄ’Ð”zbçºR ¨m\rˆ\ß)’\×ùµ\Ë\Å£2$&*\Í~ƒÎ¥/a4q\×$\Ê/þ–:¯úÓƒA^K\Í+\Ï/DÚ¾:d—„6NOà ‘„¿\Æ\Æ [˜Œ5\ÏcòöCl½ò\Â\'\Åü’I\Ë\æ2a01T·„@jo„„—¯‚\áq\rF©‘I°F\Åý2¼ÿ\0Hû¢|ˆò? “\ìþ\nbµt=!\äÿ\0\"‰A³\ä—.!„¸¿üƒ\'|\n\'\àë Ä¡±ùƒ?\êø8Ã§°%T3Zù/ƒ\rˆ\Ê(a½Žüüqÿ\0\ãô~ž-\Ë3\ÂNZ\éœ\\\È_\ä¥\áò\ì7¨jk·\è¹7\ÂK³¬7\ßÉÙ¢ót/ð1\È\È_b/øW\Â0\Ã|Ï€A!\"\\; †A!ütl¼Aóð„x[„Þž=7\Ð\Ú	‡\î\Ò{D\nø\Úôˆ~™Ù”[û\å¿A†’ˆ„¸ÁŽ\Z¡¼ü¿\Êl¥ôf\æ\Ü,ŸôË‹©\íLû\r\rÆ\"\"Z\×DœLõ\Ïqeø ÿ\0;Cÿ\0À¥#Œ”h88`‹\Éö)^…|¶b£)y!!|¿À\Æ\Ë\Â©@¸\æ\×#]Z“\éøS-\0Õ¸\Î\Ú\ÑEf³ša-¬\ßÀ¶ý\í\Íÿ\0ð\ä¥ðŽ\ÐÅ³D‰\Ñ\è†\Ãnlo„t&G\ÂW„\'+šuðC\äHHCDl.œ&BXJ- \ÑXÛ¼™mC°˜VGI\×D…\ÏòT¥)x\Ï\Ærhhi“–\Ñø:\á0ltA‚X\Ï/\àøZø\á”\ã Æ;fBFÑ¨‡\ËO\Üt·ƒp*‹cÿ\0ñÑ²ü¡8Áž \ÆÃ®/\ÒAcÐ¶!°–Î¾\\_ƒŒ!\nˆ=\ÇQ“¤MN5\×ÿ\0:‘\'‡\ÃGX·\è„!Q#\áhœ\Â|/1Ÿ\éü\íø\ã¢pù\r‰.E®:;\ã?¾\ë+¢\r\ÌªŽ­‹‚Ëƒÿ\0\î3G™ øDY_\ä¨\ßAü˜¾h¡}ÿ\0¾\\\Zþ„|/—ñ\èlp¨¨¸C`\ÉÐž\Ú\ãNð(ü\ÍýÏ†\\	™Mf\ãòyq~\Çòl¥/\ìÉ‘!r¸fð\ßÀ\Üy™Ø„\ãC³¡	ð|\í\Ê\á¾B\äG¸¶‡¸%!vt…Xt›vš\à›E~K¡\Øo-|¢1÷>\Âe_\Ã\ásxürøgcb.(K&EÆ§bœ…òs”1Œ˜—\nð¸\Ð[þþX™\àø\Ô\'‡\à•.‹Qv\á\Ô¾0vWÁL¼/¸\Ê_“\Ù\ä.F ¶-p˜;¡|h÷ða¾4^¸|3±£††\æƒ\Ü}+¢\ä&]¤¾0ôA[\ÂyL¼–ø\ì|®\Zå±Š\r	\Î\ÂÐ¸Z\Ï\Ä|\Þ6\álcrØ—o‡S.\Ä.¤}¸Á¶%;:\åŒ\ÃchˆH¿\Ï\àþlY\ár\Æ1p×²L‰sÉ‘!/ƒ\å\ï–\Æ`c\ãÑ¾\ne\áO¡˜4\ËúI8j¸c‹\ãKq!ô\àH¾/Ž\ÈE\Â\ç\ÇuðÊ„‚\Ç\Êùtl.\Ù\Ø\ÙrR‹†hcÀ\Å\Íq8¥\Êð}Œ\Ó,§!¯\îþ8xø\0V\Ù7!?ÁK\Ê\âp\ÇÁ¢cÈ‘8c\ß|%\Ã\ã®:ø„Q¾W1Š>¸\ä_ø×…=Š\è¢ÿ\0¢ñ‹¥ð¡ˆw¿ü\\!ŒoŒÈ…\ËY†‡”FœþM \æfû©Kü\r%W\è|CN‡²!¾\r–ñB\à\ÆÄ¹j!!±ˆ2ò©6å Ÿ\Z.Œ\ã\Ê)£”°\'\Ãe)Kó®p¾Oƒú_\ÅÀ…N~\ÙÖ¾¢.¨y\Ò\é/±\Ø,zNI!$¥¬Ž±)gI\Õ\Ù.ù?\Úg\çŠ6è¸QðlB\\#¸Ó—‘¬Ÿ–ÿ\0£³±‹+…ÄŒyT#•uÿ\0\à$_¡\ã•8„\ZMªôJL=\×à°•&«~Ê„W?ƒ\Ö\ï]§£	D¿È—lOŸ\í”01©~@„“i¬ÁnV6ŸØŸb¯\à\\=!†ù‘FhøNe3\È\Æ{\0¾6\\Qp8‚ÃŒ;\êb¤!?Àø\\¡|X\éD\ï\\W\Û\àU`]Žö%3{=\Ñ!u!$=47Cª¤B{¿\Ñ}¸#ÿ\0lH\ïböOÿ\0Pp ¶Î‡¿\Ï:.+\Íþ\á\Z!ºBò“‘1ñ§À‘\ìN°\Ä)E<q_\äüš)^^r¾‘\Ñ_TH ÌZ\Îmø_®\Ý\ÉI²\Ý”ºhß’£¶\èj˜;º%\ÚN¬ˆ\é´þ\Ä\ÇMzh\Ì*Húfn\Ò\Ñ^@—úýB3Ô—÷Cö%OÉC›\ÄÆ¹ô?\ì\Ä…®a&&7÷\Ê\n!8­ðN+¸\Æ.£p&«fœÚ…/,¼3v8\ÞGgzôd“N\Æ\Þø\êMdº/•\n³º*\éZWaˆ›üŒV¸j“Áf1Fs´\Ñ\èlŒ\á\\˜¯\ÐI>„š\â\à£Ãƒ@<iú\Zú\×\èY\Þ_÷ðC¾\äi(\Û\É\Ï\Ã\ì¤ð›E¶‹%~›3Ò1:ÿ\0P\Ï4OC”z\ëŠ}\Ê\ãFjø.h\Ó\"1b˜/ÿ\0NpbcB‹±?#Ùp¥‹”\áNÙ’\Ð1\äaÁŸZ-\Ý3J\\\ëÁžSxi*\çCÀ¨i’:\Åó_4!\ã\Úö\Æó+òC+\ZQ¦8®?l\ÊV«!\'\ë–\è·\ã#\Õe{tª¢,¸l\ïø­À¨\Ö\Ú$W\Ö7\ë\ÒX¿ZþÎ·þÁMà±„ðR1ýE.W\Ó)hÅ‰˜‹oUú4\ÐÑ \ÞtQðˆã¯°þ\Íx¢gh—\É÷H¸|‚<	›GG…Ž\Êq\ÝC\Ó\ßò-\ê¸Mÿ\0þ¤†dm‡‘+\Ã/±¬™cY\Ñdòš‘\àÈŽ\Æ\ë\èh{D¬]\Ü\'ýÿ\0¥,—$9´\Ôý\î/\Ñ^k\á?\Ébµû;\Ö\Ô\Æ\Ìÿ\0ã¾‡Q/G\Â3\Ö&\ít?|Ÿ\Â\Æþï¡…û\å>¿’\ÐX\ïU:}2\í+xòG&k£\É\Z\Üm}FfxWl€”—KŒFƒB\Øø¢b|.54b/y8\ÈA‡\ËŒxd>â‰‰þ±Pš1D2—¦TZtšn)¦Å–}|ß9\íŸ\ë\Í,\ÞnE_‘a£U\â\çbdOX?&ŽPS\êñþ˜§oKýŽ@D\Ï>†6\í\Ó\×C¨˜ò#7™¦a^\Ð\Ç\ÙÁ0\Û\Í/£ö¤~\Í\×üZ•Á!\Z°ö$\êÖ“ý½þYþ…\Éy´Û¯ið.\áhBcl\Ø!q‚á²œ4a³<žh•LLiµ¡=\\h™.\Z\Ê\á6\ÌF²ð\\žuze\rO\ïû\É÷£F¿ø™\Ù;}Ÿ‘8£¥ñ\ì¶{‘s|À¿²\"·\ìû\'ô/\ãal“zOÀ¢\ÙU?Ñ½ec¥úg[\Ó\Ú	‘µ‡Û‚o#6+œ\ïôB\ìô4\ë\n\ßò?ø™-\Í\ÈÚ±\Þzx‚øk‘\Î\Ým\Z¨\î\éš\Ýö<BN[÷\\$\Ä\Ü	¤7\Ë\'À\ÕFQLP˜Æˆ\"\àˆM´|4\\U\Ì\à?\Ú8!W4ƒ^\Øô\ÙW\ä©þ£\Òo1“ôò6¶RõÚ‡“¶½ø»\Û8£óû/À\Ì,™ôMÿ\0o\rm}\Ùû~\Ë\ÓÁÿ\0‘©¥‡\Ô7’”Þ¿øª¿lð\î ›R8k\ê\Ð\ã%øA²~¤\èûf÷(ß­\à%tCoJ;\ÆI\Ðk\Ò\ë\èþ\Çdj5\Ë	\á|\rü„!p¨¯†\Ä!Ž;\âŽ1\r¶˜Ð†B‚C,{\Z\ãƒ\Ô£ß’ûÀ†%;–\Ä_/¬‘\ï\Ð\ÜUn/ð6dHvŸ¬‰0\Ôq²\âx™÷qU?\È\Õ\èœi¢˜Ã\ÃC\ë\æ”ò3\Ì4üød¶!Hˆ‘ýŒ~iªO²o‰³Ÿk]Ž†£>\í+±†ýŒw7Ln_\Ñ(%¦•MôüÒ‘Í¶œljN\ë\"ŸG•’j½¨;\Z\Ô›ž[	0-ùý|ñFø&1«\ï‚0&^R!	\Ã\ß¤\Ði‚ó(½ˆD1¡Nâ¡²\ß\ä#\ÔK*S\nOG\èpÿ\0aýG¥ôT~\à\Ûûa\åöv\Åg„\ÞNð¢£^Zj+`#dðöb\Ð\ìp\Ó\Ó3N	\ÖSsú2¶\èÔª¾\íbõ\Ä\Èzõ\Ü]\n¿\ØF§ÿ\0‰®\Ë:>—û‘–\0ú²’E¿ÇŠX²•_À‰3À¿’\ØSþŒs4Œv\Ö*\ÅÇ‰‚2^(\ã\ã\ï\Åp¨„\'L¼1\rp\ÌNÁ\ã\Zh\\\n7¾>\Ìp£SøŸ\äcÿ\0h†Ýˆ²\è@¡”I`«/n\ÞN„!¶w­W…\è\\¯úÁ¥¯\Â(,\Z:,\ÙD½\ìd7‹‰\n6…~\Í}\ì6¦F5¨U2oöNà©„A¯ô~×—Ï¬ý3û\íZ/]Äº+\æ7Wù\ä7mA}Ÿú\ÌIYC½\Ñ\è\Ç2Bú™\ÏEbôy\Ìj\r?¾¼¡±‡ŽK…8ù1ðqÁ¶\Z˜—‹\ÍñAs´1\Ã\ßóCiŽÁ\ã\n\ãh_ò[Ò•ž™š7 DŽKoÀaï¡ˆ\ïH‰#ÀRl\Îý2.”bšf\ê‘Õ‡\êlG\ÃF\àýÌ†\Ü\ÓL…&ôÇ«:NyƒºuM,lû\ægü\ä÷ƒ?\í\Î\Ì+„7\åhÄ˜\ê+£\ÛV\×\Ñ\Û\ê/\Ê;ÿ\0}ŸŸ³\'ÿ\0¤\æÏ¸?µ\àZ\Í\çÛ‚\ß/‡òRp¸¥1¡¡\Ù’²úø‹(xN™]£\"^†\í\Õ/Á-õM#ùy´²o²K/¥X\é¬\Ñû:2w¤Ñšo\Ú{*Õ±dL0‘`­°\Î)¿°&óˆfSPŸboZY\Î\ÛP‹Zà£¬¤i¿|m)\ÏÈ°±?\Ê0‰¾Yž\Ç[\ïÀ\å÷…}\Ãòú”GSö5zo\\“\ã”JŒŠn\ÛÀ\ÎSN-\Ê2™\ç¶TU¸™`‹x/\Ð\âÖˆC~6d#FùÀ\'\Íü_‚‚0‰23\"Oƒ\á‹	\Ç*/+Ž˜%%®ð\'ýx!f[ô›,\Äýqb\éb[œ\Ä5Qjô+Õ¯eQ}{6C3Õ¬¯(üon\Ì\Õ\Ì6Ê¿“EÀ\ÏDN¶™zbÜ¬&ý]g·Dñ\r_ÐŽÀf²ÿ\0ÞŒ‹¼ªð3þ\ÊBaô6\ÛmºB¦U\Ê7ò~\Z…þDRv€\Û\Û\Ï\n\×\Ï}	Y_\ìc™¾(\Ø\Ï\à“_¡ƒdDB3\Î†¹h|„¸Óƒq\Óh\Ãõ€\ÙJ1,€¥¼«ö\Ð2e“\ËtJO\0lyˆ\ë\È\Ñ\Ï÷°™\'ý•®\Ù¢ÍŠVIºt24£Èó™QO_\ÅI\ì-™°$>\Z\Ò\ã5\\\Ñ\r\'¢7\äO±cUûÿ\0dóýLw?’ž\Ï(«\Äóý>™£o\Î6B*\íö\äÿ\0±³.Ið†\'ø\Æ\ç$lHžøPøf†øAô+\á‹Áô\ãõøoð´\n^\Ã+)DJ\æw\æ\Û!\r4\Ó\ìk³ŽS‘46\ÖF¥ˆÿ\0Q©6V‡Ø’µ%^\Å¼¦£»\ç\Ñ¿’b¯k\Èö*K’\Öþ9¦—;+D·*š\ë\ìd­°¨óŸš1¿\íòº˜n©\á\Ð\ÆÕŠÈ¡ò\Û,Zi5\ì}Hå‚_7ðF\Ê\âŠ\'\n5\Z‰\ÑN\Z\âcƒhÀ×¯’˜—À†ø“³ÑS\Ð\Ø\Ý\å\íºû/C ô.¢eØ¨É–—³&Ø°91ŸôG \Ëz%E\åª¥5Oc<M)´’_ø3MdJnýx …\Ò1\Z)?Ò\"©\ï\ncðh—ú2T\"}Ja½•‹Mÿ\0Dl6\í)^\ß\\ý¡¼ð\Æ>	¼\í\Îú2_ˆ\Ô\È_à± \×=±\äiúeH¤f÷L\r¾4\Èf\ßF}•ú\Ã,HÍ¿\àú††øRÁÑ¬s4¼â•¤M^\Ð?	|¶—I	HD§Qo³”\ï Ï–¤\Ïw\ì7³m¿ù¹´¬\ÂvL\\oþ%rh9û\Zö\âS&17†Ý§\ëk(\É \Ö\ØF`¶\ÔÆšJ\Æ\ãw#´³òoÐ\Èõ\Ãú\áˆÀø¨|\Îj6ø²E®\',f8‚t“œüu\âœšš.P’/ô:¤}¬jõ\Ú<¥\èð\ÒdÊ”[‚^Oð}\Û\Z¤lZ½‡n;\ÐË²cE\Ð\î\Ü\í÷†ID\Î¦XÔ»lj\á‹Ú„2À\Ø\Ü0˜\Ìj<O¼\ÌÂ‰-«Å†SWµD½3ûFô\ØJ<VF\Í:!Ÿc,u*ò:;\n\í¡!ÿ\0\Å\åˆC\åñÿ\0!Š\â’<C>\Ä\Ý\å>iF\ÆWÁùŒRRøµÎ‚Ÿ¯žVOU/\Ù\Ö4s\ÛòÑ’Œ~£uO\éý¢/l˜¢›û\n·ŒBk?‚¬\Ò(aRC‰7¤X˜\Ýö¼\Îfž‚]þž\nú-ÿ\0W+ô\Å:\\”¦ñ´°7™5hUŒeW‘ÿ\0!‘ƒ€Ô(¿\×c‚§K´7·\Ølò\Äú5&þÂ»ù‚Uµ¨™oj&\×\ÏÌ£¨Q\â›^Q1\Ã\âÛ–3o\ÈQ\Ô3óÁ¸¥Á²\Ã\à½¿,lc\áA†\Ë\Ë\Øo\Ô7!\nD€¶†\ä)J\ÌF\Û\èX…\ìFptS\Â D¢—„˜3R¤\Î\ÅTôO(KðB®†,\èÁ÷Õ–, E†`\ÏrR\Ô[jRn¿Bô\ÅGø.”z\Ùø\ÉÃªþ\ÉÖ´Oy<Á\0¤˜Ú¤ÿ\0#\ïýòyZ\ë9ú7\ÆEó˜†c$z¶!)*~\Ý:\áüY\Ð\Ö3ø¬q%\Äü[òC´>dóM¾\Ù\\1¢‹\â\Åcþ‘(\ÃBBCj$Í¿\\JÆ½„SÀ£\Õò.\Ã \Ú:Y%9¾Ì¹&°eÁý™_~º.‘N\íÁü‰•¡\æ–,V\ÆAšÿ\0f…<Bž\Õ~Ã­:\à\ØZý^‹ô\Ïûþ\Ñü‡ŸûðÙ¯ü‘8+\ß]I‘\'\Ë(ø{\ZBÁ7žN‚gžÂ¢¿¾î·³[Á´~,D~†|rý>	ðZb¤¸‚K‡8¸\ê1.$\äs¸ ª‹b²\É5²#	¦ð\ç1\ßb‚k«\Ë#\Ûft*\è­öSð?]e=\Ñ\"\Ä[IÑ„f\ÈAuÿ\0`k­¬|S¹ö3xmYuö$\â\×%\â‰\àÁyk„Ë¡¿øŽ\Ó&|ˆœRýC{\ìnU_„VKý\Äv_‘˜C\Z\Z\'k\Ã\æ½õ²·4¸À\Å\åJ¸\\BÌ†\ë\Ê¢J£zgF“Lß°Þ†[7\Ûdv¿G˜¶»X+)yF\ç\Õ<ƒ.\Ð×¼å¦\âô§\å\ÌÁºÿ\08ñ?\àEø\\±šðøF8\Ï?bFX…^\Ã:\Z².d0µ1\Ù~Øªo\ë„_ƒø\Î\Zx^ÁòW’\àl¿\É^†D!\r\Ù\ÝO\ÂoGù>†v\r•k±‘\Îÿ\0|ð	óo\Ò\'¶ß‘/\Ï\í³þ5Šñ/¤&\ß\à\Æ\Æ1¾0¡7|?ƒ\ár0”Ï¾Bå›¾rýñJQs¹t\ÉOÐ˜\à`7¬\"\nu?”!9J¨\ÝðSÔ‘\äZ‚p›;¿bBi-p?•ø#\"ø1Œe\á\n…Ãœ_eEã¡®[\à\ìš.U`NšWô;ÚŸA!®>&%¯ûD_\æ‹:tœºdŒ„!h)Þ’”z+¤=\Îø\ã¾\Ê\ÌÁ?\\Qr_1¿\Ä7\è¤\ã?ƒÁ›œ+ga\á%\Ê^\ZTˆ¨¼ƒÃ—\Ø\Éaõ\âž‘¨.\Ï\Ú\à\Zý‚ÿ\0\Ý-¯\Úzÿ\0³ÿ\0´#´þE\î»\ë$.Ë³òg†\Ï?\æF—\â\ßÁOŸqp¾Àô1F#O‹\ß”Á>|!\\3^×Ÿù—xþ†J\Å\Å=Ÿ”mùùU¤2ö$pôö¯\Âð@\×Á\ã>i„,6?\ÞOpEð\Ò0\Ù~\n\ÌD|®X\×Á{,ñJ&,Œœ1ð\Ø!ŒÁG¸šCw\nv µG>õº\ÃB\Î[±ž8½\Âö\ä.K‡Ù\ß)3Ca¨ÿ\0xaü\Èl\\4„\ÆhœBqA‚_\Ëc|\\¥|fIx|g\â\é\Ø\Ø\Æ;p|h\Ì\àh$‰Ÿ\è\Z\áIÐ†3¢	\ÏEóf4°‹eò8ƒCb\á><Ä‹n…v> \ÄTaYW\ÃR%\ÍÁŒˆ—\Ï\rˆ¼Bx\Zšð\0$5‘#\0‚5,lÉšB´z0ö_\è\\ð\ÖO\ÏBŽ4úGÀ\Ö\Êl}±|¬1lXp´\r‘I<\ÈOŠø1±¸^iü/˜Nh\Èhu:|ŸS>\ì£p\ë†Å›mˆð-”Ì—“\"¾\ïø“FJ¢|9Ÿ\ãñ5þx\Æ´Aðb\æ„!>+–>\È\ÅÆœ\à†d¢dH˜øB|>¢\áðy÷¾ŸÈ–x:‚›cÀð\Ó\Ý\Ä3þO\èL\ã–&\Ç\ìnp&7‰²\å\æ\ëùN\È‘ðŸ\ßc\Zó8Ÿ%ð||ð‘¸O\"|ý„&<—\â\ï\ÜcÏ¸F^\Ú&ab\ÇaN\Ç-‹(|I~\Ãð ™\èl4†*úÀ’q²ú,lúg\í•„&þ¾!\×ò|?‚\åðm\Êq™ÉŸ‚išE¼c–.«\ßÀ\Æc¦Nj¥\âB¸\îfŠ‡o€yL\È\é\ï\Âþˆ\ZK\É\éX\ë\Êüò½\äV×¦\ã	ô\ÂóB\Ûø`©t„>[/Á|\Û\ãcdl¼2‹‡\ÂL„ÿ\0§\ßap!‡&d‰—\Ø\È™†ðp4úfVq‹#trñI™%“Ÿùñô2ÁñQ\ÊØ†\Ë\Æx_-nÁŸ£œ\'\Å\âp\Ò57ðX\ÇÈ§\ì	AXwƒ\Ùv\ØÎžFm \Ñ\æ;mBòª<ð\Ø4\Ç\Ý[Yh•C;ˆ«\î¡r’ƒRµ—\à\éeð¾)W\ÂÀl¼\Ñ>,q†%\ÄuË°\ß0H\\N	ƒF†|ðù<BcÛƒ\à\ÝB°\èSdw=¨ß¹ý‹—‘¢dwa¥H\Ï>©ž*Zÿ\0˜¸\Ó\årÄœ¨¾\Ì\np¹cž\Í0\ÞD=qE\ÆD§-Ç·Ø…ð(×’\Û\ïƒ\Øü¨\ì‚j±•Xfm+\èc|:>°L	R+ZTO\×S2¿\Èôióƒ\r\äÄ·”/ƒŠ2.Z&EŽŒŒÏ2!\"\Å±0¾iø,\\–¸z,lc@\Ø3›¡e‚o¦\"]-¢\\\Ã\ÐLg¢’\")\'tþ—\Z1|\Ø\Ü2P „¾0\Ù—\ÄöhŠQQ¬FIÁ8c\à\Ûò.‰\Ã5gc¥ð>˜ò&°A<²YƒE\ÍLT\é\Ë%¶0·\r†%LL‘{>ºÈŸŒ”\\P—\Ç÷¢„\\#;\å.21Ar\ÆÁó!e|h\Î\ß|¤-u\rƒf…_	£BVkØ \èm¥×²p|z5\áû\Ãýœ=ÿ\0\Æ\á\È%ð~bŒ‰”e%\Ì|!	r\Ç\à]¾\Z~yoùøBƒA\Æ\ß`L\Úk8s&Rf®+\\\Ê:c^F†&\ÍL~\È~nþB\×ø(Å±À—\â\ß)¶!?‡\àh\\‹‹\Ì—\Ålà³ƒ¹ {\á`ü‰Á¿R4Pûxz«Ú¡ªN\nýbP\×:m\é£\Ó$™Eó„!8¥(\Ø\ß	±o…DÌ™/ø\Òú\'œÔ¨—;ÑƒWä•“+ƒ“+cöÇ€\Ãy{†ð¬LN¡ý”¬?†\æ·\àþ\ÏQ\"\å\à\ÙDø\\4Á\Z1ö0\ß\n%\Â\äb\à\×\Æ		„#Á“À\àmû±pô\Æ\Ì\Ø\ÈFLð©\rh#4³#N;l\Â\àŸ	—‹\Ã\à„Œ ee\Z†\á	|/Ä¢ ‚\\\ÒeÙ“‚dN/\nt#~66\ÆCw™x3—%Qp\ã‹Âˆl|\Ò[Z1Nh…)J1±ñ7\âQ¼kHa‰(ø„\Z\É\×H\\A.À¤\áò\ÕC\Ç\çþ\ßÙ·\àLððQ¡\Ø\ê)x„+\á´0ÇÀ\Þ8<õúB‹\à\ÊR”£c\áB\"\æ›\å#”O” „+	òbqxG”Á\Zý‡³‡°¸·Ž7?ÁŒõ\Ñþ\Î\âciÅ¨ °N«‘ð¼Ÿ%>hk\àðHd\Ê1‹–ù\\–øB\\\àø/£øÉ£³ûü—\×	Y\\QM†\ÉG\Èg¡b)\Ðñ²R¹³E\È\Üu=½ÿ\0††\ZåŒ‚¦\ÞeÀ\ß\ãÁð„bBø7\Æ$.¶D„>øÁú20>†\Ë}Œh\ÇÆŒo‰•$ô\"\ßÀ\àñú;;Ðœ?&t‹œþ‘oÅ¡¡¢r\È.¡y+r¾‚B\álA|Zp9¸œRp!3ð—&’+\Ñpb9£„ ‘G¸[m1gò.¡\Å3ºkÁr5>\ÂÍ·Ÿ\ã\ãÀ\ÑN¸bk\âpˆA\"H„\àHK\àønù|\ïô!\Ç\rÇ¼\Ëkö1Ÿ\Ø\é$3!ò78\æ7\r†	<p\Ë\Ç!º±\èMNU\èxö#\È\Ðò=¬­\áˆ±ñ¼AòQIp\Ùc|Á!. Š\à^B)|[\ã8¤\Ä\'aG-ñg3i¯¡¿#\r‚ð\ßoc~„¢\Â)“%ôá¿ˆ\'V»*)öz“\èo\Ìkú,6\Ûø\à_+\Ä\'\Â›\åHHEðBœQ¾C²„(¼sF¢GÀ\Øò0&\ÃþQfg‘¢cqbf\ÂP÷/Á|\É&^Q\Üú&¥®¶o¡\Ò„\Û$¿\"\Óô/Ñý\Z‘™±\çÆ¼(”\\	„\'Å±±±ŒYsHÓ°¶*6@<&˜ø/\Ê\ÅÐµC\Z˜\îð>\Æ7~kd(s#ð,t>\Ó1²B(L6U,.\nüp\Ñ\áÿ\0ô¿\È\Æ!ð\áO’\á¾•\Å\\a¢¯‚#‘6g‘‚¡\Õ<ql\ì8Ø”\å®&6(u»½16”»½‡‚\Öð5\è†\'-¯ýˆ\ÞX\ä/\ÆØŽ¸‚_+\Í)GÀcŽ\Ã\à¤o…$¸n\rü?$;)b_\Èò\Å\0\ÞA‹\×HûS†W\Ë3i	yñ}™\Ù6eÿ\0\Ù\ÎOi¢\Ñì£¼\'öYx[Š\ÄÁ°\Ñ0Š¤\n¤ˆ¤/	\àžyøg\Æ\ØøllTErqsý&¶\Ã\Z0N$6n†[V«¼.p\ÈC¶pm·\Ù•\éÑ±\ìX\èM·½xB	Ff”dú^ ††Ï‚°¸+°‚\n\Ì&_\Z\ãMòù«E\"ðý‘ºÿ\0k\'Õ±/81\Õ\n¸b¢\Zqµ\rð{!\è_\ß\á™\Z§¸€Y\áqG fI\Ñ+Ñ†¡8¸…žcŽ\Z¡D¢±º/0„\ã%|(¯RŒ&}FþZ\â\ÈÀHº\å„wüXE\á,~`x”‡ht(ï³°1\àte¼RmGµì¦„^Hdwp”ˆ†ô$E«±\Òÿ\01§\är\Ã;\Çü\èû°ÿ\0\0è†‡\Âp\Ú$4|!B|!B…ø\Ý\ács„$\Â\æ	7¥Oü\åDH|R,)„x?o\Ö\ì_bor®…s„—^G\îV^>„ú\áF\âs\Ð%\'—\Ù\×a*(ˆd—Š§³\ìB˜\ä+V\Ï^8k‹Iðœ\r¸NücˆB„ÿ\0ˆ’\"HJ,\Æ/o\à“o~\ßðx\×l\Ä0†\ÝF‘€\ØO¢®;¸‡ \Ýs<¢c\ØW\\Xû|ÀV\í\Úð<¿ƒ@×¬‰ú3\ÅvT»¢OÀ\ê\'KšV\È\ÆÄ‡ôEö3F„2aó¼S˜NaNV¾0‘\Z\ZÄ›#\Â6\Ø]hHÀ“bOD\àH„cð‘Qz^„l\×Á1’\ËIGv*o\ØùZdb^ƒ\ÏB\à\Ê\ã<L@»hI\r:!i¬™¨R2\ì\Â<•ñ•~þù\\¢d\å3\Â|#!\'ð/1(¨j‡Æ·\äOØ“\Z¶.œK³„	²CZO&’O¤&®ú¢½—Ÿn\ÎX£_m¯Á-o—\Òv‡$\Þ\êlÁpˆ\ØyLü‘µ\Â\Òt<©\r»\"L1\ïE\Ä\Ã±>„ø\\>\×¿²ÆˆB!\rxvR‚U\×dF\ë#UÀß’ÀýÌŒ™¸£Fü\Ö¢$5H!f­Åª\Û\Ñø›§«\èz\Åt´{\ÜÀ—²\'§e+ \'\Ú\Ê\ÊOÉ±14¼“S±\Ü$\ïËŒ­	ñ>3”\àK–¹p)\r²D$ôQÍ¡¡BP\ìk\äfÙžÄ‘x%\ÅV\ÚF/¬­í‹Œva,¸\ëÀŠLs\Ê?ƒ—ö\ÅXÐ—ˆº…½„’yrC^£GhjñA½„\ÄÚ…\ÎQWöe\Óy~øÑ­\'xŸ	\ÂE7\Ãe“Ÿf\ËÉƒƒ\Ü ve\Ù\'		Ø‚E\ÈúÖ½n@ci½ðœ\íBú·ôx…yCPVb¡W&Ò†\0‹\ì/\Ì^\ãòDöiWk4¦\Â8–˜\ÂA¸\àúö$\â†ð¤	<\à\\ˆö	\ãn\âŸA7\nE\Z…\Î7Árož\Ç\Öù\á>:d\É\ß$$#\èMb˜5Msi!ªÜ¬¦¸\ä#EQ//I€n˜8¤ U¹±ÄŽÆ°ˆ‹}õö=@\Ñu\é;=,ˆç‚žD\ÈT`œÒ’2\Ô|´–?q§‘û\Ùc\í\ÃbOÀŠ(B!>\Ê*›ø-¦úf\æý˜ÿ\0\åù˜fB„6\Þ\nv_ˆ*«Ö‚Š¼‰!QŠ™ö/±\à3D´³£µX»©¯õ÷[\'&?´,\Æ~™:!\Øù®\Ä\Þ\É}‘z<œ\í\ÌL˜û\Âññ¿7\È{²\áÁPŠ)!A§±uü¡‡¶ôtT-‘\íÿ\0ž›‘#>*m»’¢¹ü\rðH°½|%HU¢ý‰6fGµ”º<‹¤e\æT.P–•ù?¿Y\å¤\Åÿ\0P#\Ìü@™[\\)ñF‡¹>…\ã\'\Ç\ã\íÄœH/!§±>7\äþ‘\äcûYµ—¡½s{\â|\'\ÍüXÐºcDKÈŠžxB\î\×Av¬\n,¿¡\ê\Ñ8i\áŠ\Ä*Q&}§R\Z\àY’\Ïn(÷\ËøkNð?\"H/þa\ÆX+ÿ\0ý\Âf~DÎ‚l\Z0cÁÆ›<\Âodz\Z5ù6ˆ²¿‡5ÿ\0\Øþ¯`Éµý¿„ÿ\0ñ\ÓðqÉ‡€%Éª#\nñÁ6!%\Ú=‚`bg`>¼dW§\"œ\ßH\É@úx\ÇÁ|˜ù„ ši³\ä\í‡Y|*\ìMÇ°°‘Þ‹\é\íŽ\Ý~Mÿ\0<?„ŸþF=¢+Ð»E8&=–>„B\ëA‡[£\"\'Ð…øF¼=\á\àŒcð„|/ò3Aƒ\ß„\'\Â„ÿ\0+\ÉÑœ=Kú-³ýžO\äV\è8\å%\ÂJ1I¶\Ñ6Çª\çFd§¶{˜ŠŒ’»,þ\í‹ügÿ\0\à4\'°‘ÿ\0\èyù\Å]\Æ{T4æ‰¡L\Ä+BÓ‚UƒˆþL›\á:.kMv\Ï\é$\áñÐ¿ühBVžÇ·Î¢|>{â”¥/ùú˜þøxC[)ú/¦fö5¶ F\Ä\Óhô\Ée¶±#)\Éö¸¢½bŽ£]\Ü\à„—~h=M¡8\\/ƒcÿ\0,\å \Æt †)J^!Bž9°…’§=<!tÌ—\n^i\rÑ¡eÉ¯h^\Ç\ï\Æy¾ÆŸ”—\Ñ\Ñô —¦{¶e¡²h›,}#n\à¾ð¿\àlý‡\ÆÂ”¥æ—’ü±þ6¯¨†Iû\ÅÉ¥~\ïð\ßð;¡{\Ðÿ\Ä\0(\0\0\0\0\0\0!1AQaq‘¡±Á \Ñð\áñ0ÿ\Ú\0\0?­AgÂ©„´L„@‘] l\å\êomdõ2rœ’fôÍ»\î.4\â €b\Ü06Ù® ˆ\Z›p*u9rð\Æ0‘®\ë!9-i\ÅM*†¨\Ç|0)q›,±+ “bÀg¹{[k.lˆyD-Y¸\Z…`Ë¯w£ˆ\à\Û\à\ÜÀBù†ž¢%|t\Ì1µ€…Q\Ï1k<ˆ\é°q‘·\ÕV\æ„o\ÃKýyp/ˆ\rsbœ`ªLÂ´@(¸\ÃÎ´\rƒ0{\ØItM¹˜-5¡\î@Ö˜(-‰xb%üÃ`ˆ­ˆ¬\Ùf\n¡\ãÜ¸¡\Ñ\'·\Æ\'”A\ÜUˆ›ºHÓ\Zšz	Bi¢Ä¡¨HˆPd\n#E\ä˜ \Õü\Ô!i­û\Ø%_’2Žc¸D`a\×bµ\n¶¶22\Å\î,7CL*\Z„\È\ág›³†3µ\Û\ç¶${U5>’\Z\Å\Å\Û\Úó6Ib!\"›±Fò\ë–-P;\Z?\Ìò\\L,±Â‡\ãHº¯JX©¢X\ÄÐ©¦Ã‘j,\Ó\\)•P¦_,^\áÞq8\êsÜ«\'¬‚\ns™q~7tG,)Œ:`°\Ä\ç2£c~ \Ö\Â\Ö\îlKÙ´¯ÿ\0#\Ü»€:\ÇQ¼ ö\×Ä†ñ±¬Bk |öU.˜Š\ç0%½9†\Ö$ŠŠœÐ¸‡Y-û\\LŠJEaß°2ºÄ¾Àó†–¦Xp JÐ…T	²—}\æVÿ\0:/(øb°\Ì\nJ`S\Å\ÃE®À	\È´ð‘KüU¸JË±¢4ú`ŠmœW\ã®\ÑE• ±\í¹Vk¨]\Æ\Ã%Ó¤„v\îP\äIoÁJF2+ÖŸsõ8%\Ô\Å\ÄAIPg‘“+œcD²¸¡°ƒ/¡Æ²A®e5sŒ´x‹kƒF\'Q%0\ÝJ@K®Z2ž\à‘\0Œ\É\Ëµ\ÌP€J™Åw0on?`o\"¯1j•q\0¤[€\ë* $T6<D \Î\ì\Ë„¢\Íõ\Ùiòr0¤8\Ù\Ë\Ô\î3\Ê\r¨ñs%\Ù,D°9K—^WF/\ë\nYu\ÒU“rÿ\08µ(Îž\Û\å\Ôx(”ó¨w6`†Š\æf\ÒPp\r”ŠIQ\ÏY4\Þ.\Äw\'E•¬‰\n\â\\²\íŠ7ýe1‰pª\ÔiA\Ð\ÖÄ·U/YHŸL[X€Š·\ä\àÃ„…)\Å\ÄM,U\Âd]\Ôfµå†ƒ.ñ\Z½•9©T\n’š\0ò\Ê3{@þƒz\\\Þ\ä-FsÂ˜¹R¼‚;cp\ìø–,µ—5(Xm¢ºa.\ÏQ²k\Î7¥\ë+C±eü@B\È9ù/\êRŽ\ï0R\Ðù,¸¤Ð°;\à:‰€<ü¾£–Ž¶ì¡¯\à\ß\âœ\åûB\â™\Ô½Ò²¸\ÖQ°]Œ\ì\"§¤ýc·i•.®\n,b>\ÈA¦\æÀ	+\æ\r\ÈH)\'z­M8¾·9`)óñxmJ\ÐY1Œ z#]Œ\èM\ÅXx\ËK[VKÉ³{S–\å	\Ô#¸Š\äRø™[¯3rù˜°&8÷4×¹P¢\æ!V¬,|¦lß˜WLv;¯ö%\Z`ˆkQ\ê/E¯¨U.ü$\î6õ3¤F´\ê&½SVcW\Æ.\â¹D§›Y29ò®\ê\È*‘9P c\Ú‹U\r†ck†\Êð\Ò\0-´‰\Åó\rŽz‘ûqu\Ì:“dCiPTÏ—%Fò7£\ÓBkQ$\íØ«p\ß\â*\\Dˆa)³\ê\rkð¥¦\ÜqU2ú]\\\Çr\ï;l\Ü<3®\ËüCZŠ\Ø[\ãA„²A°D«‰Kh==DdÚ¸Na#¬3\Ê&Â¬÷l·o\Ì\ÄjPÀJÁKÌ»T¢\Ò!7¯1­M ¬\Æ¶\\ñW˜\í{œi¼R Àðu\r$R\ã\Zjóˆñ\ÙA(a¾ D™£ ”B«¨H·ª ©Q}„«8c¸©O‚\ï\ZUYl(\â\àƒ\\Â¹›(Þ¢hûAx2\ÕQÊ´@œÆ¤!yŠ\r—Ÿ2\ÏSó\á\êó8H©bfõ\r­\È\Ú\åOp¡\Ò\\b•n£\É#\é—\äR/W-\ë¶•÷Ó¾\ÈKkþ©¥x\ZŠˆ\ÃmŽ\Þ\àA\n¨ôDz\ÙA²}DÜ¬¬5B§´©E\énUU\î!ŠbAù@\éduR·>¹ˆ@®d_{ˆmòb\ç\"\Ö\ë£9¢>b:¢¡¹\0‡\rÆ›\Ô_([\Ñ±´´~Vv0&\Ë	\Ó˜×¹µ—²Š\ì\é»E.\")¢„£ƒ\Í\ÜZŒTj¢¤\æ¹•ø\æ®\ï¸M2ðˆl7¼0_U†\ÖM;\\-¤	±0H«°\æW„:~\ÄK\êª\ã\Ð8X\Zw¶JOð€c¿\èbl(Ï±°; Å¹dˆ\Ûu\nÃ’_˜\Þ ©’¬R\ÎJZÅŸ\0±’ \Ôv\n\n\ã2%Ž\à2ú*¿¹¨Œµ\ê¯LU)¨\Ó;‡”\ÚÁ\è…\ÔQ³l\Z&¬Kæ™“òªpv\Ë\rC‚‘‹\àA]X\âØ¹L¾&VÃ\È0¥ž¤•U‡P‘\\1¨ð\rBûŒhxF\ât…Á¯µc…L\0:û‡\È	:ô#\ÛnÐŒü\Ê\î7\ÜóP%-úcxV0óÀ`\ãƒN µom¹Æƒ¶ƒ,\'Ëš\Ê^ ½\nCkI-¡^¥°C\Å\Ì\äDž\Ý\â—HÀgó±,0–¥_ˆ‰\Ã\î\ÂýÎ‰…°±s‹‘S\ÄTÛ¸P\Â†y¥–\Å|M]–aQ\Â+Àµ5\n¬WH«Œˆ\ÒS\Ì$Gx%\ÖýlBôÀf(@\rÊ»¸lº•4\ÅHrK¬\r\Ú	Î´‘\0\åbók¡5\\5:†\Â\Ç­™3œ\ÌT¢[¶õ¯P ³f£­s\àc¥£\ØÂ…d\Ù\Ëy\Ç	œ:Á\æ—/\ÙP¶ò™\Æü\ïe\å·\Ì-NˆÁ‰ÄŠ$§&\ãnvZ\ç´8šÍš,TCj±°¤Yƒ”\ï\×\ÔVª\'˜>O°•T\Z˜\Ð9\æj°…ñiÁÂ‚‡¶,þ\Ä\Ù\È\ÊÙ…jŸ‰¤°\â\n¨`Ïƒª\0.}D\Øz\âx >\êQob—\Ô\ä\Ü!”#’[K‹–c·(»¶XË¢\â2ú\Z\Õ\Ë\ßX.¢´ø=V/{ÀÀŠ:\Ô%„«PPNJu—˜!•n/¨\Ó\'\'uF@jn{ ðd Kb\å\ë( \Ç\Z \æm3\èƒ~\Ú=‘\0P]K‡+¼ÚšN%Ñ¡é‰œž\Ùr\ÙE÷òr\â?#À-ƒÓ‹PX`˜\Å8e\å*#\à\åliBÊŸHcKhÄ‹…ŠAúf	¥#nºh‰aPf` _Á	\Î\ÅrƒQ–J­&Á\è\Ã\rŒ\Î<@sˆb-7â…ª	‰\Ìò Ú»‡/¶«›\Ï6s$\ÙoLan9…°UE(AVYM‰cX6vU°(Þ©– ©\Ð\Â#^#˜ð\Ètó-¤#%?ª1RBõ\å,¨>xŒh,J®\Êlel+ÀÂ¾\\\Øó…O,I­ðBn\"[º®~`\Í*5Ày\'a\ÌV\Â&\äq±½Cí—²@s*\Ôqv³n	}ÀpÀýðÁ•ydñ»\Ù\ë1\í\ÌRf\Êe\ì\èÚ—¹\Ê\è\×\r‚\Èn†a„V-±J_²`€ry‰ª³”f%A†Kt\î\0d+S”$<C.™\à¹ì’0¥EVÂ /@\Ô\Ú{eQ|A.sH&ä³¢‘¾\Ã\Ã7:ZYõ-?2\ç/\Ìä®¦\ë‘L!÷!@…~(‚\Êyö‡i,¹v%ê”©#\ÐÛ±%9,,ˆÖƒ¾TbqDªí‘­Z®y<’‚\Ê\áÿ\0Iaúb¢DÚ¨X<\ê\ÉY4»%f\àUÜ¢÷¾–*y0\ã G»qY21µô²[é¹¦4½[X\ÜC•—c\î!\Ä`¸\ÎÑŠ\Ãpñ3G˜Ò˜jSzq‹ª£hŽ\ÝOñ\rM9}´Œ\Ý\Â8”±ý[¸¶Å õq8c\ê.*£–\ïPV¢`	O3\ÓT\é)m6*Bôj `e!hRWŠœ…Ê…\äC’\0\Â\ã.P2šj\ÞEj`Q\×1”c¡¡õ\0¹\Úe\ß\ÊÕ¯±†Ó«\Ô`û\ÝÚŠ\ìÇšeØµ\Ì ;ˆ°úˆ=Kn—ˆðh†bu\èH“ƒÑ \âxƒ•˜þ:>‹8ä§„f\ãw.m)ÀÝ¯ùƒv°8J7jÈ‘\Ýd¾\ç4uTˆlZ\"t7\0£•sˆ •+³¬|\Ù\æµ¥aƒsK*-E²*\Ù\ÐKe|÷Qå—˜ˆ¦5¹ˆ‹\æ\Ô`)fB0hc\â^?&p\Ëž!t…b\0\\\Æ!¿†xPÍ—\àŠMÀ¶Ä·\ÕÁ\Ê uq`/asušE\\G\çm.)˜ƒ ¹!ø–*…qzœBµÌúN—vÂ€2¹ÁT@ˆ»\Ñ\Ì6\Îx™•©°Kñ+\Zjò…²\Òtò\ËÒ¹).ˆ —«ô\\8¦|Cãº–\äSˆ5j\ÚùƒU\Ì\Èj‡:d÷1\Ät@v<wž\æ\0C\'H½\ì·C\Â~¯©@‚ —‡¥„³\Äv±\n€AJ{ÁÑººª©­\"yˆ3)<Gò\èŠ1\î¯M’Yuðò–xS\Å\ËÌ¯ˆµ\æNÄ‰|E¨ý¦\Â	\ÝL·{C\Ä þ#\Ü8\È)NFrØ—,\Ðb\ÓXr*)w	\Ô@´\Ê™ªCÒ¥{vB6;\ÉFE\å\n‹[­¨¤MQ\ÄO€°”•0œ4€¸oÁxf©~¦_•©XC®’g\Ü@8\Ñ!\Æôax¬ü£JŠôÌ£lV‘·º¨\0\×Ö½\ì‚ ³a\Ú\â/cÆ›p\Þ~¢„i[hm\î°\ë –CµÜ¦ù|\"\Ù™Y¼”uŠò\r\Ï$.Ÿ$k•YsF\È\Ãi±st•	\'Ž\è&Rð\ÇL~%Ì© 6+‹Áºùn¿qROA¤¦W”`Ü’ƒ±vð\Ç\Ä)\Ý\Ç	‚\Å\Æ?\È\Èðô\Ü7,\ÚK¯W‡%«G\î‡­•W\áß”‹\éT{YvLBiL\é(ÂŒ\Í\É¡<Go¶¥Z¥{T\â2‰¹ju\ÈY\ß\ÙP~#²E‹[Ÿ¬	m\äò±Z©\â lFcÑˆ¸\ß™X<FV¹¾‘õ3edG£ª	«\æf\ÞHf\ä«&þS–û%>I®ùõK\nÁpƒ(8\Û‰Vÿ\0;Ñ†‚i\Ì6\Û^j`Œ>›“k,\Ê\Zr\Ê]\È}‘Ó¤’³e\"\Ç5²Óª¥\Æ\Ù\Ú\r‰Ì©µœ…Êš\Õƒ.Ó¯F;ª¯\Ù¬\âWJ\ÌV¦‡=\Ã!…b¦\êôÄiC™G´6¨H²ŠKµHÁƒÀ2¤‰;T¸œ+¥\Îô¸@¥:%…3K^f^^©ÑŠ}1ª\\\Ï\å\Ü\áµÐ³\ÊV§`¨W\nG™Àº”\0ñ•(Ã“y–n(\æ^@BÀ%¾Vƒ1.\ÅøBž.-\ãòE0¾!ŽP”jqd&5c¿G§ ¡>†Ëš±\æ\n²ôe‚\êV#1‹Q”\í\Ê\Ð ŽawC~W³E†Í°IEiä¸™­N\ë\n€kH‹¥®£^òDl\î\nbŠH(pq#Hóa	¹d4‡oX­_ˆ¡XëU\î²\áº(ø–Z¦cs‡ B	\Ó\í^¥\\¼‘R+’\Ë|‹Ô·>85	©’}ÿ\0?ˆ\nµõ9\Ø\ÇW½H\r(Æ„Á]pF\ÜÂŽ\Är¦\0Šö3¹\0”&\àls æ‹–aw‹\ß2\ÜeQL¦\"‰œüñ\ZºA‘q\ÛÐ2\áÊ±\ÜÆ¦§\"øš²È±A©\ÄQ\ë\Ã\Ì[‰\ÚDøŽH°pº&V6}-ð$¹¦\îS\ÇÁ’B\ã\âFG\Ëk\Ù\Ý0)!Ux¸\Ò\nD„¢S\0©e…õ+9aP\ÚJ‘]\âbM‰,>’=„%’n\ÐC\êkG9±L5d%š\ÆÊ’\Ã\Ê\êq\Z\Ø0u/g—\Ô\Þ\å\Þk\ê*¸w³kˆkÌºmJ\Ë «\â8\â*’\\ˆr0p˜½ry\ê\ÕƒMÀÁkˆñ.W:3€\Â\\\ÙY5J\ê\àH¼ñT¨6ù‰¯p-WzbŒ\ÝGA\ÐE\áN`Zp\ìHµ;\È\Ù\Ô\ÒWP‰Q6b†\×q-9\æˆ\ÒiÛ²óy\Â<K2x}£§‚pp3\Z¼‘‚¶\ê!¦\È\ÊR”j\ä\É’À\ÉzHžö“\Ñ-ŠH\Ëú,–âž˜¾86Š¨\rCªü\\7\"\ÝŒ¢\r\ÔÚ“”\È*\æz\îg\ÅÜ…4Z‹!ºV}\Â\Þ\æ­­\Ù\0\"þ\âBj/\áš\Þ@fú½0Xo®Kƒ	XÇ¡95U;ø\0•²„–(\Ý<Ymt¤g.Ä¢\×dÍ¡Ybjaª!	~\"ò\0\åg\Ú€AM\ÂJlÃŽ`\â\Ä\0\æ¬,A\Ö\0-T·‚$ˆþœ¡¢¨\Ñ5L`j\ÕJ9 ºŒ*ŽjR\0¡kar‹\Ä\Üé‹–µ#…5q\0ðV2Ì¸LP\äñr¾\êQ¡\Ã\Â–\Ø[\ä†ô©D©5.„\Â\ÈcE’—x\ÝöJ©n‰ž3l•ƒ\Ê	€¹w½Å°£²ˆ†q\àôõ)C–²lðŒ\ÕJ^\ìgAó\r°\â}\Ûi,ðW¨\Ä9\æDˆtÆº¸©–¸\Ç%\ì\Ò‘|¼\Ø\ÓB•Ø•\ÅÒ¨1BV@Iˆ‹\Ù¾<AK!¡	o©e\Ìg^sq’ôŽ\è\ãPb´ƒrž€½†\"ò@ß£t\ë»‡\Ðpƒ0\Ì&×¹“Áo#¼\Åec~õ/lec–\0(\Ó…$&[{U)FR\n\Ñu\âd¡VÞ©¹V\Ïž®0Ú³Ç´qI\ÐþÞ»\Ð[¬ 	\àó\Û\Û\"Wª¤a\È$Â–#\Ú@\âQ].’Tö;vþ¦¢\ëž\ìh\ÏÀ\n\È<¹Œw\É/¾S ¡D­_9Ê™ž\"\Èr\Ë[^°!‘¬)RHE(BL\é–\0Î‘\rR\è|C‚NŒñ\Ã\Ì i\ì…]ªƒ²­¾ ÁQDVŸ‰dt\Ã/»\ÓY‡I‰{Â‚\à\él.BU{9©\Æ\r‘É¢Àà¯¬LŸF!)\Ï\Ç\îâ­…›\0KD\Æ~·Ð—˜;7<D \ëQ1\à\\ ž{\â‹˜\à.\ìÀðÿ\0PP\ç\'\nH\Ý\ç\á7n¤\Ãüd\'¥\ß4g«¥ù½?ºIQ^‹‹#¦¢\Ø>¥\Å(Qu¡\Ìj\" —‡f·,5Q9\Ú(­žsQ]‚\Â!„R®Š\ãŸ7‰ùÊ¿½l\Ûüø0–ò\Ìwˆ¶C\Ìh#\Ìx´u\á÷\Z…^qm\È­ô\ØA˜\Ð\"x#R÷s\Ò\Úû‚\ÙSÌ²À\Å\\JˆP\â)sU]€\åmCm}aat\Æ©H§L\r†*rd\ÑS\Ä1F=§\æÉ«€N6¨{yˆGs\çB€ýq\Z)B\ë\É*mK4fuý\Ç<—“a\Âk\ï \Ù.yŽŸ\Ü83j1ª4»•¾\É\Ë`mŠ“92\ì \ä\Ó\ÑS\Û}‰_\\e´?PrF’–\Þ8‹P&ûšsYûV|F¹q¶;ˆ°Ö»#úq\â$f\Íð\Ï1\ç`½]Œ\ÑIT0\ÇÉ½\Ä\"	pye-mŽtC³ºª\Ø!\æX,|Ì¦0º Ã• õ*\ÆN[*\'*ERY\Ì”\0\Ô\ÚðE³\íOY)1«tžañuG\Z\Ô\ÑZvÿ\0r°*søŠ G¦}\ÆI\r4dµgp«,‚g\Zõ\ìµv„iGW(g›ª\ïf±\Ö+.J§<@\ÐB\Úá•­óÀºC76l\â©\Ä\í”\Ù*±g\"¸\Ë\îl•\æ\"M„7§L˜\ÛP\æ,¦Q…\Þh“,%@À$:\"t\åùc<	EJe˜ú.\\mœ;\Ì&ü\ë\nÁhcÔ–vcW.®3\Ê\Èi\Ô4\n¶/\Úþ¨5W\Åj;\ÑŽ:?÷bg0r´„Æ&ØAˆ<\Í0\ìpžX¯$\Z¸\0(¶õµ@½‰iq\Å\×,\å{^¦¹½ÓŽ\Z\Ëúó\é\Z)\\\ÝÌ §ö³¬t°\ê¿\Ø3R\n|Ž\×\â^\Ï#y¯2¾\Z\Þ·9½xaRzEx\'ÒŠUšmŽÊ°[Ò¬õ¿¥œJO€¤<NØ—\í(D7\ÅJE¼)Z\×=±\ZEB¹\Ýa/l-µDle)A¨&\Ý[’‡\ÊF\Î(p2\âª\í\ÆÕ¤i\ê”•ž­\Ó\é±\Ì+‹±–«Y\ãan\È¦,ž‚Ú—Ì½:³cZ*uñj\Ñ\à‹Z‡+\Õm‘¸\ËE\ÃRP•R\"¥l´>¡¢\å\Æe†1Á1¹.xd}\Ä\ä <\ÊQ»\î;´a\Æx\"f_\ÕÊ›}\ÃT¦\Ä`•¼ÑŒ\r¾CH¹F¹]Gha\Æq\ÆA\\f¬E¬\Ä÷4qóÈ¯Q\í£¹\àŠû¥˜œ4\ä¿s\ZXV¹H\ãª]\Ø-\Zo	\Ë\"\Ô@\Ù‡$Ù—\í\Äd0Ü¸N	Fš¡@\ÝD\Ö\ÈwŸ¸GŽ¬SRi…mü\Æ\n_~5å‚¥0Y‰h†Bšô<,\å{P:lCDaÁ\ÂoŽ¡ª¯\Ød\\eüŸQ(·ž<0šYyzy†—Á\Î\çl D=ˆºV¢\ÞrZ¨(ñ4r\Íò\r¨;[	\Ä\æ\Ü7• AL&\Å\ær…PB²\ÐN\ÔGŸ1\ÐB¡ª¸A¶8{‹\Ûð— ß¸³L?QØ”,ý0œ\ØýZ·´hCœò{˜c™\Ék‡¦0&}‰\Äs†p%	r0\"NFR †v!´ÈšC\ì\â(\åo`<	8€™}\Â\ÂÁxƒ©›*W‹»C\Ð9pºƒø<-#»\0e\â$=-yú”\Ð~\"¦*\èf“wk¸ò&EülòÈ–\0:`J ‡¢-s\Ï1ˆ´¹À\r\Ñ\0G™Ö–Õ‚U¶®w\êX\Ô\ëP±vW²7w\0 E+\å\n‘p˜Jt\êŽö<’\rU@z\ï\×\Ô\ä®T€ªû‡ ‡W1ZA<17`AW\ÜLy{!”kÀ\Ò8F)ô>\"¯F4q\ÉƒAC‚T<\ÆW¿vL\n\ËÁ\Åû`A\Ñ÷,NG¸ºûz\Ç\ë¨\ÕôkùiLþp¬ 9u\\±¦ñ¾)pö E\ãfƒxþ\â6=nY Y¢·k#rqHƒU\ÆSQÅZÐƒy®ú\æ%\Ä4I\Ë­6&¼bQ¢®¦9¸\ìÚŽ‡m§†VGÌ„L-H°#bÞ‘w€r0Xy\Ê-¡§\à0‡\Ô\áŒl\å\èO²Œ$\Ø3gŒr\Õ\\Š¸\×<!óµ;M”Üº©Pj—A¯„­\È¹tUz]À]Ÿy±h\í\àl{n3:˜ð$\Õg Zyj-õ°\ä|Áj\Å^Ž‘bªô\"\Üb‡E¥U9É‚ s„Q\Z:Bº‰•D6^³¸b\Ç0|1\"õ\éö˜(\Ûv\ßl@\nõN\É\ä“\ì„\Ò\n\ÍýLù‹ƒŒcOq‰ª±GkJK§J\ìý\Üòñ»SÊ‘U\æ 1T65z”Ávmjô³Ø»\â)TENZ”’\ì\è\îRE7Ds%\Z—§\Ã>¸Zˆe8\Ö4\ÊÙªœ­Le‘\Ì -Ä¢1|¸¨>S\ÌB:“±•(XT…dº\ÒU,ª\ÑYB\ï)“¬\Zy‹\ç\ãleo q±3ƒ\Ù*sQò‚K‡¾#‚ŸqAXa)DtˆSD\Ùd6+±ˆ`	]Ìµ°N\ã@X\Ê#G* z„\Z\ëX(9xB\ì.‰¾œEð \ê(\ÙAAª\ä‰\ÑÃ…\â˜ª\Ã\áù§\0\è¬€4£D\\\ÒT\Öþ£lô—_R†\0Ç¸ÀÜ æ‡¢ja[QŽ\Ù\Ö\îA\Ô*\n¥Ôº[Œ|²ù‰ü?gRµP+@\é÷\ZF»µÈp¬\Ç\×\ÂKIJûg™Á/\ê7eW_	BÊ¾\ÐùÉ·\Üúƒ\ÈJ`\àI\Èz¿q¾ÿ\0É£k·\\&’\áTi\î\ãˆ()»6Žl°\Ãcr°|l\Õ^^‰T\Õ0œ,Ù€WµF)w\ÔJ\r\àO#\Ë\î[*yp[RV&ª:¶¦\Ë[\×10\rö\ëXbº–˜>a†õ\0Îž«_\\¸q)\èU\ÃT†«˜À\æLý„G )\"`\ëR]J¦…‘¼º\ä˜N\ídZOH\ä–@Zõcòï›¨Jb5lð_¹\É\ä\É\â!\ê:®\"N¦“\è!ªaÒ¶C\íavµ¸ÿ\06[… `ZUŒ~÷‰X*’\ÒÙ¨»-\Ëlð&-§B¾œ\â\'\åÁ9û‚¡ÁGp+An¯\âƒz´\Ñü\Ä\Ê\é @\Ë\à\n\Ô\Ë;œ«“·\ÈÀ0G\rrü¤\Ó\Ðö\Ø\Å\åAµk\æ7…]dXºIcŠ}\Ê;{dEpxH@)~ŒJ4:g\ÅÙ˜\Ù\\)ùZ1\Ûñ øN ª¥‡ºh3aú_L6¹\äe£‹”û÷²\ËA\á•B!·‹P\ã@±=˜\èÃñqÆ–F\ÜFÁ©³1!\ä\Õ_Gv BÂ‡d®µm\æ1\nV¦Áj\Þüª\ÌÔ—˜ô{‚Y]‰L1½´+ ò–“\Þr\Ìj®…0$³}Òš\åC—€\ÌC\\²L\á%ÿ\0U±*\"\éMÆ‘\Ò\ãÜ¾Á†0¤\ÐpCZ\èb¾fL]c†<¼–[\r¤h•X—`\á\'\áÆˆÕˆõþ@eò-\è;ÀJ‚¡S\Ì>;Á:˜\×\ÂI`\ÚÆ·\Æ!d\é\êˆ\\F`BG`ù\Î¸\Òð\"k/ƒˆ3~9(/ =ñs\Ç\ßF\Ö\Ô0Ú‡’\Æ\å\Ö\Ó$©‚[õ\æA8¦±‰L£\Ä4†öÀ¨‡\Ü4\æ$\î4ZXVÛ¯\í;…*œ\ÆL\Ñÿ\0\ëqe\Ô=·Eþ%ŽöÀ\n\ê<NÛ¤\Æ[&ñ¤H o”*\è\n\ß\ë&J¯¸\Ý\ÖŽF7»_\Üú8}Å¤c¤ªE\Ç!\É`˜e0\ëvV\ZŽŽ™õi\Z3Z°\Ãs05\æ\ÃÒ£\ïhPz„\éb\äT\äótK\'*\ázÎ‰cü\ïK®q˜fb—(ZÖ¶]\r\Í>‰aƒ¦\Ð`I\Éä—š\ÝH¬[\0.™œ*²žÜx\×b0MX\Ç‘\Ê8\"4˜Šcw8²\Ð÷«\â²Y7À\Å,Ž\Ù\Î\Ø\Ô$D\ÓW1¯\Þ<D‹¶\Åz/\Ï!ŽA\älr‘&a\èAÁU½d²¢\ëJ‹¡\Ð!J‹\Íx‰¯h_‹ŠY¦){|FôI\Ô8¢q:~8b‹\à.ñ6¶Cu\êgyyd\0±†¡\ãI\rª°\Ü\ß±pñxÑŽJX\ÍCW\Ä	<Š~	m—\0yfLQ^ÁØ¾§Z\ç5`\ë„¦…&xDz9\é\á%\Ò.\ÈhaHºˆ\Æ7]¾`\í\Õe\Ä\Å\ÓkÁ\ï`\ê]€*¼	\î¸\âú—\ÙIi­w’þI\0’\Üzª/ÿ\0òb“¸rP\ËO0`·`½\Ñ¢8Ö¿=†\ãZ\â&\ÈvD\ÞH‘>Š¥t\Î®¹T—	=„Cø0m\íö‰õ\r\ë˜w\èG‰Q,‚\ß#§\Ôi–÷2¥ª;º³v(\n-º½\ä%˜€ø—\æ`‰©\Õ\é\ÙLiþDMRþ\\A”\Z\Î\"\Ùe\'LUñq\ÇÀ\ßR\Í\Ýq\n	±”!pp[c°ñ[\Æú\Ú\Ò#‘\É\rÍ§› ?0yò7(šA+]\Ú\ìöB\Ümc\ê-\Æ-M¿+?1Š\âÙ´Ž3zWj=ACUóHw.¦yþ^eaµ«ø$h]\Ãzs\íÅ§\Î\Ô\n+\ì!ZR¢P„,o\Ì\ã[s*LF8¥h\ä\íg°1t\Üc–ùšòRyžKÝ±‹.¥Äš\r\"Z\ÞOð•–\Ú #\îyŸ´\Í/#¸ð£-Š\åŸzhñG\\\Ò=\ã\ê\\¯rÝ±(¦<‘@\år—\Â˜`²Yƒ3\Ï>Í‰A\ç!L_}œŒZƒ\äEd»1‚Á„€-†[)Ã–Z\Ù\ÊgLm»‚v—g\îrùª^+\Ñ\×Ü½Ën¸R0C\è<AZ\r\Z6ˆ\ÔZ#S\ÌÖ†¡ƒ\Ô\Ò\"\Ê,ÁhY\ä¨\nŠ\Èà¢›X\Ç`Ž\rö2\ç\r\å‘ò,æ»ƒ.\íQa`DEþ¯³oG\ÔW RúŠ\r\r\"¥$\ÊCwr\ngS¹|9øNRVµÌ•\×\íö¦ýK±»‡$\ï/e§DPU\Òg\\­¾¡ \r-\ØJ4hŒFO9¶\æª\â+KD:nø\Ç$\ç\à•\Z(‹µ*\â	^7IE\Å\Þ\ÅE8\Å˜#n—\0\àfŠ•i\êŠ\Ð×¨\ëW*ø-‰+!û‡/Xr˜’\íUÒ‘z³.\Âf¶\Â\ÔE—,µ4½Ë”>IKQö™k\Î÷.uF€n\É\rZF‹¨\á\Û\Z©\ß\Ä	Er¢¥S„ ¨¸*[\à&F\Ç\Ã#:!Ú›¾#\0óC¤§{b\0\Íõ\0\ãF\Ëq¦\Ð(\ÅIN\Åü“\ß\ïÜ¥!]1Ÿ!÷Á)¼B\í¹\ä‚\ÛË†0b¢7\ÄI£¸»ñ\Ü\ÚM@´2t\nX¢\n\Ç\ÉôFr\Úk˜ó¬¹RXÂ¬\'#¤—Ž#¥(Tª­jn]¯k¡€\Å?­œ˜z\ä\"<KC’ª\Ç\îW+ŽH\Ò	]´O U[9ƒE­9\ÈR¥\èCöšq\0©]\Ì5a~#”p¿²Ì‹b\í*cöÈ¨…zF¥Å‡IùG´\ë…ž\Ù5\0\Ó\ZiŽa*\Øø\îXE]e¶ò«\éù–¥)\nó[OD(\è\íÅ‚²•‹w\É|4Ž)JQVZ (¨\ÓZ…K˜\ï¶S´\Ç\Ãa‹}\å3l\Ä\ÉH_™wˆx”\î5\éœ+L~e‚,”Uyãª‚ª¡J8\\\ÓU°…q9•m@¨\n\Èü‡1œ¡¤GR\ÙüJƒjl\ÓF\ÞV\×~ÀrGFTxQÔ°\0œý$6\Ü\\† ±²4(\ì[\Å\n0eˆ•)\0\ß\ÒQ˜³\0©û‹Y)a\ãb0T•¼.,†\Ý^0r\é\Él\êR *C@E°A}˜\\ZCEµ¥G]µƒ\nm!Ö§´zdPË¸–@ô0\Ç•!iÌ®0ÛŠ\íû–{bR\ìr¯Q³\Ë\ÍÀ…\Ã\Îdz´nQjZ”‚÷H¸i˜ˆmŽyX·;(e\Â\ïWMŠ*mñµw\Z N©k\éškm\Ë\Ì6;=sn\×ZÏ¹ˆPæ¨¾\Éö\Ç$Sv\åf\Êt[?D°\ä\Èû~¥\'†\ÊB\nó³œ\ÆÉ¶9¸X‹\îv‹fl«\à*E¨µ\Ä4bW)e1\ÍWpQn™F=\Ðý\Î*l±@¤3\Ú%b\ØR±ˆ]cŠAe,„€a|¹\Æ\ì…7\êX[\Öl›\Ô>Ø¾ ´\Öñ\êv¨‘(_iurw\0¯0¼\Ã1F\'9«Ì«•§\n“d}@‡GK–Šw™|¢\ÖK˜\Ó\ÄÚ¦°\ZˆþÛŒ¨¢²äŸ¨ze?Z\rœP\Ò~	\ï\Ù;ˆœK5ø@bû\Ø\Ä	Ž\ÓG—\ê´ÿ\0õ*öŸ\Å\Ä\ÐÁ\Èòx€\î\Ä\ä\r>\ÝM!µ\Z3`4\åTþLpr\ÙË\ËeGE\Ã-D8ª&‘¸¶±·$óðŠ(\ÓlÇ‚s±¨Ji²¼\â\ÜÀý#¥lˆ§˜Ä¹\îR\ãp\ß,ÿ\0¥\ê0²;®\n\ÓO\èÀ@PÈ·\á<\ìN#„U|\"ª>`ÁbD—Òˆ‰X{a €\×#ù‡`;[\n‰¦\Ñ\ÉzwŒÍ¡dncM®W(xU\ë	\'€\ÒfH”½IÐ´\rgb1»•9Ao¤_¦\0Å˜s~[A¨ö\Å~\éY­; Í¥–©j>	w8…k”|P+\î\Óbkü\ØN G<|¤¶ªŽ\àu)QA™Y¹\ê,¶e¯\"T{\n)ð#´€\ï\ÖNv.VNCEEV\Å\"Š–ƒ\Ü.lª`\Û\Ý5\r\r†Ž\ßRð]] M>‘%\Ø(´û•½+e$Á=1-F½±®\Õ\æHhJ^.qZˆ!ÿ\0\ÈQjP¨§ðx™Z‹JC\Ë*_paH¨¶91¨”üNlgýTð@!u÷\Ô\Z\"\Ä:(\åù–\Ü`]³[¿rÔ‰¹‹-÷š6°4\Å\ÄK•¨¥©K€€3©AˆX°\ÑP¥MˆB<›²/\ë«ð4‰uô \Ñ1“‹t‚B¶k*¡/\Ü]˜Û±P£^\âP.r\"aøØ¢e\àŒ©‰¥?ýP]O\Ä#{…l5„œüD\Z`\n¢n\Z l\å\ÉJ¢\ï2“E¡\"Z.ŒòM:\Ñm¼¯¨06/Œ¨»;ö`AT¯ûN!,‘UU¬=³u—‰}\ä\èSøˆ…s.€cDD¡ðMc/`?\ÄA\åƒI\ÇB4¾DqøŽ¡;˜*³˜!—‘©H=NØ‘ºO,\\Š”\r!½«=¾ö©Å£YÁ\ègˆ“Á¸‹y!\\\àó\01C¿q¯K”7‰\ìe<³¬W\é\çi<‰M]·øauh\Ñ\ë\ê&†\èø.Õ­¸P©œ}b#3zP;0´Ÿ¸˜c)6qV¼=Œ&´¸’ù½\ßLPø2\Ð\Þ2€ \Ô-¸‚«%a\nx€\n\"Ö²\îÚ…ˆ\n4›.i\rë£•J¿OS-tò0A[€\Z\ÍX(ò½\"GÁ\Ôº¾Ë‡Uv¡ \îR¬6RBPú›‹/ó\"Šw^v\0\ï¸\Zu¬=\Ëô~X0B~°\ê,Te\è\Ä	¯I	)\È÷‘\Ð2œ#_PX\ç\âŽMª\æwf\åJøX(µ½+¨\ÝRŠöü\ÚD½4¹N\Î\Éh\0]ŽJx¢\ë†\\\à\ÄT%«\Ñ,\\ƒ\ëaý76\'t\"G\Ã\0Á\ä‘6CÂ¥<ƒ’XðNµ-Õ¡\Ôp\Ì.p\Æy\Ê``¹ƒmE¤û‚uGŠ%’YÊ¼H%«\ÒQ•\Øl\0r4qˆ²\Ì\ì7\Øp>\æ‹H\àò/&0Ü«É *\Ó\àF»E¯¢$\ï[>l%|ª\ÝB (\ê\ß5õ„1µ‰È—¾\á-£\n°\Zª–\0¢\î3c\îˆ×«—Àpûe\Ð\èûšMF){8\ÎÔ¶\ÉfÖ«}@‰‘\Û:Ž·±ÿ\0#€û‰\É±öc&¯œa+a\äø•¡‘¸0\Ód\Ò	›€\È\"¤\ØC_D›¦†£Sp\â\È\èÁþÀÈ¾F\0.¾\'$H\Æ,\Ú=E<,PB˜‰¨óýRür\ÓøŒ*\ÜÁ\é•(\r&\å=\r\Ø÷a,°„Y356§:™y1!…\á8¨D\ZÁ™rÄ»S™+„\ä/\ë% õQÔ¡d\ä%´˜\Ð-çš¦xþ+¦_Y§\ÃP5#M«\n\æ63v³\Ëxœº¢zf\Ãn\æ#\î}\Î}\ÎHÀ<0Ž°žŽkK¡|\É\Îõ¹F]ÁW\á\ç¨Yt\ZbvúŽCñ:E\à¥™\Ó.žÜ\ë·\ê\Ò#¡7BCf\\¸Ó˜,&\Ñq!±»(l\r4)ùaGü«—º\Õœ‚5T\'\ÚD±>\ïÀ\Ç\á€\Ð\îQ.#&S¯6}\à\ëˆz\Ë1¿™G´«„š`)¬)‘}	Í‡6=ŸLVm93\\O\Þu2©ý\éõAI­9&B¤µmª\Û\ëjW*‹f\Í\èžT„¥_d\å RÍ°‚» ™,W¸ 0ªIÁ[e8\ÞE‘A\ÂÇ²ªò\Êpt\ïzuÚ¾·V<\\Å¯¹\Í5ñ¼qiº@?Lª´<\ät™\ç\ée#ˆþjPµ\ÜÂ·œ&\äHi]V\Ê[\ÄB\Ó8O\ÙlP²¡=\ÚY5¯CaOš€	b\ä\ç\Ð#©tó6•\ÙS½\æ_i\0\åž\èª\âRµ)@‡¢Ž~Tc\È\Õs:\â;\'.\à>G\á\á¹\îf¡§—o?ÀÁY\íÀôC\Ö\ÄOˆø˜=|\Å5£<YnnP@Dšò\Ø–¾3¿¯ˆjd$3ž\Ð\rFBþT‡«”?Xamsv8e§/´\ÆþC\ncAM.&´ˆÖ°JZ\Æ€¬\0±Q–\Î\Äiö\Ä=<y‡8Ÿ\\Fh‡dÿ\0„­T±aLñY@À:;\è#Ã¢—”5\àXÎ„\å®±+q°\Ëdtó›È‚r27?\×\ê0¬,¹¤¡½sa\0\Ýý\Ô/ ³À<’\í)q¨K—–/„øe\ß|b§ô‡,f\Ó(iL°e\Â\àc¿R¥¼B\Ä\ï›Q¹`S4±À>„þ‰˜”¯>ŒüÁy›\êi\Ûz\ë,†‰?([\Þ@ú1[\à\â¯1´„2°Ä¸ô%ûVW\âD¯|\Ñ´E\Öû^\Ù\\@?\à\Ü\Ë\"\Ø†\Ä\Û=±\ì‹Mž%C\ìe\Zq[.¿\Ø…®œXwø)+}\í³«bÀP½)A¤\Ð\Zœd_\\½K^\Ö/@PxñN\Ï\éˆj›*˜´\Zž`o½«\Ôj-A¬Eo€y”¨„wYˆ<[†~û±N?\àv&JŒ~\r\Äÿ\0)v%?dþj6#üD,\ZŸS¨8QPL\È\å\ìýK˜B\Ò3¢†PX<‘%*Ø©Rgl¸[ýÁzqb\ÈF\Ç\Ô\È=\Åa0^™Í†v”ÿ\0x¹œ\à\ê	:Ö‡h\æ\â`\ØP5Ý¿™z<©Ë­\\\n£\Û)?)\äÔŸ¾\ãFy7S%¥5r\Ã[ññ\ê_¿³Øµr.mÆ¶ŸO%W[k‡Ð¥¾\×qm\ÛÃ»($\Ð +©n¸ sQü‰k\î\ãr•V	z@\Ü|\0\âV>[³\ìJ˜`\Ä\"±JžH¢Œa½¶RX^V\n-¶$`MŠzöeÿ\0½*P\×q€[\ä¾\Ï©\Ôc„‰d‡òø¹p0\â)Œ\êS)a­4¨j(Qù‹S\É\íÁ„@\å=õˆ—ñ\Êjm€ö€±ªX­Y\r“\ÌG¹¤«ðOB%ð\æ^¤‘\rˆy†9Æ¦´—Ii¸†¬Ÿd½\ê _gW\În“\Ä_\å\Ùeû¨u\Øö²Pšh~£¹\çGR¿\í‹BY¶) G‰•~›\é†j-ÝˆR™ª0–%Y\\TŸ{\ëÔ´\'.£ý\Æs\å%\Ì£œ@#°¡´Ÿ¸Fô@¶ˆeÇ’V‰Sƒü¦pµs\Ô\0\Õ\Â0‰\Ü­/aù‰@«Ô²¡.p¡*Q)ð~_…\ßSb\Z`+|H`š\ë•\Ôtu†\Ú\rm(d…7/\î¶\êð¦26NódDh\Ñ!!þU´$x]\î´2\ã¹T¢Ï€\äÍ§2>§¼(\Ãj9÷e±§¸|48¬©†\Ãk—‹ï°¡*¦$¢\ä\ë\Ñ\âP6Õx‚q°y…U\ÖZ÷\ÕNH¯-E\ZD!¡ô!VlØ³ \æ†¬£\Ô\rì„•Ä»,³e¸ß‚¡E\n¯3UC¹o	Rª2ƒ1\ìT\î([’\\O>\ÅdT\Z\Û}S%{\ån˜ú¿3#±Er\Èü˜o\îC_g\Ç\ÆKgZ9\Z\Øq±„§BBcµ´›´2;<‹þ«½J€˜že\ÔQ_5/j.\Ê^8\ÂôC¨¹\äM!SJM¸C\â½Áñ\äD\Ù(®0Á\ÍB }[DJ\ÇgW›\Ã\Zõ±²0.oP\ê^™a\ã\ÊM,¸V>&X!@j q¤H…*f÷’\\\Ø\îPy¨Jƒ!\ÛRøY (q(¹ª\'<K”p†”O<\Í\Z–¬ °\ê\Ø7Møq2¹p<\Âø&ŸlM„@\éU1=R<Ã™Q–Ú¢\Ö\ÅÉ‰§Ü®\ì_™\í†9•C\n‡\ÒX^Òªð®±Q\Ý%2G%\îP\Ã\Ú¤}¬‚\Ìû™\ëYp»#éŒ›\Ô\ßú\È^n\'\á%˜*»%”rÊý\ã\Òm\Îl\ç\"esúøl€P4II.\rþQ\Ügô \Å@E|Œ\"jû\")ˆ¸@‹\â [·©g„efD9^6\Û7\Èy¢-\âü i*\Þž¥\Ð4#\Ê%5°QY¤\ÝU\'yô÷r\Z‹»%«°6“œ.\ìýq\0	úJ.2ýmF¤ºxR\í\Ú\ÞÅ5M\çOIµ¹m#À\Ë\Ðyø¨Ÿ?a£\íˆ\ã\Ê9…„À×ˆ\â\Ðñˆ\ê\ëLeóBª\ì.+µ \ÔÔŒ’\Ê\ß ;Ê‡–¹0¥À¸#FsM´ª¼\ë!K91\â9múƒl€~¥’@oÁLÿ\0?“±M{›÷\ÌWKŒñ+ó\0_0CTÃ™{\âb\0\ØcGB3«k„¢Á*K\Ñ.\Ì\È~VoýJ‡,ž˜\ÊHK/´\Óö>ùš±i¹t©¶\çˆlS˜‹`\êQó€	\îW…V°ŠJ–“ô0u?µ&F\È\Ö\Ü/…Žxƒ†û€\Î%ú=ÁNñ~ ;	gHøHÇ˜,=AC\í8N\ÜE\Õtý0w\àPsQG\ÂV\ÖüKÂ½\êdŸük’8É„\Ò3¦eŒ3\ÖkðÁ¬:\Î¡·s\×,úÙ’¼0W\äO\×Lk\ÛôkX\ë\ê\ã¨üb†9•ö\Ï\"J\êt·†\È\Ú\ëo.\ì,,¬9&\×0ou`e’£\Õn?\É\Ç\É- \æRÁº\Ív2´[˜‡¶q\Ã $\0\ÜnR\æk.W\\@·ðH ¯K%)\rSö°)Á^H—C¤/\È\ì\':›sžHšf\ÞT\ì¯\î]­£>\Ô^D˜¥¡-ð–p ƒõ\Ï\Ù\ãi*“¥²¦o¹\Ües,\Ú;aq)–=RU…iy•O2}E‹aw\ÍAnú:Ehz†\n\êŠc‹ƒ|G\à\nÃ¿‹\ÎsœS2¿\âOR\Ã}\Ë\Üb½\Óô\Î=ô\Ú~H½\Ã9\0\Î!nC\äs=ý\Ì\ËØˆµjöV\ÓS¨nÁ	P´=\ÜQ}q*¢É¬\"°qk…z*Q\0k‘D\\\ßXA[eŠ9V\ã\êI\Ù6—–\Ø\éiË·g’9\Õy)K½›R\ç¤V<g\Ü\Z«…ýk+ü;_¹¡€KÅº†Ä¥8i<‰\Ñ\àcnô>Á\"Eó¨ñ„Í±É™òÊ¡9»—}²\í*·ñ‹Zó?òœ‘ú£\ï\nbŸŒ¦NQú`ÿ\0\æY	@Kœÿ\0R(š	\ÎÂ„„T‘\ì\Ì%\Çœ‡ar\×\ã5-P)1\ære ¯ýó|\ì¹”®MM´ÀŸ™s4YRM\Ô8†Ã”Ø‚s,:Áñbw¼±\é€P\Ä0h¨^…ó\Í\Ë\Å\Í‡´‡Æ†Y\ê	9¼~cTÛ„¢hY\Ò\ìQ:\rwSe\rˆ‘£\ÂR¿\ìÁ¥\'P\Ö\È¸\ÂVQyÌ®FP\× øP~%\'šõ‹Gñ\ÕSd‚õ*k>\ÌI\èPÊ•‡ü*(l=BCþ¢]”\Òv’\ÃEK÷—yøa\ç\æV“Áþ¢£xþA„_*<ý‘-D\Ø{€ŸAg\âÁ\ÅyzGfü*„­š‰\âŽ¢¢X#MNP\Î\n\ã\ä\×Ôº‹{Tü7 ž.™ü¸ö>\Ê`Î•õ8ƒvaÂœJ( \Õ<F‘\Ðlý4	‘U\×\å \Ûu\êg\Þ~\ç•M{S3 CÁXR\Øb¢4v#\ß\æ=<te|#´ƒ¢\Ü-‹ZwŠ£‰S]¯\é•\Ëñ\'a*\nŒ^ývþ`p?\ÒGk#u+€`.µ\Ðq†)d\"\×ÀÁÄ¶Ÿò†|/\ÂC¹ù4\ÂVb/\î0\Z1W@›‡?]~b•ˆ*¨`e4\nh\Î\ß[ªa\ßD4ºö›œv\\µ‘q!_R\ëY\ÂSW4ìµ²k-a$G\ÄôCñ0…H\ÐIXWQr\á·\ãÀ•J”´\ÜL.¯.:„¸qºÈ }Fd\rRú\Ë.2oJÀ^¢\Ú1€Y\è\ä\nõw\0\Ó_,P”[­´!ù8ª_¾f\àu™å™¡\æÇœ\ÙX\å\ÈDšPq\è(ÈŠ²+´£†l¨d\ßòšMm\éM_\ì€7‹yË’\ã\Ùòfú©rV»4[	¤©±k\íq@˜s9Á\Þu—ø‡5~!9¨Ÿ\Êø\\g$0¨aKwŠ\á$¹\nª \ÎCWU0E_\É4\ÙR‡BZ8%Y9s\Ä£\î!˜Pp\ák\r0\Ò\nb•Oé»Á\Â^@™.xGò–\×j‚ \á[Ý’¸•œ„‚\Ù\Ú’×€oÍ¨x¤eÁ\'µ#I~kû²\è\n<¯‰L\0	yq+\×9òß°ýË¥j\Ú\Îrß¨ˆ1j6\ÂP’Ú½€2Ÿ\0\"	€ž\Ïkš‡µ…v½^\æí‚»€|$-õÑ©\ÇI\0\n.{aD²þbx\ç‘ô!ÿ\0\É3?Q\Ä		°d¥‚¢V™\Ã\á¯€Â±X[\ß?ò\Ã\É4<°^\á&\'0øa\Õ^eÿ\0ƒQ‰Œ\íƒL¿Í‹\r\ÉÀ”Š„>\Ì\æYµž|Æ‹|ì¢˜E\0…¥nB\ä\æµ.JP@ª¬ýFfQ\Éd£\Ê\Ø4ð\Ç-sòÁ¸\ÏEh\ÇÄ¸D,e2ñ\É\ÙP½ü8±.Â’p±{e\'6!Dƒ­~\ÙYüÅ¨F<PÀƒ¨>	OŒcl\"þ #96Q\n~\ÉC\äÄ±_i’~\r$q„JOQ”£\Ú$BŽ`ò-+…h#„\æÍ‘¾¥\'*P|yAŒyAl\ÎKI·Ë¾Ù–\"Cû—`Dh‘\ê+\Ûeš«•kJ“\"Ÿ’@lmA\çrr\ÇSø°Y]ù\ëž.ÿ\0H\ê¢N\Ü\ÐØ‚\\µÿ\0S\r¿yt\Æ92K\â©ibP.\Ûtà¾ˆ\ÖÂ™RE’\Æ*,SYÈ‘Ú¾\Êu0H0’sˆ\Ñ3g_Ê²\æ~˜ÄƒvÀAŠFÍ¨w\Â|À9’\ç\Ï\"_ýR\ÎU\'ˆq\Ë‰Q\Ü\èˆ(b‰l9@\Ø2\n\ÛA/egC\r1”Í›T\É[Œ«ù%Zþ\â&™þ`A¦„RÁ`e\ÝY6£\ÊAÚªWŽ\"¥@(9\æG\éYð˜d\0s·¨‹MKh¼\î,Eú{”à·Ÿ-5>¡Ü\"ð\é(\ê¥\Ú\ìä‡¥\áAL¼\ÐH¼Ç–DI8»¸7¦\à\Ü@tf\"†2\áø36Zl3iü\Ê\ÔRòR¹#€\Ü*…\ÆÀV˜ƒ\êcN;õ€5\ÎÓ—ò¡\Ýâ‡‚\Ä>¢&\Å\à§xHO\àJœ¡:Š\"\å®xk(˜k¾š–»¼Ÿˆ´\Íe\â\ÇvL(\ÙŒ\Zsþa\Ð\ßq’y)ú…¬ £‰Ö€±–ß‚²7Q>–¹\áÁ\Z\Í*`‚€xÊ¾\àz€jüõ¨\r-zÌÕ½›\Â\â\Û\Î\Ü\È:O¿â‘\Æ(	¤o²5¥‚\ï™j‚\ï\ÝQ`\ÊCc\â\ËdZ¨„ºšwx!<oÏ¹lŸµ‚öM-¸o\×ô@.„`K\Ù\0»S·.GK\ÙY\äDV\"ÀFS\ÄU†!\Ø[=QðO\\\0˜’\Ãc\îY˜‚	¤¸}0}†Z\ÖúCT\×\áRg&-šN9@\é\n÷\àÉˆúIi…\Î¼¬\é\Æl¿\á+\ß\é-\Ây74(¼Ž{*\nª}\ÂÀGSd\á\×TD\äÃª\0¬l€½;¨@VZ ò¢asñ\0¤‹/žZ5?rúmu¹(</§7\nM\Ñ?QÖ°„E6\n–‹Â¿¦(ä¬·Kh4q~T\0O0w¹M1û¶OW\ÔD0J9\ê\É~]G…\0\Ì%•á—·DšB\è2;H!ø[\áú`¸”$>øƒ†8—ñŸL¨Ø¥\Ã\Çd\Îo\0Ï‰4¥Çº\Éx-\Ûc‹¥€p3\Ó(n‚i\ßGÚ”-J\Ë\"[]C\ÃL!cÆ€pC\Ä@\Z£\ÑOÀ\Úö«;‚#1ý°²ù\ì\Ñ|m¯ôE·VŠ^D\ã-ªw‘ˆ5 —qÀv—õ[ú‡kŸ}ŒÆ˜\ÜGjÌ–ƒ eÁq§\ÜF\Ò\ßW\Ü.\â\Ù\Þ	\ãOhÀ\Þ0bì»¡L\"–_(\Åma^¤_1,\ÎožRJ\Âc1¹ðˆeŒbË°–\ÌY*?C\à&e\Ï\Ì@üe\0ø¨„Rþ£}©Eª´–|b]ôAP#¼,#v\ÄtfJO˜3\îi¼G±ÁF,Aübc%g*ôÁ/x¥\ÙZXrM\ÆTN‚WnS¼\à…YÆ«†ùºO@¶/T¥XÏ¹ \ë¥\Ç\ZQ\ZŠ\Úd7qo\äMé¨Ž\à\×€FÑ²ž\Åea ¹hU\Â\ì¡ÀV\â\r7)–½ò°%>FÑQYc\Çüd¤SO¿ 0:ù TRk\ÝG\Ê:\ë U\n™¦òR¸ø¦\Åh>¥zrü \ZŽ«\â\r–±Ce\Ø@„Šø¦T(\\$x€5Aƒ J\\\îÀ‡ÿ\0\âdJ\Õ*?Â˜ò\íªb\Ôe\0Qd±†\\@r´>ˆ¶ ’•\Çhº%-š\ÇY}fKhŽe\í¤:¥·¢\Ê/Mai\ÉÕŽ\ß\ÕJ@¬\Ó%·`¬B\êP\Ö\ì˜ó[2!|w\Z*D¼õµ–*R”¸öT\Æ\'¦k\âW\Êø\ZÙ¨ðÇ„\Ò+\ã\Ä °øG„’¼¶E\Õ[¹õ˜Rª  …Ðœ©‚s\"\'{*²Ÿ\á|“‰¿\\@•@˜–B·Š—i\È•K<Š°žº\r£\Ï\ä$E4¡ªö®D\ì,\ÍWò \Ò\Ó\r€\ØV0#us%E+(\âdKŽ%Š+`¨\r­ö1…e*Šiû*)\r°‚\Âp_ˆQ£\'x¹¤Üš\Z\n©ð!\ì¯QHiš¾`§\é˜øw.3ñ©¦4\êÎ¤¬\ßfW#œÀ\\	Po¢›`|)gb{C¼²S¹;&QC†8\ï‹S‰¬A™RB+\äj\'¹‹÷ü\æ_¹ñ>\ÜhÚŒ\é\Õ*±\\D\Ó\\‘\á©F±µðo’\Äüe\ÄÕ“x”¡W“q©Ž¥ñH\r\ïP¼J²\íœ%R\ç\á\0\ã‡žo\ìœö»`zehU4²˜{\ÚGdD¿üX!e.¤%˜0añ`O”©\Ø\Îþlû³\ë°Ñd\É-Q 	\ã\Ì\Þ\á”#Q\rB¬ibˆ#¯‰s\ìOk5\înû¸Á&³Ÿƒ˜‘!¨þ\Ú#©»œQLC\à…@\ä`	\áy’Šz‰\â‘£¨‰‰\É3@\ÅD`DÀ>\r\â©\Ék½ˆ\Z%­–¹Œ¬0Ð¸–(ÿ\0\äN¨t‹†\\…Œ\Úó\Ïy\ìE­\Ó\r†gŽ\n\ÌS‡f°\È*qy<øgP\ßÝ†Eß²/¢Jv\í%CR\Ï\Z A‚¶ðBú¯\ãqšI²o³hº\í\à4òø‡\É\ésÍ£ñ­8J*¥Tm¼ø\ë\ìˆL\ZœP±Ÿð*\r‰ð›?9û‰JW\ì¸²\nÝ†¡AL\0nZ¨\r5ddQ\Z\Æ\0\Ú\Ëp\ÂR\ÕKýFn\Û`?,~(\ØÑ‹„\Øú\nü®YV±‘[/³*5¤YÙ‘ \ßÐŽœ\'ÿ\0ÉÞ™Œe­÷lñaÊŒ\ê2ƒ\åA_t»\âŸ\rÌ£Ì­†ŒP,þ“‚\Z\é#\Â\è\Î\ßP 0PQ\Ü$Y\ZÊ©\ïb\Ø\êUŒNY\ÚôÁ&«×‰xù\ÛÁ\ÇÁ\"|1Q9ƒ1–ö\Í)¤\Ü\âB®$y3K;&}©\èu\"`?a½Š¸\Z…ÜŽ\éP\×\r™±\Õ\ã Ø¯¨\ÜF‰LÁ‰m\Ä\rjY”eŽ\ÍJl^ýel\Ô,8RÀÞ’±‡L•\âež)\äìŽ«¯n\0óJ<­Ÿûð¶\"\Ãg\ï*xl}LT`„|Ðƒ8ß¸hR1‚,\\ö¥8 (¸VûGˆƒf\Û+²\nJý±4\á»Ÿ\"3„Šø«02#\ê‚üsˆ„ ;¢‘_\×h¨ ‡—\èS\Ï5yKrbƒ&ž¡”L¨­ Ð¥“D¸\Ú\Ü\n¨YB~%DBe&TV·ö\Æ\Â4.\rY\äFö±¬Z›q5\ZÁJª\Ä;A\Ê{ \é--}q7º©E5\ÉENP\ê\Z„B\ÙW±±–1\â!–\Ãðº §©œ”Ne¼0$\Ó\ïˆ>°”¶µŠ¸‹Ø½ Kƒ–\Ä1\0‚£Q\"™A*Q(ñ)T¹¦\âkýE§¯€A¦\ê\0`ö\Ä\îc‡\Ã^Dóù_rŽWÑ®GnW²÷_K\ÝTüO²_„B\ÊD\Ð\\¸\È_œ#U\0\Ö‹§³\ã\àNš\Þü£-±\"	\ë-”\ÄiPX\Ô{Èƒ\róu\Ô:LQ\é\Ýò!’\0¡V\Ò7X$Í «b7:y—fFq\'\Ùs\êM0=‰\r)x3Ž\"Y5R\ï\ÌrG˜M;.\Åü\'Àä¹²¡ôD\ê:Xw\àþ$\0‘Št\Æ…Dn˜ý‰WA}÷¢$bHm‹¦\ÃVs\n\rH¿)Ž\ã‰C\îU?ˆ sLAsW¢*\æw·B\Ä7«\ÞH«Ä®\æ/P.”6/:%&0ø¹\"bVä£†%(‰\î0\ëwˆZ@\Ü0‹5)‘ª•\î8ŸA4Z=\Ô|i\æ¢g¤½[e”¿Ä©Á‡\ÐT¯¸À> ß³‰uQ«\éøfU/PA\Öz)@\0!d¶Z Ó°‚\Ø\Ù\Ô\Þ\î0\ä\ÆQ­\Ë\0Ü¿nx%çµg£¨‰p\â ÃŽÁD$Þ«\Ñ<\êÁ\á(ˆ-\æ,\0|xõ\ÂeD\nL \Êe. •_[dJªa:\ë\àB‡3Šd^ðø\r]r‚˜F>$–w™°+œ÷\r\ÒT¨\"|	ñø\ìvKJC\Û+š²}Å³\Ç\è9c*\äl \Ö1\íœ\æöGÀ_\æ)+—\ZLˆ­\Ù\Í,3ŒM\é)\ÕG[\r\îq\êP\å	q\ÅPò|•\ÈÀT²†¦Q·¨t„Ue\ï†¦”üR\ßüŒ~^~YÁø:\Î;%J\ÅDÁƒe\Ê×¦¨l(\'m‘\Ø\îT×œ;½¸U|\\º\'ÁðG\à³\ÜqõW\Z‘‘%…ù-‹\Û80Y¾D~ò\\Ih\ÅAÑˆ/=º?P~Û¥Š|»›O\â´þ\àª\Øy\Õ*R\ã:\é+‡ ¢\\ ‰½\ØaC—l¸S pð\0°ŠIUx”m˜£:Ê‚\æ\à@\ÉD|Wü•ŠEœ\\@ül\\µŒ+sxþ\âHˆ´ >\àwY\âŒ\ÎYz•WuüðM®rr•\â£Á€Ö¼Ù»\æT\Ç}@\0¹b¯”¹gÀ¢\â1£\à\Êû€Å¹ý9c0\âú$Y\ÐO:.s-;\ä\0|WpˆŠYÊ Ñ•ð3©µ?6ÅŒ>/\à\Þ/©oŠ\ãsPÁ\ãz›~\Øòü3	\ÄÍƒ,PFò]\nb\ïF\Z>¦«¡D\0\Ú‘\Ø|¤Hº­¶y\ÎGè‰¢\Íú\'\n0—ð\Ãþ*}|Tm\á_ Ih\Ä~køø%\Ã\É.2j–\Þ\'3p¯aøp\Ìd\"\Ê\Îa‹_›H\Å?1º\r*\à \ÄaHˆ—Sú0<\Æðfhby\"F]C<Áê‹¨g”1ÿ\0\Ä?WCƒn»4\Ô\Ô1‡\Ëšù\Z…¾X\Âa\Ã\Ø7\Ä`\Ëo‚\éhr‡³\í¨F\Ôÿ\0\îf@ož\à$9W+a!ÁEõ\0‚S_: \ÔV\å·ð1M\Ù\Å°J°\Þ\Ì/©_\ç,„MÀQ8kð\â~4•[\äÿ\0›:s\r\ë1‰œ4PóD4²\Â2G\ì\È\Ù%0\Z¬\rF\Ðóƒ\Ïvö\Íy—ù>s\á`ü,X\'2ü3¶EÀs\îŠ{l$P¿9u‰\ÖG…¶3û\Ãó\éþAß˜%qqŠY\\<¼AuPº¬\â ”´»_¹\î¡\ã\ág)(˜Œ\\¼µ–‡24q¬¾\åÖ‚†ö”i\Ã,\0.Þ™†\ì]$³ýy\íA\Ô\Ó+\Û\ÔAòZ\ßó-s•\Å?!ðœ›ø¬Á>—\Ô[~-ó_ð±eË—HŸEk\ár2½Gj\']Æ«¾¡øgM)”ÿ\0Wûÿ\0j)\ê\ëüš\\¾¥\ì\È\r\Ú\ê&«¿ö`t\ãü—»\ÅË†Ã´CAõ!Û—Ÿˆ´Tt]Á\Ä\"”Ë—^&>4`¿ð!.a£\îUD\æY‘+Q\Ì\î\æ\åc8»\íŠÖªÀ–Ô¿p$ù\ä…P²y\ê^¢- «\0€ˆö,bÿ\0ü<G‘¯\Â\çÛ‰Ì¦hGž\'\r\ì.\Æ\É_\ätP\ê°\Ø\ß?üw¯\ì”\\ÿ\0~I`[¾kô\Ì3\ÓûHÝ»\Ïòñ\ÜML©Zy³ûcV\Î\ê)?\ì üŸ¹\ëü˜O¹ŠÎ¿\É\äJs\×ù;W™f@;øR2°ö³\é-:ˆ/Lº\Ü4a&F\0%P¬¯8”h‚8\Ú\é*¶R²µ[¯N3š,\Ï\Ä\ÃU\å\ë\Ê1~)€\Ô~».:”\Ì\ÆQWpØƒ©HK†+¸\êÏ¿öz\Zþby7õ_\ä\Ùw·úaD†Ÿ\Ã-Šü‘sógðÇ—7\ìŸ\Óÿ\0Œ4“¥·,8Ú˜y\ßÿ\0²\è3òp3\ÇùýÜ¬[yþC„Þ‡\äÛ—§\Ü\\ü’\Ð>#“R\ßQŠ\åK¿È•1òÁTÅµuÁ ­\Ôhõ*D=|cÏŠ£\ã…&À\Ø «ˆÃ˜zº\ç\î„Pa:²¡ò³¹‘ð‰–+¬\È lA\Zsâ¼§ˆ$\ì§ùÿ\0\äE¿þ‘³\Çÿ\0ÿ\0g\îPþ\á),þÿ\0ø†;\æÿ\0™hªý½2Œ)ûy\áÿ\0F\rs\âK\á)‡þl»€þ¢:yÿ\0`÷\É	d¡˜s\Ì™\ÔVŸq¼œGù+]›y‚0ò@\Ë²‘}L\r¼Â¸K­`x¹‚:r\Ã x©cPv­ŒA\æa^X‰n8>G¢/øV‚Ž–¥\ÏFSûXÿ\0Â£‹\"\Üe¥•-\ìø§X(9ø¿qx ”3ó+ºŽŸ¾%ð““y\Óøfü’\ã^fžlo\ÇöJþ.u~¿É„k¿ö8¾§#\ìþÈ›G#ý–ð^˜\Ü\Ð\Â\ïóþÍœ‰¯0 ¯\ßû,H­™ñ¾#E\'4w”X\Îg©†ˆN§¤rZý˜\á„/‰’\\\Ú`P:%\ÕR´®ûÜµüˆð)|À»$\0v\Æsý¦?ðrQ³\íQ®~D€>ÂœJK\\@§0j5ø1®?¤þ\Ø7ž?úK‡¦7i\î#Jù?É‡ó\ãÜ¬\Ãÿ\0Œ\Ð\×öFµ_û†Vª	œó_õ\Ïÿ\0Z@\ìõ\nð\ÌX\'Qi’ø!ôÿ\0\Ì-9³‡\â-?\ZS\ÊATÎ®™¿ˆn²`ˆCþIÀ¥C\Ñ \Õð\n	Tõ:\è‡ä©©O\ãù3*%Q\'üeÍŸ+y@\Ùz–®\Ì%\Ë÷1¨Àøaq&œ\ÏB\â[A9”\ê.þb(?\ä‡ÿ\0a‚Æ¼Mr(þ7ø\Ä\Ï\Íÿ\0#–tq(£\îV*—\ßû\08\\ÿ\0 Û\×ù90#\ÞD\É\ß³ÿ\0x‡Y\ßû\0\àñ)\á`\Ç~;>ˆ6\äR\æ„\r\ç\âEJ2ÿ\0s”ù!\ÓgV€z‰\à;3ÿ\03ó²˜\äR»i¶TJ{Œ\ê,©\ÌO‚k¬º\äK€³µeNXP=0g\ÄJ|\Æ£L»»9ƒ|@\"V\Ä)>\Õ\ßô\Ço\Ú AzN<D\Ü\'mpL\ãùû,\ëü†‡\ßû8&,KŸ\ê&¯\ËýÁŽ3‘÷ðÿ\0 .2õÈ‰Ug\0õþMþ_\ì05€®\Ô( \ì\Øñ*\Ør\É[ƒm\\Esð0Š@Ú½\Ãdðl÷\åD©DÜ§6bEoO\Ëb#\Ü/\îP5AŸyb|p…N\Í§\à\ÄYŽÀ)\r¤¬\â%n Â‰Q¨YÐ€|¸†\Ïc¯þEc”d÷l&\ÕUOû*‚\ØþJýÿ\0/ú`ˆqC“übk*\Ø\r\\\Ï[\ì³\É\Ô²Y³ñtÃõþ@\ëó7\Ä\àüÄ„N=\Ä\â\æA\Ø\ç\'8\"\äF\Ì-½±Å“ E(†”Å®\É\Þyšˆ\ë\éˆ0hc.\0BeG ›/\à†9‘÷\n¨‹óYzEŒ†[<Q\ÂOSž£u\\N,M¹i)x;\ZÆ„\Ìõ\r[ŒÌ•“§¯úbYa-|’£ñþA÷\ZÜ•w1U%\ç|‘¿ù\î˜\Ç\'4L\æ8\Û\È2e\ÊÙb‘\Z*i\ZÀœ\Ï$¤HI\ÄvŽo\ê\È\êP³|\ÂL\ß\Ï#²\Ä~13a/6Yb\ÙHjpd\Z2\"¸Kt3\á—FR†£ñ¨\ïá°¡\Ö_I\Ë\"\å›Yd\å\Z\ÞJX\Õ\ÕÀ|Dl–¸ƒ\'	v\É\Ì!V1r[\ÔW>¡-ý?\ÉÁÿ\0±aõ\íœš3X«	¡B\É\nðB*&S\ê\"¨\Øm\ÅÁú”>(óŠšð\Ò9\áHöK›4ß™¯\ÖbK\Ò;±M˜9‚ °•¼J\à% \'\ÅÅ‹·:SƒQªn\å•u‚5,°– k~\ZG|ó(\0K¹kröÂ‰ \Æ\å\í¼¯òc—?÷:„0K%«5›|wþ\Ï\×?\É}{†þ?\ä{öÿ\0³¨­ üVÜ–_ˆ\ä‹O¹{–»Ž\\§\Ô\0G\r~&Øš°ƒhX”$¥ÁRºL\Ð\ã‰\Þ\È_p&ð‰l¶Ç‚‰z W>n/\ÅË–GLŒB}M\åIW—\çŸöSˆ\n\è\î7\ÌÃ˜uDK%E6\æ\0- dJ¹\È÷þ\ÃT®¿\Éû3!\Ü)ýU`8jˆ9¯aô¶ò\Üà¸E%s9-û˜©_\Ûý†3ÁýM\ìYl}Â¹¸¶\Ê>+0\ì·Ä†/ž*\åW@A\àØ¬\ÊhÍœT qv\ÃY‚þ\n2\ã\ÍdbŒCŒ±\Þø|“V‰u7…BIeJ_ø\å\Å>\r%3€‡29?s¨T±\à‡<GXfj PjD2PA’²Á\ÊÆ–|´N\Þ¶I,µ™+¯;TlEß…€)hqÄ­lT\ÐGópE\Õüs4\Õÿ\0@g/´xü„±ƒ¿ö[T\ÄŸü¶\\m¨§Q…\\±¥\Å@y—8e¨a	–\ÜøJ¿FT0!\Äxp\â\ÙnElñ\Õ_\Ö\ãP2g¸Œ›?†\"p\Â\ë\Ô]9œbÁ€À¢R\ÊcñVF<u\ì\æ<aS¶\ÎWp\'|<óo©§ò”D¬-”,|\ÃÀˆzT[\å*–\"â†Šé‹¢*^ð(»U°Š\æI\Ý\Ìõ\0 `d\0n·\0\Ùc\áôÂ¹\Ø\êî„«:æ†\ÞB\ß`\\¢I¥:9mý\Ï7½˜ˆ‹}ÿ\0²\ÃN¿È¢\Í\\—¯‰\ÕK¢:\Ì\í\'\ZŒ&7ñµ%dº\ê]Vüj‡„¤› deAo\Û\ãó™\ÅP4–7©džN•é‰¡1šdB¨VcTO…%„4b\'\æ\ÙKª©\î%¤D\ç\áŠ\æp\Ï\éº%ŽDBZ\Íp6\Ìü\á/\ÏXw©­w	•\ÃQi†¿}Š\Ü\ÒsÚƒ&´»I¦Ý¤;•À©‘qùŠ\ájK^;\ì¿(<9#rk_\à¸\×+ù\\ú\Ìzÿ\0\"Û¹GN¦þ¦Ñ†Ÿ\äT1\Ó¬i` ¨|…@”õŠM\ÔbÀ…\Ägž‘bñ\Ü99„92Ž\å\r‘\Ç\áðËœSXŽm\ÙV“\Â\Å~f_0\ã\"-\ì\Ã`À\"\ä\"\êqM²;Ôƒ¬¾jk£žvtƒy`4%NI\ÇQû¤<ü-„v¼£\ì¿\Ü\ÆmIž_(vgvP…)\Û}Ï¶• c\Õ\0pô}\Ð8\Òù´­\Ò\ZoD(\ÉY,%}Œv[ûŠ\Õ$¿\é \è+ú©|(\ÍAf\ÕL½Pr–Š\Öü¿¹@Wˆ‘bHV+Dµ\Ë\Ê8ŠÆ´Á\Ã\Ì8©\Ê#Qº#NbðS*b$ÁA›ñ-F-Ù•2*kñ8\ÏùöBÂ‹\Ó\Ì$!$¬aƒl\Åx\"i–¤]R˜p\ZŒ¥mÁrÀCuÅ¡ðu\Þ\âñ‰¥®ò\ÄS¶½Ý„¯f2®hJv¥Ú­VÏ«3”~£- \Z\Ã\É7qq¢Mó%—°¨Z\Îé¢¹ôb{_f7ö<2š‰\á\ÅI\Z7Ôµ@2]„^>ÿ\0§\àLA]…\']\"Â¿H2	\ÉÅ‡2‘Ev‚‚¦•ú»\'”O\Ôa\nV·\ä\Éz­ƒ|\Ü9r÷ðLó\ëüˆ¾y_äŒ¶T\Ý\Þ\"±NLT£ˆH \ç~ˆ¿|‚b¥÷…¨\"\ZÀ°˜#V\Ü|\"{ðó	9™s»e„ü7\0\ç„!i0\æ9‘\æ@¸l\å\Ã)\Úù“N‰`M»a•Aœ\ïmû\'\Ô\à3°$° ß€\íqfh»\Ô<<\ÆÕ¯/Zö~˜”Š¬t¢€\Ø\Ís\Ç\Ã*5\ç6j.F4\\*¸bù\Ö~!fJ\å6€Ë½ú<2©\ÕÝŠºÊ³ñÁ\'&FdzeE\Í\0·°ù3„`žú¿°›\Çcô¤Q?F\"/Jý@?oú‰\ÌÁül#·ö\éµ;\ÌwÁ\"¤ƒ„VÒ¨%·³V—xÀMžqÿ\0&Wÿ\0 \Ý\Æm„Ea_\æPvX°€@$.‹©‹*\"ÿ\0²Z{†mœQ\î –»—@Ö8\Ñ_‚È¨¬en’r0Dl&Y\ì¸øš\ÞH•IŒ\Ú;š\ÉÎ¶º{mI,°\Ù <\Æ\Ä*±*,\'9\ì˜LÐ­»g;/ô|£¤_Wšƒ˜\Û\È=a(»` ¬6ð­\É\Ö4¯¸Y\ÔyŒ‘\èFý\Ú~\Ô\ìû%ýd\íÿ\0\âŽ\Ðý´Me@(–”†F•ð\n\"„¡¢ö‰p78D\ngŽ¿‰vº3Að¿–\0M\äƒe³É£o)Kþ™\ÐÐ«º}œü“\rüH²ž¥ \"Ô¾x¹ó\Ê‡\ßT’ª(š}\äQ¸**XyA±\Â¹q\Äe–Ä³!\Û\ÕO\äFl«™™Fl¶:úµžŠ•±MóYe\êj	r^ \Æ\\6Ó°¯ˆ‘\áu‘a\î×˜de\èt€«˜‡EkøPFWK^\ÖBœ^\ÅÆ [-šý·gðµþFõ¦iUÀTZGQœƒ“\Ð\ß\ï–r\0¡\ëEó|Êš•þ9g¬\Ø@’KúF0+\à„€Š,(\ÃkY~`xjô\ÇH\×pÄ¾\æ\ÙEhXQs¥ñ,\\C].Ø¹K˜\à\ÙZm\ÈuaNV1X0”$?M´£ÿ\0Ý¡\Z6\Öò·TzyNŽ\ÕLLŠ‚®À\Ç\Ù.¦6w\Ôyvu¶c“ªaV¢\Ó\èGa\rVÀ•fV\Â\"‚Z\ÊŠ±Ô½ X€\âW\"#U,R°©€rÇƒÑ‘h\çúN\Ø+Q\Ó,©k\ÕBœ2\"ë‡¡¤=‰\Ü\\~¡W»——Ö”o•C:\\\Ò#gð„ž\èyTe\ä\Æ5%ò½KU¿šH\'°p«jR\ï\Z÷…smß9²/b´K\r’¿ˆ:¯ñ\n]ýé·‹D\Ñ\Þ×™\èC¯˜-Ë¹1ƒk‘«~´’	\è%¢\'hý-!Û³ö±i\ävýK@Æ¥\Ñyµžû}Y(yŸ4\Â\Õòº\Ç\\\í2n\Z®e9DËŠ· \ÈC.‚/‹VÆ±fM\Ï\éÇ„PÀ%ˆ®|°_0; \Í&¢\Ô`I`\\a)½ó©a\Z\îs³,\Ä8 li8\â0’†/Ô«®\Ç\Ôc\rG\Å÷=b\Õ\Â£*\èFºu¿’S>ß£QŠÐµCWüDP\áŽ|7G\æ’3Jì¢¯\ÉýD}\ZA™0\íôa6Li£0\n?4\ÛýC\ÌR+Y+m¼¼˜ôƒ—\ß1\\ù\é`\ä?Pú‚¥ˆG9ñ\Ãÿ\0·¦Ã“ƒ†\ÄR-D¾\ç\Þ}fSuZ‰M\n´iƒº/,\ÞB+\"Mn”„ [\×1n€\à\á\Ø ·a9\\s‡œs¯h\Ñg,¤Ë‚U\"Bñð·•‹aU4fT\0¯bh>9a*½\ì Nˆ+\Ä.ú‹\Â<BŒ\0Œ\Û\Ñ\Ærlñ\Ç1ò—\èøra”šh\Ã.3\n	¢\ÊIR„ =Î§¡\Ä0û,–¢µ«A)0¢?{”:2\ÊÝ”77þðÿ\0$\æ\î,¸(Ps:Q¶&ŽôüF’>\'¡H\Ú_\éQlJ­­û¹LQ+nfÇ•\Ï\á„õ„Kz\ÚS½Â¬‚yR^HuHú/D¦$ƒ0\Ù	Ù¤óSˆÂ¡q	¡Iv?˜N§y\Ðq¢GuŽ\Î\å­•’\ÙO p\à4\áEVs\êd\Ê\Ý\à\ÅŠ§\ác%•†³\Í\Ü{‡4k‚\Ê\å7º·PñL¢\Ú7O1køq– ¹—¨\ÑÏ‡Ÿb\ÞYD[+XtH8mA8€¦Bdú˜ŽHj\Ö\Â.*M\Ï\"q\æ]È”¨À•K\"´\r\Ó\ì€\Ë\ÆPb\Þ	P\ÃM1\ì„\É}\Ö\ÆÝ½1rŸ§ÿ\0P‚ô*Y»°ó@\ÅýWW—FÕ¢¸”Ñœ\ëUw%)þ„_H‚iÑš\Ð%QTuˆ—\à›¤üWù(±\í\Zc10@\È\ê¸c†õdoã’›\æW+\ÔÅ”uøýÀ&`\Ý\ÉkY.Ö¨~\à¸r‰\Ë<‡r¿D]^¿¸@p>\â\ä¤\"’¢E ¶#H”\ÝOPf\éýÁ_ˆ—/U3\Òx¢‰\Ó\ì{%„†P²YãŽº\êj\r•3Š&¦\Õ*?.,—aDT…™\é¥¢\Ã8A§þ\'–\r„QTs¢\ÉÁŸUJ¥Äš~\0Mñ\Z¯¤ý…\ØøY/õ\ãd;q_\Év(65±\Ü•(Š\Ë\Í\ê\ï1ñ4\Ìe‚8ó¶\"\ß\â)T\Æ\çÎˆa\è \Å\Ã}G \àX§ F‹Ñ²‰(©\Û+ ~%â…š\ÆAZ)±ÏS2Åš\ëŠ\Ú(€\ìñÀ\Ý\èT~>\Z\ÚÁ1÷qÍšH­U\n\Ò&0Ø‘g&¯b\ë\çaLZ†.z¬\àb²Ö˜Êº\ç8	\äóþ0ª\ëöCƒ~\Ò\Ñhvmq;\Æ\'Mªþ’‘ñCvEˆí‚¨µŠccûe¢ZŸ¤2Bª2dg»™\äŒe¢­\'Y\ÂmúŒ%\Ö0ciÌ„¹¬\Ç}ôˆ³\Þv®\ßM	¢\é±Y}o\Î\í<\Î÷®	b‹\\(tAç“¯r\ì®cbÁg°qe8oŽ\é¨EnB\îQNt\Ê\îB0\âÖ¢\\°JF\ì	IÝ’¯iÐ€)‡ƒÄ²\Üh\Í\æT\å¾\×\Åm\årù\ë6h>\rU\Ø\0…“µŽLþ¢·[Ÿ\'ˆ\ÞüD²€T´”QVkmElZ 7ai\Æ\äPñ@n•\×ù\ç.\ßP\Ö]\"§ˆl\èo¯WKp#[izG„LmM\"–\ËTc¿¥Žš¸\ê¦d}LM.%…G\áYxIRž…—:\Ìo2!\îl®p™\Z€\Æb(·™‚²%§\Æ\rOü¸Å•`u\"¶^­†ý\Ä;ôå“±l›˜m–Œ*€\\iS@D\rŒ9IÜˆš¶Sx¡…™3\ïUª»ºY\Ê1è´¾ov>˜BE\Êqp©[ô\Ä#½\Ú\Z\ïO´&.±‘‡û\ÉõQØHW(Œ>`\Ûò$#\Ý~ª\å\nü@A£n[’HÇ¹\nû ‡PdÓ‚\rœ½•MUn-¹Z\n\×òJ‹\ÞCÿ\0¾!P¬\Û)øò\Öø@\é:”bcp¿bÁÜ±b¦[Øp\Ô…Î™ð&0e1›.E/gS8‹\ä‡\Æ²©·HÆª6-”MŠ®ÀL•ñ\r“B‚bùQ\×[\æ \Ð(¾3– PKc7tö[†n»óV\ÇCœ¹¨½¬¿\ä—÷m%\Ì\ÛN¨\Ë8®_„-\îÆ˜À\æYp˜Æ«›ŠXƒ²\Ûzÿ\0²!N\\e©\ØT2‘®K~_Z„2ø©–À\Ò\ÛB\r\à90S\Ãú\Ø\é)\Çü0ò:\r	f‰\Zh=ˆXR\ß\ßÜ¬ð`pœCy•/`\æ\Ø\Õ4\È/‘¥°¢\ì¢Õž6\Ía Y\ZVyª#Y·\Ý3ò‘k3<ž\Ò\ã¿‚\ã.c‰tQ×¾ZÁ1!\í/xK N¥PÏ´\'†z\æ|y G\é>\Ñ>4¦%Aó´\î >;}õØ¹agª³On}‘\ì¸Sñ)BË‚^%E¡\Ý#\êW\ÝZz0\å;¹G,¿-Æª‚]fÿ\0‡|•ÿ\0\ßÄ¿”ª«‹ˆ®%„ß¼=D·\ìÿ\0kþ\Å\ï£iº \âGa_5˜³•$/\Ën®§ò R¨\×f‹9%x˜?WF}7\×~\Ä\â¥ñH“jKµþ`ô±“`“©F;LD£Ÿø¸¸ˆE\Ç\Ú\ß\Í)¹\çµbôÀ€.3x\æ\ÑÄ‡ÌŠK { ¡\"€¢¿¹–N\á’\ÛbÃ˜²1\Óû\ËX¬%\Ë\íÊœ²´NZ3ŸhbJr\Â>%¸™pªÊ„8‹\×p	C˜Á7qgÊ«‚\ÉcO\'&‘ûW_d´k°©Ê£Š\æF\Í\ì\\») \ì!*\Í\Ýv\"«ÀØÊ®o‡ý!0Ã®{\â~\Ì)¨Á¡Ž\ÝW/8B-¹\æ\"þ\É\nÆ¹´¼ßˆ8ú t2ºVYÎ‡J·0O\ÐD¬ö…¨\ã-Ï©0x\á\Óo\r‹U<X9gbš\'‘l~h]6\ßú¿û”,o‚\Ñú²pU\ÉU\'#>\ëðª–².Ò—ö  ª*‚sxã€«ÿ\0¨\0p¸‰X\\þ\Ì$m\Z¾#\Â,<l²ð£ð¢\âŒ\ÂyÀ¹\é\È\Þ`¸-‚-6mˆ.Åƒ·È„DF\ì`Em\Æ*\"lQ0!p.g\Ä¬\ç\ï\Û÷\Ú\â,maû\ä0«û‰\â\Ñ\ÚË>R“T\Ñô8\Ò\Ö-B;l\n­\Û¸Q‚\Ç\Ð;ax¯˜\Ò\\pU\Ãh_\ÚDZ¦°8\Â(\ß\á‘\É^ñºw\ês™D:<<*ª¥™\\\nwWpõ~‰\Ëyü\Ð8Œö¾\0?¨K\Æ\ß\â\Ô\æ\æ¬3°\Âr5€(s¾*\ã\"¯ñ±“_„µÇ–¿+QP«¼7\0$*ý	\äoR\Ôve§9%‰\Ë\àh‰c™‘}Ì—¸\Ëa\ÅA·PÚ„B‘q%V²¡ñ~bÅ«Ù¯XÜ½\Ì?Q\Æ+¹N\ânY_ø\×\è‡\Û( þ\"vp¨¶?\Ìc¦\Ð3ú\r^\Ü}}\Ã\n`ul\çNö9„pMYd¢™tÓµŽ\Ï	˜KPµÉº-Õ¹\Z%\Ï]„%8™¢\Ð\ÚXEn…€h\Þ\ÌeF(”¸HF\ÞÀ¤\àº\Ø,$––ù+c\Í\Ê%¹C4-ñ\ê5\ï\ìƒ\n£üÙ•Œg#	ôh\ähu;ø\æ™nýw\Ä\r‰\Ðq\Ö\ã¸\á¨_\ê0m±·¦Ç´\ØZó*\\i&R‡„€­\ÄA¹v&ª\Ñb66¸+\æ{/HŠ>\ã†qeÐµ2Xc)\ÕÙŒ™ðBK|£œFÃ»\èø’\ã_˜\ë‚l\È|{6¼0;yþ\æ\0xË”ˆeÁõD­J¯˜TtBV\ÉLU\ÕX‘‚È¥%c€X(´õ¦0& g‰2¥¯±\à‡m`X¹\Ö\â\ì…l$†Z	;\È@ÙŠL«\èU|°¶¬°—’a¾t³?#J\è…FiFE³²9\Þd\Åò(qa\r• õ/‡\ÑdcT3‚&s’‚·¸¬\Ï\Ì\ãb‚+ˆ¹\Û\Öj\Ú%i\ÎF\èŽt’\åTÈŸ¤®£W^\rü?¾ã¦½\Ä™\Î`\ÙM\ÈeF ‰£\rŸh\Ã6P.L\ë—\Äq\ÎAy—\Íø°”øW6\â)šPžBŒ\ì@jJ¸¦\\¸mL/\à\Éô\ØFaH•\n \Ê\Ïf\Ä.L\ãü\Â]UU\æ\ß¾JD/\â]waûT€N70\è­\Ê\ãeÁÔ¾\ÛfTð\r	y¢›\ên0¥4\à µ÷Pª\Ønñ+¡†0\íú#Z¤A±‹\åú‰mE\ëpe\Ócš\â±<¡.(k].“R5·•ƒ.*‡Ü¡VRQ©&¼•£\áM*Ô¢N˜Pø%B–@I;õ9›ƒ\0	®¤>\Æ\Zq„r‚.‚1©\ZÜ Dÿ\0J2\Çót2:\Óñ‡,ks\ã\í®¥Yð:%?ŠžÈ½Ê†9ÈŽ¥\à3„(Š÷åŠŸu­ô\ï.<J‚\Ô|KBù\Ö!\æ+7‚T¶ÁÈ¯\È,Z\îT\Ô÷\ÜE‡%\å“Ê§	\ZÈ£@\æ&!J\r]F[·#®Jž¾\Þb\Ø YrÝ‡ó¼\ë£z`\Ør˜\r·˜K$ð+?ž`]\â%œ\Â û°Ä¾	¡Q,\ÖZYAt\È\È^¢\Æ\ÝV±®¢Š… \Z-\ßUQ6º\ëjg¨¶QS\àTu\Ú4•Oö\'0©Pö€yúpƒ¨\Ò~\Â_šûÊ¥\"DŽUö\ë\ÉEaj9 »ð\ê-\ÅÊ‚\ÅßˆCZ¢±ñ\r¦\\\ÉÔ®|*\ÉX\Øp¢_\å3Žü\Ç\êÚ–\Åxž8`µ\Ü\ÖMqˆ\å8¨\ëc<K7)”ø„¸§4\äJ\å\"\ÂA¾ Dz‹,ÿ\0\Þ\È\ï>¾K‘H}ˆ¦Z›øõQ\rô±=%Y\Ú\\R\ác\ãµE©L\ç\Ñ\ä’2MBø\ZŠN@BOyj2!š°e7J® €\ß\Ñ(s)s-Xú\Ø\æ‹9¬C\åER­\à»*³yW¿¹‡÷¡Ý½¾Tnüœ²/·)\rHv£À¾ù`b^\éo›5®ýB[\Ú`B/™yœLJA*8V\á#H‚W7\ëq€yÑ™Cð’K\Ñ\0\"S£ƒ¶]Ps‘‹ùFˆÃ¾%\ÉWzø\Æ\Ý\â>\ïõåˆ´\ã\à/)hPJ†\"g\ÇDx¸y6\Ã_Š\æÞ‡¬cU\"\Þ3W\Z\Ó3G\\’\ÎbŽx67A÷ ˜¿N²³¥D³~X\\h\ÐUk\\\ÑW«RÀ4€9T\î\é\ïx\ÛIaW\Û\áP`\"@ýº‚‚:½¬\ßÑ«Ø¼\å\å_RC\Þ\åA\ç@\"^\à¢,R½A\ÉkK`\ä\Ôeƒ\î1¶\'~ðÈ£~>HhšE—¹÷>½Ÿ\\Aõ* ÁhS\æer7|©xñ\Ê\\\0!ˆ0Óˆ\îd\ØŽVB®„5`\'&>\ÂRt\Égü\0’V\Îap‡\Ñ7öB\Ã:¤Nlb\ÝRmÁºŸQ2\æ´N”u\×*\Î9ˆ\ì‘\îBºG\â51•^ oj©J¾|G\Å\ÜYP´p*\çrI8\Ûw\à!Þ¥\Ão:\â>†U\Ö}\Úz€\Ø \ß!¿ðÄ¶»¨œ\ä\Ú\Êò\Å\Ðs>Ûˆ¨k‰\Ä\0Q(*‘˜tŒƒiÌ¢‡F\r?¼…’’\n\ï¡!B`y_L\0|¯+!bü	Q\Æ:\âi«øøuˆuH†Dñ$M”!²Pš\Ïú¾\Ì\\ƒú ^‘ˆõÀ®lF³\î\Äi`8š¡\Z´\ç<\Ñ(YP\n#Rp\Â`•<\ê\ï\à‚\ÝÇ¢Lo-<û(ƒ\Ùe(s\ÄF2Y¸0ø4ºs\Ô\ÞD\"ü	qž%ü*ù\ÑGŽb\\(üD_0­™iø<‘\"\Ã\\\Ä.\âò\Å\åV1„:D„q>¡aðªj2¬Àl–\îG:c6„%M ’\Ïø’¥!~F}d¯@~’ˆ° ¤T\ì­\ÇKjö\Û0\â²)Ü€v˜ú˜hÀB‹øU±9°J—¹8?\Â2•ñ,mFX¶4Ky\×Á¾ \ä²\Ï5—ð\èNX\Ñ\Â°–\Ê ‰P\\^£‚šO}³¯.y…F\Ô:A—.9\Êc4\æg\ç€eo‘l½4b*ˆŒU2 š\\üWŠƒ‹¨`µšJü@\æOO¶Z>û¾þB‘Þ¢W\í\å‹\Ù+Žuz”#¸pø0\â\"&75/X¤D…W0€J†\rZ	t\"8¢ÀGq¾ ^þb\Çñp\ß,ª€P Ì \Þmr¶7Hw\í‰.Ÿ‚2\ÄpÔ¸‡¶§\ásŠ·`\Ó\ÒAý«¥UTv~\ã\ng\àÐ“Š±\"5k\ëy}ga}‹¿¥<¿©,ÿ\04I\Ã	Âƒ,¼~a\Þ\Ä¿\ÄE\Æi,ÿ\0…˜­[q²jA†\Ã\á\0\\.Jùº\Ù^^&Œ\æ\Ä\Ëü\Ô*\\Y½1A”lÒ«±\nm³€X\Ö\Ôn<–b\ê2\"=\Êhj‚ˆÿ\0\å\r÷ý†	h,f ØŽU4{ŠYÀ‰H2Ž ±PQúsvö?\ÚL\å=\èeqMŽš…z\'ø%“I%‘‚Rhþ%ôTZ\ä¨#ô\æ-öºû ¡²\ê‡ÁJ„F\\S\á¤\Ç\àˆpˆü#8øù\"ñ°\æ(CUM¨\n]E2Æ½NLŠ\Õ\Ç\Ò>£EDn B¡øm<C0|.@\àØ‘\Z‰+VÆŸË‚Ø‹EK\Â\ÈOdnÂ‘U\í!\Éd•<‘1&R(\ÍÂœ·û	d`S˜ò^~!…\ßWþO*¡µ(p\Î\×þ2¶<?„«\ã\0f\éc9²¡ð\Ó\î*j\ÙQ\r‡À„k\â\ÒX\å-±!TAÁ+bTT³zItn(…Å¶½@/‰OÁ°\×,\Ê «<¬A9 ²óAž¼$Xªƒ˜\é„2X4 \Ñ\nwñ4%I\"¡ñ/+\rDÔ \á1‰(\Éd›8„\á\ÄËžqy›p‘\r¨‘ð?SÃ¼?O\Ät!\×S‰s•+˜÷@\Û¾YN‰¾ª€¨@J–`JŒnˆ\Ïrð1ø=\ÎP[¹]\Ä\Øý\Äù\ÈaŸT9\Î\ÈÃ¨7e.A\'A‘\Ñ\ß\"€l\ãü&\Üí—³#\î3ƒ)i¢wZaM\Úi=`\æž\â@ø?”\"‘½k—­@”p\Âü3XR\Õ\Õ?–¢k\Ò0øTOE~™\r’ô¿\äAˆ)²)\Äuu\Ãv\ÏýP^»–u!­ø(\Ü&¥\Ï2ˆ\'_l`üÆ¶\â‡8¶\Ë|W\ä\Ýdb5pÅ·ó\nò\Ë\"\Å¡^#\nR\á\Æ÷+hrAåš‚1\çú2\ÒòD[\å7% ¯ŠTT¸\Ë\Ü2Å¸]¹j¢\åûˆWd¾\Þn\nœ^5f\Ý8C´´‚Zs¸@‘\áo\àu=b\Ç@b§ÿ\0À–\â2\àW\æ\ØP vZ)0$¥ˆ|\Ìv}\Âð¾\Æ+ J\"Ÿñ\î«õ9\ÕQûœLa\Zñ¾`ckŠ	at“=¢W™eñ\Þ%£²\Ø\å\Åc3¾\àÏ¤q˜~\ê\Äb[Uö*x]LF¦S)Ï™•l”\Ù\âN®€B\Ëgp\Ð÷/oôå£\Û-”\ÚŠqOµ\Å<“bZ|[ô§õ±U\Â\å_p«~\0\Â\Ðy\"bº\áŠ|w!M”ŠW\à‡üPDùlyŒw’õX53Dð\æ\î[=â…·SL–Qó\æP\Ék¹†y•¨|;†pƒ}\ÅäˆýÁŒñ”\Í@\á\í\"Qˆ’ô±\n•\ßHo•\Ä^l¤¸Ÿ˜‰Ô©„/ìŽˆ—üAP\Ø\ÚYBN\\{!kK\Zp†þc\ã\ã:þv‡bdÄ”\ë¨7$¨E Š0!\èù/\Åy˜\êÃ’øu.\Ä\àŽ¦¬¹„~¡«\"\Ùð^BŠJ° 7Ü˜a“‰\Úq‚6?P’ý*r3‰:ü\nÜµ\âÝ¬XÛºš_P\ë\â\ãû\Â¯\åµs¨x´%œ\ã\Ä9®]’©i6®IK}T0\ê,EA2~/&Y²\é^YHC.\Ãpú!ù\æ\É@>0\ï\à¥Á\É\áøYe\Å\Ä#Šˆ¹Z€ºaPó\Ïñ/•\0©uYNm@V²–\Ê1. Y­Q\0[\0‘\ÄDÉ¨wö_\ê+¨˜Mõ[±‡8ø”’ ”\"ñ)ø\îT1rt!“¼³¦®R>\'\àqÑ›ˆvQ\0³W<‘\Ù\È\ç\Üh\Òq²­3«Ÿ\ÄT\á\íÜ´n\',\áÊ€}Ã¡\á\'\'\àŒ]LX\Ôõ\r%ü(ó¢®*ÀLÏ– 9„\\XnP8—!1e\ÔN&»u\r3®\æ.?,ñ\0¡Á\ZX\æ!Uð¨G/¡‚ \ê\É%@ú•Š\å&S“x‚á’µ%Ý…`Ø©8…?\0C¹hÛˆñdEnGñ¢!\Ë\ØÆ…¡K]ÁX‡˜V¢\ëId\ÈÀ\ì\Û\\±ª*­þ3)Ad\ê€­»\'•ðü^F/\"\Ðñ,/\ÂjX\Í661|‡±÷(€¼ˆ]\Zˆ\ÂØ¦Ä¿\ÌiœXp*] º\×TT%z\Î[6T€¯ñ9N\'À˜öS\çº%O\Â<(Ž*\åNŒY(+\n\â2rš\'\ì\Ä\Êþ\r‰*ˆ•”~\É\âe\Ë=\Ä\ÓÈŠd£ƒ¬aÒ¡gpÎ»\á*Q\Òy\Ðv¢¾Ê”œ‡ðeQ8>Vx•¢##Xˆ g\Õ\ÌŸÐ¯š\Ç\ÎD¹j\ØóW+(¯Üº›„.3¬8†\'(—©r•G¤]Ê¢`±BRò\å\âJS2ü6/\çc8D„	V\ZºZ‚©\Ä Th©{gv*\ã•=¡û#kax\'¢\ãK¥0\Ñ}óÿ\0LF\×\'qœ\Ädú\â\àm\ê<¯=2Í¢üL¯©Áñq„C\Z·±÷ s\Ä\0`“l;	\×\Ãba\ã?D\\Àw:\r—;c\0\Þ\ÊŽ\á½!\à	HÜ‚qN{™h.Vþe¥¼\ÇluŠ¤qqCˆqŽ•yK=$4gP\ä•DruB\Âk&å±~ô`0A÷¦KP‹\ì\Ï`zˆbC\áDš¿ìŽ¢p[½’\Î\Â\ZlÅˆ¨\Ø\Ø>X\0\Æ\áòü\æIn÷\â7p\0\È~\0ŒcR®¬ÿ\0\'Ú‚¾\Îø\ßA\Ëƒ\ÅA§S\È@`\ï06@-mÀ€þ>8AVH025ŽÚ—8\Ç%®qõ|vD\ÐT`GG\Æ4c&ª+­\"Æ–0¨±\0Ë¹PQÿ\0¹0	šD\æ¦\Å>£%«¼ª3\Ì^H\ÂpžÐ¨´Z™,3\î‚>|`!.V1L[³C\Ó3ú›‡\Æ|Tp„-—\\s±V<\Ì2¾ %(h\î\"šÁh\'uE`\"H6+~™„\è¸ó\0\'2+¥ñÀ—O4pÇ†òM0z>k\èbh¹y4¤\Ö$õ\ÚK-\Í+Ì©pSù&\Ð\ä¥Q\å‚²…Z;\0¨¡¹Ï·Q7\ê¥5§÷³Sða\ÄÐ‡ü*\\Y„e5.cC\àQ\â\È!/È¶ÁKj-¢rJs@ð¹4\ÊIpX,F\È!ºœN…DJ•\Ù¨9*1ø^r$\Zñ7÷ù\"\ìq„Z¨‹\r_¾\í\êpÌ©|@£a¸ðR€\ì–u(\çðÀ†»p…œ\ß)\É,¢“÷¼DT\ÚüÂ‡˜?ðX±›œŠ%“h\ÈGˆ.,¹KÁ.#‡i_™^\"\á—ne„\ÔŠ`>~`\0²\\@NI½9r1Sð„\Ðò£¿\Ò;ûY¡÷šƒ\êK\Æ6“ž<\Äú1/\Ô>“»Ë©–j0H\ëyj\Z4Ž®•‰\ÉÔ¾\ìZ²ZF§`vZiY\Î\Ïc1jm\Ò\æ.\ÅF\Ã\å‹.\ÙE„ŽÏüS\ÌL_ýÁ¹g³™ìœ„\n\n6‘Y§1=Ãø+\Ä\å\ÄP\Ë\Ñð©h¨e7²‹Á4_9\r\Äs2>˜öÁ\ÈÍ€¡ˆ;ÊŸ\Âù¥bY)Q]ý²\Ã\Ë8\"e£ñ:_LÐŒ‘\å\æXØ“š{.yŒ½\"Ë¯ ¥=\ÎQk–ñ}`\ÖœAßŽ\\ü: \ÞÁP@Aw³\Ë\ÅF–ÁX\àø,[\Ï$ªl&\ÌuY™\Ù\í€b\å\Çgˆó\Ì8”ˆ/‡¾\Øiƒó\Ý\â\r¹y´¨wküB¨}J²˜,7¾#{\îd7–#÷Ç²Ì…x¸¼´øB\â(i°\rÿ\0¾.*ü\">¼{…‹½\Å559–\Ð<b÷ðtúe®9¨„\ßùØ©>\Ë>_‚‘Ô±(«a#®e§cª1#ÏRúœ„mƒ!\ÆZE\æ¿c®&€œý°\Â1Š\ÆKy˜þ\Z™q\Ô\êú™°D~\"º§ZƒOwÌ¸%<t¬w*c4– Àøg<\Õñ9}x&\Êu…ˆEð1~¢ò@r§mq\å gŸ”\â\"¹L\â´z\ÆR¨\ÛEw‚@\Ø1gôË•|\ÅTCW\äzÊªBÁ7¦ ÷ðCP\0ŒR£™P\ì¹Vwv\Ê\ç”\'h<\Ç\æ?ª–¯«|\0|D/²6ã©±;Š\ìö³`M¢\ê+\å{‚¦	&œOpdtX\Ö÷b\ËW¸´\0µ\î\rðc99N,PZñ*#L%†â´¸Ü¨•`Y\ÄÁ\Ä;BXóði\ÇÁb.ƒ(©Å‘Z2j ˜+\àt¨@\Â\Â\ç>Æq˜\Ô20¶ÀÄ¬N$v6W\ÎÇ³ÀCb`ÛŒÕœ\ã˜5U(Z\å\ß\rT²WÌ£\Æx{õ‰Köœn¢´!œUKPXz\áŠ<wl¥Š¬†\Âªˆ/j\Üe˜‘©K8\êm—K_€Ù¦Ê€D1È¶1»\È%E\â¥Àø3†1bB\0Ï…•JNbl¹X(0•–„Hz=±x|K³\î ©Gs\"}¶²À¸\ËMQ«1Œk\á\ØNvýÿ\0,*t@E›\ÂX\é¨¿Ä˜²ÿ\0/2™\×4TóŒ·0\ß\å-g?)q„7\à»øÂªUAQ›*:”D\\@,¥ºb®²öQ>Ê‡Á‚yC’ˆ”ˆ4\Â.\"\æ,Š»(E‹Ä§”—\0Á¢Þ \×öÀZ\ê6=²‚\á†.U¥%8÷üø¢,¸ö\ÂlÊ³Œ€%u	·\Ëü²±VXN:,1ƒHDºRßˆ\Ð:y»ƒE§\Ç\Çm{—»€ú8ÁÁ˜ü†\Ò\Ñ2%Apôƒ\ÔgjUŒW\"FÃŸ‘)‚0j§ª`C°!ƒ\å\0Œ%+ð(ˆŽ¥@B(da‘\ÑÐ‡\Ö\äM\î_\í(.£*M21[’\ç|\ä[¦ñ\Í9\Ä$õ˜Çª.q ½\æþ›ŠƒÉ£\Ø\Ëò€XAR$™±wmyH‘\ë÷q-ü?g£‡í‘œ\Ç\ã¿	Ì¤\"\ÖVF|BÅ¶[ð\à\ÈA©l\Äsn7ó0J\Æ$¹wPX‚Psð%%\â-¯Zž\"iø\'hø#p’]-Ë‹uŽ ð‘”V\\\êŒl¹A¹2¥\Zß‰¡ø$C²\ã pprQ«\"Z‚*\ËÕ¸\Æj\âk„=`\"$\Ê¨Gä›¸‰d~ ñ\×Á+0›r\Ø ¢|„œ\Èmünr¥¬Pe@ø_Ž\Í\ÔP·…8\èv™\êP¥Ÿ,(\â/Ë·7©u~\×ñ–\æº\"4º\Æ|ˆ\È<‘j ´šýNAAs‘hŠÖ¹u¨> \ßR(9µ\àžÀ}C\Ê}T¿\rW_p\×\Ê%D*ØŽ¥‡D\éMž}¦\ÎV°³+\Ï:\ß!b1\çüoáŒ¤¬¨ÅŒ‰-b,¨9ŽÜ·\È\êcññd\ä	\Ô0JÀ\Ã\à#	\Û\árò`YQ\×D`ùA\Ë<†\ÉmÇŸe\Èv}T»\'„Qc\ÊòˆŸ-VY\ì\Ã«\Ç,\â\è”x€+\0œKRX \æT\\ž\"!¥À°°E]¾L2\ï‰f™1\ä\Åo@û”\r¹l3ùq*œƒô*®U/Ä¿ù–(Œ¨6=ž ¬(‚„¼8‚0\È/øj²¥üñ\Z\åž\â\ÖW\ÊR>H.\ã\í3¼©\åG\Ú\r@M\ØQ\Ý\ì¶\çå†¼FF„¤Á2R(“¼\ê?œøx;¢®%ÜŸ¸Ý„¼\Ë\\‚\ÖýÃ’Ñ†˜B¹Se¸\à\ßÔª\×\å›Aúÿ\0e\Õc…8±\Ì\áåœBXªð«ñ€¤ s0%eÁ–|Œ-‰/a„†Ì‡ŠˆM %J‡\Ãð\ÉDþ¿¸·ÛŽY4”b\í1\" \ë\ÉØ°)`±Û°V0\ÃÚ¶9Þ´{Inø!ey9ñNL¸ú”÷#œ°\\k\áb\ÏRÁ%S™u\Õgz1‹ò\âH¤û–k¸~\Ègµ«j9\\¶rU\r¹Ô \ä`]„ÿ\0\Ê\Ö¼i¬vÄ…*$ž\ÈOpN\àX$%dA5e®Q²\ß³þ	I@€!‘Wü1wr¶dÇ™kñ)È¿0˜\Ê_ªDCj\\¶4\æU.yIŸá‚›•œ\æ&*.—VW\Î.\Þj¥DŽÌ€2+»o˜¯-me´lzE¿L•xKñ-Cò¸NÌ¶•;\Çx\ËSy˜R‡\à¸·\ÜXˆÄ‡š48k„¡fH\ç1Q‡0\ï\à/u‡xLD$K€} Ü­;q\ÏQºS\ß\ä¯ó0üCûLˆÐ›\Ôq-´Ž—cüq7\âW0q\r²\É\Ã\Ô\Èú`û%šZ·Pre˜hUB´!_r¥\È0\'TgT»%\Ë%rÔ¤m±¿1LB,\à\"+¸Ž«m~eŽ7\Ô ]:.€\àšM¿Ü¿\ÏÜ¼&\Üs’\Ú\åX\Ç^ˆ+\re\Ó	kÔ¿2\ß‡Š`ªeR—\äb–)\Ï\ÄöÀ\Ð\ÚÀ…N\ÉRµ\Ùgž%Bk\êcŒ¿L)—V¸ˆj\á¬\Òsq+½Ž¹…\Ã.’Š\È±˜L\ì%~¸<Cè£‘@}3‹ÿ\0‰Œ§\nu(\ï\Þ\Âel„þ+Q)vœ\Ü\\2ý\ÅÀ\\A:ø„\á± G>ŸQg¶zÂ¨øØ¤\í›	ª¯l-iÍ¯Ü h+Äº-)Ý²­ñ)\Ã<óú‡A\ÔüGcÁ‡fr¿¦%mÌ¡Ô‘Çˆ!¦rJø³‰²À\×À#¹§ÅŽe¼\ËM7-\\ÀÀ3°U¹œ…\Å{‹ ·‚P*½j\'R÷ˆ96\ÜøqÀmš\ä_Dú€U„Ÿ\Ëd\Å\æPY±\0T1c7°`\ßS.3\Ô\Å{\Î!L…¶m;´`_¢t©A\É(13rúš,NjXnGU·Ž“œ¿\ÉDT[ñø>`©tEÀ5¿vg8DD±‚\âQñ\Â†\äE³\0—ˆo™hAHj3YhÈˆüÿ\0\åñ!FKÞ¢\"\È	—Y¯þ–\n\n‚\Ñ\à¹;_\á\n\ä}DX*\ÍÇ¨ˆ\Ô1\00ÀkûYms®\ÄAT>\á\"´¸^S\Ë\Â»\Í%ðY{I\ÆO>²·%\ë\ë\àÀvÙ„¡x\ÅùA\×,Vªñ	µW’#ô\äÝˆs)W¿\äµ)šqª\Ãô?7 ó\Ø7ôÜ³¤#YO\ç2ŽüT¤4\ËK\Û &÷\ZøT—~`FDôG3\ë/\âl—ˆ¢s„rea™n‹”\rF—\nL\Ó\Üd‰\\\æ	5`Q“œ”\Ê\Ã/‚*¨zA:27?\ne\Ü \ÉM@r\ØH\Ô°±\ÄZõ}O½+*T‹yefÕ“’P>÷¨[a\ïŽ,2ŸgL8W\Û\æ“ošD…\ÐB¼q”\ÂZCn \×,\Óso,\î\Äq98‚·\ÜIR‡+b\à\"¹¿1,°GfjË³ˆJ²Šx–M•Ëˆ\Ú¬ø\È_®\"V3Œˆª¹j§þ\ÎPµø;T =u(ñ*üI_da|P((;A\Ö*¾X«?)[ð«4\"“=7\Å0…,\ß½DYB\r\æQ\0ŒŠ[M^\"·.£c —T\äñ.©³ð™R\nA\áûŒ¹`2þ\È\ÛPqŽ nU”›ZÌ¥p:¿©ƒd\0\Ð\×P \Üzlk,¶DŽ\Ò\Ü\r”	\Ë\î8o›ˆ‚«\ê®™ö§\r2\à”NH”\Åð°ê¨ e\\CH/¤°@^›rœ–ü\rð0C\Ö#\í\á7jUµ\âqL°‰@µGi€\à‰\ÄSo·‰µ£ * —ð\Î\Å½1pýÂµo˜\0\à@øFcaþÉ¦\ÃU#ˆ@I¾1”Ðœ\ã/R\ßBDh¨˜s(K›Ò¿\á\íƒ4\âEdu¬®S\Ï\Ñ	\Ð]\n\Â\Ð\Èb]dÈ±9e\ËZ!\Ê+|\äbà¼…t\äX!“Ÿ ò\Â\ÑP)£#U·\ê1Ô«5Œ\Z\ãH\ï\Ìs0\Ã\à\Ã}D#\ÜŸ>%ž	z‚<A\"¯ \Â$Pü2‹?‹œ®\"Û¡fUhñ¢¥¾\Ã½=À\è*¥·-\å\Za±\Ô©\ä!<N#O…&	i³:\")Ý’‰ó’T\Â<\ß\'\Ü\È;´„l‚1œ\rü‰¤\Z)\ÊÀò>6\ÂTn¯X4\å\îX¡m\êRø©·.p@:¤K\Ã±²ž\ã<:\Ø\è^&\í\Ð\énQP²®’{ëŸŒ€½g}³\Ì\á3F\â$a1Ž¸\î\'dS†jR\Ô¢QðS\"\än”j¶PF©T§jx!ø\Ù\Üz®\Ø\ÊÉ˜xˆ -\n¢H\ß\raù\È“¥¦\'\æ\Ê&·\Úr°\nF	²9«|F\×\èÀÁ^b\ËRAÿ\0;L‚,\"¸\íc\Â\éñ*«÷\Ì)µ\Ôé²™“\ÐEf\Ë!\ÕË˜óúH\áO\n0¬[þ\â©T¤ºƒ¥bªW\Þ\â	³W¨Þ¿I\ÔÁ\à\Êø‹øúD3N E7óTrJøñ:h‚E©S7nýÁ G‚5c<°+¨ñ\ä\ÌmV\ÔoŒ?€n	\ÜðD;1\ïr\Ç\r\ÞT¥\êR\ì~(\ÉÛ–r\è\r÷	¥³\ÄC@	©Œ¸Ÿ.\ãû\É\É\Ë\è‡_ò \n(ž&\Ï\ì\äU+eøsD\Ó\á0J\Äý\ÇÄ“PfŸc\è\àF¢Ü‘\ê\Ä\n€\à(– ¤ª¢\ì)\åC5(ùM‚ü_\ÅFP”‘ñó\Üã¸°€<\Ã\ÃôN‡\ÇÀoe½þ£Œ»»aÎˆ[ˆ|õ\ÅT.“¦\â7†-¬û\è{\r¹VÃ…\Ê|œ•(ƒGˆ\äõM--S¯L\ã[\ÞC#qð Z´J°ûX¦­GØœ€%Lp2úK¹¤·¨™‚¼ÿ\03@¬J’\à\êx˜\r§\éˆ\ÂQ]GÁtÀGHbyN„”£¾qzd«·F¨\é\â7‚\0\ÞË´C³HtÊ‚¾\ËøV0?0·c~\çhE7\ÄXfò#!\á‡X÷*>Q›¨6ø\ä\Ê>+ýAÑ±¨CÒªýg‘¢w\\\ã%mªV\08xø_€œ$]c‚\Ên¢7O\í—{q–¢ª€X\Õó08²\åg\ì?\êÀµl*3<1°°\ØU\Ö8cs*”<Jò\å.­A™(N#‚ŒQ´\êUcŸG\'%¿ûf+Ÿˆ[_\n¦RŽG{J@“\Â(–¶o˜\Ê1\ï’8$ H\ËEÎ”\è¤`¹g‚t­FK\Ä˜\ÉMgÚ†\ÇñJ;F!ÁS±©M²<dˆ\Ó-µ„LWP>‚~|¡\ZGõR\è~ž±ªwhÀ­ƒ-ù~H\ç\Ïpšu‚\ïF1+VKòÛ©—\Z	<ÿ\0ˆ\Ö’T®@a†!Lü@<1Ø¥Nš\ã\Ée£%f“N*†\Ùk	\Þ\Z\Ùx<À-\æ³`–\ÛX	\\U¥3u\æT1–Cø¥!O¡A*IR¥_²-z3bI÷\r \Ð\ì\ËúÂ¼’¾P’-¬¬C\ÔwD]\Ê\Ër&	\ÅÁ\0°\\/€³\ÖG•?–¢\Ç\íÁE^±ƒõ¬oc¶\Æ\Õ\\|ª[þ5P~VË—ðÃºl\Øj¹ \r,‚\Â#¨óv\Æt¬›! kÐ [r©Bñ\É(\Î>¦Ñ³bQ3`\ëkìŽŽ±\æ\Ø>\\k¬ÿ\0$×–~ ª°cøn‘y%;óWÁ‚ÿ\0T‡©}•2\×\í\ÃKŸƒ.˜‚JKð\Ê*Š4l‡I\ï\í]­©~b¥£J~\íƒ\×ê«$ýA)\ìÕ²\ä\0õ”b\×ÎŒ°\ã\à!ò¸F\ï \Ü~†pK#7e\Ëø¿\äŽ=óbÈ»r#%\r ˆ]G¨ðÈµ?B	ZBoŽˆ²¯\Ñh‡¹2¼g’5E‡84\Ò&\Ö\\²\å±˜…­Á\Õ)Rú8\é\"\ä¯r“¨\ÒJ‰\nŠ/‚£Â†/\Ì0pZ2\"}„«ýò*ª¹‚mˆü8À´\Õ\æš%?\çU½¦VñÀø`—\à¡ó_A}F[\å~O‡›™R¢\Ô\ä1©·¡û„\ÏBjªgg÷PI\î¥<¬P§!H!”×¹¼H\áÃ‚ˆ§rA¼@Z%½	Z\èü0¸\Z\Ö8ûb\ØK²ùe\Ëø¡™p•\rœl£\áó?ü_¢\nY™¤ ¡%+%|T\áðdDHF\\R?¹y.\\P\Æq°™•ª\æ\Äÿ\0yŸ‰\"\ì8R!&z¨À9\Ù\éÀŠ”h³ó°{c\ê\0\áŠõ.\åüUiÇˆv¢€‰c}ˆoXó„<Á/\â\åN	¿ƒ\Ì!+ÿ\0\â\Î`\ÂV‰IP¼\è`\Ü>\à2¥|6K‡1ùcü?ð\ËX¼øù”­Qr’<°\Þv8\0\ä\Ç\Æ\n6‚kˆ-©€-TZ€tf¸·p\Øðª\Ïpý1;8ýÌ€¼¥«¢\àM\æ±0%Cˆ¨E\Ì]ù\×\ÍTx%\ØÕ—¤\äMI\Éy9*\Í#`ó<%‘š¿ñ®1ùB?4F¡\å8¿i¿PaK€pš”X©!G\ßŽ‰^Œ\ãQ\Óc\Ð\æ9B/ˆ›ú(>\ß\à–ƒX\Ó{ü\Ë\0výÁl\r\ØD9;ø\ÒÈ±!³ôN¢T²\â2\Â\ÔÃˆ\ãðsóp¯šø¯…Qe/ôœ—\ÜQu.	Že\ËJB9_¸\Ó+|Y\Ä.*1\ê5òü¯Á*°jyaµ÷X[I÷±Ò¥^r ½5øL\Ú\âLùrÿ\02š\Ó\×,B5HWF\ÇcŸ8%œ¿\Ê\n\ä¤ð—›Q\å\'\æµ~X«i\æö\Z„¹²ôq\Ó\ÒF•=\ÌTv-a6<K„[ƒ\áq`\Ân\\¿–^\ÅK\Ò:_¶1A\âC,b\Ò\àü+\nÊ¸\Â\Ðø¹qr0Æ¼|?/Ào\Ã\r\â\r\Ç\Ü3O nTû\ï\n\ê\Ì\Åý®7mO¼ƒ˜¢ÿ\Ù','VJ Transport','vignesh@whydigit.in','vignesh@whydigit.in','','29ABCDE1234F1Z5',1000000004,'VIGNESH','AAACC2498P','9345377252','','vignesh@whydigit.in','');
/*!40000 ALTER TABLE `companyprofile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companyprofileseq`
--

DROP TABLE IF EXISTS `companyprofileseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companyprofileseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companyprofileseq`
--

LOCK TABLES `companyprofileseq` WRITE;
/*!40000 ALTER TABLE `companyprofileseq` DISABLE KEYS */;
INSERT INTO `companyprofileseq` VALUES (1000000002);
/*!40000 ALTER TABLE `companyprofileseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customerid` bigint NOT NULL,
  `active` bit(1) DEFAULT NULL,
  `branch` varchar(255) DEFAULT NULL,
  `branchcode` varchar(255) DEFAULT NULL,
  `cancel` bit(1) DEFAULT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `customercode` varchar(255) DEFAULT NULL,
  `customername` varchar(255) DEFAULT NULL,
  `customertype` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `gstnumber` varchar(255) DEFAULT NULL,
  `image` longblob,
  `orgid` bigint DEFAULT NULL,
  `pannumber` varchar(255) DEFAULT NULL,
  `phonenumber` varchar(255) DEFAULT NULL,
  `pocemail` varchar(255) DEFAULT NULL,
  `pocname` varchar(255) DEFAULT NULL,
  `pocnumber` varchar(255) DEFAULT NULL,
  `salesperson` varchar(255) DEFAULT NULL,
  `screencode` varchar(5) DEFAULT NULL,
  `screenname` varchar(25) DEFAULT NULL,
  `modifiedby` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`customerid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1000000001,_binary '','','',_binary '\0','19-09-2026 03:23:49 PM','19-09-2026 03:57:20 PM','vignesh@whydigit.in','CUS0001','Ruchitha','Customer','ruchitha@whydigit.in','29ABCDE1234F1Z6',NULL,1000000004,'AAACC2498T','8050898176','dhineshkumar93262@gmail.com','DHINESH','9080335964','','CUS','CUSTOMER','vignesh@whydigit.in'),(1000000002,_binary '','','',_binary '\0','19-09-2026 03:26:18 PM','19-09-2026 03:26:18 PM','vignesh@whydigit.in','CUS002','NandhaKumar','Customer','nandhakumar@whydigit.in','29ABCDE1234F1Z9',NULL,1000000004,'AAACC2498J','6374794287','vignesh@whydigit.in','VIGNESH','9345377252','','CUS','CUSTOMER','vignesh@whydigit.in');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customeraddress`
--

DROP TABLE IF EXISTS `customeraddress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customeraddress` (
  `customeraddressid` bigint NOT NULL,
  `additionaladdress` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `pincode` int DEFAULT NULL,
  `primaryaddress` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `customerid` bigint DEFAULT NULL,
  PRIMARY KEY (`customeraddressid`),
  KEY `FKg3auos6vlh8e7hh42wlehw2i4` (`customerid`),
  CONSTRAINT `FKg3auos6vlh8e7hh42wlehw2i4` FOREIGN KEY (`customerid`) REFERENCES `customer` (`customerid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customeraddress`
--

LOCK TABLES `customeraddress` WRITE;
/*!40000 ALTER TABLE `customeraddress` DISABLE KEYS */;
INSERT INTO `customeraddress` VALUES (1000000002,'KK NAGAR, CHENNAI','NATHAM',678898,'NATHAM,DINDIGUL','TAMILNADU','Export',1000000002),(1000000003,'Marathahalli,Bangalore','MELUR',625106,'Melur,Madurai','TAMILNADU','Domestic',1000000001);
/*!40000 ALTER TABLE `customeraddress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customeraddressseq`
--

DROP TABLE IF EXISTS `customeraddressseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customeraddressseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customeraddressseq`
--

LOCK TABLES `customeraddressseq` WRITE;
/*!40000 ALTER TABLE `customeraddressseq` DISABLE KEYS */;
INSERT INTO `customeraddressseq` VALUES (1000000004);
/*!40000 ALTER TABLE `customeraddressseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customerseq`
--

DROP TABLE IF EXISTS `customerseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customerseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customerseq`
--

LOCK TABLES `customerseq` WRITE;
/*!40000 ALTER TABLE `customerseq` DISABLE KEYS */;
INSERT INTO `customerseq` VALUES (1000000003);
/*!40000 ALTER TABLE `customerseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `einvoiceheader`
--

DROP TABLE IF EXISTS `einvoiceheader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `einvoiceheader` (
  `einvoiceheaderid` bigint NOT NULL,
  `authtoken` varchar(255) DEFAULT NULL,
  `client_id` varchar(255) DEFAULT NULL,
  `client_secret` varchar(255) DEFAULT NULL,
  `gstin` varchar(255) DEFAULT NULL,
  `pwd` varchar(255) DEFAULT NULL,
  `sek` varchar(255) DEFAULT NULL,
  `token_expiry` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`einvoiceheaderid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `einvoiceheader`
--

LOCK TABLES `einvoiceheader` WRITE;
/*!40000 ALTER TABLE `einvoiceheader` DISABLE KEYS */;
/*!40000 ALTER TABLE `einvoiceheader` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_otp`
--

DROP TABLE IF EXISTS `email_otp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_otp` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `email` varchar(255) NOT NULL,
  `encrypted_otp` varchar(1024) NOT NULL,
  `expiry_time` datetime(6) NOT NULL,
  `verified` bit(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_agpgp27lulkh46wjbkbpc7cfs` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_otp`
--

LOCK TABLES `email_otp` WRITE;
/*!40000 ALTER TABLE `email_otp` DISABLE KEYS */;
INSERT INTO `email_otp` VALUES (1,'2026-07-20 09:59:16.511862','dhinesh@whydigit.in','J9CXzGQt/uudwEHkwDey2w==:cAq/AAf5+g9lzhtwHf71sg==','2026-07-20 10:04:16.511862',_binary ''),(2,'2026-07-20 11:02:04.970464','vignesh@whydigit.in','2mXErBdzN59yXjhL9yJ3UA==:kEdNJx9UiSLCOgUIYQqwqA==','2026-07-20 11:07:04.970464',_binary '');
/*!40000 ALTER TABLE `email_otp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fuel`
--

DROP TABLE IF EXISTS `fuel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fuel` (
  `fuelid` bigint NOT NULL,
  `active` bit(1) DEFAULT NULL,
  `branchcode` varchar(255) DEFAULT NULL,
  `branchname` varchar(255) DEFAULT NULL,
  `cancel` bit(1) DEFAULT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `cost` decimal(19,2) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `fueldate` date DEFAULT NULL,
  `efficiency` double DEFAULT NULL,
  `fueltype` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `odometerreading` decimal(19,2) DEFAULT NULL,
  `orgid` bigint DEFAULT NULL,
  `previousodometer` decimal(19,2) DEFAULT NULL,
  `quantity` decimal(19,2) DEFAULT NULL,
  `receiptnumber` varchar(255) DEFAULT NULL,
  `station` varchar(255) DEFAULT NULL,
  `fueltime` time DEFAULT NULL,
  `modifiedby` varchar(255) DEFAULT NULL,
  `driver` bigint DEFAULT NULL,
  `userid` bigint DEFAULT NULL,
  `vehicle` bigint DEFAULT NULL,
  PRIMARY KEY (`fuelid`),
  KEY `FKcn54m899yosa0a13bvruf4f1i` (`driver`),
  KEY `FKgxx75l097l24dd0powa1bt46j` (`userid`),
  KEY `FK797o0hla10yu5fii8rlfqp44r` (`vehicle`),
  CONSTRAINT `FK797o0hla10yu5fii8rlfqp44r` FOREIGN KEY (`vehicle`) REFERENCES `tvehicle` (`tvehicleid`),
  CONSTRAINT `FKcn54m899yosa0a13bvruf4f1i` FOREIGN KEY (`driver`) REFERENCES `tdriver` (`tdriverid`),
  CONSTRAINT `FKgxx75l097l24dd0powa1bt46j` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fuel`
--

LOCK TABLES `fuel` WRITE;
/*!40000 ALTER TABLE `fuel` DISABLE KEYS */;
INSERT INTO `fuel` VALUES (1000000001,_binary '','MAIN','Main Branch',_binary '\0','19-09-2026 03:31:53 PM','19-09-2026 03:31:53 PM',1300.00,'1000000004','2026-09-19',NULL,'diesel','FUEL DETAILS ',5500.00,1000000004,5000.00,10.00,'RCPT-876','INDIAN OIL','15:30:00','1000000004',1000000002,NULL,1000000001);
/*!40000 ALTER TABLE `fuel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fuelseq`
--

DROP TABLE IF EXISTS `fuelseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fuelseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fuelseq`
--

LOCK TABLES `fuelseq` WRITE;
/*!40000 ALTER TABLE `fuelseq` DISABLE KEYS */;
INSERT INTO `fuelseq` VALUES (1000000002);
/*!40000 ALTER TABLE `fuelseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintenance`
--

DROP TABLE IF EXISTS `maintenance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenance` (
  `maintenanceid` bigint NOT NULL,
  `active` bit(1) DEFAULT NULL,
  `branchcode` varchar(255) DEFAULT NULL,
  `branchname` varchar(255) DEFAULT NULL,
  `cancel` bit(1) DEFAULT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `completeddate` date DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `estimatedcost` decimal(19,2) DEFAULT NULL,
  `mechanic` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `odometerreading` decimal(19,2) DEFAULT NULL,
  `orgid` bigint DEFAULT NULL,
  `priority` varchar(255) DEFAULT NULL,
  `scheduleddate` date DEFAULT NULL,
  `servicecenter` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `totalcost` decimal(19,2) DEFAULT NULL,
  `totalqty` decimal(19,2) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `modifiedby` varchar(255) DEFAULT NULL,
  `userid` bigint DEFAULT NULL,
  `vehicle` bigint DEFAULT NULL,
  PRIMARY KEY (`maintenanceid`),
  KEY `FKkcgvei1xku8q2606v1tmst5qu` (`userid`),
  KEY `FK12hurryvqunvrms01dw6b7wbu` (`vehicle`),
  CONSTRAINT `FK12hurryvqunvrms01dw6b7wbu` FOREIGN KEY (`vehicle`) REFERENCES `tvehicle` (`tvehicleid`),
  CONSTRAINT `FKkcgvei1xku8q2606v1tmst5qu` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenance`
--

LOCK TABLES `maintenance` WRITE;
/*!40000 ALTER TABLE `maintenance` DISABLE KEYS */;
INSERT INTO `maintenance` VALUES (1000000001,_binary '','BLR','Bangalore',_binary '\0','19-09-2026 03:37:48 PM','19-09-2026 03:37:48 PM','2026-09-19','Justin','Engineoil change',3000.00,'PRABHU','Engine oil change',5000.00,1000000004,'medium','2026-09-18','Auto Care','completed','Engine oil',2500.00,2.00,'preventive','Justin',NULL,1000000002);
/*!40000 ALTER TABLE `maintenance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintenanceparts`
--

DROP TABLE IF EXISTS `maintenanceparts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenanceparts` (
  `maintenancepartsid` bigint NOT NULL,
  `cost` decimal(19,2) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `maintenanceid` bigint DEFAULT NULL,
  PRIMARY KEY (`maintenancepartsid`),
  KEY `FK5tmkj1uqwix33bb9gpkcf05ml` (`maintenanceid`),
  CONSTRAINT `FK5tmkj1uqwix33bb9gpkcf05ml` FOREIGN KEY (`maintenanceid`) REFERENCES `maintenance` (`maintenanceid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenanceparts`
--

LOCK TABLES `maintenanceparts` WRITE;
/*!40000 ALTER TABLE `maintenanceparts` DISABLE KEYS */;
INSERT INTO `maintenanceparts` VALUES (1000000001,2000.00,'Engine oil',1,1000000001),(1000000002,500.00,'Brake Pad',1,1000000001);
/*!40000 ALTER TABLE `maintenanceparts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintenancepartseq`
--

DROP TABLE IF EXISTS `maintenancepartseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenancepartseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenancepartseq`
--

LOCK TABLES `maintenancepartseq` WRITE;
/*!40000 ALTER TABLE `maintenancepartseq` DISABLE KEYS */;
INSERT INTO `maintenancepartseq` VALUES (1000000003);
/*!40000 ALTER TABLE `maintenancepartseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintenanceseq`
--

DROP TABLE IF EXISTS `maintenanceseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenanceseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenanceseq`
--

LOCK TABLES `maintenanceseq` WRITE;
/*!40000 ALTER TABLE `maintenanceseq` DISABLE KEYS */;
INSERT INTO `maintenanceseq` VALUES (1000000002);
/*!40000 ALTER TABLE `maintenanceseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `notification_id` bigint NOT NULL AUTO_INCREMENT,
  `createdon` datetime(6) DEFAULT NULL,
  `drivername` varchar(100) DEFAULT NULL,
  `duedate` date DEFAULT NULL,
  `isdeleted` bit(1) DEFAULT NULL,
  `isread` bit(1) DEFAULT NULL,
  `message` text,
  `notificationstage` varchar(20) DEFAULT NULL,
  `notificationtype` varchar(50) DEFAULT NULL,
  `orgid` bigint NOT NULL,
  `referenceid` bigint DEFAULT NULL,
  `severity` varchar(20) DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `userid` bigint DEFAULT NULL,
  `vehicle_number` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`notification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `responsibility`
--

DROP TABLE IF EXISTS `responsibility`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `responsibility` (
  `responsibilityid` bigint NOT NULL,
  `active` bit(1) NOT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `orgid` bigint DEFAULT NULL,
  `responsibility` varchar(255) DEFAULT NULL,
  `modifiedby` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`responsibilityid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `responsibility`
--

LOCK TABLES `responsibility` WRITE;
/*!40000 ALTER TABLE `responsibility` DISABLE KEYS */;
/*!40000 ALTER TABLE `responsibility` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `responsibilityseq`
--

DROP TABLE IF EXISTS `responsibilityseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `responsibilityseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `responsibilityseq`
--

LOCK TABLES `responsibilityseq` WRITE;
/*!40000 ALTER TABLE `responsibilityseq` DISABLE KEYS */;
INSERT INTO `responsibilityseq` VALUES (1000000001);
/*!40000 ALTER TABLE `responsibilityseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `roleid` bigint NOT NULL,
  `active` bit(1) DEFAULT NULL,
  `cancel` bit(1) DEFAULT NULL,
  `cancelremarks` varchar(255) DEFAULT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `orgid` bigint DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `modifiedby` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`roleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolepermission`
--

DROP TABLE IF EXISTS `rolepermission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rolepermission` (
  `rolepermissionid` bigint NOT NULL,
  `candelete` bit(1) DEFAULT NULL,
  `canread` bit(1) DEFAULT NULL,
  `canwrite` bit(1) DEFAULT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `screenid` varchar(255) DEFAULT NULL,
  `screenname` varchar(255) DEFAULT NULL,
  `rolepermissionheaderid` bigint DEFAULT NULL,
  PRIMARY KEY (`rolepermissionid`),
  KEY `FKq9ttgvxll7hp835ejbg11r88x` (`rolepermissionheaderid`),
  CONSTRAINT `FKq9ttgvxll7hp835ejbg11r88x` FOREIGN KEY (`rolepermissionheaderid`) REFERENCES `rolepermissionheader` (`rolepermissionheaderid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolepermission`
--

LOCK TABLES `rolepermission` WRITE;
/*!40000 ALTER TABLE `rolepermission` DISABLE KEYS */;
/*!40000 ALTER TABLE `rolepermission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolepermissionheader`
--

DROP TABLE IF EXISTS `rolepermissionheader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rolepermissionheader` (
  `rolepermissionheaderid` bigint NOT NULL,
  `active` bit(1) DEFAULT NULL,
  `cancel` bit(1) DEFAULT NULL,
  `cancelremarks` varchar(255) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `orgid` bigint DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `modifiedby` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`rolepermissionheaderid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolepermissionheader`
--

LOCK TABLES `rolepermissionheader` WRITE;
/*!40000 ALTER TABLE `rolepermissionheader` DISABLE KEYS */;
/*!40000 ALTER TABLE `rolepermissionheader` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolepermissionheaderseq`
--

DROP TABLE IF EXISTS `rolepermissionheaderseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rolepermissionheaderseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolepermissionheaderseq`
--

LOCK TABLES `rolepermissionheaderseq` WRITE;
/*!40000 ALTER TABLE `rolepermissionheaderseq` DISABLE KEYS */;
INSERT INTO `rolepermissionheaderseq` VALUES (1000000001);
/*!40000 ALTER TABLE `rolepermissionheaderseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolepermissionseq`
--

DROP TABLE IF EXISTS `rolepermissionseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rolepermissionseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolepermissionseq`
--

LOCK TABLES `rolepermissionseq` WRITE;
/*!40000 ALTER TABLE `rolepermissionseq` DISABLE KEYS */;
INSERT INTO `rolepermissionseq` VALUES (1000000001);
/*!40000 ALTER TABLE `rolepermissionseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `rolesid` bigint NOT NULL,
  `active` bit(1) NOT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `orgid` bigint DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `modifiedby` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`rolesid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roleseq`
--

DROP TABLE IF EXISTS `roleseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roleseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roleseq`
--

LOCK TABLES `roleseq` WRITE;
/*!40000 ALTER TABLE `roleseq` DISABLE KEYS */;
INSERT INTO `roleseq` VALUES (1000000001);
/*!40000 ALTER TABLE `roleseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolesresponsibility`
--

DROP TABLE IF EXISTS `rolesresponsibility`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rolesresponsibility` (
  `rolesresponsibilityid` bigint NOT NULL,
  `orgid` bigint DEFAULT NULL,
  `responsibility` varchar(255) DEFAULT NULL,
  `responsibilityid` bigint DEFAULT NULL,
  `rolesid` bigint DEFAULT NULL,
  PRIMARY KEY (`rolesresponsibilityid`),
  KEY `FKeci4f1t6kxn7ig0kyq7dl7ky0` (`rolesid`),
  CONSTRAINT `FKeci4f1t6kxn7ig0kyq7dl7ky0` FOREIGN KEY (`rolesid`) REFERENCES `roles` (`rolesid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolesresponsibility`
--

LOCK TABLES `rolesresponsibility` WRITE;
/*!40000 ALTER TABLE `rolesresponsibility` DISABLE KEYS */;
/*!40000 ALTER TABLE `rolesresponsibility` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolesresponsibilityseq`
--

DROP TABLE IF EXISTS `rolesresponsibilityseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rolesresponsibilityseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolesresponsibilityseq`
--

LOCK TABLES `rolesresponsibilityseq` WRITE;
/*!40000 ALTER TABLE `rolesresponsibilityseq` DISABLE KEYS */;
INSERT INTO `rolesresponsibilityseq` VALUES (1000000001);
/*!40000 ALTER TABLE `rolesresponsibilityseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolesseq`
--

DROP TABLE IF EXISTS `rolesseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rolesseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolesseq`
--

LOCK TABLES `rolesseq` WRITE;
/*!40000 ALTER TABLE `rolesseq` DISABLE KEYS */;
INSERT INTO `rolesseq` VALUES (1000000001);
/*!40000 ALTER TABLE `rolesseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `screenname`
--

DROP TABLE IF EXISTS `screenname`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `screenname` (
  `screennameid` bigint NOT NULL,
  `active` bit(1) NOT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `createdby` varchar(25) DEFAULT NULL,
  `screencode` varchar(50) DEFAULT NULL,
  `screenname` varchar(255) DEFAULT NULL,
  `modifiedby` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`screennameid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `screenname`
--

LOCK TABLES `screenname` WRITE;
/*!40000 ALTER TABLE `screenname` DISABLE KEYS */;
/*!40000 ALTER TABLE `screenname` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `screennameseq`
--

DROP TABLE IF EXISTS `screennameseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `screennameseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `screennameseq`
--

LOCK TABLES `screennameseq` WRITE;
/*!40000 ALTER TABLE `screennameseq` DISABLE KEYS */;
INSERT INTO `screennameseq` VALUES (1000000001);
/*!40000 ALTER TABLE `screennameseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `screens`
--

DROP TABLE IF EXISTS `screens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `screens` (
  `screensid` bigint NOT NULL,
  `orgid` bigint DEFAULT NULL,
  `screenname` varchar(255) DEFAULT NULL,
  `responsibilityid` bigint DEFAULT NULL,
  PRIMARY KEY (`screensid`),
  KEY `FK8ntnq3og4blj4kmo31omppnax` (`responsibilityid`),
  CONSTRAINT `FK8ntnq3og4blj4kmo31omppnax` FOREIGN KEY (`responsibilityid`) REFERENCES `responsibility` (`responsibilityid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `screens`
--

LOCK TABLES `screens` WRITE;
/*!40000 ALTER TABLE `screens` DISABLE KEYS */;
/*!40000 ALTER TABLE `screens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `screensseq`
--

DROP TABLE IF EXISTS `screensseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `screensseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `screensseq`
--

LOCK TABLES `screensseq` WRITE;
/*!40000 ALTER TABLE `screensseq` DISABLE KEYS */;
INSERT INTO `screensseq` VALUES (1000000001);
/*!40000 ALTER TABLE `screensseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tdriver`
--

DROP TABLE IF EXISTS `tdriver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tdriver` (
  `tdriverid` bigint NOT NULL,
  `aadharnumber` varchar(20) DEFAULT NULL,
  `active` bit(1) DEFAULT NULL,
  `address` text,
  `assignedvehicle` varchar(30) DEFAULT NULL,
  `bloodgroup` varchar(10) DEFAULT NULL,
  `branchcode` varchar(255) DEFAULT NULL,
  `branchname` varchar(255) DEFAULT NULL,
  `cancel` bit(1) DEFAULT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `currentlocation` varchar(100) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `emergencycontact` varchar(20) DEFAULT NULL,
  `experience` varchar(50) DEFAULT NULL,
  `joineddate` date DEFAULT NULL,
  `lasttrip` date DEFAULT NULL,
  `licenseexpiry` date DEFAULT NULL,
  `licensenumber` varchar(50) DEFAULT NULL,
  `name` varchar(150) DEFAULT NULL,
  `orgid` bigint DEFAULT NULL,
  `performance` varchar(20) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `salary` varchar(50) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `modifiedby` varchar(255) DEFAULT NULL,
  `userid` bigint DEFAULT NULL,
  PRIMARY KEY (`tdriverid`),
  KEY `FK19hvygnf4t704edohywps6fxy` (`userid`),
  CONSTRAINT `FK19hvygnf4t704edohywps6fxy` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tdriver`
--

LOCK TABLES `tdriver` WRITE;
/*!40000 ALTER TABLE `tdriver` DISABLE KEYS */;
INSERT INTO `tdriver` VALUES (1000000001,'4553 6745 6785',_binary '','MARATHAHALLI, BANGALORE','','A+','MAIN','Main Branch',_binary '\0','19-09-2026 03:06:26 PM','19-09-2026 03:06:26 PM','1000000004','MADURAI','karuppu@whydigit.in','4653456783','5','2026-09-01',NULL,'2030-10-22','ABC12345678','KARUPPU',1000000004,'4.5/5','9790060277','100000','Active','1000000004',1000000004),(1000000002,'2435 6789 0657',_binary '','MELUR, MADURAI','','B+','MAIN','Main Branch',_binary '\0','19-09-2026 03:09:30 PM','19-09-2026 03:57:20 PM','1000000004','MADURAI','dhineshkumar93262@gmail.com','2345678906','5','2026-09-02',NULL,'2028-10-17','DC23456783456789','DHINESH',1000000004,'4.5/5','9080335964','50000','Active','1000000004',1000000004);
/*!40000 ALTER TABLE `tdriver` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tdriverdocsseq`
--

DROP TABLE IF EXISTS `tdriverdocsseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tdriverdocsseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tdriverdocsseq`
--

LOCK TABLES `tdriverdocsseq` WRITE;
/*!40000 ALTER TABLE `tdriverdocsseq` DISABLE KEYS */;
INSERT INTO `tdriverdocsseq` VALUES (1000000007);
/*!40000 ALTER TABLE `tdriverdocsseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tdriverdocuments`
--

DROP TABLE IF EXISTS `tdriverdocuments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tdriverdocuments` (
  `tdriverdocumentsid` bigint NOT NULL,
  `documenttype` varchar(50) DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `filepath` varchar(500) DEFAULT NULL,
  `filesize` bigint DEFAULT NULL,
  `filetype` varchar(50) DEFAULT NULL,
  `uploadedon` datetime(6) DEFAULT NULL,
  `tdriverid` bigint NOT NULL,
  PRIMARY KEY (`tdriverdocumentsid`),
  KEY `FKay89um67wdcj7u1uw60jyme4c` (`tdriverid`),
  CONSTRAINT `FKay89um67wdcj7u1uw60jyme4c` FOREIGN KEY (`tdriverid`) REFERENCES `tdriver` (`tdriverid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tdriverdocuments`
--

LOCK TABLES `tdriverdocuments` WRITE;
/*!40000 ALTER TABLE `tdriverdocuments` DISABLE KEYS */;
INSERT INTO `tdriverdocuments` VALUES (1000000001,'DL','cfa0cd2a-7ecd-4488-8580-72d29eb3b662_4657370983.pdf','uploads/driver/ABC12345678/DL/cfa0cd2a-7ecd-4488-8580-72d29eb3b662_4657370983.pdf',193806,'application/pdf','2026-09-19 09:36:26.209941',1000000001),(1000000002,'AADHAR','8c327b7f-f14d-47c4-b29b-baf21c32555f_4864203315.pdf','uploads/driver/ABC12345678/AADHAR/8c327b7f-f14d-47c4-b29b-baf21c32555f_4864203315.pdf',193922,'application/pdf','2026-09-19 09:36:26.238269',1000000001),(1000000003,'PHOTO','bc1282df-8a39-452d-8516-35665a28074a_Arun img.jpeg','uploads/driver/ABC12345678/PHOTO/bc1282df-8a39-452d-8516-35665a28074a_Arun img.jpeg',523815,'image/jpeg','2026-09-19 09:36:26.256285',1000000001),(1000000004,'DL','fcc2120e-d539-4ac5-a57e-1abbeec1e446_4657370983.pdf','uploads/driver/DC23456783456789/DL/fcc2120e-d539-4ac5-a57e-1abbeec1e446_4657370983.pdf',193806,'application/pdf','2026-09-19 09:39:30.589656',1000000002),(1000000005,'AADHAR','71b76997-4f05-42f9-b726-3d3fe1c4dd25_4864203315.pdf','uploads/driver/DC23456783456789/AADHAR/71b76997-4f05-42f9-b726-3d3fe1c4dd25_4864203315.pdf',193922,'application/pdf','2026-09-19 09:39:30.613673',1000000002),(1000000006,'PHOTO','25cc216a-72d3-4ab1-97d8-d96a1aed9dd7_dhinesh img.jpeg','uploads/driver/DC23456783456789/PHOTO/25cc216a-72d3-4ab1-97d8-d96a1aed9dd7_dhinesh img.jpeg',118674,'image/jpeg','2026-09-19 09:39:30.631662',1000000002);
/*!40000 ALTER TABLE `tdriverdocuments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tdriverseq`
--

DROP TABLE IF EXISTS `tdriverseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tdriverseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tdriverseq`
--

LOCK TABLES `tdriverseq` WRITE;
/*!40000 ALTER TABLE `tdriverseq` DISABLE KEYS */;
INSERT INTO `tdriverseq` VALUES (1000000003);
/*!40000 ALTER TABLE `tdriverseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket`
--

DROP TABLE IF EXISTS `ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticket` (
  `ticketid` bigint NOT NULL,
  `branch` varchar(255) DEFAULT NULL,
  `branchcode` varchar(255) DEFAULT NULL,
  `cancel` bit(1) NOT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `companyname` varchar(255) DEFAULT NULL,
  `contenttype` varchar(255) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `docid` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `filepath` varchar(255) DEFAULT NULL,
  `filesize` bigint DEFAULT NULL,
  `notificationflag` bit(1) DEFAULT NULL,
  `orgid` bigint DEFAULT NULL,
  `screenshot` longblob,
  `source_id` bigint DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `statusflag` bit(1) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `ticketstatus` varchar(255) DEFAULT NULL,
  `modifiedy` varchar(255) DEFAULT NULL,
  `updateddate` date DEFAULT NULL,
  `uploadon` datetime(6) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ticketid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket`
--

LOCK TABLES `ticket` WRITE;
/*!40000 ALTER TABLE `ticket` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticketseq`
--

DROP TABLE IF EXISTS `ticketseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticketseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticketseq`
--

LOCK TABLES `ticketseq` WRITE;
/*!40000 ALTER TABLE `ticketseq` DISABLE KEYS */;
INSERT INTO `ticketseq` VALUES (1000000001);
/*!40000 ALTER TABLE `ticketseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token`
--

DROP TABLE IF EXISTS `token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token` (
  `id` varchar(255) NOT NULL,
  `created_date` datetime(6) DEFAULT NULL,
  `exp_date` datetime(6) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token`
--

LOCK TABLES `token` WRITE;
/*!40000 ALTER TABLE `token` DISABLE KEYS */;
INSERT INTO `token` VALUES ('a43f15c4-03c4-41b4-9c9d-4c012baf59f6','2026-09-19 09:17:56.074000','2026-09-19 10:07:56.074000',1000000004);
/*!40000 ALTER TABLE `token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trackingtoken`
--

DROP TABLE IF EXISTS `trackingtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trackingtoken` (
  `trackingtokenid` bigint NOT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `refresh_token` varchar(2000) DEFAULT NULL,
  `token` varchar(2000) DEFAULT NULL,
  `token_expiry` datetime(6) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`trackingtokenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trackingtoken`
--

LOCK TABLES `trackingtoken` WRITE;
/*!40000 ALTER TABLE `trackingtoken` DISABLE KEYS */;
INSERT INTO `trackingtoken` VALUES (1000000001,'2026-01-21 14:49:53','2026-01-21 14:49:53','Masters@12345','','',NULL,'info@whydigit.com'),(1000000002,'19-09-2026 03:45:10 PM','19-09-2026 03:45:10 PM','Masters@12345','eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc5MjQ5MTMxMSwianRpIjoiMmRjZGJmMjA3ZDljNDU1ZDlmYzk1ZDI0YTlmNGE0NmQiLCJ1c2VyX2lkIjozMjY4NCwidXNlcm5hbWUiOiJpbmZvQHdoeWRpZ2l0LmNvbSIsImVtYWlsIjoiaW5mb0B3aHlkaWdpdC5jb20iLCJvcmdfaWQiOm51bGx9.0qTwy8V5COV_v-e_cgWbeg8sJywbWejU3RKwT0lbG6o','eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzg5ODk5MzExLCJqdGkiOiI5ZjI0Mjc2YWVkMDg0OGYwOWNiYzIzMWZjYzFkMmJhNSIsInVzZXJfaWQiOjMyNjg0LCJ1c2VybmFtZSI6ImluZm9Ad2h5ZGlnaXQuY29tIiwiZW1haWwiOiJpbmZvQHdoeWRpZ2l0LmNvbSIsIm9yZ19pZCI6bnVsbH0.iHXZDIKtmcGDesLUsYzv6wMJj_nGvUHoRr4xxk8aMIw','2026-09-20 10:15:11.000000','info@whydigit.com');
/*!40000 ALTER TABLE `trackingtoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trackingtokenseq`
--

DROP TABLE IF EXISTS `trackingtokenseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trackingtokenseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trackingtokenseq`
--

LOCK TABLES `trackingtokenseq` WRITE;
/*!40000 ALTER TABLE `trackingtokenseq` DISABLE KEYS */;
INSERT INTO `trackingtokenseq` VALUES (1000000003);
/*!40000 ALTER TABLE `trackingtokenseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trip`
--

DROP TABLE IF EXISTS `trip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trip` (
  `tripid` bigint NOT NULL,
  `active` bit(1) DEFAULT NULL,
  `branchcode` varchar(255) DEFAULT NULL,
  `branchname` varchar(255) DEFAULT NULL,
  `cancel` bit(1) DEFAULT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `destination` varchar(255) DEFAULT NULL,
  `destinationlat` varchar(255) DEFAULT NULL,
  `destinationlng` varchar(255) DEFAULT NULL,
  `distance` double DEFAULT NULL,
  `enddate` date DEFAULT NULL,
  `endtime` time DEFAULT NULL,
  `estimatedduration` varchar(255) DEFAULT NULL,
  `fuelcost` decimal(19,2) DEFAULT NULL,
  `goodstype` varchar(255) DEFAULT NULL,
  `goodsvalue` decimal(19,2) DEFAULT NULL,
  `goodsweight` decimal(19,2) DEFAULT NULL,
  `invoice_no` varchar(255) DEFAULT NULL,
  `notes` varchar(1000) DEFAULT NULL,
  `orgid` bigint DEFAULT NULL,
  `otherexpenses` decimal(19,2) DEFAULT NULL,
  `profit` decimal(19,2) DEFAULT NULL,
  `revenue` decimal(19,2) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `sourcelat` varchar(255) DEFAULT NULL,
  `sourcelng` varchar(255) DEFAULT NULL,
  `startdate` date DEFAULT NULL,
  `starttime` time DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `tollcharges` decimal(19,2) DEFAULT NULL,
  `tripcost` decimal(19,2) DEFAULT NULL,
  `tripendtime` datetime(6) DEFAULT NULL,
  `tripstarttime` datetime(6) DEFAULT NULL,
  `triptrackid` varchar(255) DEFAULT NULL,
  `triptype` varchar(255) DEFAULT NULL,
  `modifiedby` varchar(255) DEFAULT NULL,
  `customer` bigint DEFAULT NULL,
  `driver` bigint DEFAULT NULL,
  `userid` bigint DEFAULT NULL,
  `vehicle` bigint DEFAULT NULL,
  PRIMARY KEY (`tripid`),
  KEY `FKr4icv2aeuutsbte4je81o4uvd` (`customer`),
  KEY `FKl0bplx16yatcdutgvib6p1njr` (`driver`),
  KEY `FK60s5tmb4lky31r0wrkcyjt4j8` (`userid`),
  KEY `FKgx8celknuwouxqbtpm7s7d3tw` (`vehicle`),
  CONSTRAINT `FK60s5tmb4lky31r0wrkcyjt4j8` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`),
  CONSTRAINT `FKgx8celknuwouxqbtpm7s7d3tw` FOREIGN KEY (`vehicle`) REFERENCES `tvehicle` (`tvehicleid`),
  CONSTRAINT `FKl0bplx16yatcdutgvib6p1njr` FOREIGN KEY (`driver`) REFERENCES `tdriver` (`tdriverid`),
  CONSTRAINT `FKr4icv2aeuutsbte4je81o4uvd` FOREIGN KEY (`customer`) REFERENCES `customer` (`customerid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trip`
--

LOCK TABLES `trip` WRITE;
/*!40000 ALTER TABLE `trip` DISABLE KEYS */;
INSERT INTO `trip` VALUES (1000000001,_binary '','MAIN','Main Branch',_binary '\0','19-09-2026 03:29:13 PM','19-09-2026 03:57:20 PM','1000000004','Chennai, Tamil Nadu, India','13.0570568','80.2098219',451,'2026-09-19','23:04:00','7 hours 29 mins',5000.00,'',0.00,0.00,'20260919152913','TRIP TO CHENNAI',1000000004,3000.00,11000.00,60000.00,'Madurai, Tamil Nadu, India','9.9252007','78.1197754','2026-09-19','15:35:00','COMPLETED',1000.00,40000.00,'2026-09-19 15:49:52.000000','2026-09-19 15:38:56.000000','c6e9e742-31e4-4e2b-a203-03a466c319a5','passenger','1000000004',1000000001,1000000002,1000000004,1000000001);
/*!40000 ALTER TABLE `trip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tripinvoice`
--

DROP TABLE IF EXISTS `tripinvoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tripinvoice` (
  `invoiceid` bigint NOT NULL,
  `active` bit(1) DEFAULT NULL,
  `amountpaid` decimal(19,2) DEFAULT NULL,
  `balancedue` decimal(19,2) DEFAULT NULL,
  `branchcode` varchar(255) DEFAULT NULL,
  `branchname` varchar(255) DEFAULT NULL,
  `cancel` bit(1) DEFAULT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `discount` decimal(19,2) DEFAULT NULL,
  `duedate` date DEFAULT NULL,
  `issuedate` date DEFAULT NULL,
  `notes` varchar(1000) DEFAULT NULL,
  `orgid` bigint DEFAULT NULL,
  `paymentdate` date DEFAULT NULL,
  `paymentmethod` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `subtotal` decimal(19,2) DEFAULT NULL,
  `taxamount` decimal(19,2) DEFAULT NULL,
  `taxrate` decimal(19,2) DEFAULT NULL,
  `totalamount` decimal(19,2) DEFAULT NULL,
  `tripdetails` varchar(255) DEFAULT NULL,
  `updatedby` varchar(255) DEFAULT NULL,
  `customer` bigint DEFAULT NULL,
  `tdriverid` bigint DEFAULT NULL,
  `tripid` bigint DEFAULT NULL,
  `tvehicleid` bigint DEFAULT NULL,
  PRIMARY KEY (`invoiceid`),
  KEY `FKg4anm59bvmyi5oepp7ukmi5dt` (`customer`),
  KEY `FKrcsbelse6fx5el8l4iy3gpe0r` (`tdriverid`),
  KEY `FKlen8j8ypbg3hgtiqajp1kpg6y` (`tripid`),
  KEY `FKsppm4jmlul3sqya7p9uxy4w32` (`tvehicleid`),
  CONSTRAINT `FKg4anm59bvmyi5oepp7ukmi5dt` FOREIGN KEY (`customer`) REFERENCES `customer` (`customerid`),
  CONSTRAINT `FKlen8j8ypbg3hgtiqajp1kpg6y` FOREIGN KEY (`tripid`) REFERENCES `trip` (`tripid`),
  CONSTRAINT `FKrcsbelse6fx5el8l4iy3gpe0r` FOREIGN KEY (`tdriverid`) REFERENCES `tdriver` (`tdriverid`),
  CONSTRAINT `FKsppm4jmlul3sqya7p9uxy4w32` FOREIGN KEY (`tvehicleid`) REFERENCES `tvehicle` (`tvehicleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tripinvoice`
--

LOCK TABLES `tripinvoice` WRITE;
/*!40000 ALTER TABLE `tripinvoice` DISABLE KEYS */;
INSERT INTO `tripinvoice` VALUES (1000000001,_binary '',50000.00,20000.00,NULL,NULL,_binary '\0','19-09-2026 03:57:20 PM','19-09-2026 03:57:20 PM','vignesh@whydigit.in',800.00,'2026-10-19','2026-09-19','Invoice to chennai',1000000004,'2026-09-19','bank_transfer','paid',60000.00,10800.00,18.00,70000.00,'Madurai, Tamil Nadu, India to Chennai, Tamil Nadu, India','vignesh@whydigit.in',1000000001,1000000002,1000000001,1000000001);
/*!40000 ALTER TABLE `tripinvoice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tripinvoiceitem`
--

DROP TABLE IF EXISTS `tripinvoiceitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tripinvoiceitem` (
  `invoiceitemid` bigint NOT NULL,
  `amount` decimal(19,2) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `itemcode` varchar(255) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `rate` decimal(19,2) DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `invoiceid` bigint DEFAULT NULL,
  PRIMARY KEY (`invoiceitemid`),
  KEY `FK2c3ooobrshploo5cdgg9xjclk` (`invoiceid`),
  CONSTRAINT `FK2c3ooobrshploo5cdgg9xjclk` FOREIGN KEY (`invoiceid`) REFERENCES `tripinvoice` (`invoiceid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tripinvoiceitem`
--

LOCK TABLES `tripinvoiceitem` WRITE;
/*!40000 ALTER TABLE `tripinvoiceitem` DISABLE KEYS */;
INSERT INTO `tripinvoiceitem` VALUES (1000000001,60000.00,'Trip to Chennai','ITEM-001',1,60000.00,'trip',1000000001);
/*!40000 ALTER TABLE `tripinvoiceitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tripinvoiceitemseq`
--

DROP TABLE IF EXISTS `tripinvoiceitemseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tripinvoiceitemseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tripinvoiceitemseq`
--

LOCK TABLES `tripinvoiceitemseq` WRITE;
/*!40000 ALTER TABLE `tripinvoiceitemseq` DISABLE KEYS */;
INSERT INTO `tripinvoiceitemseq` VALUES (1000000002);
/*!40000 ALTER TABLE `tripinvoiceitemseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tripinvoiceseq`
--

DROP TABLE IF EXISTS `tripinvoiceseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tripinvoiceseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tripinvoiceseq`
--

LOCK TABLES `tripinvoiceseq` WRITE;
/*!40000 ALTER TABLE `tripinvoiceseq` DISABLE KEYS */;
INSERT INTO `tripinvoiceseq` VALUES (1000000002);
/*!40000 ALTER TABLE `tripinvoiceseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tripseq`
--

DROP TABLE IF EXISTS `tripseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tripseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tripseq`
--

LOCK TABLES `tripseq` WRITE;
/*!40000 ALTER TABLE `tripseq` DISABLE KEYS */;
INSERT INTO `tripseq` VALUES (1000000002);
/*!40000 ALTER TABLE `tripseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tripwaypoints`
--

DROP TABLE IF EXISTS `tripwaypoints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tripwaypoints` (
  `waypoint_id` bigint NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `sequenceno` int DEFAULT NULL,
  `tripid` bigint DEFAULT NULL,
  PRIMARY KEY (`waypoint_id`),
  KEY `FK6epvxf85s08k3foe5dmouabgc` (`tripid`),
  CONSTRAINT `FK6epvxf85s08k3foe5dmouabgc` FOREIGN KEY (`tripid`) REFERENCES `trip` (`tripid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tripwaypoints`
--

LOCK TABLES `tripwaypoints` WRITE;
/*!40000 ALTER TABLE `tripwaypoints` DISABLE KEYS */;
INSERT INTO `tripwaypoints` VALUES (1000000001,'Tiruchirappalli, Tamil Nadu, India',1,1000000001);
/*!40000 ALTER TABLE `tripwaypoints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tripwaypointseq`
--

DROP TABLE IF EXISTS `tripwaypointseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tripwaypointseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tripwaypointseq`
--

LOCK TABLES `tripwaypointseq` WRITE;
/*!40000 ALTER TABLE `tripwaypointseq` DISABLE KEYS */;
INSERT INTO `tripwaypointseq` VALUES (1000000002);
/*!40000 ALTER TABLE `tripwaypointseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tvehicle`
--

DROP TABLE IF EXISTS `tvehicle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tvehicle` (
  `tvehicleid` bigint NOT NULL,
  `active` varchar(255) DEFAULT NULL,
  `branchcode` varchar(255) DEFAULT NULL,
  `branchname` varchar(255) DEFAULT NULL,
  `cancel` bit(1) DEFAULT NULL,
  `capacity` varchar(100) DEFAULT NULL,
  `chassisnumber` varchar(100) DEFAULT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `currentlocation` varchar(150) DEFAULT NULL,
  `driver` varchar(100) DEFAULT NULL,
  `driverphone` varchar(25) DEFAULT NULL,
  `droplocation` varchar(255) DEFAULT NULL,
  `enginenumber` varchar(100) DEFAULT NULL,
  `fitnessexpiry` date DEFAULT NULL,
  `fuelefficiency` varchar(50) DEFAULT NULL,
  `hirecost` decimal(19,2) DEFAULT NULL,
  `hiredate` date DEFAULT NULL,
  `insuranceexpiry` date DEFAULT NULL,
  `lastservice` date DEFAULT NULL,
  `maintenancerequired` bit(1) DEFAULT NULL,
  `model` varchar(150) DEFAULT NULL,
  `nextservice` date DEFAULT NULL,
  `orgid` bigint DEFAULT NULL,
  `ownername` varchar(100) DEFAULT NULL,
  `permittype` varchar(50) DEFAULT NULL,
  `pickuplocation` varchar(255) DEFAULT NULL,
  `pucexpiry` date DEFAULT NULL,
  `registrationtype` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `modifiedby` varchar(255) DEFAULT NULL,
  `vehiclenumber` varchar(50) DEFAULT NULL,
  `year` int DEFAULT NULL,
  `userid` bigint DEFAULT NULL,
  PRIMARY KEY (`tvehicleid`),
  UNIQUE KEY `UK_pwuhj8xa8elargd9s2ttmxj5e` (`vehiclenumber`),
  KEY `FKcdon9vxql1c5s2vvldtdyaksy` (`userid`),
  CONSTRAINT `FKcdon9vxql1c5s2vvldtdyaksy` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tvehicle`
--

LOCK TABLES `tvehicle` WRITE;
/*!40000 ALTER TABLE `tvehicle` DISABLE KEYS */;
INSERT INTO `tvehicle` VALUES (1000000001,'ACTIVE','CHE001','Chennai',_binary '\0','50FT','2345678DFG','19-09-2026 03:17:47 PM','19-09-2026 03:57:20 PM','Admin','MADURAI','DHINESH','9080335964',NULL,'DFGK4567895678','2028-11-19','5',NULL,NULL,'2028-10-26','2026-09-19',_binary '\0','TATA','2026-10-01',1000000004,'Self','National',NULL,'2028-11-23','TOURIST','OPEN_TRUCK','Admin','TN-09-AB-0909',2026,1000000004),(1000000002,'ACTIVE','CHE001','Chennai',_binary '\0','60','SDFGH4567','19-09-2026 03:20:17 PM','19-09-2026 03:37:48 PM','Admin','BANGALORE','KARUPPU','9790060277',NULL,'DFGHJK3456789','2026-09-23','4',NULL,NULL,'2026-09-24','2026-09-17',_binary '\0','BOLERO','2026-10-30',1000000004,'Self','National',NULL,'2026-09-20','COMMERCIAL','TANKER','Admin','KL-09-RB-9878',2026,1000000004);
/*!40000 ALTER TABLE `tvehicle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tvehicledocuments`
--

DROP TABLE IF EXISTS `tvehicledocuments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tvehicledocuments` (
  `tvehicledocumentsid` bigint NOT NULL,
  `documenttype` varchar(50) DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `filepath` varchar(500) DEFAULT NULL,
  `filesize` bigint DEFAULT NULL,
  `filetype` varchar(50) DEFAULT NULL,
  `uploadedon` datetime(6) DEFAULT NULL,
  `tvehicleid` bigint DEFAULT NULL,
  PRIMARY KEY (`tvehicledocumentsid`),
  KEY `FKnbr8su2rhtdlek3vp0kcopyu3` (`tvehicleid`),
  CONSTRAINT `FKnbr8su2rhtdlek3vp0kcopyu3` FOREIGN KEY (`tvehicleid`) REFERENCES `tvehicle` (`tvehicleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tvehicledocuments`
--

LOCK TABLES `tvehicledocuments` WRITE;
/*!40000 ALTER TABLE `tvehicledocuments` DISABLE KEYS */;
INSERT INTO `tvehicledocuments` VALUES (1000000001,'RC','3c0a5c4f-e55a-412b-a5e8-d8f26ad33c7b_4657370983.pdf','/uploads/vehicles/TN-09-AB-0909/RC/3c0a5c4f-e55a-412b-a5e8-d8f26ad33c7b_4657370983.pdf',193806,'application/pdf','2026-09-19 09:47:47.315299',1000000001),(1000000002,'INSURANCE','5a3369da-9c67-4b8f-8df8-969d9d476401_4864902443.pdf','/uploads/vehicles/TN-09-AB-0909/INSURANCE/5a3369da-9c67-4b8f-8df8-969d9d476401_4864902443.pdf',201428,'application/pdf','2026-09-19 09:47:47.344290',1000000001),(1000000003,'FC','6368360f-db0f-46da-bf45-cfeb684314df_4864203315.pdf','/uploads/vehicles/TN-09-AB-0909/FC/6368360f-db0f-46da-bf45-cfeb684314df_4864203315.pdf',193922,'application/pdf','2026-09-19 09:47:47.368291',1000000001),(1000000004,'RC','b3db2dce-b21b-4802-b67b-15d5caa0aaec_4657370983.pdf','/uploads/vehicles/KL-09-RB-9878/RC/b3db2dce-b21b-4802-b67b-15d5caa0aaec_4657370983.pdf',193806,'application/pdf','2026-09-19 09:50:17.367493',1000000002),(1000000005,'INSURANCE','d30009ee-9448-4ba3-aa20-343663430e83_4864203315.pdf','/uploads/vehicles/KL-09-RB-9878/INSURANCE/d30009ee-9448-4ba3-aa20-343663430e83_4864203315.pdf',193922,'application/pdf','2026-09-19 09:50:17.391500',1000000002),(1000000006,'FC','552bd919-1f5c-4c71-bf3d-85a5d4eb8c71_4864203315.pdf','/uploads/vehicles/KL-09-RB-9878/FC/552bd919-1f5c-4c71-bf3d-85a5d4eb8c71_4864203315.pdf',193922,'application/pdf','2026-09-19 09:50:17.413502',1000000002);
/*!40000 ALTER TABLE `tvehicledocuments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tvehicledocumentsseq`
--

DROP TABLE IF EXISTS `tvehicledocumentsseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tvehicledocumentsseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tvehicledocumentsseq`
--

LOCK TABLES `tvehicledocumentsseq` WRITE;
/*!40000 ALTER TABLE `tvehicledocumentsseq` DISABLE KEYS */;
INSERT INTO `tvehicledocumentsseq` VALUES (1000000007);
/*!40000 ALTER TABLE `tvehicledocumentsseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tvehicleseq`
--

DROP TABLE IF EXISTS `tvehicleseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tvehicleseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tvehicleseq`
--

LOCK TABLES `tvehicleseq` WRITE;
/*!40000 ALTER TABLE `tvehicleseq` DISABLE KEYS */;
INSERT INTO `tvehicleseq` VALUES (1000000003);
/*!40000 ALTER TABLE `tvehicleseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tyremaster`
--

DROP TABLE IF EXISTS `tyremaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tyremaster` (
  `tyreid` bigint NOT NULL,
  `active` bit(1) DEFAULT NULL,
  `branchcode` varchar(255) DEFAULT NULL,
  `branchname` varchar(255) DEFAULT NULL,
  `brand` varchar(255) DEFAULT NULL,
  `cancel` bit(1) DEFAULT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `odometerreading` decimal(19,2) DEFAULT NULL,
  `orgid` bigint DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `pressure` int DEFAULT NULL,
  `purchasecost` decimal(19,2) DEFAULT NULL,
  `purchasedate` date DEFAULT NULL,
  `recommendedpressure` int DEFAULT NULL,
  `serialnumber` varchar(255) DEFAULT NULL,
  `size` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `treaddepth` decimal(19,2) DEFAULT NULL,
  `modifiedby` varchar(255) DEFAULT NULL,
  `userid` bigint DEFAULT NULL,
  `vehicle` bigint DEFAULT NULL,
  PRIMARY KEY (`tyreid`),
  KEY `FKkwk2brr1blo5vifvdabh3oteu` (`userid`),
  KEY `FKo4ie7gvyhc8ao3fglb1r2xc8t` (`vehicle`),
  CONSTRAINT `FKkwk2brr1blo5vifvdabh3oteu` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`),
  CONSTRAINT `FKo4ie7gvyhc8ao3fglb1r2xc8t` FOREIGN KEY (`vehicle`) REFERENCES `tvehicle` (`tvehicleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tyremaster`
--

LOCK TABLES `tyremaster` WRITE;
/*!40000 ALTER TABLE `tyremaster` DISABLE KEYS */;
INSERT INTO `tyremaster` VALUES (1000000001,_binary '','MAIN','Main Branch','MRF',_binary '\0','19-09-2026 03:33:44 PM','19-09-2026 03:33:44 PM','Admin User','ZAPPER','TYRE DETAILS ',5000.00,1000000004,'Front Right',32,10000.00,'2026-09-19',35,'TYRE-8978','205/66 R16','active',7.00,'Admin User',1000000004,1000000002);
/*!40000 ALTER TABLE `tyremaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tyremasterseq`
--

DROP TABLE IF EXISTS `tyremasterseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tyremasterseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tyremasterseq`
--

LOCK TABLES `tyremasterseq` WRITE;
/*!40000 ALTER TABLE `tyremasterseq` DISABLE KEYS */;
INSERT INTO `tyremasterseq` VALUES (1000000002);
/*!40000 ALTER TABLE `tyremasterseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_action`
--

DROP TABLE IF EXISTS `user_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_action` (
  `action_id` bigint NOT NULL AUTO_INCREMENT,
  `action_date` datetime(6) DEFAULT NULL,
  `action_type` varchar(255) DEFAULT NULL,
  `login_ip` varchar(255) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`action_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_action`
--

LOCK TABLES `user_action` WRITE;
/*!40000 ALTER TABLE `user_action` DISABLE KEYS */;
INSERT INTO `user_action` VALUES (1,'2026-09-19 09:17:56.027000','LOGIN','49.37.180.174',1000000004,'vignesh@whydigit.in');
/*!40000 ALTER TABLE `user_action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userbranchaccess`
--

DROP TABLE IF EXISTS `userbranchaccess`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userbranchaccess` (
  `userloginbranchaccessibleid` bigint NOT NULL,
  `branch` varchar(255) DEFAULT NULL,
  `branchcode` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`userloginbranchaccessibleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userbranchaccess`
--

LOCK TABLES `userbranchaccess` WRITE;
/*!40000 ALTER TABLE `userbranchaccess` DISABLE KEYS */;
/*!40000 ALTER TABLE `userbranchaccess` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userloginbranchaccessibleseq`
--

DROP TABLE IF EXISTS `userloginbranchaccessibleseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userloginbranchaccessibleseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userloginbranchaccessibleseq`
--

LOCK TABLES `userloginbranchaccessibleseq` WRITE;
/*!40000 ALTER TABLE `userloginbranchaccessibleseq` DISABLE KEYS */;
INSERT INTO `userloginbranchaccessibleseq` VALUES (1000000001);
/*!40000 ALTER TABLE `userloginbranchaccessibleseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userloginrolesseq`
--

DROP TABLE IF EXISTS `userloginrolesseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userloginrolesseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userloginrolesseq`
--

LOCK TABLES `userloginrolesseq` WRITE;
/*!40000 ALTER TABLE `userloginrolesseq` DISABLE KEYS */;
INSERT INTO `userloginrolesseq` VALUES (1000000001);
/*!40000 ALTER TABLE `userloginrolesseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userrolesaccess`
--

DROP TABLE IF EXISTS `userrolesaccess`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userrolesaccess` (
  `userloginrolesid` bigint NOT NULL,
  `enddate` date DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `roleid` bigint DEFAULT NULL,
  `startdate` date DEFAULT NULL,
  PRIMARY KEY (`userloginrolesid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userrolesaccess`
--

LOCK TABLES `userrolesaccess` WRITE;
/*!40000 ALTER TABLE `userrolesaccess` DISABLE KEYS */;
/*!40000 ALTER TABLE `userrolesaccess` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `userid` bigint NOT NULL,
  `active` bit(1) DEFAULT NULL,
  `approveby` varchar(255) DEFAULT NULL,
  `approveon` varchar(255) DEFAULT NULL,
  `branch` varchar(255) DEFAULT NULL,
  `branchcode` varchar(255) DEFAULT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mobileno` varchar(255) DEFAULT NULL,
  `orgid` bigint DEFAULT NULL,
  `organizationname` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `status` int DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `modifiedby` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `vendorid` bigint DEFAULT NULL,
  `usertype` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1000000001,_binary '',NULL,NULL,NULL,NULL,'20-07-2026 03:29:16 PM','18-09-2026 11:00:00 PM','Dhinesh','dhinesh@whydigit.in','9080335964',NULL,'D Transport','$2a$10$T/WqRbq0UsjilFvoeyrh0eYfmVa8GlejW0Ntwjor32/thpeEyt5tu',1,'Transporter',NULL,'dhinesh@whydigit.in',NULL,'ADMIN'),(1000000004,_binary '','admin','20-07-2026 04:33:13 PM',NULL,NULL,'20-07-2026 04:32:04 PM','19-09-2026 03:57:20 PM','Vignesh','vignesh@whydigit.in','9345377252',1000000004,'VJ Transport','$2a$10$aCB51tp2emGhki9zZau6Xu6R7AlGQu3kHwVrNq0BriflIArEwVplO',1,'Transporter',NULL,'vignesh@whydigit.in',NULL,'USER');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usersseq`
--

DROP TABLE IF EXISTS `usersseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usersseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usersseq`
--

LOCK TABLES `usersseq` WRITE;
/*!40000 ALTER TABLE `usersseq` DISABLE KEYS */;
INSERT INTO `usersseq` VALUES (1000000005);
/*!40000 ALTER TABLE `usersseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicle`
--

DROP TABLE IF EXISTS `vehicle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle` (
  `vehicleid` bigint NOT NULL,
  `active` bit(1) DEFAULT NULL,
  `branch` varchar(255) DEFAULT NULL,
  `branchcode` varchar(255) DEFAULT NULL,
  `cancel` bit(1) DEFAULT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `orgid` bigint DEFAULT NULL,
  `screencode` varchar(255) DEFAULT NULL,
  `screenname` varchar(255) DEFAULT NULL,
  `modifiedby` varchar(255) DEFAULT NULL,
  `vehiclenumber` varchar(255) DEFAULT NULL,
  `vehicletype` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`vehicleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle`
--

LOCK TABLES `vehicle` WRITE;
/*!40000 ALTER TABLE `vehicle` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicleseq`
--

DROP TABLE IF EXISTS `vehicleseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicleseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicleseq`
--

LOCK TABLES `vehicleseq` WRITE;
/*!40000 ALTER TABLE `vehicleseq` DISABLE KEYS */;
INSERT INTO `vehicleseq` VALUES (1000000001);
/*!40000 ALTER TABLE `vehicleseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicletype`
--

DROP TABLE IF EXISTS `vehicletype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicletype` (
  `vehicletypeid` bigint NOT NULL,
  `active` bit(1) DEFAULT NULL,
  `branch` varchar(255) DEFAULT NULL,
  `branchcode` varchar(255) DEFAULT NULL,
  `cancel` bit(1) DEFAULT NULL,
  `createdon` varchar(25) DEFAULT NULL,
  `modifiedon` varchar(25) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `hight` double DEFAULT NULL,
  `length` double DEFAULT NULL,
  `mileage` double DEFAULT NULL,
  `orgid` bigint DEFAULT NULL,
  `screencode` varchar(255) DEFAULT NULL,
  `screenname` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `modifiedby` varchar(255) DEFAULT NULL,
  `vehiclesqftcapacity` double DEFAULT NULL,
  `vehicletonnagecapacity` double DEFAULT NULL,
  `vehicletype` varchar(255) DEFAULT NULL,
  `width` double DEFAULT NULL,
  PRIMARY KEY (`vehicletypeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicletype`
--

LOCK TABLES `vehicletype` WRITE;
/*!40000 ALTER TABLE `vehicletype` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicletype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicletypeseq`
--

DROP TABLE IF EXISTS `vehicletypeseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicletypeseq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicletypeseq`
--

LOCK TABLES `vehicletypeseq` WRITE;
/*!40000 ALTER TABLE `vehicletypeseq` DISABLE KEYS */;
INSERT INTO `vehicletypeseq` VALUES (1000000001);
/*!40000 ALTER TABLE `vehicletypeseq` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-19 16:29:18
