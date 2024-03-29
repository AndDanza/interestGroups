-- MySQL Script generated by MySQL Workbench
-- Sun May 21 19:33:35 2017
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema WebDiP2016x030
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema WebDiP2016x030
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `WebDiP2016x030` DEFAULT CHARACTER SET utf8 ;
USE `WebDiP2016x030` ;

-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`tip_korisnika`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`tip_korisnika` (
  `id_tip_korisnika` INT NOT NULL,
  `naziv_tipa` VARCHAR(45) NOT NULL,
  `ovlasti` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_tip_korisnika`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`korisnik`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`korisnik` (
  `id_korisnik` INT NOT NULL,
  `tip_korisnika` INT NOT NULL,
  `ime` VARCHAR(45) NULL DEFAULT NULL,
  `prezime` VARCHAR(45) NULL DEFAULT NULL,
  `korisnicko_ime` VARCHAR(70) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `lozinka` VARCHAR(45) NOT NULL,
  `kriptirana_lozinka` VARCHAR(45) NOT NULL,
  `prijava_dva_koraka` TINYINT NOT NULL DEFAULT 0,
  `aktivan_racun` TINYINT NOT NULL DEFAULT 1,
  `stanje_bodova` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_korisnik`),
  INDEX `fk_korisnik_tip_korisnika_idx` (`tip_korisnika` ASC),
  CONSTRAINT `fk_korisnik_tip_korisnika`
    FOREIGN KEY (`tip_korisnika`)
    REFERENCES `WebDiP2016x030`.`tip_korisnika` (`id_tip_korisnika`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`cekanje_aktivacije`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`cekanje_aktivacije` (
  `datum_vrijeme_slanja_linka` DATETIME NOT NULL,
  `korisnik` INT NOT NULL,
  `link_iskoristen` TINYINT NOT NULL DEFAULT 0,
  `link_aktivacije` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`datum_vrijeme_slanja_linka`, `korisnik`),
  INDEX `fk_cekanje_aktivacije_korisnik1_idx` (`korisnik` ASC),
  CONSTRAINT `fk_cekanje_aktivacije_korisnik1`
    FOREIGN KEY (`korisnik`)
    REFERENCES `WebDiP2016x030`.`korisnik` (`id_korisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`pogresna_prijava`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`pogresna_prijava` (
  `korisnik` INT NOT NULL,
  `datum_vrijeme_pokusaja` DATETIME NOT NULL,
  `administrator` INT NULL DEFAULT NULL,
  `racun_zakljucan` TINYINT NULL DEFAULT 1,
  `datum_vrijeme_otkljucavanje` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`korisnik`, `datum_vrijeme_pokusaja`),
  INDEX `fk_pogresna_prijava_korisnik2_idx` (`administrator` ASC),
  CONSTRAINT `fk_pogresna_prijava_korisnik1`
    FOREIGN KEY (`korisnik`)
    REFERENCES `WebDiP2016x030`.`korisnik` (`id_korisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pogresna_prijava_korisnik2`
    FOREIGN KEY (`administrator`)
    REFERENCES `WebDiP2016x030`.`korisnik` (`id_korisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`prijava_dva_koraka`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`prijava_dva_koraka` (
  `korisnik` INT NOT NULL,
  `datum_vrijeme_izdavanja_koda` DATETIME NOT NULL,
  `jednokratni_kod` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`korisnik`, `datum_vrijeme_izdavanja_koda`),
  CONSTRAINT `fk_prijava_dva_koraka_korisnik1`
    FOREIGN KEY (`korisnik`)
    REFERENCES `WebDiP2016x030`.`korisnik` (`id_korisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`izgled_stranice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`izgled_stranice` (
  `id_izgled_stranice` INT NOT NULL,
  `boja` VARCHAR(45) NOT NULL,
  `font` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_izgled_stranice`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`podrucja_interesa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`podrucja_interesa` (
  `id_podrucja` INT NOT NULL,
  `naziv_podrucja` VARCHAR(100) NOT NULL,
  `moderator` INT NOT NULL,
  `izgled_stranice_id` INT NOT NULL,
  PRIMARY KEY (`id_podrucja`),
  INDEX `fk_podrucja_interesa_korisnik1_idx` (`moderator` ASC),
  INDEX `fk_podrucja_interesa_izgled_stranice1_idx` (`izgled_stranice_id` ASC),
  CONSTRAINT `fk_podrucja_interesa_korisnik1`
    FOREIGN KEY (`moderator`)
    REFERENCES `WebDiP2016x030`.`korisnik` (`id_korisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_podrucja_interesa_izgled_stranice1`
    FOREIGN KEY (`izgled_stranice_id`)
    REFERENCES `WebDiP2016x030`.`izgled_stranice` (`id_izgled_stranice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`odabir_podrucja_interesa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`odabir_podrucja_interesa` (
  `korisnik_id_korisnik` INT NOT NULL,
  `podrucja_interesa_id_podrucja` INT NOT NULL,
  `datum_vrijeme_odabira` DATETIME NOT NULL,
  `datum_vrijeme_prekida` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`korisnik_id_korisnik`, `podrucja_interesa_id_podrucja`, `datum_vrijeme_odabira`),
  INDEX `fk_korisnik_has_podrucja_interesa_podrucja_interesa1_idx` (`podrucja_interesa_id_podrucja` ASC),
  INDEX `fk_korisnik_has_podrucja_interesa_korisnik1_idx` (`korisnik_id_korisnik` ASC),
  CONSTRAINT `fk_korisnik_has_podrucja_interesa_korisnik1`
    FOREIGN KEY (`korisnik_id_korisnik`)
    REFERENCES `WebDiP2016x030`.`korisnik` (`id_korisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_korisnik_has_podrucja_interesa_podrucja_interesa1`
    FOREIGN KEY (`podrucja_interesa_id_podrucja`)
    REFERENCES `WebDiP2016x030`.`podrucja_interesa` (`id_podrucja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`kupon_clanstva`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`kupon_clanstva` (
  `id_kupona` INT NOT NULL,
  `administrator` INT NOT NULL,
  `generirani_kod` VARCHAR(45) NULL,
  `podrucja_interesa` INT NULL DEFAULT NULL,
  `naziv_kupona` VARCHAR(70) NOT NULL,
  `pdf_opis_slika` MEDIUMBLOB NOT NULL,
  `potrebno_bodova` INT NULL DEFAULT NULL,
  `datum_vrijeme_izdavanja` DATETIME NOT NULL,
  `datum_vrijeme_istjecanja` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id_kupona`),
  INDEX `fk_kupon_clanstva_korisnik1_idx` (`administrator` ASC),
  INDEX `fk_kupon_clanstva_podrucja_interesa1_idx` (`podrucja_interesa` ASC),
  CONSTRAINT `fk_kupon_clanstva_korisnik1`
    FOREIGN KEY (`administrator`)
    REFERENCES `WebDiP2016x030`.`korisnik` (`id_korisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_kupon_clanstva_podrucja_interesa1`
    FOREIGN KEY (`podrucja_interesa`)
    REFERENCES `WebDiP2016x030`.`podrucja_interesa` (`id_podrucja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`kosarica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`kosarica` (
  `id_kosarica` INT NOT NULL,
  `korisnik` INT NOT NULL,
  `datum_vrijeme_kupnje` DATETIME NOT NULL,
  PRIMARY KEY (`id_kosarica`),
  INDEX `fk_kosarica_korisnik1_idx` (`korisnik` ASC),
  CONSTRAINT `fk_kosarica_korisnik1`
    FOREIGN KEY (`korisnik`)
    REFERENCES `WebDiP2016x030`.`korisnik` (`id_korisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`sadrzaj_kosarice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`sadrzaj_kosarice` (
  `kosarica_id_kosarica` INT NOT NULL,
  `kupon_clanstva_id_kupona` INT NOT NULL,
  PRIMARY KEY (`kosarica_id_kosarica`, `kupon_clanstva_id_kupona`),
  INDEX `fk_kosarica_has_kupon_clanstva_kupon_clanstva1_idx` (`kupon_clanstva_id_kupona` ASC),
  INDEX `fk_kosarica_has_kupon_clanstva_kosarica1_idx` (`kosarica_id_kosarica` ASC),
  CONSTRAINT `fk_kosarica_has_kupon_clanstva_kosarica1`
    FOREIGN KEY (`kosarica_id_kosarica`)
    REFERENCES `WebDiP2016x030`.`kosarica` (`id_kosarica`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_kosarica_has_kupon_clanstva_kupon_clanstva1`
    FOREIGN KEY (`kupon_clanstva_id_kupona`)
    REFERENCES `WebDiP2016x030`.`kupon_clanstva` (`id_kupona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`vrsta_akcije`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`vrsta_akcije` (
  `id_vrste_akcije` INT NOT NULL,
  `naziv_akcije` VARCHAR(100) NOT NULL,
  `broj_bodova` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_vrste_akcije`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`log_bodova`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`log_bodova` (
  `korisnik` INT NOT NULL,
  `datum_vrijeme_stjecanja` DATETIME NOT NULL,
  `vrsta_akcije` INT NOT NULL,
  PRIMARY KEY (`korisnik`, `datum_vrijeme_stjecanja`),
  INDEX `fk_log_bodova_vrsta_akcije1_idx` (`vrsta_akcije` ASC),
  CONSTRAINT `fk_log_bodova_korisnik1`
    FOREIGN KEY (`korisnik`)
    REFERENCES `WebDiP2016x030`.`korisnik` (`id_korisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_log_bodova_vrsta_akcije1`
    FOREIGN KEY (`vrsta_akcije`)
    REFERENCES `WebDiP2016x030`.`vrsta_akcije` (`id_vrste_akcije`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`diskusija`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`diskusija` (
  `id_diskusija` INT NOT NULL,
  `podrucja_interesa` INT NOT NULL,
  `naziv_diskusije` VARCHAR(100) NOT NULL,
  `pravila` TEXT(150) NOT NULL,
  `datum_vrijeme_otvaranja` DATETIME NOT NULL,
  `datum_vrijeme_zatvaranja` DATETIME NOT NULL,
  PRIMARY KEY (`id_diskusija`),
  INDEX `fk_diskusija_podrucja_interesa1_idx` (`podrucja_interesa` ASC),
  CONSTRAINT `fk_diskusija_podrucja_interesa1`
    FOREIGN KEY (`podrucja_interesa`)
    REFERENCES `WebDiP2016x030`.`podrucja_interesa` (`id_podrucja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`obavijesti`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`obavijesti` (
  `korisnik` INT NOT NULL,
  `diskusija` INT NOT NULL,
  `datum_vrijeme_slanja` DATETIME NOT NULL,
  `naziv_obavijesti` VARCHAR(70) NOT NULL,
  `poruka` TEXT(150) NOT NULL,
  INDEX `fk_obavijesti_diskusija1_idx` (`diskusija` ASC),
  PRIMARY KEY (`korisnik`, `datum_vrijeme_slanja`, `diskusija`),
  INDEX `fk_obavijesti_korisnik1_idx` (`korisnik` ASC),
  CONSTRAINT `fk_obavijesti_diskusija1`
    FOREIGN KEY (`diskusija`)
    REFERENCES `WebDiP2016x030`.`diskusija` (`id_diskusija`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_obavijesti_korisnik1`
    FOREIGN KEY (`korisnik`)
    REFERENCES `WebDiP2016x030`.`korisnik` (`id_korisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`komentari`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`komentari` (
  `korisnik` INT NOT NULL,
  `diskusija` INT NOT NULL,
  `datum_vrijeme_pisanja` DATETIME NOT NULL,
  `tekst_komentara` TEXT(200) NOT NULL,
  PRIMARY KEY (`korisnik`, `diskusija`, `datum_vrijeme_pisanja`),
  INDEX `fk_komentari_diskusija1_idx` (`diskusija` ASC),
  CONSTRAINT `fk_komentari_korisnik1`
    FOREIGN KEY (`korisnik`)
    REFERENCES `WebDiP2016x030`.`korisnik` (`id_korisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_komentari_diskusija1`
    FOREIGN KEY (`diskusija`)
    REFERENCES `WebDiP2016x030`.`diskusija` (`id_diskusija`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`pretplata`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`pretplata` (
  `korisnik` INT NOT NULL,
  `diskusija` INT NOT NULL,
  `datum_vrijeme_pretplate` DATETIME NOT NULL,
  `datum_vrijeme_prestanka` DATETIME NULL DEFAULT NULL,
  `zabrana_komentiranja` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`korisnik`, `diskusija`, `datum_vrijeme_pretplate`),
  INDEX `fk_pretplata_diskusija1_idx` (`diskusija` ASC),
  CONSTRAINT `fk_pretplata_korisnik1`
    FOREIGN KEY (`korisnik`)
    REFERENCES `WebDiP2016x030`.`korisnik` (`id_korisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pretplata_diskusija1`
    FOREIGN KEY (`diskusija`)
    REFERENCES `WebDiP2016x030`.`diskusija` (`id_diskusija`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`log_aplikacije`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`log_aplikacije` (
  `datum_vrijeme_akcije` DATETIME NOT NULL,
  `korisnik_id_korisnik` INT NOT NULL,
  PRIMARY KEY (`korisnik_id_korisnik`, `datum_vrijeme_akcije`),
  INDEX `fk_log_aplikacije_korisnik1_idx` (`korisnik_id_korisnik` ASC),
  CONSTRAINT `fk_log_aplikacije_korisnik1`
    FOREIGN KEY (`korisnik_id_korisnik`)
    REFERENCES `WebDiP2016x030`.`korisnik` (`id_korisnik`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`log_aplikacije_prijava`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`log_aplikacije_prijava` (
  `korisnik` INT NOT NULL,
  `datum_vrijeme_akcije` DATETIME NOT NULL,
  `datum_vrijeme_odjave` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`korisnik`, `datum_vrijeme_akcije`),
  INDEX `fk_log_aplikacije_prijava_log_aplikacije1_idx` (`korisnik` ASC, `datum_vrijeme_akcije` ASC),
  CONSTRAINT `fk_log_aplikacije_prijava_log_aplikacije1`
    FOREIGN KEY (`korisnik` , `datum_vrijeme_akcije`)
    REFERENCES `WebDiP2016x030`.`log_aplikacije` (`korisnik_id_korisnik` , `datum_vrijeme_akcije`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`log_aplikacije_baza`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`log_aplikacije_baza` (
  `korisnik` INT NOT NULL,
  `datum_vrijeme_akcije` DATETIME NOT NULL,
  `upit_nad_bazom` TEXT(200) NOT NULL,
  PRIMARY KEY (`korisnik`, `datum_vrijeme_akcije`),
  CONSTRAINT `fk_log_aplikacije_baza_log_aplikacije1`
    FOREIGN KEY (`korisnik` , `datum_vrijeme_akcije`)
    REFERENCES `WebDiP2016x030`.`log_aplikacije` (`korisnik_id_korisnik` , `datum_vrijeme_akcije`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`log_aplikacije_ostalo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`log_aplikacije_ostalo` (
  `korisnik` INT NOT NULL,
  `datum_vrijeme_akcije` DATETIME NOT NULL,
  `opis_radnje` TEXT(200) NOT NULL,
  PRIMARY KEY (`korisnik`, `datum_vrijeme_akcije`),
  CONSTRAINT `fk_log_aplikacije_ostalo_log_aplikacije1`
    FOREIGN KEY (`korisnik` , `datum_vrijeme_akcije`)
    REFERENCES `WebDiP2016x030`.`log_aplikacije` (`korisnik_id_korisnik` , `datum_vrijeme_akcije`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `WebDiP2016x030`.`konfiguracija_sustava`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `WebDiP2016x030`.`konfiguracija_sustava` (
  `id` INT NOT NULL,
  `sesija` VARCHAR(45) NULL,
  `pogresna_prijava` INT NULL,
  `pomak_vremena` TIME NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
