--
-- PostgreSQL database dump
--

\restrict MW35KbbMDZUK4eIA2buMFEixYQzmGh9YraSaFtQPgTlMgxRchWnbA2IyA3exMpa

-- Dumped from database version 18.1 (Debian 18.1-1.pgdg12+2)
-- Dumped by pg_dump version 18.1 (Debian 18.1-1.pgdg13+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: badge_statut_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.badge_statut_enum AS ENUM (
    'locked',
    'in_progress',
    'earned'
);


--
-- Name: etat_caisse_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.etat_caisse_enum AS ENUM (
    'ouverte',
    'fermee',
    'suspendue',
    'cloturee'
);


--
-- Name: etat_collecteur_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.etat_collecteur_enum AS ENUM (
    'connecte',
    'deconnecte'
);


--
-- Name: periodicite_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.periodicite_enum AS ENUM (
    'journaliere',
    'hebdomadaire',
    'mensuelle',
    'trimestrielle'
);


--
-- Name: role_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.role_enum AS ENUM (
    'admin',
    'collecteur',
    'contribuable'
);


--
-- Name: statut_collecte_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.statut_collecte_enum AS ENUM (
    'pending',
    'completed',
    'failed',
    'cancelled'
);


--
-- Name: statut_collecteur_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.statut_collecteur_enum AS ENUM (
    'active',
    'desactive'
);


--
-- Name: statut_demande_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.statut_demande_enum AS ENUM (
    'envoyee',
    'en_traitement',
    'completee',
    'rejetee'
);


--
-- Name: statut_journal_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.statut_journal_enum AS ENUM (
    'en_cours',
    'cloture'
);


--
-- Name: statut_relance_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.statut_relance_enum AS ENUM (
    'en_attente',
    'envoyee',
    'echec',
    'annulee'
);


--
-- Name: statut_transaction_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.statut_transaction_enum AS ENUM (
    'pending',
    'success',
    'failed',
    'cancelled',
    'refunded'
);


--
-- Name: type_caisse_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.type_caisse_enum AS ENUM (
    'physique',
    'en_ligne'
);


--
-- Name: type_coupure_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.type_coupure_enum AS ENUM (
    'billet',
    'piece'
);


--
-- Name: type_operation_caisse_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.type_operation_caisse_enum AS ENUM (
    'ouverture',
    'fermeture',
    'entree',
    'sortie',
    'ajustement',
    'cloture'
);


--
-- Name: type_paiement_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.type_paiement_enum AS ENUM (
    'especes',
    'mobile_money',
    'carte',
    'bamboopay'
);


--
-- Name: type_relance_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.type_relance_enum AS ENUM (
    'sms',
    'email',
    'appel',
    'courrier',
    'visite'
);


--
-- Name: calculer_prochaine_periode(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.calculer_prochaine_periode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            DECLARE
                v_periodicite periodicite_enum;
                v_date_debut DATE;
                v_date_fin DATE;
                v_annee INTEGER;
                v_mois INTEGER;
            BEGIN
                -- Ne calculer que si les valeurs ne sont pas déjà définies
                IF NEW.periode_debut IS NULL THEN
                    -- Calculer la date de début (date actuelle)
                    v_date_debut := CURRENT_DATE;

                    -- Récupérer la périodicité de la taxe
                    SELECT periodicite INTO v_periodicite FROM taxe WHERE id = NEW.taxe_id;

                    IF v_periodicite = 'mensuelle' THEN
                        -- Début du mois en cours
                        v_date_debut := date_trunc('month', CURRENT_DATE)::DATE;
                        -- Fin du mois en cours
                        v_date_fin := (date_trunc('month', CURRENT_DATE) + interval '1 month' - interval '1 day')::DATE;
                        v_annee := EXTRACT(YEAR FROM v_date_debut)::INTEGER;
                        v_mois := EXTRACT(MONTH FROM v_date_debut)::INTEGER;
                    ELSIF v_periodicite = 'trimestrielle' THEN
                        -- Calculer le trimestre en cours
                        v_annee := EXTRACT(YEAR FROM CURRENT_DATE)::INTEGER;
                        v_mois := EXTRACT(MONTH FROM CURRENT_DATE)::INTEGER;

                        IF v_mois BETWEEN 1 AND 3 THEN
                            v_date_debut := make_date(v_annee, 1, 1);
                            v_date_fin := make_date(v_annee, 3, 31);
                            v_mois := 1;
                        ELSIF v_mois BETWEEN 4 AND 6 THEN
                            v_date_debut := make_date(v_annee, 4, 1);
                            v_date_fin := make_date(v_annee, 6, 30);
                            v_mois := 4;
                        ELSIF v_mois BETWEEN 7 AND 9 THEN
                            v_date_debut := make_date(v_annee, 7, 1);
                            v_date_fin := make_date(v_annee, 9, 30);
                            v_mois := 7;
                        ELSE
                            v_date_debut := make_date(v_annee, 10, 1);
                            v_date_fin := make_date(v_annee, 12, 31);
                            v_mois := 10;
                        END IF;
                    ELSE
                        -- Par défaut, période annuelle ou ponctuelle
                        v_date_debut := CURRENT_DATE;
                        v_date_fin := NULL;
                        v_annee := EXTRACT(YEAR FROM CURRENT_DATE)::INTEGER;
                        v_mois := NULL;
                    END IF;

                    NEW.periode_debut := v_date_debut;
                    NEW.periode_fin := v_date_fin;
                    NEW.annee := v_annee;
                    NEW.mois := v_mois;
                    NEW.date_echeance := v_date_fin + INTERVAL '15 days';
                END IF;

                -- Calculer le montant attendu seulement s'il n'est pas défini
                IF NEW.montant_attendu IS NULL THEN
                    IF NEW.montant_custom IS NOT NULL THEN
                        NEW.montant_attendu := NEW.montant_custom;
                    ELSE
                        SELECT montant INTO NEW.montant_attendu FROM taxe WHERE id = NEW.taxe_id;
                    END IF;
                END IF;

                -- Définir le statut par défaut
                IF NEW.statut IS NULL THEN
                    NEW.statut := 'en_attente';
                END IF;

                RETURN NEW;
            END;
            $$;


--
-- Name: generer_periodes_suivantes(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generer_periodes_suivantes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
                    DECLARE
                        v_periodicite periodicite_enum;
                        v_prochaine_periode DATE;
                    BEGIN
                        SELECT periodicite INTO v_periodicite FROM taxe WHERE id = NEW.taxe_id;
                        
                        IF v_periodicite = 'mensuelle' AND NEW.actif = TRUE THEN
                            v_prochaine_periode := NEW.periode_fin + INTERVAL '1 day';
                            
                            IF NOT EXISTS (
                                SELECT 1 FROM info_taxation
                                WHERE contribuable_id = NEW.contribuable_id
                                AND taxe_id = NEW.taxe_id
                                AND periode_debut = v_prochaine_periode
                            ) THEN
                                INSERT INTO info_taxation (
                                    contribuable_id, taxe_id, periode_debut,
                                    montant_custom, actif
                                ) VALUES (
                                    NEW.contribuable_id, NEW.taxe_id, v_prochaine_periode,
                                    NEW.montant_custom, NEW.actif
                                );
                            END IF;
                        END IF;
                        
                        RETURN NEW;
                    END;
                    $$;


--
-- Name: mettre_a_jour_statut_taxation(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.mettre_a_jour_statut_taxation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            DECLARE
                v_montant_attendu NUMERIC(12,2);
                v_montant_paye NUMERIC(12,2);
                v_date_echeance DATE;
                v_nouveau_statut VARCHAR(20);
            BEGIN
                -- Ne mettre à jour que si la collecte est complétée et active
                IF NEW.statut = 'completed' AND NEW.annule = FALSE THEN
                    -- Récupérer les informations de la taxation
                    SELECT montant_attendu, date_echeance
                    INTO v_montant_attendu, v_date_echeance
                    FROM info_taxation
                    WHERE contribuable_id = NEW.contribuable_id
                      AND taxe_id = NEW.taxe_id
                      AND periode_debut <= NEW.date_collecte::DATE
                      AND (periode_fin IS NULL OR periode_fin >= NEW.date_collecte::DATE)
                      AND actif = TRUE;

                    IF v_montant_attendu IS NOT NULL THEN
                        -- Calculer le montant total payé pour cette taxation
                        SELECT COALESCE(SUM(montant), 0)
                        INTO v_montant_paye
                        FROM info_collecte
                        WHERE contribuable_id = NEW.contribuable_id
                          AND taxe_id = NEW.taxe_id
                          AND info_taxation_id IS NOT NULL
                          AND statut = 'completed'
                          AND annule = FALSE
                          AND date_collecte >= (
                              SELECT periode_debut FROM info_taxation
                              WHERE contribuable_id = NEW.contribuable_id
                                AND taxe_id = NEW.taxe_id
                                AND periode_debut <= NEW.date_collecte::DATE
                                AND (periode_fin IS NULL OR periode_fin >= NEW.date_collecte::DATE)
                                AND actif = TRUE
                              LIMIT 1
                          );

                        -- Déterminer le nouveau statut
                        IF v_montant_paye >= v_montant_attendu THEN
                            v_nouveau_statut := 'paye';
                        ELSIF v_montant_paye > 0 THEN
                            v_nouveau_statut := 'partiel';
                        ELSIF CURRENT_DATE > v_date_echeance THEN
                            v_nouveau_statut := 'impaye';
                        ELSE
                            v_nouveau_statut := 'en_attente';
                        END IF;

                        -- Mettre à jour le statut de la taxation
                        UPDATE info_taxation
                        SET statut = v_nouveau_statut, updated_at = CURRENT_TIMESTAMP
                        WHERE contribuable_id = NEW.contribuable_id
                          AND taxe_id = NEW.taxe_id
                          AND periode_debut <= NEW.date_collecte::DATE
                          AND (periode_fin IS NULL OR periode_fin >= NEW.date_collecte::DATE)
                          AND actif = TRUE;
                    END IF;
                END IF;

                RETURN NEW;
            END;
            $$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
                    BEGIN
                        NEW.updated_at = CURRENT_TIMESTAMP;
                        RETURN NEW;
                    END;
                    $$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: affectation_taxe; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.affectation_taxe (
    id integer NOT NULL,
    contribuable_id integer NOT NULL,
    taxe_id integer NOT NULL,
    date_debut timestamp without time zone NOT NULL,
    date_fin timestamp without time zone,
    montant_custom numeric(12,2),
    actif boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: affectation_taxe_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.affectation_taxe_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: affectation_taxe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.affectation_taxe_id_seq OWNED BY public.affectation_taxe.id;


--
-- Name: appareil_collecteur; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appareil_collecteur (
    id integer NOT NULL,
    collecteur_id integer NOT NULL,
    device_id character varying(255) NOT NULL,
    plateforme character varying(50),
    device_info text,
    authorized boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: appareil_collecteur_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.appareil_collecteur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: appareil_collecteur_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.appareil_collecteur_id_seq OWNED BY public.appareil_collecteur.id;


--
-- Name: arrondissement; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.arrondissement (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    code character varying(20) NOT NULL,
    commune_id integer NOT NULL,
    description text,
    actif boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: arrondissement_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.arrondissement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: arrondissement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.arrondissement_id_seq OWNED BY public.arrondissement.id;


--
-- Name: caisse; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.caisse (
    id integer NOT NULL,
    collecteur_id integer NOT NULL,
    type_caisse public.type_caisse_enum NOT NULL,
    etat public.etat_caisse_enum,
    code character varying(50) NOT NULL,
    nom character varying(100),
    solde_initial numeric(12,2),
    solde_actuel numeric(12,2),
    date_ouverture timestamp without time zone,
    date_fermeture timestamp without time zone,
    date_cloture timestamp without time zone,
    montant_cloture numeric(12,2),
    notes text,
    actif boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: caisse_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.caisse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: caisse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.caisse_id_seq OWNED BY public.caisse.id;


--
-- Name: collecteur; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collecteur (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    prenom character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    telephone character varying(20) NOT NULL,
    matricule character varying(50) NOT NULL,
    zone_id integer,
    latitude numeric(10,8),
    longitude numeric(11,8),
    geom public.geometry(Point,4326),
    date_derniere_connexion timestamp without time zone,
    date_derniere_deconnexion timestamp without time zone,
    heure_cloture character varying(5),
    actif boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    statut public.statut_collecteur_enum DEFAULT 'active'::public.statut_collecteur_enum,
    etat public.etat_collecteur_enum DEFAULT 'deconnecte'::public.etat_collecteur_enum
);


--
-- Name: contribuable; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contribuable (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    prenom character varying(100),
    email character varying(100),
    telephone character varying(20) NOT NULL,
    type_contribuable_id integer NOT NULL,
    quartier_id integer NOT NULL,
    collecteur_id integer NOT NULL,
    adresse text,
    latitude numeric(10,8),
    longitude numeric(11,8),
    geom public.geometry(Point,4326),
    nom_activite character varying(200),
    photo_url character varying(500),
    numero_identification character varying(50),
    qr_code character varying(100),
    distance_quartier_m numeric(10,2),
    mot_de_passe_hash character varying(255),
    matricule character varying(50),
    actif boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: info_collecte; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.info_collecte (
    id integer NOT NULL,
    contribuable_id integer NOT NULL,
    taxe_id integer NOT NULL,
    collecteur_id integer NOT NULL,
    montant numeric(12,2) NOT NULL,
    commission numeric(12,2),
    reference character varying(50) NOT NULL,
    billetage text,
    date_collecte timestamp without time zone NOT NULL,
    date_cloture timestamp without time zone,
    sms_envoye boolean,
    ticket_imprime boolean,
    annule boolean DEFAULT false,
    raison_annulation text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    info_taxation_id integer,
    type_paiement public.type_paiement_enum DEFAULT 'especes'::public.type_paiement_enum,
    statut public.statut_collecte_enum DEFAULT 'pending'::public.statut_collecte_enum
);


--
-- Name: quartier; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quartier (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    code character varying(20) NOT NULL,
    zone_id integer NOT NULL,
    description text,
    actif boolean,
    geom public.geometry(Point,4326),
    osm_id bigint,
    place_type character varying(50),
    tags json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    latitude numeric(10,8),
    longitude numeric(11,8)
);


--
-- Name: type_contribuable; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.type_contribuable (
    id integer NOT NULL,
    nom character varying(50) NOT NULL,
    code character varying(20) NOT NULL,
    description text,
    actif boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: zone; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.zone (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    code character varying(20) NOT NULL,
    description text,
    actif boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cartographie_contribuable_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.cartographie_contribuable_view AS
 SELECT c.id,
    c.nom,
    c.prenom,
    c.nom_activite,
    c.telephone,
    c.adresse,
        CASE
            WHEN ((c.latitude IS NOT NULL) AND (c.latitude >= '-1.5'::numeric) AND (c.latitude <= (0)::numeric) AND (c.longitude IS NOT NULL) AND (c.longitude >= 8.5) AND (c.longitude <= 9.5)) THEN (c.latitude)::double precision
            WHEN (q.geom IS NOT NULL) THEN public.st_y(q.geom)
            ELSE NULL::double precision
        END AS latitude,
        CASE
            WHEN ((c.latitude IS NOT NULL) AND (c.latitude >= '-1.5'::numeric) AND (c.latitude <= (0)::numeric) AND (c.longitude IS NOT NULL) AND (c.longitude >= 8.5) AND (c.longitude <= 9.5)) THEN (c.longitude)::double precision
            WHEN (q.geom IS NOT NULL) THEN public.st_x(q.geom)
            ELSE NULL::double precision
        END AS longitude,
    c.photo_url,
    c.actif,
    tc.nom AS type_contribuable,
    q.nom AS quartier,
    COALESCE(z.nom, 'Non assigné'::character varying) AS zone,
    concat(COALESCE(col.nom, ''::character varying), ' ', COALESCE(col.prenom, ''::character varying)) AS collecteur,
        CASE
            WHEN (count(
            CASE
                WHEN ((ic.statut = 'completed'::public.statut_collecte_enum) AND ((ic.annule = false) OR (ic.annule IS NULL))) THEN 1
                ELSE NULL::integer
            END) > 0) THEN true
            ELSE false
        END AS a_paye,
    COALESCE(sum(
        CASE
            WHEN ((ic.statut = 'completed'::public.statut_collecte_enum) AND ((ic.annule = false) OR (ic.annule IS NULL))) THEN ic.montant
            ELSE (0)::numeric
        END), (0)::numeric) AS total_collecte,
    count(
        CASE
            WHEN ((ic.statut = 'completed'::public.statut_collecte_enum) AND ((ic.annule = false) OR (ic.annule IS NULL))) THEN 1
            ELSE NULL::integer
        END) AS nombre_collectes,
    max(
        CASE
            WHEN ((ic.statut = 'completed'::public.statut_collecte_enum) AND ((ic.annule = false) OR (ic.annule IS NULL))) THEN ic.date_collecte
            ELSE NULL::timestamp without time zone
        END) AS derniere_collecte,
    '[]'::json AS taxes_impayees
   FROM (((((public.contribuable c
     LEFT JOIN public.quartier q ON ((c.quartier_id = q.id)))
     LEFT JOIN public.zone z ON ((q.zone_id = z.id)))
     LEFT JOIN public.type_contribuable tc ON ((c.type_contribuable_id = tc.id)))
     LEFT JOIN public.collecteur col ON ((c.collecteur_id = col.id)))
     LEFT JOIN public.info_collecte ic ON ((c.id = ic.contribuable_id)))
  WHERE (c.actif = true)
  GROUP BY c.id, c.nom, c.prenom, c.nom_activite, c.telephone, c.adresse, c.latitude, c.longitude, c.photo_url, c.actif, q.geom, q.nom, z.nom, tc.nom, col.nom, col.prenom;


--
-- Name: collecteur_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.collecteur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collecteur_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.collecteur_id_seq OWNED BY public.collecteur.id;


--
-- Name: collecteur_zone; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collecteur_zone (
    id integer NOT NULL,
    collecteur_id integer NOT NULL,
    nom character varying(255) NOT NULL,
    latitude numeric(10,8) NOT NULL,
    longitude numeric(11,8) NOT NULL,
    radius numeric(10,2) NOT NULL,
    description text,
    actif boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: collecteur_zone_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.collecteur_zone_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collecteur_zone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.collecteur_zone_id_seq OWNED BY public.collecteur_zone.id;


--
-- Name: commune; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.commune (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    code character varying(20) NOT NULL,
    ville_id integer NOT NULL,
    description text,
    actif boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: commune_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.commune_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commune_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.commune_id_seq OWNED BY public.commune.id;


--
-- Name: contribuable_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contribuable_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contribuable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contribuable_id_seq OWNED BY public.contribuable.id;


--
-- Name: coupure_caisse; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coupure_caisse (
    id integer NOT NULL,
    valeur numeric(12,2) NOT NULL,
    devise character varying(3) NOT NULL,
    type_coupure public.type_coupure_enum NOT NULL,
    description character varying(255),
    ordre_affichage integer NOT NULL,
    actif boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: coupure_caisse_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.coupure_caisse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: coupure_caisse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.coupure_caisse_id_seq OWNED BY public.coupure_caisse.id;


--
-- Name: demande_citoyen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.demande_citoyen (
    id integer NOT NULL,
    contribuable_id integer NOT NULL,
    type_demande character varying(100) NOT NULL,
    sujet character varying(255) NOT NULL,
    description text NOT NULL,
    reponse text,
    traite_par_id integer,
    date_traitement timestamp without time zone,
    pieces_jointes json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    statut public.statut_demande_enum DEFAULT 'envoyee'::public.statut_demande_enum
);


--
-- Name: demande_citoyen_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.demande_citoyen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: demande_citoyen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.demande_citoyen_id_seq OWNED BY public.demande_citoyen.id;


--
-- Name: dossier_impaye; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dossier_impaye (
    id integer NOT NULL,
    contribuable_id integer NOT NULL,
    affectation_taxe_id integer NOT NULL,
    montant_initial numeric(12,2) NOT NULL,
    montant_paye numeric(12,2),
    montant_restant numeric(12,2) NOT NULL,
    penalites numeric(12,2),
    date_echeance timestamp without time zone NOT NULL,
    jours_retard integer,
    statut character varying(50),
    priorite character varying(20),
    dernier_contact timestamp without time zone,
    nombre_relances integer,
    notes text,
    assigne_a integer,
    date_assignation timestamp without time zone,
    date_cloture timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: dossier_impaye_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dossier_impaye_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dossier_impaye_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dossier_impaye_id_seq OWNED BY public.dossier_impaye.id;


--
-- Name: info_collecte_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.info_collecte_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: info_collecte_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.info_collecte_id_seq OWNED BY public.info_collecte.id;


--
-- Name: info_taxation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.info_taxation (
    id integer NOT NULL,
    contribuable_id integer NOT NULL,
    taxe_id integer NOT NULL,
    periode_debut date NOT NULL,
    periode_fin date,
    annee integer NOT NULL,
    mois integer,
    montant_attendu numeric(12,2) NOT NULL,
    montant_custom numeric(12,2),
    statut character varying(20) DEFAULT 'en_attente'::character varying,
    date_echeance date,
    actif boolean DEFAULT true,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: info_taxation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.info_taxation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: info_taxation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.info_taxation_id_seq OWNED BY public.info_taxation.id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification (
    id integer NOT NULL,
    user_id integer NOT NULL,
    type character varying(50) NOT NULL,
    title character varying(255) NOT NULL,
    message text NOT NULL,
    read boolean,
    data json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: notification_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notification_id_seq OWNED BY public.notification.id;


--
-- Name: operation_caisse; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.operation_caisse (
    id integer NOT NULL,
    caisse_id integer NOT NULL,
    collecteur_id integer NOT NULL,
    type_operation public.type_operation_caisse_enum NOT NULL,
    montant numeric(12,2) NOT NULL,
    libelle character varying(200) NOT NULL,
    collecte_id integer,
    reference character varying(50),
    solde_avant numeric(12,2),
    solde_apres numeric(12,2),
    notes text,
    date_operation timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: operation_caisse_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.operation_caisse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: operation_caisse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.operation_caisse_id_seq OWNED BY public.operation_caisse.id;


--
-- Name: quartier_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quartier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quartier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quartier_id_seq OWNED BY public.quartier.id;


--
-- Name: relance; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.relance (
    id integer NOT NULL,
    contribuable_id integer NOT NULL,
    affectation_taxe_id integer,
    type_relance public.type_relance_enum NOT NULL,
    statut public.statut_relance_enum,
    message text,
    montant_due numeric(12,2) NOT NULL,
    date_echeance timestamp without time zone,
    date_envoi timestamp without time zone,
    date_planifiee timestamp without time zone NOT NULL,
    canal_envoi character varying(100),
    reponse_recue boolean,
    date_reponse timestamp without time zone,
    notes text,
    utilisateur_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: relance_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.relance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: relance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.relance_id_seq OWNED BY public.relance.id;


--
-- Name: role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    code character varying(50) NOT NULL,
    description text,
    permissions text,
    actif boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.role_id_seq OWNED BY public.role.id;


--
-- Name: secteur_activite; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.secteur_activite (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    code character varying(50) NOT NULL,
    description text,
    actif boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: secteur_activite_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.secteur_activite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: secteur_activite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.secteur_activite_id_seq OWNED BY public.secteur_activite.id;


--
-- Name: service; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    description text,
    code character varying(20) NOT NULL,
    actif boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    montant numeric(12,2) DEFAULT 0 NOT NULL
);


--
-- Name: service_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.service_id_seq OWNED BY public.service.id;


--
-- Name: taxe; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.taxe (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    code character varying(20) NOT NULL,
    description text,
    montant numeric(12,2) NOT NULL,
    montant_variable boolean,
    type_taxe_id integer NOT NULL,
    service_id integer NOT NULL,
    commission_pourcentage numeric(5,2),
    actif boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    periodicite public.periodicite_enum DEFAULT 'mensuelle'::public.periodicite_enum
);


--
-- Name: taxe_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.taxe_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taxe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.taxe_id_seq OWNED BY public.taxe.id;


--
-- Name: type_contribuable_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.type_contribuable_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: type_contribuable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.type_contribuable_id_seq OWNED BY public.type_contribuable.id;


--
-- Name: type_taxe; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.type_taxe (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    code character varying(20) NOT NULL,
    description text,
    actif boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: type_taxe_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.type_taxe_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: type_taxe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.type_taxe_id_seq OWNED BY public.type_taxe.id;


--
-- Name: utilisateur; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.utilisateur (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    prenom character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    telephone character varying(20),
    mot_de_passe_hash character varying(255) NOT NULL,
    actif boolean,
    derniere_connexion timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    role public.role_enum
);


--
-- Name: utilisateur_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.utilisateur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: utilisateur_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.utilisateur_id_seq OWNED BY public.utilisateur.id;


--
-- Name: v_montant_collecte; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_montant_collecte AS
 SELECT sum(montant) AS total_collecte,
    count(*) AS nombre_collectes
   FROM public.info_collecte
  WHERE ((statut = 'completed'::public.statut_collecte_enum) AND (annule = false));


--
-- Name: v_montant_espere; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_montant_espere AS
 SELECT sum(it.montant_attendu) AS total_espere,
    count(*) AS nombre_taxations,
    count(DISTINCT it.contribuable_id) AS nombre_contribuables,
    count(DISTINCT it.taxe_id) AS nombre_taxes
   FROM (public.info_taxation it
     JOIN public.contribuable c ON ((it.contribuable_id = c.id)))
  WHERE ((it.actif = true) AND (c.actif = true) AND ((it.statut)::text = ANY ((ARRAY['en_attente'::character varying, 'echeance'::character varying, 'partiel'::character varying, 'impaye'::character varying])::text[])));


--
-- Name: v_stats_par_taxe; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_stats_par_taxe AS
 SELECT t.id AS taxe_id,
    t.nom AS taxe_nom,
    count(DISTINCT it.contribuable_id) AS nombre_contribuables,
    COALESCE(sum(it.montant_attendu), (0)::numeric) AS montant_espere,
    COALESCE(sum(ic.montant), (0)::numeric) AS montant_collecte,
    (COALESCE(sum(it.montant_attendu), (0)::numeric) - COALESCE(sum(ic.montant), (0)::numeric)) AS montant_restant_du,
        CASE
            WHEN (COALESCE(sum(it.montant_attendu), (0)::numeric) > (0)::numeric) THEN ((COALESCE(sum(ic.montant), (0)::numeric) / sum(it.montant_attendu)) * (100)::numeric)
            ELSE (0)::numeric
        END AS taux_collecte
   FROM ((public.taxe t
     LEFT JOIN public.info_taxation it ON (((t.id = it.taxe_id) AND (it.actif = true))))
     LEFT JOIN public.info_collecte ic ON (((t.id = ic.taxe_id) AND (ic.statut = 'completed'::public.statut_collecte_enum) AND (ic.annule = false) AND (ic.info_taxation_id = it.id))))
  WHERE (t.actif = true)
  GROUP BY t.id, t.nom;


--
-- Name: ville; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ville (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    code character varying(20) NOT NULL,
    description text,
    pays character varying(50),
    actif boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ville_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ville_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ville_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ville_id_seq OWNED BY public.ville.id;


--
-- Name: zone_geographique; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.zone_geographique (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    type_zone character varying(50) NOT NULL,
    code character varying(50),
    geometry json NOT NULL,
    properties json,
    quartier_id integer,
    geom public.geometry(MultiPolygon,4326),
    actif boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: zone_geographique_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.zone_geographique_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: zone_geographique_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.zone_geographique_id_seq OWNED BY public.zone_geographique.id;


--
-- Name: zone_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.zone_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: zone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.zone_id_seq OWNED BY public.zone.id;


--
-- Name: affectation_taxe id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.affectation_taxe ALTER COLUMN id SET DEFAULT nextval('public.affectation_taxe_id_seq'::regclass);


--
-- Name: appareil_collecteur id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appareil_collecteur ALTER COLUMN id SET DEFAULT nextval('public.appareil_collecteur_id_seq'::regclass);


--
-- Name: arrondissement id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.arrondissement ALTER COLUMN id SET DEFAULT nextval('public.arrondissement_id_seq'::regclass);


--
-- Name: caisse id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caisse ALTER COLUMN id SET DEFAULT nextval('public.caisse_id_seq'::regclass);


--
-- Name: collecteur id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collecteur ALTER COLUMN id SET DEFAULT nextval('public.collecteur_id_seq'::regclass);


--
-- Name: collecteur_zone id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collecteur_zone ALTER COLUMN id SET DEFAULT nextval('public.collecteur_zone_id_seq'::regclass);


--
-- Name: commune id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commune ALTER COLUMN id SET DEFAULT nextval('public.commune_id_seq'::regclass);


--
-- Name: contribuable id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contribuable ALTER COLUMN id SET DEFAULT nextval('public.contribuable_id_seq'::regclass);


--
-- Name: coupure_caisse id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupure_caisse ALTER COLUMN id SET DEFAULT nextval('public.coupure_caisse_id_seq'::regclass);


--
-- Name: demande_citoyen id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demande_citoyen ALTER COLUMN id SET DEFAULT nextval('public.demande_citoyen_id_seq'::regclass);


--
-- Name: dossier_impaye id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dossier_impaye ALTER COLUMN id SET DEFAULT nextval('public.dossier_impaye_id_seq'::regclass);


--
-- Name: info_collecte id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_collecte ALTER COLUMN id SET DEFAULT nextval('public.info_collecte_id_seq'::regclass);


--
-- Name: info_taxation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_taxation ALTER COLUMN id SET DEFAULT nextval('public.info_taxation_id_seq'::regclass);


--
-- Name: notification id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification ALTER COLUMN id SET DEFAULT nextval('public.notification_id_seq'::regclass);


--
-- Name: operation_caisse id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operation_caisse ALTER COLUMN id SET DEFAULT nextval('public.operation_caisse_id_seq'::regclass);


--
-- Name: quartier id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quartier ALTER COLUMN id SET DEFAULT nextval('public.quartier_id_seq'::regclass);


--
-- Name: relance id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relance ALTER COLUMN id SET DEFAULT nextval('public.relance_id_seq'::regclass);


--
-- Name: role id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);


--
-- Name: secteur_activite id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.secteur_activite ALTER COLUMN id SET DEFAULT nextval('public.secteur_activite_id_seq'::regclass);


--
-- Name: service id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service ALTER COLUMN id SET DEFAULT nextval('public.service_id_seq'::regclass);


--
-- Name: taxe id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taxe ALTER COLUMN id SET DEFAULT nextval('public.taxe_id_seq'::regclass);


--
-- Name: type_contribuable id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.type_contribuable ALTER COLUMN id SET DEFAULT nextval('public.type_contribuable_id_seq'::regclass);


--
-- Name: type_taxe id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.type_taxe ALTER COLUMN id SET DEFAULT nextval('public.type_taxe_id_seq'::regclass);


--
-- Name: utilisateur id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.utilisateur ALTER COLUMN id SET DEFAULT nextval('public.utilisateur_id_seq'::regclass);


--
-- Name: ville id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ville ALTER COLUMN id SET DEFAULT nextval('public.ville_id_seq'::regclass);


--
-- Name: zone id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zone ALTER COLUMN id SET DEFAULT nextval('public.zone_id_seq'::regclass);


--
-- Name: zone_geographique id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zone_geographique ALTER COLUMN id SET DEFAULT nextval('public.zone_geographique_id_seq'::regclass);


--
-- Data for Name: affectation_taxe; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.affectation_taxe (id, contribuable_id, taxe_id, date_debut, date_fin, montant_custom, actif, created_at, updated_at) FROM stdin;
1	6	13	2026-01-22 10:31:26.189123	\N	\N	t	2026-01-22 10:31:26.194594	2026-01-22 10:31:26.194596
2	6	14	2026-01-22 10:31:26.190696	\N	\N	t	2026-01-22 10:31:26.194597	2026-01-22 10:31:26.194597
3	6	16	2026-01-22 10:31:26.192247	\N	\N	t	2026-01-22 10:31:26.194598	2026-01-22 10:31:26.194598
4	6	17	2026-01-22 10:31:26.193682	\N	\N	t	2026-01-22 10:31:26.194598	2026-01-22 10:31:26.194599
6	50	13	2026-01-01 00:00:00	2026-01-31 00:00:00	5000.00	t	2026-01-24 14:47:05.334619	2026-01-24 14:47:05.334619
7	33	13	2026-01-01 00:00:00	2026-01-31 00:00:00	5000.00	t	2026-01-24 14:47:05.334619	2026-01-24 14:47:05.334619
8	57	13	2026-01-01 00:00:00	2026-01-31 00:00:00	5000.00	t	2026-01-24 14:47:05.334619	2026-01-24 14:47:05.334619
9	51	13	2026-01-01 00:00:00	2026-01-31 00:00:00	5000.00	t	2026-01-24 14:47:05.334619	2026-01-24 14:47:05.334619
10	39	13	2026-01-01 00:00:00	2026-01-31 00:00:00	5000.00	t	2026-01-24 14:47:05.334619	2026-01-24 14:47:05.334619
11	45	13	2026-01-26 15:23:05.015642	\N	\N	t	2026-01-26 15:23:05.018495	2026-01-26 15:23:05.018497
12	45	14	2026-01-26 15:23:05.016995	\N	\N	t	2026-01-26 15:23:05.018498	2026-01-26 15:23:05.0185
\.


--
-- Data for Name: appareil_collecteur; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.appareil_collecteur (id, collecteur_id, device_id, plateforme, device_info, authorized, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: arrondissement; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.arrondissement (id, nom, code, commune_id, description, actif, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: caisse; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.caisse (id, collecteur_id, type_caisse, etat, code, nom, solde_initial, solde_actuel, date_ouverture, date_fermeture, date_cloture, montant_cloture, notes, actif, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: collecteur; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.collecteur (id, nom, prenom, email, telephone, matricule, zone_id, latitude, longitude, geom, date_derniere_connexion, date_derniere_deconnexion, heure_cloture, actif, created_at, updated_at, statut, etat) FROM stdin;
8	OBAME	Jean	jean.obame@mairie-pg.ga	+241077000003	COL-003	53	\N	\N	\N	\N	\N	\N	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	active	deconnecte
9	MBOUMBA	Sophie	sophie.mboumba@mairie-pg.ga	+241077000004	COL-004	54	\N	\N	\N	\N	\N	\N	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	active	deconnecte
10	MVE	Pierre	pierre.mve@mairie-pg.ga	+241077000005	COL-005	55	\N	\N	\N	\N	\N	\N	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	active	deconnecte
6	MOUSSAVOU	Paul	paul.moussavou@mairie-pg.ga	+241077000001	COL-001	51	\N	\N	\N	\N	\N	\N	t	2026-01-22 06:58:15.820013	2026-01-23 05:50:02.677383	active	deconnecte
7	NDONG	Marie	marie.ndong@mairie-pg.ga	+241077000002	COL-002	52	\N	\N	\N	2026-01-23 05:50:17.157508	\N	\N	t	2026-01-22 06:58:15.820013	2026-01-23 05:50:17.157513	active	connecte
\.


--
-- Data for Name: collecteur_zone; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.collecteur_zone (id, collecteur_id, nom, latitude, longitude, radius, description, actif, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: commune; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.commune (id, nom, code, ville_id, description, actif, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: contribuable; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contribuable (id, nom, prenom, email, telephone, type_contribuable_id, quartier_id, collecteur_id, adresse, latitude, longitude, geom, nom_activite, photo_url, numero_identification, qr_code, distance_quartier_m, mot_de_passe_hash, matricule, actif, created_at, updated_at) FROM stdin;
64	NAMBO	kevin	kevin@gmail.com	066524410	13	48	8	louis	\N	\N	\N	\N	\N	CONT-91BFAF6F	\N	\N	$2b$12$BGWpf8RH/viRsp9KpSw3FelCBQCDIJRdodk7VRgC4QwF9sr7FKHWq	\N	t	2026-01-24 17:17:15.867725	2026-01-24 17:17:15.867728
1	MBOUMBA	André	andre.mboumba@email.ga	+241062000001	13	41	6	\N	\N	\N	\N	\N	\N	CONT-001	\N	\N	$2b$12$FLES7TYRAuBky2h.k5ppluAIt8nat28gSl7zHe5NksK1WwW7bZ3um	\N	t	2026-01-22 06:58:15.820013	2026-01-24 11:34:23.196031
2	NDONG	Brigitte	brigitte.ndong@email.ga	+241062000002	14	42	7	\N	\N	\N	\N	\N	\N	CONT-002	\N	\N	$2b$12$FLES7TYRAuBky2h.k5ppluAIt8nat28gSl7zHe5NksK1WwW7bZ3um	\N	t	2026-01-22 06:58:15.820013	2026-01-24 11:34:23.196031
3	OBAME	David	david.obame@email.ga	+241062000003	15	43	8	\N	\N	\N	\N	\N	\N	CONT-003	\N	\N	$2b$12$FLES7TYRAuBky2h.k5ppluAIt8nat28gSl7zHe5NksK1WwW7bZ3um	\N	t	2026-01-22 06:58:15.820013	2026-01-24 11:34:23.196031
4	MVE	Estelle	estelle.mve@email.ga	+241062000004	14	44	9	\N	\N	\N	\N	\N	\N	CONT-004	\N	\N	$2b$12$FLES7TYRAuBky2h.k5ppluAIt8nat28gSl7zHe5NksK1WwW7bZ3um	\N	t	2026-01-22 06:58:15.820013	2026-01-24 11:34:23.196031
5	MOUSSAVOU	François	francois.moussavou@email.ga	+241062000005	13	45	10	\N	\N	\N	\N	\N	\N	CONT-005	\N	\N	$2b$12$FLES7TYRAuBky2h.k5ppluAIt8nat28gSl7zHe5NksK1WwW7bZ3um	\N	t	2026-01-22 06:58:15.820013	2026-01-24 11:34:23.196031
7	emore	junior	emore@gmail.com	077795600	13	42	7	pc	\N	\N	\N	\N	\N	CONT-58F11974	\N	\N	$2b$12$kYQo74hppdIRqOxysS7XnuuU.pK2MCmJIwggn9eEaz5PjJKopIlpu	\N	t	2026-01-22 10:48:31.715088	2026-01-24 11:34:23.196031
11	ndong	aude	aude@gmail.com	066235666	13	41	6	pc	\N	\N	\N	\N	\N	CONT-9A05C5EF	\N	\N	$2b$12$TmBn9ST/BeXBWYdb4X8ML.UCkCpc02LVq79/XUZ3MxqqI9FCc55Ei	\N	t	2026-01-23 19:56:55.620876	2026-01-24 11:34:23.196031
12	ELI	david	david@gmail.com	066554477	13	48	8	akanda	\N	\N	\N	\N	\N	CONT-239A6871	CONT-12-B99141DE	\N	$2b$12$znshLxAXmJFa8ea227MIGOTV.jWAuQ1Ypx8tvibw.bnZG7z9cZw9u	\N	t	2026-01-23 20:00:30.257118	2026-01-24 11:34:23.196031
6	BEBANE MOUKOUMBI	MARINA BRUNELLE	\N	+24177861364	13	47	8	IAI	\N	\N	\N	renover immeuble	\N	79551544	\N	\N	\N	\N	t	2026-01-22 10:31:26.180171	2026-01-24 10:35:35.816313
13	Mbina	Marie	marie.mbina0@gmail.com	+241062812155	18	51	8	Atelier mécanique - Quartier Ancien-Aéroport	0.41872073	9.46076825	\N	Atelier mécanique	\N	\N	TAX-6553-135	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
14	Owono	Jean	jean.owono1@gmail.com	+241077289680	18	51	8	Quincaillerie - Quartier Akébé	0.36595180	9.47681337	\N	Quincaillerie	\N	\N	TAX-4946-195	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
15	Mouity	Christelle	christelle.mouity2@gmail.com	+241065186164	18	51	8	Quincaillerie - Quartier Louis	0.39788621	9.46704579	\N	Quincaillerie	\N	\N	TAX-5728-851	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
16	Ondo	Paul	paul.ondo3@gmail.com	+241062798040	18	51	8	Couture - Quartier Akébé	0.37320315	9.46648259	\N	Couture	\N	\N	TAX-6765-498	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
33	Ella	Michel	michel.ella.pg0@gmail.com	+241074117482	18	58	8	Bar - Quartier Zone Industrielle, Port-Gentil	-0.71804165	8.75000000	\N	Bar	\N	\N	PG-4440-565	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
34	Owono	Hortense	hortense.owono.pg1@gmail.com	+241062539699	18	52	8	Pharmacie - Quartier Balise, Port-Gentil	-0.72076369	8.77834136	\N	Pharmacie	\N	\N	PG-9842-600	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
35	Mbina	Angélique	angélique.mbina.pg2@gmail.com	+241077926625	18	54	8	Pharmacie - Quartier Mvengue, Port-Gentil	-0.71547430	8.76820266	\N	Pharmacie	\N	\N	PG-1026-493	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
36	Ondo	François	françois.ondo.pg3@gmail.com	+241065759296	18	56	8	Couture - Quartier Cité, Port-Gentil	-0.71797942	8.77133275	\N	Couture	\N	\N	PG-5485-591	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
37	Owono	Célestine	célestine.owono.pg4@gmail.com	+241066426180	18	56	8	Restaurant - Quartier Cité, Port-Gentil	-0.71293489	8.76871875	\N	Restaurant	\N	\N	PG-9761-406	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
38	Ndong	Angélique	angélique.ndong.pg5@gmail.com	+241066791855	18	54	8	Salon de coiffure - Quartier Mvengue, Port-Gentil	-0.71515466	8.76746532	\N	Salon de coiffure	\N	\N	PG-2771-769	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
39	Ella	Joseph	joseph.ella.pg6@gmail.com	+241062615377	18	56	8	Boulangerie - Quartier Cité, Port-Gentil	-0.71763196	8.77164162	\N	Boulangerie	\N	\N	PG-6508-351	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
40	Owono	François	françois.owono.pg7@gmail.com	+241066315636	18	58	8	Boutique - Quartier Zone Industrielle, Port-Gentil	-0.71589524	8.75098561	\N	Boutique	\N	\N	PG-8627-413	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
41	Ondo	Christelle	christelle.ondo.pg8@gmail.com	+241074176892	18	55	8	Atelier mécanique - Quartier Grand Village, Port-Gentil	-0.71953899	8.75967774	\N	Atelier mécanique	\N	\N	PG-5249-583	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
42	Ndong	François	françois.ndong.pg9@gmail.com	+241077824979	18	57	8	Épicerie - Quartier Aéroport, Port-Gentil	-0.70673584	8.75629258	\N	Épicerie	\N	\N	PG-8507-263	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
43	Obame	Jean	jean.obame.pg10@gmail.com	+241062344837	18	57	8	Quincaillerie - Quartier Aéroport, Port-Gentil	-0.70630889	8.75208751	\N	Quincaillerie	\N	\N	PG-5736-839	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
32	Mbina	Célestine	célestine.mbina19@gmail.com	+241066393182	18	51	8	Pharmacie - Quartier Derrière Prison	0.39860033	9.44759736	\N	Pharmacie	\N	\N	TAX-4751-458	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
44	Ondo	Joseph	joseph.ondo.pg11@gmail.com	+241065685532	18	59	8	Atelier mécanique - Quartier Port, Port-Gentil	-0.71977905	8.77079891	\N	Atelier mécanique	\N	\N	PG-5131-943	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
45	Ndong	Marie	marie.ndong.pg12@gmail.com	+241065588190	18	57	8	Couture - Quartier Aéroport, Port-Gentil	-0.70742050	8.75542985	\N	Couture	\N	\N	PG-5777-286	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
46	Mouity	François	françois.mouity.pg13@gmail.com	+241065501359	18	56	8	Couture - Quartier Cité, Port-Gentil	-0.71796108	8.77338770	\N	Couture	\N	\N	PG-5486-910	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
47	Ndong	Michel	michel.ndong.pg14@gmail.com	+241062696782	18	52	8	Restaurant - Quartier Balise, Port-Gentil	-0.71646532	8.77919550	\N	Restaurant	\N	\N	PG-1930-324	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
48	Nguema	Joseph	joseph.nguema.pg15@gmail.com	+241074827678	18	53	8	Restaurant - Quartier Château, Port-Gentil	-0.71067389	8.77258776	\N	Restaurant	\N	\N	PG-6310-266	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
49	Owono	Michel	michel.owono.pg16@gmail.com	+241065506118	18	55	8	Boulangerie - Quartier Grand Village, Port-Gentil	-0.72258425	8.76206465	\N	Boulangerie	\N	\N	PG-3836-767	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
50	Mouity	Célestine	célestine.mouity.pg17@gmail.com	+241066302722	18	58	8	Salon de coiffure - Quartier Zone Industrielle, Port-Gentil	-0.71944504	8.75404958	\N	Salon de coiffure	\N	\N	PG-2564-622	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
51	Ndong	Angélique	angélique.ndong.pg18@gmail.com	+241066308138	18	57	8	Salon de coiffure - Quartier Aéroport, Port-Gentil	-0.70402564	8.75099917	\N	Salon de coiffure	\N	\N	PG-3424-403	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
52	Ndong	Michel	michel.ndong.pg19@gmail.com	+241066503286	18	54	8	Bar - Quartier Mvengue, Port-Gentil	-0.71271687	8.76659149	\N	Bar	\N	\N	PG-8102-767	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
53	Mouity	Paul	paul.mouity.pg20@gmail.com	+241066107027	18	53	8	Bar - Quartier Château, Port-Gentil	-0.70688823	8.77346297	\N	Bar	\N	\N	PG-3891-534	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
54	Ndong	François	françois.ndong.pg21@gmail.com	+241074403748	18	58	8	Pharmacie - Quartier Zone Industrielle, Port-Gentil	-0.72062905	8.75398827	\N	Pharmacie	\N	\N	PG-1699-725	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
55	Owono	Michel	michel.owono.pg22@gmail.com	+241062621986	18	58	8	Bar - Quartier Zone Industrielle, Port-Gentil	-0.72096818	8.75000000	\N	Bar	\N	\N	PG-9997-454	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
56	Obame	Angélique	angélique.obame.pg23@gmail.com	+241062206812	18	59	8	Boulangerie - Quartier Port, Port-Gentil	-0.72103586	8.77108104	\N	Boulangerie	\N	\N	PG-6772-441	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
57	Nguema	Angélique	angélique.nguema.pg24@gmail.com	+241065315242	18	52	8	Quincaillerie - Quartier Balise, Port-Gentil	-0.71762714	8.77688406	\N	Quincaillerie	\N	\N	PG-7123-232	\N	\N	\N	t	2026-01-24 10:17:44.731754	2026-01-24 10:23:37.157699
61	MVE	Estelle	estelle.mve@citoyen.ga	+241066004004	13	52	8	Centre-ville Port-Gentil	-0.71930000	8.77790000	\N	\N	\N	\N	\N	\N	\\\\\\.uz7BA/u/.KxtIWIARCBZURam	CONT-004	t	2026-01-24 11:16:33.741111	2026-01-24 11:16:33.741111
62	OBAME	Pierre	pierre.obame@citoyen.ga	+241066005005	13	56	8	Quartier Cité, Port-Gentil	-0.71560000	8.77120000	\N	\N	\N	\N	\N	\N	\\\\\\	CONT-005	t	2026-01-24 11:25:00.466247	2026-01-24 11:25:00.466247
63	NDONG	jean	ndong@gmail.com	077795601	13	48	8	lalara	\N	\N	\N	\N	\N	CONT-2398530A	\N	\N	$2b$12$jxYLhZz0QzsIRhkBw2ZVwumMi0HdVxFzgCDcKNOt3AYGSmG8J56Qe	\N	t	2026-01-24 11:34:32.991045	2026-01-24 11:34:32.99105
17	Ondo	Paul	paul.ondo4@gmail.com	+241065647579	18	51	8	Épicerie - Quartier Akébé	0.37534524	9.47834740	\N	Épicerie	\N	\N	TAX-4017-768	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
18	Mouity	Joseph	joseph.mouity5@gmail.com	+241066297436	18	51	8	Boutique - Quartier Lalala	0.41215367	9.47796731	\N	Boutique	\N	\N	TAX-1872-612	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
19	Ella	Jean	jean.ella6@gmail.com	+241074633537	18	51	8	Quincaillerie - Quartier Louis	0.39822299	9.45561873	\N	Quincaillerie	\N	\N	TAX-2749-672	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
20	Bongo	Joseph	joseph.bongo7@gmail.com	+241077501366	18	51	8	Quincaillerie - Quartier Mont-Bouët	0.37614982	9.45462954	\N	Quincaillerie	\N	\N	TAX-2014-317	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
21	Bongo	Michel	michel.bongo8@gmail.com	+241074844874	18	51	8	Boulangerie - Quartier Derrière Prison	0.39521488	9.44585357	\N	Boulangerie	\N	\N	TAX-4507-582	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
22	Mbina	Michel	michel.mbina9@gmail.com	+241077874592	18	51	8	Couture - Quartier Akébé	0.37747896	9.46677587	\N	Couture	\N	\N	TAX-9062-583	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
23	Mouity	Marie	marie.mouity10@gmail.com	+241074451280	18	51	8	Restaurant - Quartier Louis	0.38544969	9.46251724	\N	Restaurant	\N	\N	TAX-8231-274	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
24	Owono	Hortense	hortense.owono11@gmail.com	+241074879492	18	51	8	Boutique - Quartier Mont-Bouët	0.39536575	9.44537127	\N	Boutique	\N	\N	TAX-1199-333	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
25	Mbina	Jean	jean.mbina12@gmail.com	+241074842816	18	51	8	Salon de coiffure - Quartier PK8	0.42551402	9.48966220	\N	Salon de coiffure	\N	\N	TAX-6121-596	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
26	Nguema	François	françois.nguema13@gmail.com	+241065133776	18	51	8	Boutique - Quartier Louis	0.39231413	9.45962378	\N	Boutique	\N	\N	TAX-5332-662	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
27	Mouity	Paul	paul.mouity14@gmail.com	+241065559418	18	51	8	Quincaillerie - Quartier Bambou	0.40774110	9.45395467	\N	Quincaillerie	\N	\N	TAX-7675-295	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
28	Ondo	Joseph	joseph.ondo15@gmail.com	+241062857745	18	51	8	Restaurant - Quartier Ancien-Aéroport	0.41365964	9.45756429	\N	Restaurant	\N	\N	TAX-7920-269	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
29	Bongo	Michel	michel.bongo16@gmail.com	+241062759940	18	51	8	Restaurant - Quartier Derrière Prison	0.40730896	9.45030810	\N	Restaurant	\N	\N	TAX-8532-367	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
30	Mouity	Hortense	hortense.mouity17@gmail.com	+241062659530	18	51	8	Bar - Quartier Mont-Bouët	0.37597157	9.45937559	\N	Bar	\N	\N	TAX-3307-407	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
31	Ella	Paul	paul.ella18@gmail.com	+241062741562	18	51	8	Restaurant - Quartier Nombakélé	0.40668691	9.44434305	\N	Restaurant	\N	\N	TAX-5642-957	\N	\N	\N	t	2026-01-24 09:57:32.973257	2026-01-24 10:35:35.816313
\.


--
-- Data for Name: coupure_caisse; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.coupure_caisse (id, valeur, devise, type_coupure, description, ordre_affichage, actif, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: demande_citoyen; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.demande_citoyen (id, contribuable_id, type_demande, sujet, description, reponse, traite_par_id, date_traitement, pieces_jointes, created_at, updated_at, statut) FROM stdin;
19	7	27	Demande de Service de la Voirie	demande	\N	\N	\N	["/uploads/demandes/19_0dfcb993-2c9f-4c42-a652-64f27753f3ec.png"]	2026-01-22 14:29:16.228331	2026-01-22 14:29:23.613676	envoyee
20	7	36	Demande de Service de la Santé	demande	\N	\N	\N	["/uploads/demandes/20_b238065f-9d4e-4e61-a149-ba119db55a61.png"]	2026-01-22 14:41:19.955065	2026-01-22 14:41:27.742691	envoyee
21	4	27	Demande de Service de la Voirie	demande	\N	\N	\N	["/uploads/demandes/21_dd07d7a0-dc38-4eee-9422-687afaeaf308.png"]	2026-01-23 21:23:13.077485	2026-01-23 21:23:23.408165	envoyee
22	4	27	Demande de Service de la Voirie	demande	\N	\N	\N	["/uploads/demandes/22_438d68a4-6ff0-4035-ac84-593e4b875754.png"]	2026-01-23 21:38:04.845761	2026-01-23 21:38:23.014868	envoyee
23	4	27	Demande de Service de la Voirie	demande en ligne	\N	\N	\N	["/uploads/demandes/23_4b63a53d-74a2-43ea-9311-9f240c2337d5.png"]	2026-01-23 23:12:31.877035	2026-01-23 23:12:39.797599	envoyee
1	4	reclamation	Demande de Service de lÉtat Civil	tes	\N	\N	\N	["/uploads/demandes/1_69e90256-e4b3-4916-acc5-e9fdcccbd2a2.png"]	2026-01-22 09:24:09.516996	2026-01-22 09:24:55.575728	envoyee
2	4	reclamation	Demande de Service de la Voirie	demande urgente	\N	\N	\N	["/uploads/demandes/2_f2ef6b9b-f04e-4a4d-8204-b912c7fe9d68.png"]	2026-01-22 09:45:41.619705	2026-01-22 09:46:03.870114	envoyee
3	4	reclamation	Demande de Service de lUrbanisme	demande	\N	\N	\N	["/uploads/demandes/3_42a0cb48-5686-4c77-8a64-0c2c401f78d4.png"]	2026-01-22 09:58:24.024	2026-01-22 09:58:40.163706	envoyee
4	4	reclamation	Demande de Service de l'Environnement	demande	\N	\N	\N	["/uploads/demandes/4_b88e1fa0-3c8c-4ee0-a819-27284e6c35ee.png"]	2026-01-22 10:09:04.793099	2026-01-22 10:09:13.387503	envoyee
5	4	reclamation	Demande de Service de lUrbanisme	demande	\N	\N	\N	["/uploads/demandes/5_17f44f5d-6469-47bd-a0ec-3b0ddccb81c4.png"]	2026-01-22 10:27:20.721875	2026-01-22 10:27:27.910621	envoyee
6	4	reclamation	Demande de Service de la Santé	demande	\N	\N	\N	["/uploads/demandes/6_821bc59e-fd1f-4913-8334-ddffc60eb0c2.png"]	2026-01-22 10:32:47.004867	2026-01-22 10:32:54.71689	envoyee
7	4	reclamation	Demande de Service de la Santé	demande	\N	\N	\N	["/uploads/demandes/7_a28b5f7e-acf3-4d92-8c94-e72c67f47f16.png"]	2026-01-22 10:39:55.06549	2026-01-22 10:40:02.034637	envoyee
8	4	reclamation	Demande de Service du Commerce	demande	\N	\N	\N	["/uploads/demandes/8_79e72eb3-2fdc-4730-8e03-b6e3ff48cd49.png"]	2026-01-22 10:51:01.984649	2026-01-22 10:51:09.12722	envoyee
9	4	reclamation	Demande de Service de lÉtat Civil	dedee	\N	\N	\N	["/uploads/demandes/9_29da9a8b-4082-4269-bf81-81f1d6caccbb.png"]	2026-01-22 10:53:10.328232	2026-01-22 10:53:18.548486	envoyee
10	4	reclamation	Demande de Service de lUrbanisme	demande	\N	\N	\N	["/uploads/demandes/10_c8bbcea0-0e8b-45c3-8ae9-d25a121578fb.png"]	2026-01-22 10:57:35.08686	2026-01-22 10:57:44.025745	envoyee
11	4	30	Demande de Service de lÉtat Civil	demande\n	\N	\N	\N	["/uploads/demandes/11_39cb3f1e-9093-49a5-8716-c87a8dd3b6ba.png"]	2026-01-22 11:02:21.299502	2026-01-22 11:03:23.787284	envoyee
13	4	39	Demande de Service du Commerce	demande	\N	\N	\N	["/uploads/demandes/13_a1290b0a-8783-4916-983c-e45fba7cdb58.png"]	2026-01-22 11:11:08.706166	2026-01-22 11:11:17.152841	envoyee
12	4	26	Demande de Service de lUrbanisme	demande	\N	2	2026-01-22 11:12:40.24385	["/uploads/demandes/12_b7195ff4-d164-4d1a-aed3-8865d4896c2f.png"]	2026-01-22 11:05:44.014954	2026-01-22 11:12:40.243872	en_traitement
14	4	39	Demande de Service du Commerce	demande	\N	\N	\N	["/uploads/demandes/14_204fd2b2-e97e-4899-9aa7-bee9c9d388a6.png"]	2026-01-22 11:22:43.579375	2026-01-22 11:22:50.938853	envoyee
15	4	28	Demande de Service de lHygiène	demande	\N	\N	\N	["/uploads/demandes/15_61e9040e-d68f-47e1-aa50-4bb7e33fe11b.png"]	2026-01-22 11:25:41.71288	2026-01-22 11:25:49.090311	envoyee
16	4	29	Demande de Service des Marchés	demande	\N	\N	\N	["/uploads/demandes/16_5a24b87a-83e1-4629-a5c8-934ea033e667.png"]	2026-01-22 13:28:30.467192	2026-01-22 13:28:47.824441	envoyee
17	4	36	Demande de Service de la Santé	demande	\N	\N	\N	["/uploads/demandes/17_6a6e45b8-c04e-460c-ad64-94aa4b76d7c6.png"]	2026-01-22 13:37:23.536719	2026-01-22 13:37:37.047838	envoyee
18	4	37	Demande de Service de l'Éducation	education enfant	\N	\N	\N	["/uploads/demandes/18_c81ad578-01f9-428f-a786-5325fb605164.png"]	2026-01-22 14:19:28.547057	2026-01-22 14:19:47.723202	envoyee
24	4	30	Demande de Service de lÉtat Civil	demande	\N	\N	\N	["/uploads/demandes/24_825dc4f8-f1b6-4d62-a948-93fa2f899ea3.png"]	2026-01-23 23:12:57.779703	2026-01-23 23:13:05.051955	envoyee
25	4	27	Demande de Service de la Voirie	en lgne	\N	\N	\N	["/uploads/demandes/25_742152a3-75db-48ba-8166-2ef52cdafdaa.png"]	2026-01-23 23:16:21.036926	2026-01-23 23:16:28.301541	envoyee
26	4	27	Demande de Service de la Voirie	en ligne	\N	\N	\N	["/uploads/demandes/26_a256bec3-6098-43f7-acf3-0e95b8846f78.png"]	2026-01-23 23:19:13.855365	2026-01-23 23:19:20.044043	envoyee
27	4	27	Demande de Service de la Voirie	demande	\N	\N	\N	["/uploads/demandes/27_61c924bd-37f4-47a3-9c90-8c452ac3342d.png"]	2026-01-23 23:21:42.140151	2026-01-23 23:21:48.915388	envoyee
28	4	37	Demande de Service de l'Éducation	demande en ligne	\N	\N	\N	["/uploads/demandes/28_5c733e94-bdd2-43c1-96bc-42935c955290.png"]	2026-01-23 23:24:34.643668	2026-01-23 23:24:42.771314	envoyee
29	4	27	Demande de Service de la Voirie	demande en ligne	\N	\N	\N	["/uploads/demandes/29_1e984d30-0132-428a-beef-096cd3467cf1.png"]	2026-01-23 23:27:17.986415	2026-01-23 23:27:28.814893	envoyee
30	4	27	Demande de Service de la Voirie	demande en ligne	\N	\N	\N	["/uploads/demandes/30_82d969c7-1667-46dd-a34d-a801d8862aa4.png"]	2026-01-23 23:42:15.34629	2026-01-23 23:42:32.903879	envoyee
31	7	30	Demande de Service de lÉtat Civil	demande	\N	\N	\N	[]	2026-01-24 12:20:03.205416	2026-01-24 12:20:03.205419	envoyee
32	7	Copie d'Acte de Naissance	Demande de Copie d'Acte de Naissance	demande	\N	\N	\N	[]	2026-01-24 12:50:29.688261	2026-01-24 12:50:29.688263	envoyee
33	7	Acte de Naissance	Demande de Acte de Naissance	demande d'etablissement acte	\N	\N	\N	[]	2026-01-24 14:52:01.927846	2026-01-24 14:52:01.92785	envoyee
34	7	Certificat d'Urbanisme	Demande de Certificat d'Urbanisme	demande	\N	2	2026-01-24 16:52:12.043779	["/uploads/demandes/34_d2d1c689-51bc-46af-aca9-c511ba6e2f3b.png"]	2026-01-24 15:01:45.631159	2026-01-24 16:52:12.043814	en_traitement
35	7	Autorisation d'Abattage d'Arbres	Demande de Autorisation d'Abattage d'Arbres	demande	\N	\N	\N	["/uploads/demandes/35_c878fbe0-718f-4792-8585-a18fb0eaf8da.png"]	2026-01-24 17:19:23.684989	2026-01-24 17:19:32.848516	envoyee
36	7	Acte de Naissance	Demande de Acte de Naissance	demande	\N	\N	\N	["/uploads/demandes/36_0231e7d4-7ebc-4e9a-b2d2-f9484898c215.png"]	2026-01-24 19:02:51.394022	2026-01-24 19:03:08.919628	envoyee
\.


--
-- Data for Name: dossier_impaye; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dossier_impaye (id, contribuable_id, affectation_taxe_id, montant_initial, montant_paye, montant_restant, penalites, date_echeance, jours_retard, statut, priorite, dernier_contact, nombre_relances, notes, assigne_a, date_assignation, date_cloture, created_at, updated_at) FROM stdin;
2	33	7	5000.00	0.00	5000.00	0.00	2026-02-15 00:00:00	-22	en_cours	faible	\N	0	Dossier pour Ella - Taxe de Marché	\N	\N	\N	2026-01-24 14:47:07.880499	2026-01-24 14:47:07.880499
3	57	8	5000.00	0.00	5000.00	0.00	2026-02-15 00:00:00	-22	en_cours	faible	\N	0	Dossier pour Nguema - Taxe de Marché	\N	\N	\N	2026-01-24 14:47:07.880499	2026-01-24 14:47:07.880499
4	51	9	5000.00	0.00	5000.00	0.00	2026-02-15 00:00:00	-22	en_cours	faible	\N	0	Dossier pour Ndong - Taxe de Marché	\N	\N	\N	2026-01-24 14:47:07.880499	2026-01-24 14:47:07.880499
5	39	10	5000.00	0.00	5000.00	0.00	2026-02-15 00:00:00	-22	en_cours	faible	\N	0	Dossier pour Ella - Taxe de Marché	\N	\N	\N	2026-01-24 14:47:07.880499	2026-01-24 14:47:07.880499
\.


--
-- Data for Name: info_collecte; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.info_collecte (id, contribuable_id, taxe_id, collecteur_id, montant, commission, reference, billetage, date_collecte, date_cloture, sms_envoye, ticket_imprime, annule, raison_annulation, created_at, updated_at, info_taxation_id, type_paiement, statut) FROM stdin;
33	61	13	8	5000.00	250.00	COL-20260124-0001	\N	2026-01-23 00:00:00	\N	f	f	f	\N	2026-01-24 11:57:26.417496	2026-01-24 11:57:26.4175	1515	especes	completed
34	62	13	8	5000.00	250.00	COL-20260124-0002	\N	2026-01-24 00:00:00	\N	f	f	f	\N	2026-01-24 12:50:06.92772	2026-01-24 12:50:06.927724	1516	especes	completed
35	50	13	8	5000.00	250.00	COL-20260124-0003	\N	2026-01-24 00:00:00	\N	f	f	f	\N	2026-01-24 12:50:56.802294	2026-01-24 12:50:56.802295	1507	especes	completed
36	50	13	8	5000.00	250.00	COL-20260126-0004	\N	2026-01-26 00:00:00	\N	f	f	f	\N	2026-01-26 15:29:26.951048	2026-01-26 15:29:26.95105	\N	especes	completed
\.


--
-- Data for Name: info_taxation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.info_taxation (id, contribuable_id, taxe_id, periode_debut, periode_fin, annee, mois, montant_attendu, montant_custom, statut, date_echeance, actif, notes, created_at, updated_at) FROM stdin;
495	6	13	2026-01-23	2026-01-31	2026	1	5000.00	\N	en_attente	2026-02-15	t	\N	2026-01-23 08:19:23.919379	2026-01-23 08:19:23.919379
496	6	14	2026-01-23	2026-01-31	2026	1	10000.00	\N	en_attente	2026-02-15	t	\N	2026-01-23 08:19:23.919379	2026-01-23 08:19:23.919379
497	6	16	2026-01-23	2026-01-31	2026	1	3000.00	\N	en_attente	2026-02-15	t	\N	2026-01-23 08:19:23.919379	2026-01-23 08:19:23.919379
498	6	17	2026-01-23	2026-01-31	2026	1	50000.00	\N	en_attente	2026-02-15	t	\N	2026-01-23 08:19:23.919379	2026-01-23 08:19:23.919379
1488	7	13	2026-01-23	2026-01-31	2026	1	5000.00	\N	en_attente	2026-02-15	t	\N	2026-01-23 10:05:12.205493	2026-01-23 10:05:12.205495
1489	7	14	2026-01-23	2026-01-31	2026	1	10000.00	\N	en_attente	2026-02-15	t	\N	2026-01-23 10:05:34.141159	2026-01-23 10:05:34.141161
1490	34	13	2026-01-24	2026-01-31	2026	1	5000.00	\N	en_attente	2026-02-15	t	\N	2026-01-24 10:55:04.720405	2026-01-24 10:55:04.720408
1491	33	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1492	35	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1493	36	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1494	37	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1495	38	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1496	39	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1497	40	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1498	41	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1499	42	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1500	43	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1501	44	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1502	45	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1503	46	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1504	47	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1505	48	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1506	49	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1508	51	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1509	52	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1510	53	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1511	54	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1512	55	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1513	56	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1514	57	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	impaye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-24 10:58:00.727098
1515	61	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	paye	2026-02-15	t	\N	2026-01-24 11:16:44.973825	2026-01-24 12:08:10.388432
1516	62	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	paye	2026-02-15	t	\N	2026-01-24 11:25:13.779873	2026-01-24 12:50:06.917901
1517	63	13	2026-01-24	2026-01-31	2026	1	5000.00	\N	en_attente	2026-02-15	t	\N	2026-01-24 16:51:19.501306	2026-01-24 16:51:19.501307
1518	48	14	2026-01-24	2026-01-31	2026	1	10000.00	\N	en_attente	2026-02-15	t	\N	2026-01-24 18:17:24.203093	2026-01-24 18:17:24.203095
1519	48	15	2026-01-24	2026-01-31	2026	1	7500.00	\N	en_attente	2026-02-15	t	\N	2026-01-24 18:17:24.203096	2026-01-24 18:17:24.203096
1507	50	13	2026-01-01	2026-01-31	2026	1	5000.00	\N	paye	2026-02-15	t	\N	2026-01-24 10:58:00.727098	2026-01-26 15:29:26.943729
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notification (id, user_id, type, title, message, read, data, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: operation_caisse; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.operation_caisse (id, caisse_id, collecteur_id, type_operation, montant, libelle, collecte_id, reference, solde_avant, solde_apres, notes, date_operation, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: quartier; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.quartier (id, nom, code, zone_id, description, actif, geom, osm_id, place_type, tags, created_at, updated_at, latitude, longitude) FROM stdin;
52	Balise	BAL89	81	\N	t	\N	\N	\N	\N	2026-01-24 10:17:36.19034	2026-01-24 10:17:36.19034	\N	\N
53	Château	CHÂ42	81	\N	t	\N	\N	\N	\N	2026-01-24 10:17:37.349193	2026-01-24 10:17:37.349193	\N	\N
54	Mvengue	MVE90	81	\N	t	\N	\N	\N	\N	2026-01-24 10:17:38.401618	2026-01-24 10:17:38.401618	\N	\N
55	Grand Village	GRA17	81	\N	t	\N	\N	\N	\N	2026-01-24 10:17:39.454004	2026-01-24 10:17:39.454004	\N	\N
56	Cité	CIT91	81	\N	t	\N	\N	\N	\N	2026-01-24 10:17:40.50649	2026-01-24 10:17:40.50649	\N	\N
57	Aéroport	AÉR99	81	\N	t	\N	\N	\N	\N	2026-01-24 10:17:41.559036	2026-01-24 10:17:41.559036	\N	\N
58	Zone Industrielle	ZON47	81	\N	t	\N	\N	\N	\N	2026-01-24 10:17:42.611458	2026-01-24 10:17:42.611458	\N	\N
59	Port	POR58	81	\N	t	\N	\N	\N	\N	2026-01-24 10:17:43.678054	2026-01-24 10:17:43.678054	\N	\N
51	Glass	GLASS	84	\N	t	\N	\N	\N	\N	2026-01-24 09:57:31.499925	2026-01-24 09:57:31.499925	\N	\N
41	Tchengue	PG-Q001	84	\N	t	\N	\N	\N	\N	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	-0.71670000	8.78330000
42	miboue	PG-Q002	84	\N	t	\N	\N	\N	\N	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	-0.72000000	8.79000000
43	Aéroport International	PG-Q003	84	\N	t	\N	\N	\N	\N	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	-0.71000000	8.75000000
44	quartier chic	PG-Q004	84	\N	t	\N	\N	\N	\N	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	-0.71500000	8.78000000
45	grand village	PG-Q005	84	\N	t	\N	\N	\N	\N	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	-0.73000000	8.80000000
46	quartier ocean	PG-Q006	84	\N	t	\N	\N	\N	\N	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	-0.70000000	8.77000000
47	carrefour hassan	PG-Q007	84	\N	t	\N	\N	\N	\N	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	-0.70500000	8.77500000
48	SOGARA	PG-Q008	84	\N	t	\N	\N	\N	\N	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	-0.71000000	8.78500000
49	Plage	PG-Q009	84	\N	t	\N	\N	\N	\N	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	-0.72500000	8.79500000
50	Résidence	PG-Q010	84	\N	t	\N	\N	\N	\N	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	-0.70000000	8.76000000
\.


--
-- Data for Name: relance; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.relance (id, contribuable_id, affectation_taxe_id, type_relance, statut, message, montant_due, date_echeance, date_envoi, date_planifiee, canal_envoi, reponse_recue, date_reponse, notes, utilisateur_id, created_at, updated_at) FROM stdin;
1	33	7	sms	en_attente	Rappel : Vous avez une taxe de 5000.00 FCFA à payer. Échéance : 31/01/2026	5000.00	2026-01-31 00:00:00	\N	2026-01-26 15:39:07.155958	+241074117482	f	\N	\N	\N	2026-01-26 15:39:07.167636	2026-01-26 15:39:07.167638
2	57	8	sms	en_attente	Rappel : Vous avez une taxe de 5000.00 FCFA à payer. Échéance : 31/01/2026	5000.00	2026-01-31 00:00:00	\N	2026-01-26 15:39:07.160491	+241065315242	f	\N	\N	\N	2026-01-26 15:39:07.16764	2026-01-26 15:39:07.167641
3	51	9	sms	en_attente	Rappel : Vous avez une taxe de 5000.00 FCFA à payer. Échéance : 31/01/2026	5000.00	2026-01-31 00:00:00	\N	2026-01-26 15:39:07.162993	+241066308138	f	\N	\N	\N	2026-01-26 15:39:07.167641	2026-01-26 15:39:07.167642
4	39	10	sms	en_attente	Rappel : Vous avez une taxe de 5000.00 FCFA à payer. Échéance : 31/01/2026	5000.00	2026-01-31 00:00:00	\N	2026-01-26 15:39:07.165382	+241062615377	f	\N	\N	\N	2026-01-26 15:39:07.167642	2026-01-26 15:39:07.167643
5	39	\N	sms	echec	bonjour payé	1000.00	2026-01-28 15:42:00	\N	2026-01-26 15:42:00	+241077861364	f	\N	Erreur envoi SMS: Impossible de récupérer le token d'accès Keycloak	\N	2026-01-26 15:40:57.862335	2026-01-26 15:41:41.338896
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.role (id, nom, code, description, permissions, actif, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: secteur_activite; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.secteur_activite (id, nom, code, description, actif, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.service (id, nom, description, code, actif, created_at, updated_at, montant) FROM stdin;
25	Service des Finances	Gestion des finances municipales	SF001	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	5000.00
26	Service de lUrbanisme	Aménagement et urbanisme	SU001	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	5000.00
27	Service de la Voirie	Entretien de la voirie	SV001	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	5000.00
28	Service de lHygiène	Hygiène et salubrité publique	SH001	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	5000.00
29	Service des Marchés	Gestion des marchés municipaux	SM001	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	5000.00
30	Service de lÉtat Civil	État civil et documentation	SEC001	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	5000.00
35	Service de l'Habitat	Gestion de l'habitat et du logement	habitat	t	2026-01-22 09:47:33.381811	2026-01-22 09:47:33.381811	5000.00
36	Service de la Santé	Services de santé publique	sante	t	2026-01-22 09:47:33.381811	2026-01-22 09:47:33.381811	5000.00
37	Service de l'Éducation	Services éducatifs	education	t	2026-01-22 09:47:33.381811	2026-01-22 09:47:33.381811	5000.00
38	Service de l'Environnement	Gestion de l'environnement	environnement	t	2026-01-22 09:47:33.381811	2026-01-22 09:47:33.381811	5000.00
39	Service du Commerce	Gestion du commerce et des marchés	commerce	t	2026-01-22 09:47:33.381811	2026-01-22 09:47:33.381811	5000.00
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: taxe; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.taxe (id, nom, code, description, montant, montant_variable, type_taxe_id, service_id, commission_pourcentage, actif, created_at, updated_at, periodicite) FROM stdin;
13	Taxe de Marché	TM-MARCHE	Taxe sur les activités de marché	5000.00	f	5	29	5.00	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	mensuelle
14	Taxe dOccupation du Domaine Public	TM-ODP	Taxe pour occupation de lespace public	10000.00	f	5	26	5.00	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	mensuelle
15	Taxe de Voirie	TM-VOIRIE	Taxe pour entretien de la voirie	7500.00	f	5	27	5.00	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	mensuelle
16	Taxe dOrdures Ménagères	TM-ORDURES	Taxe pour collecte des ordures	3000.00	f	5	28	5.00	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	mensuelle
17	Taxe de Patente	TM-PATENTE	Taxe de patente annuelle	50000.00	f	5	25	5.00	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	mensuelle
18	Taxe de Séjour	TM-SEJOUR	Taxe de séjour pour hôtels	20000.00	f	5	25	5.00	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013	mensuelle
19	Taxe d'occupation du domaine public	TODP	\N	50000.00	f	5	25	0.00	t	2026-01-22 09:53:57.316404	2026-01-22 09:53:57.316404	journaliere
20	Taxe de marché	TM	\N	100000.00	f	5	25	0.00	t	2026-01-22 09:53:57.316404	2026-01-22 09:53:57.316404	hebdomadaire
21	Taxe professionnelle	TP	\N	75000.00	f	5	25	0.00	t	2026-01-22 09:53:57.316404	2026-01-22 09:53:57.316404	mensuelle
22	Taxe sur les débits de boisson	TDB	\N	25000.00	f	5	25	0.00	t	2026-01-22 09:53:57.316404	2026-01-22 09:53:57.316404	mensuelle
23	Impôt sur le revenu	IR	\N	150000.00	f	5	25	0.00	t	2026-01-22 09:53:57.316404	2026-01-22 09:53:57.316404	trimestrielle
24	Taxe foncière	TF	\N	200000.00	f	5	25	0.00	t	2026-01-22 09:53:57.316404	2026-01-22 09:53:57.316404	trimestrielle
\.


--
-- Data for Name: type_contribuable; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.type_contribuable (id, nom, code, description, actif, created_at, updated_at) FROM stdin;
13	Particulier	PART	\N	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013
14	Commerçant	COMM	\N	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013
15	Entreprise	ENTR	\N	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013
18	Commerce	COM	\N	t	2026-01-24 09:57:30.397676	2026-01-24 09:57:30.397676
\.


--
-- Data for Name: type_taxe; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.type_taxe (id, nom, code, description, actif, created_at, updated_at) FROM stdin;
5	Taxe Municipale	TM001	Taxes municipales générales	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013
6	Taxe d'occupation	taxe_occupation	\N	\N	2026-01-22 09:35:35.590485	2026-01-22 09:35:35.590485
7	Taxe de marché	taxe_marche	\N	\N	2026-01-22 09:35:35.590485	2026-01-22 09:35:35.590485
8	Taxe professionnelle	taxe_professionnelle	\N	\N	2026-01-22 09:35:35.590485	2026-01-22 09:35:35.590485
9	Taxe sur les débits de boisson	taxe_debit_boisson	\N	\N	2026-01-22 09:35:35.590485	2026-01-22 09:35:35.590485
10	Impôt sur le revenu	impot_revenu	\N	\N	2026-01-22 09:35:35.590485	2026-01-22 09:35:35.590485
11	Taxe foncière	taxe_fonciere	\N	\N	2026-01-22 09:35:35.590485	2026-01-22 09:35:35.590485
\.


--
-- Data for Name: utilisateur; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.utilisateur (id, nom, prenom, email, telephone, mot_de_passe_hash, actif, derniere_connexion, created_at, updated_at, role) FROM stdin;
17	NDONG	jean	ndong@gmail.com	077795601	$2b$12$jxYLhZz0QzsIRhkBw2ZVwumMi0HdVxFzgCDcKNOt3AYGSmG8J56Qe	t	\N	2026-01-24 11:34:33.000092	2026-01-24 11:34:33.000094	contribuable
18	NAMBO	kevin	kevin@gmail.com	066524410	$2b$12$BGWpf8RH/viRsp9KpSw3FelCBQCDIJRdodk7VRgC4QwF9sr7FKHWq	t	\N	2026-01-24 17:17:15.877122	2026-01-24 17:17:15.877124	contribuable
15	ndong	aude	aude@gmail.com	066235666	$2b$12$TmBn9ST/BeXBWYdb4X8ML.UCkCpc02LVq79/XUZ3MxqqI9FCc55Ei	t	\N	2026-01-23 19:56:55.629276	2026-01-23 19:56:55.629278	contribuable
16	ELI	david	david@gmail.com	066554477	$2b$12$znshLxAXmJFa8ea227MIGOTV.jWAuQ1Ypx8tvibw.bnZG7z9cZw9u	t	\N	2026-01-23 20:00:30.262485	2026-01-23 20:00:30.262488	contribuable
13	emore	junior	emore@gmail.com	077795600	$2b$12$kYQo74hppdIRqOxysS7XnuuU.pK2MCmJIwggn9eEaz5PjJKopIlpu	t	\N	2026-01-22 10:48:31.726137	2026-01-22 10:48:31.72614	contribuable
12	Moussavou	Paul	paul.moussavou@mairie-pg.ga	+241614000000	$2b$12$1JxHpCWZxTfOjzeFR4zUXuVnAYWeCCzZDdIbP0DQM64eMobQN4afW	t	2026-01-23 22:18:28.863656	2026-01-22 09:14:57.502632	2026-01-23 22:18:28.864315	collecteur
2	NDONG	Claire	claire.ndong@mairie-pg.ga	+241077010002	$2b$12$POWx1f8P9VQti4x1lkTozec3tY8Kbo30Vjlg9UrfIoNKyPWevt1eO	t	2026-01-26 20:11:47.683998	2026-01-22 06:27:49.268015	2026-01-26 20:11:47.684524	admin
1	Admin	Système	admin@mairie-pg.ga	+241077010001	$2b$12$3qrSgPoSyU5.6Ht/aT2QLO.oj24hotaIoAY201iGQTTCK9Ffq4pFK	t	\N	2026-01-22 06:27:49.268015	2026-01-22 06:27:49.268015	admin
3	OBAME	Marc	marc.obame@mairie-pg.ga	+241077010003	$2b$12$3qrSgPoSyU5.6Ht/aT2QLO.oj24hotaIoAY201iGQTTCK9Ffq4pFK	t	\N	2026-01-22 06:27:49.268015	2026-01-22 06:27:49.268015	admin
4	MBOUMBA	Lucie	lucie.mboumba@mairie-pg.ga	+241077010004	$2b$12$3qrSgPoSyU5.6Ht/aT2QLO.oj24hotaIoAY201iGQTTCK9Ffq4pFK	t	\N	2026-01-22 06:27:49.268015	2026-01-22 06:27:49.268015	admin
5	MVE	Thomas	thomas.mve@mairie-pg.ga	+241077010005	$2b$12$3qrSgPoSyU5.6Ht/aT2QLO.oj24hotaIoAY201iGQTTCK9Ffq4pFK	t	\N	2026-01-22 06:27:49.268015	2026-01-22 06:27:49.268015	admin
6	MBOUMBA	André	andre.mboumba@email.ga	+241062000001	$2b$12$FLES7TYRAuBky2h.k5ppluAIt8nat28gSl7zHe5NksK1WwW7bZ3um	t	\N	2026-01-22 06:27:49.268015	2026-01-22 06:27:49.268015	contribuable
7	NDONG	Brigitte	brigitte.ndong@email.ga	+241062000002	$2b$12$FLES7TYRAuBky2h.k5ppluAIt8nat28gSl7zHe5NksK1WwW7bZ3um	t	\N	2026-01-22 06:27:49.268015	2026-01-22 06:27:49.268015	contribuable
8	OBAME	David	david.obame@email.ga	+241062000003	$2b$12$FLES7TYRAuBky2h.k5ppluAIt8nat28gSl7zHe5NksK1WwW7bZ3um	t	\N	2026-01-22 06:27:49.268015	2026-01-22 06:27:49.268015	contribuable
9	MVE	Estelle	estelle.mve@email.ga	+241062000004	$2b$12$FLES7TYRAuBky2h.k5ppluAIt8nat28gSl7zHe5NksK1WwW7bZ3um	t	\N	2026-01-22 06:27:49.268015	2026-01-22 06:27:49.268015	contribuable
10	MOUSSAVOU	François	francois.moussavou@email.ga	+241062000005	$2b$12$FLES7TYRAuBky2h.k5ppluAIt8nat28gSl7zHe5NksK1WwW7bZ3um	t	\N	2026-01-22 06:27:49.268015	2026-01-22 06:27:49.268015	contribuable
\.


--
-- Data for Name: ville; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ville (id, nom, code, description, pays, actif, created_at, updated_at) FROM stdin;
6	Port-Gentil	PG	Ville économique du Gabon	Gabon	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013
\.


--
-- Data for Name: zone; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.zone (id, nom, code, description, actif, created_at, updated_at) FROM stdin;
61	Centre-Ville	centre	Quartier central	t	2026-01-22 09:39:49.153098	2026-01-22 09:39:49.153098
62	Akanda	akanda	Zone résidentielle	t	2026-01-22 09:39:49.153098	2026-01-22 09:39:49.153098
63	Okoume	okoume	Zone commerciale	t	2026-01-22 09:39:49.153098	2026-01-22 09:39:49.153098
64	Owendo	owendo	Zone industrielle	t	2026-01-22 09:39:49.153098	2026-01-22 09:39:49.153098
65	Sotega	sotega	Zone périphérique	t	2026-01-22 09:39:49.153098	2026-01-22 09:39:49.153098
81	Port-Gentil	PG	Ville pétrolière de Port-Gentil	t	2026-01-24 10:17:34.341157	2026-01-24 10:17:34.341157
84	Libreville	ZON-LBV	Zone de Libreville - Capitale du Gabon	t	2026-01-24 12:03:59.188844	2026-01-24 12:03:59.188844
51	Centre-ville	PG-Z001	Zone centrale de Port-Gentil	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013
52	Zone Industrielle	PG-Z002	Zone industrielle et portuaire	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013
53	Aéroport	PG-Z003	Zone de laéroport	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013
54	Rond-point Shell	PG-Z004	Zone du rond-point Shell	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013
55	Cap Lope	PG-Z005	Zone de Cap Lopez	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013
56	Ibeka	PG-Z006	Quartier Ibeka	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013
57	tchengue	PG-Z007	Quartier Nzeng-Ayong	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013
58	Louis	PG-Z008	Quartier Louis	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013
59	Bord de Mer	PG-Z009	Zone du bord de mer	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013
60	Zone Résidentielle	PG-Z010	Zone résidentielle	t	2026-01-22 06:58:15.820013	2026-01-22 06:58:15.820013
\.


--
-- Data for Name: zone_geographique; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.zone_geographique (id, nom, type_zone, code, geometry, properties, quartier_id, geom, actif, created_at, updated_at) FROM stdin;
\.


--
-- Name: affectation_taxe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.affectation_taxe_id_seq', 12, true);


--
-- Name: appareil_collecteur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.appareil_collecteur_id_seq', 1, false);


--
-- Name: arrondissement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.arrondissement_id_seq', 1, false);


--
-- Name: caisse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.caisse_id_seq', 1, false);


--
-- Name: collecteur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.collecteur_id_seq', 10, true);


--
-- Name: collecteur_zone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.collecteur_zone_id_seq', 1, false);


--
-- Name: commune_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.commune_id_seq', 1, false);


--
-- Name: contribuable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.contribuable_id_seq', 64, true);


--
-- Name: coupure_caisse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.coupure_caisse_id_seq', 1, false);


--
-- Name: demande_citoyen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.demande_citoyen_id_seq', 36, true);


--
-- Name: dossier_impaye_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dossier_impaye_id_seq', 5, true);


--
-- Name: info_collecte_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.info_collecte_id_seq', 36, true);


--
-- Name: info_taxation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.info_taxation_id_seq', 1519, true);


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.notification_id_seq', 1, false);


--
-- Name: operation_caisse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.operation_caisse_id_seq', 1, false);


--
-- Name: quartier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.quartier_id_seq', 59, true);


--
-- Name: relance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.relance_id_seq', 5, true);


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.role_id_seq', 1, false);


--
-- Name: secteur_activite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.secteur_activite_id_seq', 1, false);


--
-- Name: service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.service_id_seq', 45, true);


--
-- Name: taxe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.taxe_id_seq', 24, true);


--
-- Name: type_contribuable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.type_contribuable_id_seq', 18, true);


--
-- Name: type_taxe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.type_taxe_id_seq', 35, true);


--
-- Name: utilisateur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.utilisateur_id_seq', 18, true);


--
-- Name: ville_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ville_id_seq', 12, true);


--
-- Name: zone_geographique_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.zone_geographique_id_seq', 1, false);


--
-- Name: zone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.zone_id_seq', 84, true);


--
-- Name: affectation_taxe affectation_taxe_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.affectation_taxe
    ADD CONSTRAINT affectation_taxe_pkey PRIMARY KEY (id);


--
-- Name: appareil_collecteur appareil_collecteur_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appareil_collecteur
    ADD CONSTRAINT appareil_collecteur_pkey PRIMARY KEY (id);


--
-- Name: arrondissement arrondissement_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.arrondissement
    ADD CONSTRAINT arrondissement_code_key UNIQUE (code);


--
-- Name: arrondissement arrondissement_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.arrondissement
    ADD CONSTRAINT arrondissement_pkey PRIMARY KEY (id);


--
-- Name: caisse caisse_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caisse
    ADD CONSTRAINT caisse_pkey PRIMARY KEY (id);


--
-- Name: collecteur collecteur_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collecteur
    ADD CONSTRAINT collecteur_pkey PRIMARY KEY (id);


--
-- Name: collecteur collecteur_telephone_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collecteur
    ADD CONSTRAINT collecteur_telephone_key UNIQUE (telephone);


--
-- Name: collecteur_zone collecteur_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collecteur_zone
    ADD CONSTRAINT collecteur_zone_pkey PRIMARY KEY (id);


--
-- Name: commune commune_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commune
    ADD CONSTRAINT commune_code_key UNIQUE (code);


--
-- Name: commune commune_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commune
    ADD CONSTRAINT commune_pkey PRIMARY KEY (id);


--
-- Name: contribuable contribuable_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contribuable
    ADD CONSTRAINT contribuable_pkey PRIMARY KEY (id);


--
-- Name: coupure_caisse coupure_caisse_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupure_caisse
    ADD CONSTRAINT coupure_caisse_pkey PRIMARY KEY (id);


--
-- Name: demande_citoyen demande_citoyen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demande_citoyen
    ADD CONSTRAINT demande_citoyen_pkey PRIMARY KEY (id);


--
-- Name: dossier_impaye dossier_impaye_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dossier_impaye
    ADD CONSTRAINT dossier_impaye_pkey PRIMARY KEY (id);


--
-- Name: info_collecte info_collecte_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_collecte
    ADD CONSTRAINT info_collecte_pkey PRIMARY KEY (id);


--
-- Name: info_taxation info_taxation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_taxation
    ADD CONSTRAINT info_taxation_pkey PRIMARY KEY (id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: operation_caisse operation_caisse_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operation_caisse
    ADD CONSTRAINT operation_caisse_pkey PRIMARY KEY (id);


--
-- Name: quartier quartier_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quartier
    ADD CONSTRAINT quartier_code_key UNIQUE (code);


--
-- Name: quartier quartier_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quartier
    ADD CONSTRAINT quartier_pkey PRIMARY KEY (id);


--
-- Name: relance relance_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relance
    ADD CONSTRAINT relance_pkey PRIMARY KEY (id);


--
-- Name: role role_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_code_key UNIQUE (code);


--
-- Name: role role_nom_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_nom_key UNIQUE (nom);


--
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- Name: secteur_activite secteur_activite_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.secteur_activite
    ADD CONSTRAINT secteur_activite_code_key UNIQUE (code);


--
-- Name: secteur_activite secteur_activite_nom_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.secteur_activite
    ADD CONSTRAINT secteur_activite_nom_key UNIQUE (nom);


--
-- Name: secteur_activite secteur_activite_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.secteur_activite
    ADD CONSTRAINT secteur_activite_pkey PRIMARY KEY (id);


--
-- Name: service service_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service
    ADD CONSTRAINT service_code_key UNIQUE (code);


--
-- Name: service service_nom_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service
    ADD CONSTRAINT service_nom_key UNIQUE (nom);


--
-- Name: service service_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- Name: taxe taxe_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taxe
    ADD CONSTRAINT taxe_pkey PRIMARY KEY (id);


--
-- Name: type_contribuable type_contribuable_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.type_contribuable
    ADD CONSTRAINT type_contribuable_code_key UNIQUE (code);


--
-- Name: type_contribuable type_contribuable_nom_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.type_contribuable
    ADD CONSTRAINT type_contribuable_nom_key UNIQUE (nom);


--
-- Name: type_contribuable type_contribuable_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.type_contribuable
    ADD CONSTRAINT type_contribuable_pkey PRIMARY KEY (id);


--
-- Name: type_taxe type_taxe_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.type_taxe
    ADD CONSTRAINT type_taxe_code_key UNIQUE (code);


--
-- Name: type_taxe type_taxe_nom_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.type_taxe
    ADD CONSTRAINT type_taxe_nom_key UNIQUE (nom);


--
-- Name: type_taxe type_taxe_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.type_taxe
    ADD CONSTRAINT type_taxe_pkey PRIMARY KEY (id);


--
-- Name: info_taxation unique_taxation_periode; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_taxation
    ADD CONSTRAINT unique_taxation_periode UNIQUE (contribuable_id, taxe_id, annee, mois);


--
-- Name: coupure_caisse uq_coupure_valeur_devise_type; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupure_caisse
    ADD CONSTRAINT uq_coupure_valeur_devise_type UNIQUE (valeur, devise, type_coupure);


--
-- Name: utilisateur utilisateur_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.utilisateur
    ADD CONSTRAINT utilisateur_pkey PRIMARY KEY (id);


--
-- Name: utilisateur utilisateur_telephone_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.utilisateur
    ADD CONSTRAINT utilisateur_telephone_key UNIQUE (telephone);


--
-- Name: ville ville_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ville
    ADD CONSTRAINT ville_code_key UNIQUE (code);


--
-- Name: ville ville_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ville
    ADD CONSTRAINT ville_pkey PRIMARY KEY (id);


--
-- Name: zone zone_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zone
    ADD CONSTRAINT zone_code_key UNIQUE (code);


--
-- Name: zone_geographique zone_geographique_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zone_geographique
    ADD CONSTRAINT zone_geographique_pkey PRIMARY KEY (id);


--
-- Name: zone zone_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zone
    ADD CONSTRAINT zone_pkey PRIMARY KEY (id);


--
-- Name: idx_collecte_statut; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_collecte_statut ON public.info_collecte USING btree (statut);


--
-- Name: idx_collecte_taxation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_collecte_taxation ON public.info_collecte USING btree (info_taxation_id);


--
-- Name: idx_collecteur_geom; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_collecteur_geom ON public.collecteur USING gist (geom);


--
-- Name: idx_contribuable_geom; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_contribuable_geom ON public.contribuable USING gist (geom);


--
-- Name: idx_info_taxation_contribuable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_info_taxation_contribuable ON public.info_taxation USING btree (contribuable_id);


--
-- Name: idx_info_taxation_echeance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_info_taxation_echeance ON public.info_taxation USING btree (date_echeance);


--
-- Name: idx_info_taxation_periode; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_info_taxation_periode ON public.info_taxation USING btree (annee, mois);


--
-- Name: idx_info_taxation_statut; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_info_taxation_statut ON public.info_taxation USING btree (statut);


--
-- Name: idx_info_taxation_taxe; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_info_taxation_taxe ON public.info_taxation USING btree (taxe_id);


--
-- Name: idx_quartier_geom; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quartier_geom ON public.quartier USING gist (geom);


--
-- Name: idx_zone_geographique_geom; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_zone_geographique_geom ON public.zone_geographique USING gist (geom);


--
-- Name: ix_affectation_taxe_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_affectation_taxe_id ON public.affectation_taxe USING btree (id);


--
-- Name: ix_appareil_collecteur_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_appareil_collecteur_id ON public.appareil_collecteur USING btree (id);


--
-- Name: ix_arrondissement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_arrondissement_id ON public.arrondissement USING btree (id);


--
-- Name: ix_caisse_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_caisse_code ON public.caisse USING btree (code);


--
-- Name: ix_caisse_collecteur_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_caisse_collecteur_id ON public.caisse USING btree (collecteur_id);


--
-- Name: ix_caisse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_caisse_id ON public.caisse USING btree (id);


--
-- Name: ix_collecteur_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_collecteur_email ON public.collecteur USING btree (email);


--
-- Name: ix_collecteur_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_collecteur_id ON public.collecteur USING btree (id);


--
-- Name: ix_collecteur_matricule; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_collecteur_matricule ON public.collecteur USING btree (matricule);


--
-- Name: ix_collecteur_zone_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_collecteur_zone_id ON public.collecteur_zone USING btree (id);


--
-- Name: ix_commune_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_commune_id ON public.commune USING btree (id);


--
-- Name: ix_contribuable_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_contribuable_email ON public.contribuable USING btree (email);


--
-- Name: ix_contribuable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_contribuable_id ON public.contribuable USING btree (id);


--
-- Name: ix_contribuable_numero_identification; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_contribuable_numero_identification ON public.contribuable USING btree (numero_identification);


--
-- Name: ix_contribuable_qr_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_contribuable_qr_code ON public.contribuable USING btree (qr_code);


--
-- Name: ix_contribuable_telephone; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_contribuable_telephone ON public.contribuable USING btree (telephone);


--
-- Name: ix_coupure_caisse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_coupure_caisse_id ON public.coupure_caisse USING btree (id);


--
-- Name: ix_demande_citoyen_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_demande_citoyen_id ON public.demande_citoyen USING btree (id);


--
-- Name: ix_dossier_impaye_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_dossier_impaye_id ON public.dossier_impaye USING btree (id);


--
-- Name: ix_info_collecte_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_info_collecte_id ON public.info_collecte USING btree (id);


--
-- Name: ix_info_collecte_reference; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_info_collecte_reference ON public.info_collecte USING btree (reference);


--
-- Name: ix_notification_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_notification_id ON public.notification USING btree (id);


--
-- Name: ix_operation_caisse_caisse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_operation_caisse_caisse_id ON public.operation_caisse USING btree (caisse_id);


--
-- Name: ix_operation_caisse_collecteur_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_operation_caisse_collecteur_id ON public.operation_caisse USING btree (collecteur_id);


--
-- Name: ix_operation_caisse_date_operation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_operation_caisse_date_operation ON public.operation_caisse USING btree (date_operation);


--
-- Name: ix_operation_caisse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_operation_caisse_id ON public.operation_caisse USING btree (id);


--
-- Name: ix_operation_caisse_reference; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_operation_caisse_reference ON public.operation_caisse USING btree (reference);


--
-- Name: ix_quartier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_quartier_id ON public.quartier USING btree (id);


--
-- Name: ix_quartier_osm_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_quartier_osm_id ON public.quartier USING btree (osm_id);


--
-- Name: ix_relance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_relance_id ON public.relance USING btree (id);


--
-- Name: ix_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_role_id ON public.role USING btree (id);


--
-- Name: ix_secteur_activite_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_secteur_activite_id ON public.secteur_activite USING btree (id);


--
-- Name: ix_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_service_id ON public.service USING btree (id);


--
-- Name: ix_taxe_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_taxe_code ON public.taxe USING btree (code);


--
-- Name: ix_taxe_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_taxe_id ON public.taxe USING btree (id);


--
-- Name: ix_type_contribuable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_type_contribuable_id ON public.type_contribuable USING btree (id);


--
-- Name: ix_type_taxe_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_type_taxe_id ON public.type_taxe USING btree (id);


--
-- Name: ix_utilisateur_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_utilisateur_email ON public.utilisateur USING btree (email);


--
-- Name: ix_utilisateur_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_utilisateur_id ON public.utilisateur USING btree (id);


--
-- Name: ix_ville_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_ville_id ON public.ville USING btree (id);


--
-- Name: ix_zone_geographique_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_zone_geographique_code ON public.zone_geographique USING btree (code);


--
-- Name: ix_zone_geographique_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_zone_geographique_id ON public.zone_geographique USING btree (id);


--
-- Name: ix_zone_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_zone_id ON public.zone USING btree (id);


--
-- Name: info_taxation trigger_calculer_periode_taxation; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_calculer_periode_taxation BEFORE INSERT OR UPDATE ON public.info_taxation FOR EACH ROW EXECUTE FUNCTION public.calculer_prochaine_periode();


--
-- Name: info_collecte trigger_update_statut_taxation; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_statut_taxation AFTER INSERT OR UPDATE ON public.info_collecte FOR EACH ROW EXECUTE FUNCTION public.mettre_a_jour_statut_taxation();


--
-- Name: affectation_taxe affectation_taxe_contribuable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.affectation_taxe
    ADD CONSTRAINT affectation_taxe_contribuable_id_fkey FOREIGN KEY (contribuable_id) REFERENCES public.contribuable(id);


--
-- Name: affectation_taxe affectation_taxe_taxe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.affectation_taxe
    ADD CONSTRAINT affectation_taxe_taxe_id_fkey FOREIGN KEY (taxe_id) REFERENCES public.taxe(id);


--
-- Name: appareil_collecteur appareil_collecteur_collecteur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appareil_collecteur
    ADD CONSTRAINT appareil_collecteur_collecteur_id_fkey FOREIGN KEY (collecteur_id) REFERENCES public.collecteur(id) ON DELETE CASCADE;


--
-- Name: arrondissement arrondissement_commune_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.arrondissement
    ADD CONSTRAINT arrondissement_commune_id_fkey FOREIGN KEY (commune_id) REFERENCES public.commune(id);


--
-- Name: caisse caisse_collecteur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caisse
    ADD CONSTRAINT caisse_collecteur_id_fkey FOREIGN KEY (collecteur_id) REFERENCES public.collecteur(id);


--
-- Name: collecteur_zone collecteur_zone_collecteur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collecteur_zone
    ADD CONSTRAINT collecteur_zone_collecteur_id_fkey FOREIGN KEY (collecteur_id) REFERENCES public.collecteur(id) ON DELETE CASCADE;


--
-- Name: collecteur collecteur_zone_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collecteur
    ADD CONSTRAINT collecteur_zone_id_fkey FOREIGN KEY (zone_id) REFERENCES public.zone(id);


--
-- Name: commune commune_ville_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commune
    ADD CONSTRAINT commune_ville_id_fkey FOREIGN KEY (ville_id) REFERENCES public.ville(id);


--
-- Name: contribuable contribuable_collecteur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contribuable
    ADD CONSTRAINT contribuable_collecteur_id_fkey FOREIGN KEY (collecteur_id) REFERENCES public.collecteur(id);


--
-- Name: contribuable contribuable_quartier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contribuable
    ADD CONSTRAINT contribuable_quartier_id_fkey FOREIGN KEY (quartier_id) REFERENCES public.quartier(id);


--
-- Name: contribuable contribuable_type_contribuable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contribuable
    ADD CONSTRAINT contribuable_type_contribuable_id_fkey FOREIGN KEY (type_contribuable_id) REFERENCES public.type_contribuable(id);


--
-- Name: demande_citoyen demande_citoyen_contribuable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demande_citoyen
    ADD CONSTRAINT demande_citoyen_contribuable_id_fkey FOREIGN KEY (contribuable_id) REFERENCES public.contribuable(id) ON DELETE CASCADE;


--
-- Name: demande_citoyen demande_citoyen_traite_par_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demande_citoyen
    ADD CONSTRAINT demande_citoyen_traite_par_id_fkey FOREIGN KEY (traite_par_id) REFERENCES public.utilisateur(id) ON DELETE SET NULL;


--
-- Name: dossier_impaye dossier_impaye_affectation_taxe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dossier_impaye
    ADD CONSTRAINT dossier_impaye_affectation_taxe_id_fkey FOREIGN KEY (affectation_taxe_id) REFERENCES public.affectation_taxe(id);


--
-- Name: dossier_impaye dossier_impaye_assigne_a_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dossier_impaye
    ADD CONSTRAINT dossier_impaye_assigne_a_fkey FOREIGN KEY (assigne_a) REFERENCES public.collecteur(id);


--
-- Name: dossier_impaye dossier_impaye_contribuable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dossier_impaye
    ADD CONSTRAINT dossier_impaye_contribuable_id_fkey FOREIGN KEY (contribuable_id) REFERENCES public.contribuable(id);


--
-- Name: info_collecte info_collecte_collecteur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_collecte
    ADD CONSTRAINT info_collecte_collecteur_id_fkey FOREIGN KEY (collecteur_id) REFERENCES public.collecteur(id);


--
-- Name: info_collecte info_collecte_contribuable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_collecte
    ADD CONSTRAINT info_collecte_contribuable_id_fkey FOREIGN KEY (contribuable_id) REFERENCES public.contribuable(id);


--
-- Name: info_collecte info_collecte_info_taxation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_collecte
    ADD CONSTRAINT info_collecte_info_taxation_id_fkey FOREIGN KEY (info_taxation_id) REFERENCES public.info_taxation(id);


--
-- Name: info_collecte info_collecte_taxe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_collecte
    ADD CONSTRAINT info_collecte_taxe_id_fkey FOREIGN KEY (taxe_id) REFERENCES public.taxe(id);


--
-- Name: info_taxation info_taxation_contribuable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_taxation
    ADD CONSTRAINT info_taxation_contribuable_id_fkey FOREIGN KEY (contribuable_id) REFERENCES public.contribuable(id) ON DELETE CASCADE;


--
-- Name: info_taxation info_taxation_taxe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_taxation
    ADD CONSTRAINT info_taxation_taxe_id_fkey FOREIGN KEY (taxe_id) REFERENCES public.taxe(id) ON DELETE CASCADE;


--
-- Name: notification notification_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.utilisateur(id) ON DELETE CASCADE;


--
-- Name: operation_caisse operation_caisse_caisse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operation_caisse
    ADD CONSTRAINT operation_caisse_caisse_id_fkey FOREIGN KEY (caisse_id) REFERENCES public.caisse(id);


--
-- Name: operation_caisse operation_caisse_collecte_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operation_caisse
    ADD CONSTRAINT operation_caisse_collecte_id_fkey FOREIGN KEY (collecte_id) REFERENCES public.info_collecte(id);


--
-- Name: operation_caisse operation_caisse_collecteur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operation_caisse
    ADD CONSTRAINT operation_caisse_collecteur_id_fkey FOREIGN KEY (collecteur_id) REFERENCES public.collecteur(id);


--
-- Name: quartier quartier_zone_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quartier
    ADD CONSTRAINT quartier_zone_id_fkey FOREIGN KEY (zone_id) REFERENCES public.zone(id);


--
-- Name: relance relance_affectation_taxe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relance
    ADD CONSTRAINT relance_affectation_taxe_id_fkey FOREIGN KEY (affectation_taxe_id) REFERENCES public.affectation_taxe(id);


--
-- Name: relance relance_contribuable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relance
    ADD CONSTRAINT relance_contribuable_id_fkey FOREIGN KEY (contribuable_id) REFERENCES public.contribuable(id);


--
-- Name: relance relance_utilisateur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relance
    ADD CONSTRAINT relance_utilisateur_id_fkey FOREIGN KEY (utilisateur_id) REFERENCES public.utilisateur(id);


--
-- Name: taxe taxe_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taxe
    ADD CONSTRAINT taxe_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.service(id);


--
-- Name: taxe taxe_type_taxe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taxe
    ADD CONSTRAINT taxe_type_taxe_id_fkey FOREIGN KEY (type_taxe_id) REFERENCES public.type_taxe(id);


--
-- Name: zone_geographique zone_geographique_quartier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zone_geographique
    ADD CONSTRAINT zone_geographique_quartier_id_fkey FOREIGN KEY (quartier_id) REFERENCES public.quartier(id);


--
-- PostgreSQL database dump complete
--

\unrestrict MW35KbbMDZUK4eIA2buMFEixYQzmGh9YraSaFtQPgTlMgxRchWnbA2IyA3exMpa

