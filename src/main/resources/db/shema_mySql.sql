-- ===================================================================
-- Your Car Your Way - Schéma relationnel (MySQL 8)
-- ===================================================================
-- Options générales
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- (Optionnel) créer une DB dédiée
-- CREATE DATABASE IF NOT EXISTS ycyw DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- USE ycyw;

-- ===================================================================
-- ENUMS via CHECK (MySQL 8.0.16+) ou ENUM natif
-- Ici: on utilise ENUM natif pour simplicité.
-- ===================================================================

-- Messages.status: sent, delivered, read
-- Reservation.status: (libre, je mets 'pending','confirmed','cancelled')
-- Payment.status: (pending, paid, failed, refunded)
-- VideoCall.status: ongoing, ended, missed

-- ===================================================================
-- TABLE: user
-- ===================================================================
DROP TABLE IF EXISTS user;
CREATE TABLE user (
  user_id       CHAR(36)     NOT NULL,
  first_name    VARCHAR(100) NOT NULL,
  last_name     VARCHAR(100) NOT NULL,
  birth_date    DATE         NULL,
  address       VARCHAR(255) NULL,
  email         VARCHAR(190) NOT NULL,
  password      VARCHAR(255) NOT NULL,
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT pk_user PRIMARY KEY (user_id),
  CONSTRAINT uq_user_email UNIQUE (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===================================================================
-- TABLE: agency
-- ===================================================================
DROP TABLE IF EXISTS agency;
CREATE TABLE agency (
  agency_id   CHAR(36)     NOT NULL,
  name        VARCHAR(150) NOT NULL,
  address     VARCHAR(255) NULL,
  created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT pk_agency PRIMARY KEY (agency_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===================================================================
-- TABLE: vehicle
-- (Chaque véhicule appartient à une agence)
-- ===================================================================
DROP TABLE IF EXISTS vehicle;
CREATE TABLE vehicle (
  vehicle_id   CHAR(36)     NOT NULL,
  model        VARCHAR(120) NOT NULL,
  category     VARCHAR(20)  NOT NULL, -- ex code ACRISS
  available    BOOLEAN      NOT NULL DEFAULT TRUE,
  agency_id    CHAR(36)     NOT NULL,
  created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT pk_vehicle PRIMARY KEY (vehicle_id),
  CONSTRAINT fk_vehicle_agency FOREIGN KEY (agency_id) REFERENCES agency(agency_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX ix_vehicle_agency ON vehicle(agency_id);

-- ===================================================================
-- TABLE: offer
-- (Une agence publie 0..n offres; chaque offre référence un véhicule)
-- ===================================================================
DROP TABLE IF EXISTS offer;
CREATE TABLE offer (
  offer_id     CHAR(36)     NOT NULL,
  agency_id    CHAR(36)     NOT NULL,
  vehicle_id   CHAR(36)     NOT NULL,
  city_start   VARCHAR(120) NOT NULL,
  city_end     VARCHAR(120) NOT NULL,
  start_date   DATE         NOT NULL,
  end_date     DATE         NOT NULL,
  price        BIGINT       NOT NULL,   -- en centimes pour éviter les flottants
  created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT pk_offer PRIMARY KEY (offer_id),
  CONSTRAINT fk_offer_agency  FOREIGN KEY (agency_id)  REFERENCES agency(agency_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_offer_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX ix_offer_agency  ON offer(agency_id);
CREATE INDEX ix_offer_vehicle ON offer(vehicle_id);
CREATE INDEX ix_offer_dates   ON offer(start_date, end_date);

-- ===================================================================
-- TABLE: reservation
-- (Relation entre user et offer)
-- ===================================================================
DROP TABLE IF EXISTS reservation;
CREATE TABLE reservation (
  reservation_id CHAR(36)     NOT NULL,
  offer_id       CHAR(36)     NOT NULL,
  user_id        CHAR(36)     NOT NULL,
  created_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  status         ENUM('pending','confirmed','cancelled') NOT NULL DEFAULT 'pending',
  CONSTRAINT pk_reservation PRIMARY KEY (reservation_id),
  CONSTRAINT fk_reservation_offer FOREIGN KEY (offer_id) REFERENCES offer(offer_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_reservation_user  FOREIGN KEY (user_id)  REFERENCES user(user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX ix_reservation_offer ON reservation(offer_id);
CREATE INDEX ix_reservation_user  ON reservation(user_id);

-- ===================================================================
-- TABLE: payment (lié 1–1 à reservation)
-- ===================================================================
DROP TABLE IF EXISTS payment;
CREATE TABLE payment (
  payment_id     CHAR(36)  NOT NULL,
  reservation_id CHAR(36)  NOT NULL,
  amount         BIGINT    NOT NULL,    -- en centimes
  payment_date   DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status         ENUM('pending','paid','failed','refunded') NOT NULL DEFAULT 'pending',
  CONSTRAINT pk_payment PRIMARY KEY (payment_id),
  CONSTRAINT uq_payment_reservation UNIQUE (reservation_id),
  CONSTRAINT fk_payment_reservation FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===================================================================
-- TABLE: messages (messagerie)
-- ===================================================================
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
  message_id  CHAR(36)     NOT NULL,
  sender_id   CHAR(36)     NOT NULL,
  receiver_id CHAR(36)     NOT NULL,
  content     TEXT         NOT NULL,
  sent_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status      ENUM('sent','delivered','read') NOT NULL DEFAULT 'sent',
  CONSTRAINT pk_messages PRIMARY KEY (message_id),
  CONSTRAINT fk_messages_sender   FOREIGN KEY (sender_id)   REFERENCES user(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_messages_receiver FOREIGN KEY (receiver_id) REFERENCES user(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX ix_messages_sender_receiver ON messages(sender_id, receiver_id);
CREATE INDEX ix_messages_sent_at         ON messages(sent_at);

-- ===================================================================
-- TABLE: video_call
-- ===================================================================
DROP TABLE IF EXISTS video_call;
CREATE TABLE video_call (
  call_id     CHAR(36)     NOT NULL,
  caller_id   CHAR(36)     NOT NULL,
  receiver_id CHAR(36)     NOT NULL,
  started_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ended_at    DATETIME     NULL,
  status      ENUM('ongoing','ended','missed') NOT NULL DEFAULT 'ongoing',
  call_url    VARCHAR(255) NULL,
  CONSTRAINT pk_video_call PRIMARY KEY (call_id),
  CONSTRAINT fk_video_call_caller   FOREIGN KEY (caller_id)   REFERENCES user(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_video_call_receiver FOREIGN KEY (receiver_id) REFERENCES user(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX ix_video_call_parties ON video_call(caller_id, receiver_id);

SET FOREIGN_KEY_CHECKS = 1;
