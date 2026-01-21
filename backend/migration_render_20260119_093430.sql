--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

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
-- Data for Name: zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.zone VALUES (303, 'Centre-ville', 'ZONE-001', 'Zone centrale de Libreville', true, '2025-11-20 21:29:19.959435', '2025-11-20 21:29:19.959435');
INSERT INTO public.zone VALUES (304, 'Akanda', 'ZONE-002', 'Zone Akanda', true, '2025-11-20 21:29:19.959435', '2025-11-20 21:29:19.959435');
INSERT INTO public.zone VALUES (305, 'Ntoum', 'ZONE-003', 'Zone Ntoum', true, '2025-11-20 21:29:19.959435', '2025-11-20 21:29:19.959435');
INSERT INTO public.zone VALUES (306, 'Owendo', 'ZONE-004', 'Zone portuaire d''Owendo', true, '2025-11-20 21:29:19.959435', '2025-11-20 21:29:19.959435');
INSERT INTO public.zone VALUES (307, 'Port-Gentil', 'ZONE-005', 'Zone Port-Gentil', true, '2025-11-20 21:29:19.959435', '2025-11-20 21:29:19.959435');
INSERT INTO public.zone VALUES (308, 'Franceville', 'ZONE-006', 'Zone Franceville', true, '2025-11-20 21:29:19.959435', '2025-11-20 21:29:19.959435');
INSERT INTO public.zone VALUES (309, 'Zone 7', 'ZONE-007', 'Zone géographique 7', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (310, 'Zone 8', 'ZONE-008', 'Zone géographique 8', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (311, 'Zone 9', 'ZONE-009', 'Zone géographique 9', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (312, 'Zone 10', 'ZONE-010', 'Zone géographique 10', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (313, 'Zone 11', 'ZONE-011', 'Zone géographique 11', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (314, 'Zone 12', 'ZONE-012', 'Zone géographique 12', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (315, 'Zone 13', 'ZONE-013', 'Zone géographique 13', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (316, 'Zone 14', 'ZONE-014', 'Zone géographique 14', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (317, 'Zone 15', 'ZONE-015', 'Zone géographique 15', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (318, 'Zone 16', 'ZONE-016', 'Zone géographique 16', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (319, 'Zone 17', 'ZONE-017', 'Zone géographique 17', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (320, 'Zone 18', 'ZONE-018', 'Zone géographique 18', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (321, 'Zone 19', 'ZONE-019', 'Zone géographique 19', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (322, 'Zone 20', 'ZONE-020', 'Zone géographique 20', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (323, 'Zone 21', 'ZONE-021', 'Zone géographique 21', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (324, 'Zone 22', 'ZONE-022', 'Zone géographique 22', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (325, 'Zone 23', 'ZONE-023', 'Zone géographique 23', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (326, 'Zone 24', 'ZONE-024', 'Zone géographique 24', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (327, 'Zone 25', 'ZONE-025', 'Zone géographique 25', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (328, 'Zone 26', 'ZONE-026', 'Zone géographique 26', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (329, 'Zone 27', 'ZONE-027', 'Zone géographique 27', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (330, 'Zone 28', 'ZONE-028', 'Zone géographique 28', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (331, 'Zone 29', 'ZONE-029', 'Zone géographique 29', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (332, 'Zone 30', 'ZONE-030', 'Zone géographique 30', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (333, 'Zone 31', 'ZONE-031', 'Zone géographique 31', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (334, 'Zone 32', 'ZONE-032', 'Zone géographique 32', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (335, 'Zone 33', 'ZONE-033', 'Zone géographique 33', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (336, 'Zone 34', 'ZONE-034', 'Zone géographique 34', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (337, 'Zone 35', 'ZONE-035', 'Zone géographique 35', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (338, 'Zone 36', 'ZONE-036', 'Zone géographique 36', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (339, 'Zone 37', 'ZONE-037', 'Zone géographique 37', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (340, 'Zone 38', 'ZONE-038', 'Zone géographique 38', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (341, 'Zone 39', 'ZONE-039', 'Zone géographique 39', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (342, 'Zone 40', 'ZONE-040', 'Zone géographique 40', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (343, 'Zone 41', 'ZONE-041', 'Zone géographique 41', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (344, 'Zone 42', 'ZONE-042', 'Zone géographique 42', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (345, 'Zone 43', 'ZONE-043', 'Zone géographique 43', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (346, 'Zone 44', 'ZONE-044', 'Zone géographique 44', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (347, 'Zone 45', 'ZONE-045', 'Zone géographique 45', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (348, 'Zone 46', 'ZONE-046', 'Zone géographique 46', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (349, 'Zone 47', 'ZONE-047', 'Zone géographique 47', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (350, 'Zone 48', 'ZONE-048', 'Zone géographique 48', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (351, 'Zone 49', 'ZONE-049', 'Zone géographique 49', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (352, 'Zone 50', 'ZONE-050', 'Zone géographique 50', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (353, 'Zone 51', 'ZONE-051', 'Zone géographique 51', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (354, 'Zone 52', 'ZONE-052', 'Zone géographique 52', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (355, 'Zone 53', 'ZONE-053', 'Zone géographique 53', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (356, 'Zone 54', 'ZONE-054', 'Zone géographique 54', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (357, 'Zone 55', 'ZONE-055', 'Zone géographique 55', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (358, 'Zone 56', 'ZONE-056', 'Zone géographique 56', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (359, 'Zone 57', 'ZONE-057', 'Zone géographique 57', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (360, 'Zone 58', 'ZONE-058', 'Zone géographique 58', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (361, 'Zone 59', 'ZONE-059', 'Zone géographique 59', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (362, 'Zone 60', 'ZONE-060', 'Zone géographique 60', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (363, 'Zone 61', 'ZONE-061', 'Zone géographique 61', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (364, 'Zone 62', 'ZONE-062', 'Zone géographique 62', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (365, 'Zone 63', 'ZONE-063', 'Zone géographique 63', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (366, 'Zone 64', 'ZONE-064', 'Zone géographique 64', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (367, 'Zone 65', 'ZONE-065', 'Zone géographique 65', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (368, 'Zone 66', 'ZONE-066', 'Zone géographique 66', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (369, 'Zone 67', 'ZONE-067', 'Zone géographique 67', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (370, 'Zone 68', 'ZONE-068', 'Zone géographique 68', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (371, 'Zone 69', 'ZONE-069', 'Zone géographique 69', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (372, 'Zone 70', 'ZONE-070', 'Zone géographique 70', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (373, 'Zone 71', 'ZONE-071', 'Zone géographique 71', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (374, 'Zone 72', 'ZONE-072', 'Zone géographique 72', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (375, 'Zone 73', 'ZONE-073', 'Zone géographique 73', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (376, 'Zone 74', 'ZONE-074', 'Zone géographique 74', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (377, 'Zone 75', 'ZONE-075', 'Zone géographique 75', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (378, 'Zone 76', 'ZONE-076', 'Zone géographique 76', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (379, 'Zone 77', 'ZONE-077', 'Zone géographique 77', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (380, 'Zone 78', 'ZONE-078', 'Zone géographique 78', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (381, 'Zone 79', 'ZONE-079', 'Zone géographique 79', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (382, 'Zone 80', 'ZONE-080', 'Zone géographique 80', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (383, 'Zone 81', 'ZONE-081', 'Zone géographique 81', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (384, 'Zone 82', 'ZONE-082', 'Zone géographique 82', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (385, 'Zone 83', 'ZONE-083', 'Zone géographique 83', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (386, 'Zone 84', 'ZONE-084', 'Zone géographique 84', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (387, 'Zone 85', 'ZONE-085', 'Zone géographique 85', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (388, 'Zone 86', 'ZONE-086', 'Zone géographique 86', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (389, 'Zone 87', 'ZONE-087', 'Zone géographique 87', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (390, 'Zone 88', 'ZONE-088', 'Zone géographique 88', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (391, 'Zone 89', 'ZONE-089', 'Zone géographique 89', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (392, 'Zone 90', 'ZONE-090', 'Zone géographique 90', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (393, 'Zone 91', 'ZONE-091', 'Zone géographique 91', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (394, 'Zone 92', 'ZONE-092', 'Zone géographique 92', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (395, 'Zone 93', 'ZONE-093', 'Zone géographique 93', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (396, 'Zone 94', 'ZONE-094', 'Zone géographique 94', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (397, 'Zone 95', 'ZONE-095', 'Zone géographique 95', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (398, 'Zone 96', 'ZONE-096', 'Zone géographique 96', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (399, 'Zone 97', 'ZONE-097', 'Zone géographique 97', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (400, 'Zone 98', 'ZONE-098', 'Zone géographique 98', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (401, 'Zone 99', 'ZONE-099', 'Zone géographique 99', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (402, 'Zone 100', 'ZONE-100', 'Zone géographique 100', true, '2025-11-20 21:29:19.962533', '2025-11-20 21:29:19.962533');
INSERT INTO public.zone VALUES (862, 'Zone Neighbourhood', 'neighbourhood', 'Zone importée automatiquement depuis OSM (neighbourhood)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735');
INSERT INTO public.zone VALUES (863, 'Zone Quarter', 'quarter', 'Zone importée automatiquement depuis OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735');
INSERT INTO public.zone VALUES (864, 'Zone Suburb', 'suburb', 'Zone importée automatiquement depuis OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735');


--
-- Data for Name: collecteur; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.collecteur VALUES (351, 'NDONG', 'Marie', 'collecteur1@mairie-libreville.ga', '+241061000001', 'COL-001', 'active', 'connecte', 374, NULL, NULL, '18:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (352, 'OBAME', 'Pierre', 'collecteur2@mairie-libreville.ga', '+241061000002', 'COL-002', 'active', 'deconnecte', 308, NULL, NULL, '19:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (353, 'BONGO', 'Paul', 'collecteur3@mairie-libreville.ga', '+241061000003', 'COL-003', 'active', 'connecte', 368, NULL, NULL, '17:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (354, 'ESSONO', 'Sophie', 'collecteur4@mairie-libreville.ga', '+241061000004', 'COL-004', 'active', 'deconnecte', 314, NULL, NULL, '18:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (355, 'MVE', 'Luc', 'collecteur5@mairie-libreville.ga', '+241061000005', 'COL-005', 'active', 'connecte', 337, NULL, NULL, '19:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (356, 'MINTSA', 'Anne', 'collecteur6@mairie-libreville.ga', '+241061000006', 'COL-006', 'active', 'deconnecte', 347, NULL, NULL, '17:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (357, 'MBOUMBA', 'David', 'collecteur7@mairie-libreville.ga', '+241061000007', 'COL-007', 'active', 'connecte', 324, NULL, NULL, '18:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (358, 'NDONG', 'FranÃ§ois', 'collecteur8@mairie-libreville.ga', '+241061000008', 'COL-008', 'active', 'deconnecte', 322, NULL, NULL, '19:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (359, 'OBAME', 'Catherine', 'collecteur9@mairie-libreville.ga', '+241061000009', 'COL-009', 'active', 'connecte', 348, NULL, NULL, '17:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (360, 'BONGO', 'Michel', 'collecteur10@mairie-libreville.ga', '+241061000010', 'COL-010', 'desactive', 'deconnecte', 334, NULL, NULL, '18:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (361, 'ESSONO', 'Isabelle', 'collecteur11@mairie-libreville.ga', '+241061000011', 'COL-011', 'active', 'connecte', 357, NULL, NULL, '19:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (362, 'MVE', 'AndrÃ©', 'collecteur12@mairie-libreville.ga', '+241061000012', 'COL-012', 'active', 'deconnecte', 305, NULL, NULL, '17:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (363, 'MINTSA', 'Christine', 'collecteur13@mairie-libreville.ga', '+241061000013', 'COL-013', 'active', 'connecte', 384, NULL, NULL, '18:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (364, 'MBOUMBA', 'Jean', 'collecteur14@mairie-libreville.ga', '+241061000014', 'COL-014', 'active', 'deconnecte', 341, NULL, NULL, '19:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (365, 'NDONG', 'Marie', 'collecteur15@mairie-libreville.ga', '+241061000015', 'COL-015', 'active', 'connecte', 398, NULL, NULL, '17:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (366, 'OBAME', 'Pierre', 'collecteur16@mairie-libreville.ga', '+241061000016', 'COL-016', 'active', 'deconnecte', 340, NULL, NULL, '18:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (367, 'BONGO', 'Paul', 'collecteur17@mairie-libreville.ga', '+241061000017', 'COL-017', 'active', 'connecte', 306, NULL, NULL, '19:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (368, 'ESSONO', 'Sophie', 'collecteur18@mairie-libreville.ga', '+241061000018', 'COL-018', 'active', 'deconnecte', 374, NULL, NULL, '17:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (369, 'MVE', 'Luc', 'collecteur19@mairie-libreville.ga', '+241061000019', 'COL-019', 'active', 'connecte', 317, NULL, NULL, '18:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (370, 'MINTSA', 'Anne', 'collecteur20@mairie-libreville.ga', '+241061000020', 'COL-020', 'desactive', 'deconnecte', 385, NULL, NULL, '19:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (371, 'MBOUMBA', 'David', 'collecteur21@mairie-libreville.ga', '+241061000021', 'COL-021', 'active', 'connecte', 311, NULL, NULL, '17:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (372, 'NDONG', 'FranÃ§ois', 'collecteur22@mairie-libreville.ga', '+241061000022', 'COL-022', 'active', 'deconnecte', 375, NULL, NULL, '18:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (373, 'OBAME', 'Catherine', 'collecteur23@mairie-libreville.ga', '+241061000023', 'COL-023', 'active', 'connecte', 325, NULL, NULL, '19:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (374, 'BONGO', 'Michel', 'collecteur24@mairie-libreville.ga', '+241061000024', 'COL-024', 'active', 'deconnecte', 386, NULL, NULL, '17:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (375, 'ESSONO', 'Isabelle', 'collecteur25@mairie-libreville.ga', '+241061000025', 'COL-025', 'active', 'connecte', 310, NULL, NULL, '18:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (376, 'MVE', 'AndrÃ©', 'collecteur26@mairie-libreville.ga', '+241061000026', 'COL-026', 'active', 'deconnecte', 397, NULL, NULL, '19:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (377, 'MINTSA', 'Christine', 'collecteur27@mairie-libreville.ga', '+241061000027', 'COL-027', 'active', 'connecte', 308, NULL, NULL, '17:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (378, 'MBOUMBA', 'Jean', 'collecteur28@mairie-libreville.ga', '+241061000028', 'COL-028', 'active', 'deconnecte', 379, NULL, NULL, '18:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (379, 'NDONG', 'Marie', 'collecteur29@mairie-libreville.ga', '+241061000029', 'COL-029', 'active', 'connecte', 383, NULL, NULL, '19:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (380, 'OBAME', 'Pierre', 'collecteur30@mairie-libreville.ga', '+241061000030', 'COL-030', 'desactive', 'deconnecte', 308, NULL, NULL, '17:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (381, 'BONGO', 'Paul', 'collecteur31@mairie-libreville.ga', '+241061000031', 'COL-031', 'active', 'connecte', 356, NULL, NULL, '18:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (382, 'ESSONO', 'Sophie', 'collecteur32@mairie-libreville.ga', '+241061000032', 'COL-032', 'active', 'deconnecte', 320, NULL, NULL, '19:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (383, 'MVE', 'Luc', 'collecteur33@mairie-libreville.ga', '+241061000033', 'COL-033', 'active', 'connecte', 371, NULL, NULL, '17:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (384, 'MINTSA', 'Anne', 'collecteur34@mairie-libreville.ga', '+241061000034', 'COL-034', 'active', 'deconnecte', 310, NULL, NULL, '18:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (385, 'MBOUMBA', 'David', 'collecteur35@mairie-libreville.ga', '+241061000035', 'COL-035', 'active', 'connecte', 383, NULL, NULL, '19:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (386, 'NDONG', 'FranÃ§ois', 'collecteur36@mairie-libreville.ga', '+241061000036', 'COL-036', 'active', 'deconnecte', 402, NULL, NULL, '17:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (387, 'OBAME', 'Catherine', 'collecteur37@mairie-libreville.ga', '+241061000037', 'COL-037', 'active', 'connecte', 317, NULL, NULL, '18:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (388, 'BONGO', 'Michel', 'collecteur38@mairie-libreville.ga', '+241061000038', 'COL-038', 'active', 'deconnecte', 337, NULL, NULL, '19:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (389, 'ESSONO', 'Isabelle', 'collecteur39@mairie-libreville.ga', '+241061000039', 'COL-039', 'active', 'connecte', 340, NULL, NULL, '17:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (390, 'MVE', 'AndrÃ©', 'collecteur40@mairie-libreville.ga', '+241061000040', 'COL-040', 'desactive', 'deconnecte', 365, NULL, NULL, '18:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (391, 'MINTSA', 'Christine', 'collecteur41@mairie-libreville.ga', '+241061000041', 'COL-041', 'active', 'connecte', 368, NULL, NULL, '19:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (392, 'MBOUMBA', 'Jean', 'collecteur42@mairie-libreville.ga', '+241061000042', 'COL-042', 'active', 'deconnecte', 376, NULL, NULL, '17:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (393, 'NDONG', 'Marie', 'collecteur43@mairie-libreville.ga', '+241061000043', 'COL-043', 'active', 'connecte', 352, NULL, NULL, '18:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (394, 'OBAME', 'Pierre', 'collecteur44@mairie-libreville.ga', '+241061000044', 'COL-044', 'active', 'deconnecte', 400, NULL, NULL, '19:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (395, 'BONGO', 'Paul', 'collecteur45@mairie-libreville.ga', '+241061000045', 'COL-045', 'active', 'connecte', 374, NULL, NULL, '17:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (396, 'ESSONO', 'Sophie', 'collecteur46@mairie-libreville.ga', '+241061000046', 'COL-046', 'active', 'deconnecte', 349, NULL, NULL, '18:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (397, 'MVE', 'Luc', 'collecteur47@mairie-libreville.ga', '+241061000047', 'COL-047', 'active', 'connecte', 388, NULL, NULL, '19:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (398, 'MINTSA', 'Anne', 'collecteur48@mairie-libreville.ga', '+241061000048', 'COL-048', 'active', 'deconnecte', 371, NULL, NULL, '17:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (399, 'MBOUMBA', 'David', 'collecteur49@mairie-libreville.ga', '+241061000049', 'COL-049', 'active', 'connecte', 337, NULL, NULL, '18:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);
INSERT INTO public.collecteur VALUES (400, 'NDONG', 'FranÃ§ois', 'collecteur50@mairie-libreville.ga', '+241061000050', 'COL-050', 'desactive', 'deconnecte', 383, NULL, NULL, '19:00', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041', NULL, NULL, NULL);


--
-- Data for Name: quartier; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.quartier VALUES (302, 'Mont-Bouët', 'Q-001', 303, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (303, 'Glass', 'Q-002', 303, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (304, 'Quartier Louis', 'Q-003', 303, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (305, 'Nombakélé', 'Q-004', 303, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (306, 'Akébé', 'Q-005', 303, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (307, 'Oloumi', 'Q-006', 303, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (308, 'Batterie IV', 'Q-007', 303, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (309, 'Derrière la Prison', 'Q-008', 303, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (310, 'Charbonnages', 'Q-009', 303, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (311, 'Lalala', 'Q-010', 303, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (312, 'Cocotiers', 'Q-011', 304, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (313, 'Angondjé', 'Q-012', 304, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (314, 'Melen', 'Q-013', 304, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (315, 'Nkoltang', 'Q-014', 304, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (316, 'Minko', 'Q-015', 304, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (317, 'Ntoum Centre', 'Q-016', 305, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (318, 'Mveng', 'Q-017', 305, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (319, 'Mvouli', 'Q-018', 305, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (320, 'Owendo Centre', 'Q-019', 306, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (321, 'PK8', 'Q-020', 306, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (322, 'PK12', 'Q-021', 306, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (323, 'PK15', 'Q-022', 306, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (324, 'Port-Gentil Centre', 'Q-023', 307, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (325, 'Ivea', 'Q-024', 307, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (326, 'Nzeng-Ayong', 'Q-025', 307, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (327, 'Franceville Centre', 'Q-026', 308, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (328, 'Mounana', 'Q-027', 308, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (329, 'Okondja', 'Q-028', 308, NULL, true, '2025-11-20 21:29:20.082486', '2025-11-20 21:29:20.082486', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (330, 'Quartier 29', 'Q-029', 348, 'Quartier 29 de Zone 46', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (331, 'Quartier 30', 'Q-030', 357, 'Quartier 30 de Zone 55', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (332, 'Quartier 31', 'Q-031', 350, 'Quartier 31 de Zone 48', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (333, 'Quartier 32', 'Q-032', 325, 'Quartier 32 de Zone 23', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (334, 'Quartier 33', 'Q-033', 392, 'Quartier 33 de Zone 90', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (335, 'Quartier 34', 'Q-034', 308, 'Quartier 34 de Franceville', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (336, 'Quartier 35', 'Q-035', 389, 'Quartier 35 de Zone 87', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (337, 'Quartier 36', 'Q-036', 388, 'Quartier 36 de Zone 86', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (338, 'Quartier 37', 'Q-037', 358, 'Quartier 37 de Zone 56', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (339, 'Quartier 38', 'Q-038', 362, 'Quartier 38 de Zone 60', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (340, 'Quartier 39', 'Q-039', 388, 'Quartier 39 de Zone 86', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (341, 'Quartier 40', 'Q-040', 372, 'Quartier 40 de Zone 70', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (342, 'Quartier 41', 'Q-041', 351, 'Quartier 41 de Zone 49', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (343, 'Quartier 42', 'Q-042', 354, 'Quartier 42 de Zone 52', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (344, 'Quartier 43', 'Q-043', 362, 'Quartier 43 de Zone 60', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (345, 'Quartier 44', 'Q-044', 371, 'Quartier 44 de Zone 69', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (346, 'Quartier 45', 'Q-045', 378, 'Quartier 45 de Zone 76', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (347, 'Quartier 46', 'Q-046', 361, 'Quartier 46 de Zone 59', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (348, 'Quartier 47', 'Q-047', 362, 'Quartier 47 de Zone 60', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (349, 'Quartier 48', 'Q-048', 309, 'Quartier 48 de Zone 7', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (350, 'Quartier 49', 'Q-049', 399, 'Quartier 49 de Zone 97', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (351, 'Quartier 50', 'Q-050', 342, 'Quartier 50 de Zone 40', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (352, 'Quartier 51', 'Q-051', 332, 'Quartier 51 de Zone 30', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (353, 'Quartier 52', 'Q-052', 353, 'Quartier 52 de Zone 51', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (354, 'Quartier 53', 'Q-053', 399, 'Quartier 53 de Zone 97', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (355, 'Quartier 54', 'Q-054', 383, 'Quartier 54 de Zone 81', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (356, 'Quartier 55', 'Q-055', 347, 'Quartier 55 de Zone 45', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (357, 'Quartier 56', 'Q-056', 356, 'Quartier 56 de Zone 54', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (358, 'Quartier 57', 'Q-057', 379, 'Quartier 57 de Zone 77', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (359, 'Quartier 58', 'Q-058', 341, 'Quartier 58 de Zone 39', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (360, 'Quartier 59', 'Q-059', 339, 'Quartier 59 de Zone 37', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (361, 'Quartier 60', 'Q-060', 336, 'Quartier 60 de Zone 34', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (362, 'Quartier 61', 'Q-061', 380, 'Quartier 61 de Zone 78', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (363, 'Quartier 62', 'Q-062', 398, 'Quartier 62 de Zone 96', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (364, 'Quartier 63', 'Q-063', 380, 'Quartier 63 de Zone 78', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (365, 'Quartier 64', 'Q-064', 311, 'Quartier 64 de Zone 9', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (366, 'Quartier 65', 'Q-065', 391, 'Quartier 65 de Zone 89', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (367, 'Quartier 66', 'Q-066', 397, 'Quartier 66 de Zone 95', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (368, 'Quartier 67', 'Q-067', 321, 'Quartier 67 de Zone 19', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (369, 'Quartier 68', 'Q-068', 311, 'Quartier 68 de Zone 9', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (370, 'Quartier 69', 'Q-069', 349, 'Quartier 69 de Zone 47', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (371, 'Quartier 70', 'Q-070', 372, 'Quartier 70 de Zone 70', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (372, 'Quartier 71', 'Q-071', 388, 'Quartier 71 de Zone 86', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (373, 'Quartier 72', 'Q-072', 317, 'Quartier 72 de Zone 15', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (374, 'Quartier 73', 'Q-073', 376, 'Quartier 73 de Zone 74', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (375, 'Quartier 74', 'Q-074', 400, 'Quartier 74 de Zone 98', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (376, 'Quartier 75', 'Q-075', 370, 'Quartier 75 de Zone 68', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (377, 'Quartier 76', 'Q-076', 385, 'Quartier 76 de Zone 83', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (378, 'Quartier 77', 'Q-077', 310, 'Quartier 77 de Zone 8', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (379, 'Quartier 78', 'Q-078', 382, 'Quartier 78 de Zone 80', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (380, 'Quartier 79', 'Q-079', 336, 'Quartier 79 de Zone 34', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (381, 'Quartier 80', 'Q-080', 370, 'Quartier 80 de Zone 68', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (382, 'Quartier 81', 'Q-081', 330, 'Quartier 81 de Zone 28', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (383, 'Quartier 82', 'Q-082', 372, 'Quartier 82 de Zone 70', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (384, 'Quartier 83', 'Q-083', 385, 'Quartier 83 de Zone 83', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (385, 'Quartier 84', 'Q-084', 327, 'Quartier 84 de Zone 25', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (386, 'Quartier 85', 'Q-085', 382, 'Quartier 85 de Zone 80', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (387, 'Quartier 86', 'Q-086', 352, 'Quartier 86 de Zone 50', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (388, 'Quartier 87', 'Q-087', 325, 'Quartier 87 de Zone 23', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (389, 'Quartier 88', 'Q-088', 349, 'Quartier 88 de Zone 47', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (390, 'Quartier 89', 'Q-089', 373, 'Quartier 89 de Zone 71', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (391, 'Quartier 90', 'Q-090', 324, 'Quartier 90 de Zone 22', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (392, 'Quartier 91', 'Q-091', 310, 'Quartier 91 de Zone 8', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (393, 'Quartier 92', 'Q-092', 401, 'Quartier 92 de Zone 99', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (394, 'Quartier 93', 'Q-093', 367, 'Quartier 93 de Zone 65', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (395, 'Quartier 94', 'Q-094', 357, 'Quartier 94 de Zone 55', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (396, 'Quartier 95', 'Q-095', 394, 'Quartier 95 de Zone 92', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (397, 'Quartier 96', 'Q-096', 336, 'Quartier 96 de Zone 34', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (398, 'Quartier 97', 'Q-097', 320, 'Quartier 97 de Zone 18', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (399, 'Quartier 98', 'Q-098', 379, 'Quartier 98 de Zone 77', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (400, 'Quartier 99', 'Q-099', 339, 'Quartier 99 de Zone 37', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (401, 'Quartier 100', 'Q-100', 384, 'Quartier 100 de Zone 82', true, '2025-11-20 21:29:20.093978', '2025-11-20 21:29:20.093978', NULL, NULL, NULL, NULL);
INSERT INTO public.quartier VALUES (869, 'Acaé', 'acae', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000E8548DB9C6F222409F7AFF7AE03ED63F', 5115327802, 'suburb', '{"name": "Acaé", "place": "suburb", "official_name": "Ateliers et Chantiers de l''Afrique Équatoriale"}');
INSERT INTO public.quartier VALUES (870, 'Akournam I', 'akournam-i', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000006FB5F3A21B06234036221807978ED53F', 5115327798, 'quarter', '{"name": "Akournam I", "place": "quarter"}');
INSERT INTO public.quartier VALUES (871, 'Akournam II', 'akournam-ii', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000009A5BC6F253052340A87EEF80FC36D63F', 5115327799, 'quarter', '{"name": "Akournam II", "place": "quarter"}');
INSERT INTO public.quartier VALUES (872, 'Akébé Frontière_ Baraka', 'akebe-frontiere-bara', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000007E8CB96B09ED22407555455D10B6D83F', 4218653707, 'suburb', '{"name": "Akébé Frontière_ Baraka", "place": "suburb"}');
INSERT INTO public.quartier VALUES (873, 'Akébé Plaine', 'akebe-plaine', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000318F464FDBEC22402B63E87D8832D93F', 1827771023, 'suburb', '{"name": "Akébé Plaine", "place": "suburb"}');
INSERT INTO public.quartier VALUES (874, 'Akébé Ville', 'akebe-ville', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000005E42AACDA4EA22405AD4CCFF5055D93F', 1827771024, 'suburb', '{"name": "Akébé Ville", "place": "suburb"}');
INSERT INTO public.quartier VALUES (875, 'Akébé-Kinguélé', 'akebe-kinguele', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000004FAE2990D9F12240A0EE4D1DF5A1D93F', 1827771025, 'suburb', '{"name": "Akébé-Kinguélé", "place": "suburb"}');
INSERT INTO public.quartier VALUES (876, 'Akémindjogoni', 'akemindjogoni', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000598638D6C5E12240926E95719D90D93F', 1827907506, 'suburb', '{"name": "Akémindjogoni", "place": "suburb"}');
INSERT INTO public.quartier VALUES (877, 'Alibandeng', 'alibandeng', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E610000091C0D5F0E3DA22401142F6306A2DDD3F', 1827771026, 'suburb', '{"name": "Alibandeng", "place": "suburb"}');
INSERT INTO public.quartier VALUES (878, 'Alénakirie', 'alenakirie', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000004023C78CA60523408103FF00109CD33F', 5115327790, 'quarter', '{"name": "Alénakirie", "place": "quarter"}');
INSERT INTO public.quartier VALUES (879, 'Ambilambani', 'ambilambani', 862, 'Import OSM (neighbourhood)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000958334BE8AEB22402A3D2E05FFB6D83F', 1827907487, 'neighbourhood', '{"name": "Ambilambani", "place": "neighbourhood"}');
INSERT INTO public.quartier VALUES (880, 'Ambowè', 'ambowe', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000002E2B03BD26DE22408733BF9A0384DC3F', 1827771027, 'suburb', '{"name": "Ambowè", "place": "suburb", "source": "survey", "addr:full": "1ère arrondissement de la Commune de Libreville", "description": "Ambowè du nom d’un affluent qui se jette dans la rivière Tsini."}');
INSERT INTO public.quartier VALUES (881, 'Ancienne Sobraga', 'ancienne-sobraga', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000003F2201FE84E622407A466CC19CEADA3F', 1832438130, 'suburb', '{"name": "Ancienne Sobraga", "place": "suburb"}');
INSERT INTO public.quartier VALUES (882, 'Angondjé Village', 'angondje-village', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000007EFD101B2CDC2240ABBAA2EFC95EE03F', 13283449768, 'suburb', '{"name": "Angondjé Village", "place": "suburb"}');
INSERT INTO public.quartier VALUES (883, 'Angondjé', 'angondje', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000268A35012BD42240EE2AFFB517ECE03F', 13283361248, 'suburb', '{"name": "Angondjé", "place": "suburb"}');
INSERT INTO public.quartier VALUES (884, 'Atong Abe', 'atong-abe', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000A63E350301E72240A066ED5B525ADA3F', 1827771028, 'suburb', '{"name": "Atong Abe", "place": "suburb"}');
INSERT INTO public.quartier VALUES (885, 'Atong-Abe', 'atong-abe-2', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000CF7E49CF99E52240A22D420CCF26DA3F', 1827907490, 'suburb', '{"name": "Atong-Abe", "place": "suburb"}');
INSERT INTO public.quartier VALUES (886, 'Atsib-tchoss', 'atsib-tchoss', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000002082058B1EEB22403A0895134864DA3F', 1827771029, 'suburb', '{"name": "Atsib-tchoss", "place": "suburb"}');
INSERT INTO public.quartier VALUES (887, 'Avea', 'avea', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000B2B2220FE9EC2240AB2A8FC93D38DA3F', 4071408095, 'suburb', '{"name": "Avea", "place": "suburb"}');
INSERT INTO public.quartier VALUES (888, 'Avorbam', 'avorbam', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000B96C1915DDC7224000338408DD4AE03F', 13283361249, 'suburb', '{"name": "Avorbam", "place": "suburb"}');
INSERT INTO public.quartier VALUES (889, 'Awendjé', 'awendje', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000002984C42C6AF2224079C663AB70F0D83F', 1827771030, 'suburb', '{"name": "Awendjé", "place": "suburb"}');
INSERT INTO public.quartier VALUES (890, 'Awoungou', 'awoungou', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000DFC4909C4C042340B2CE424CD331D43F', 5115327792, 'quarter', '{"name": "Awoungou", "place": "quarter"}');
INSERT INTO public.quartier VALUES (891, 'Aéroport', 'aeroport', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E610000096044DF0F2D122400C1F11532289DD3F', 13091960621, 'suburb', '{"name": "Aéroport", "place": "suburb"}');
INSERT INTO public.quartier VALUES (892, 'Bambouchine', 'bambouchine', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E610000036EC527EAD0A2340087767EDB60BDC3F', 7023723033, 'suburb', '{"name": "Bambouchine", "place": "suburb"}');
INSERT INTO public.quartier VALUES (893, 'Baraka-Mission', 'baraka-mission', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E610000012610D6146EA2240FA6D3E6480FAD73F', 12980637969, 'suburb', '{"name": "Baraka-Mission", "place": "suburb"}');
INSERT INTO public.quartier VALUES (894, 'Barakounda', 'barakounda', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000A49E4F2ED7F82240B125F5AFF6C1D43F', 5115327795, 'quarter', '{"name": "Barakounda", "place": "quarter"}');
INSERT INTO public.quartier VALUES (896, 'Bassin du PK5', 'bassin-du-pk5', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000474FDBD0DEF222402C1103B8B4F5D93F', 12980637967, 'suburb', '{"name": "Bassin du PK5", "place": "suburb"}');
INSERT INTO public.quartier VALUES (897, 'Batavéa', 'batavea', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E610000003DCE2D011E722405061B6AEE29ED83F', 1827907492, 'suburb', '{"name": "Batavéa", "place": "suburb"}');
INSERT INTO public.quartier VALUES (898, 'Batterie 4', 'batterie-4', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000F4ED13F6A3DB22401736B9CE75D0DA3F', 4218673739, 'suburb', '{"name": "Batterie 4", "place": "suburb", "addr:city": "Libreville"}');
INSERT INTO public.quartier VALUES (899, 'Beau-Séjour', 'beau-sejour', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000DF5916A7B5F82240EEE64E554648D93F', 1827771031, 'suburb', '{"name": "Beau-Séjour", "place": "suburb"}');
INSERT INTO public.quartier VALUES (901, 'Belle-Vue', 'belle-vue', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000D6F95C120CF02240E503A7E3D649D93F', 5115327812, 'suburb', '{"name": "Belle-Vue", "place": "suburb"}');
INSERT INTO public.quartier VALUES (902, 'Bikélé', 'bikele', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000C7A98C35121B2340E3C4573B8A73DA3F', 11195231298, 'suburb', '{"name": "Bikélé", "place": "suburb", "source": "survey"}');
INSERT INTO public.quartier VALUES (903, 'Bizango-Rail', 'bizango-rail', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000DD5B9198A00E23400DB21B6CA02FD93F', 5115327811, 'suburb', '{"name": "Bizango-Rail", "place": "suburb"}');
INSERT INTO public.quartier VALUES (905, 'Campagne', 'campagne', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000EE60C43E01E82240EB419CE2CC0ADA3F', 12980637965, 'suburb', '{"name": "Campagne", "place": "suburb"}');
INSERT INTO public.quartier VALUES (906, 'Cap Esterias', 'cap-esterias', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000006A45E570F7A322405FE4AFDA468DE33F', 7023720525, 'quarter', '{"name": "Cap Esterias", "place": "quarter", "description": "Le Cap Esterias offre les plaisirs de la plage pour ceux qui ne possèdent ni 4x4, ni bateau."}');
INSERT INTO public.quartier VALUES (908, 'Charbonnages', 'charbonnages', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000032FE9DE79E422403C050A0621EADB3F', 12103941215, 'suburb', '{"name": "Charbonnages", "place": "suburb", "source": "survey", "addr:city": "Libreville"}');
INSERT INTO public.quartier VALUES (909, 'Cité Damas', 'cite-damas', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000000173E3CC65F52240D57B2AA73DA5D83F', 1827907494, 'suburb', '{"name": "Cité Damas", "place": "suburb"}');
INSERT INTO public.quartier VALUES (910, 'Cité Mébiame', 'cite-mebiame', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000AEC78ED7CDEE22404860BD9BB866DA3F', 1827907496, 'suburb', '{"name": "Cité Mébiame", "place": "suburb"}');
INSERT INTO public.quartier VALUES (911, 'Cité de la Caisse', 'cite-de-la-caisse', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000004735913E52F1224090E7E912C4AFDA3F', 12980637966, 'suburb', '{"name": "Cité de la Caisse", "place": "suburb"}');
INSERT INTO public.quartier VALUES (912, 'Cité de la Démocratie', 'cite-de-la-democrati', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000C17861C66FE922400270A24C59BCDB3F', 4059029050, 'suburb', '{"name": "Cité de la Démocratie", "place": "suburb", "name:fr": "Cité de la Démocratie"}');
INSERT INTO public.quartier VALUES (913, 'Cité des Ambassadeurs', 'cite-des-ambassadeur', 862, 'Import OSM (neighbourhood)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E610000043098E2672F82240F9A1D288997DDB3F', 13018571287, 'neighbourhood', '{"name": "Cité des Ambassadeurs", "place": "neighbourhood"}');
INSERT INTO public.quartier VALUES (914, 'Cité horizon', 'cite-horizon', 862, 'Import OSM (neighbourhood)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000820D3E833C0523407ACD61AD90A8D93F', 12556050136, 'neighbourhood', '{"name": "Cité horizon", "place": "neighbourhood"}');
INSERT INTO public.quartier VALUES (915, 'Cocotiers', 'cocotiers', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E610000030F081C245E72240D8E20973718ADA3F', 1827771034, 'suburb', '{"name": "Cocotiers", "place": "suburb"}');
INSERT INTO public.quartier VALUES (916, 'Derrière la Prison', 'derriere-la-prison', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000438F183DB7E02240D5E3631CC81FDB3F', 1827771036, 'suburb', '{"name": "Derrière la Prison", "place": "suburb"}');
INSERT INTO public.quartier VALUES (917, 'Glass', 'glass', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000C597E4DB16E82240AFB893E3A922D83F', 1827771038, 'suburb', '{"name": "Glass", "place": "suburb", "wikidata": "Q3439785", "wikipedia": "fr:Roi Glass"}');
INSERT INTO public.quartier VALUES (918, 'Grand Village', 'grand-village', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000A14ED42D96FD22406A3AF18B01C8D33F', 5115327791, 'quarter', '{"name": "Grand Village", "place": "quarter"}');
INSERT INTO public.quartier VALUES (921, 'Igoumie', 'igoumie', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000005D418985100A2340DE10F461075FD73F', 5115327803, 'quarter', '{"name": "Igoumie", "place": "quarter"}');
INSERT INTO public.quartier VALUES (922, 'Institut des Sports', 'institut-des-sports', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000001AB2704859F522409150E9167005D73F', 4746500558, 'suburb', '{"name": "Institut des Sports", "place": "suburb"}');
INSERT INTO public.quartier VALUES (923, 'Kosmoparc', 'kosmoparc', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000E83D84A746EE22408198DFC4EBD5D93F', 1827771033, 'suburb', '{"name": "Kosmoparc", "place": "suburb"}');
INSERT INTO public.quartier VALUES (924, 'La Nomba', 'la-nomba', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000CAA07F27D2FA22407A4265B26EF2D53F', 5115327800, 'quarter', '{"name": "La Nomba", "place": "quarter"}');
INSERT INTO public.quartier VALUES (925, 'Lalala-Dakar', 'lalala-dakar', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000007771D17FC5F0224024B891B245D2D73F', 1827771035, 'suburb', '{"name": "Lalala-Dakar", "place": "suburb"}');
INSERT INTO public.quartier VALUES (926, 'Lalala-Droite', 'lalala-droite', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000C2548E249CED224085E16DEF6481D73F', 5115327806, 'suburb', '{"name": "Lalala-Droite", "place": "suburb"}');
INSERT INTO public.quartier VALUES (927, 'Lalala-Gauche', 'lalala-gauche', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E610000004C69F4DB3F1224029F7F186EA9CD73F', 1827771044, 'suburb', '{"name": "Lalala-Gauche", "place": "suburb"}');
INSERT INTO public.quartier VALUES (928, 'Likouala-Moussaka', 'likouala-moussaka', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000004E5E64027EE922405485ABA866FBD83F', 1827771045, 'suburb', '{"name": "Likouala-Moussaka", "place": "suburb"}');
INSERT INTO public.quartier VALUES (929, 'London', 'london', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000004D2954DC5DE82240F7B589EEB490D83F', 1827771047, 'suburb', '{"name": "London", "place": "suburb"}');
INSERT INTO public.quartier VALUES (930, 'Louis', 'louis', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000BC97569E9BDD22408FDBD4E53947DA3F', 1827771053, 'suburb', '{"name": "Louis", "place": "suburb"}');
INSERT INTO public.quartier VALUES (931, 'Lycée Technique', 'lycee-technique', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000B789496E0305234074A37ECD28CCD43F', 5115327793, 'quarter', '{"name": "Lycée Technique", "place": "quarter"}');
INSERT INTO public.quartier VALUES (932, 'Michel Marine', 'michel-marine', 862, 'Import OSM (neighbourhood)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000BFAE70DC73EA22409B73F04C6892D73F', 1827907498, 'neighbourhood', '{"name": "Michel Marine", "place": "neighbourhood"}');
INSERT INTO public.quartier VALUES (933, 'Mikolongo', 'mikolongo', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000008E12AA8A5FD7224040E88F1FE07FDE3F', 4916222183, 'suburb', '{"name": "Mikolongo", "place": "suburb"}');
INSERT INTO public.quartier VALUES (934, 'Mindoube 1', 'mindoube-1', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000F68C8EF51EFC224041EEC792DEDCD73F', 1827907500, 'suburb', '{"name": "Mindoube 1", "place": "suburb"}');
INSERT INTO public.quartier VALUES (935, 'Mindoubé 2', 'mindoube-2', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000002134CC1A06FD2240D12CBFC2386ED83F', 12208579774, 'suburb', '{"name": "Mindoubé 2", "place": "suburb"}');
INSERT INTO public.quartier VALUES (936, 'Mindoubé 3', 'mindoube-3', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000FAA29817BB002340BC4DC9833EA2D83F', 8347219426, 'quarter', '{"name": "Mindoubé 3", "place": "quarter", "description": "Le quartier Mindoubé 3 commence par le rond point(appelé \"Rond point La 2 au pavé\" ou \"Mindoubé 2 aux pavés\") et suit cette route secondaire qui mene au Carrefour Château"}');
INSERT INTO public.quartier VALUES (937, 'Mont Bouet', 'mont-bouet', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000006AFBB20F0DE62240894336902EB6D93F', 1827771055, 'suburb', '{"name": "Mont Bouet", "place": "suburb"}');
INSERT INTO public.quartier VALUES (938, 'Montagne Sainte', 'montagne-sainte', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000975A4AF14CE32240E9FAF48E0967D93F', 1827771057, 'suburb', '{"name": "Montagne Sainte", "place": "suburb", "source": "survey"}');
INSERT INTO public.quartier VALUES (939, 'Montalier', 'montalier', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000E29D32ED510223406D3997E2AAB2DB3F', 12774289181, 'suburb', '{"name": "Montalier", "place": "suburb", "source": "survey"}');
INSERT INTO public.quartier VALUES (940, 'N''kembo', 'n-kembo', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000D86322A5D9E82240475F9C53243ADA3F', 1827771060, 'suburb', '{"name": "N''kembo", "place": "suburb"}');
INSERT INTO public.quartier VALUES (941, 'Nomba-Domaine', 'nomba-domaine', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000009FD85427B1FD2240F29E5E848483D53F', 5115327797, 'suburb', '{"name": "Nomba-Domaine", "place": "suburb"}');
INSERT INTO public.quartier VALUES (942, 'Nombakele', 'nombakele', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000D37833B44BE522401B6BDA20EEC5D83F', 1827771062, 'suburb', '{"name": "Nombakele", "place": "suburb"}');
INSERT INTO public.quartier VALUES (943, 'Nzeng Ayong', 'nzeng-ayong', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000A8FC6B79E5F62240F35C3A41F655DB3F', 1827771064, 'suburb', '{"name": "Nzeng Ayong", "place": "suburb"}');
INSERT INTO public.quartier VALUES (944, 'Okala', 'okala', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E610000079680EFF9FD1224044A33B889D29DF3F', 1832438148, 'suburb', '{"name": "Okala", "place": "suburb"}');
INSERT INTO public.quartier VALUES (945, 'Oloumi', 'oloumi', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000DE9E31DD35EA2240D9DAB1C7FABCD73F', 12980637968, 'suburb', '{"name": "Oloumi", "place": "suburb"}');
INSERT INTO public.quartier VALUES (947, 'Owendo Port', 'owendo-port', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000BD40FFF3EAFE22401DDF837C75FAD23F', 5115327789, 'quarter', '{"name": "Owendo Port", "place": "quarter"}');
INSERT INTO public.quartier VALUES (948, 'Ozangué', 'ozangue', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000506562049EF522400D946F117324D83F', 5115327808, 'suburb', '{"name": "Ozangué", "place": "suburb"}');
INSERT INTO public.quartier VALUES (949, 'Ozoungué', 'ozoungue', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000006C49FDAB7DF4224001DD9733DB95D63F', 4746500559, 'suburb', '{"name": "Ozoungué", "place": "suburb"}');
INSERT INTO public.quartier VALUES (950, 'PK 10', 'pk-10', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000005283C4D1B003234040506EDBF728D93F', 5115327810, 'quarter', '{"name": "PK 10", "place": "quarter"}');
INSERT INTO public.quartier VALUES (951, 'PK5', 'pk5', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000009F831DB578EF22405B80118F1F05DA3F', 4071487877, 'quarter', '{"name": "PK5", "place": "quarter"}');
INSERT INTO public.quartier VALUES (952, 'Petit Paris', 'petit-paris', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000003F4DD2A178E622403A03232F6B62D93F', 1827771073, 'suburb', '{"name": "Petit Paris", "place": "suburb"}');
INSERT INTO public.quartier VALUES (953, 'Peyrie', 'peyrie', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000002634EE72B6E92240DE6F592A148ED93F', 1827907501, 'suburb', '{"name": "Peyrie", "place": "suburb"}');
INSERT INTO public.quartier VALUES (954, 'Plaine Niger', 'plaine-niger', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E610000078B06AB52CEC22405F84DF3C8B14D83F', 1827771074, 'suburb', '{"name": "Plaine Niger", "place": "suburb"}');
INSERT INTO public.quartier VALUES (955, 'Plaine Orety', 'plaine-orety', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E610000002F4FBFECDDF22406F18BB33C97EDA3F', 1827907502, 'suburb', '{"name": "Plaine Orety", "place": "suburb"}');
INSERT INTO public.quartier VALUES (956, 'Plein-ciel', 'plein-ciel', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000722FD571A1F3224093324EE89A6ED93F', 4281744333, 'suburb', '{"name": "Plein-ciel", "place": "suburb"}');
INSERT INTO public.quartier VALUES (957, 'Pont-Nomba', 'pont-nomba', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000ED6FBF3225F42240E844CC3681B3D53F', 5115327801, 'quarter', '{"name": "Pont-Nomba", "place": "quarter"}');
INSERT INTO public.quartier VALUES (959, 'Razel', 'razel', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000003B808F0B18F622405F903EF72F5AD53F', 5115327796, 'quarter', '{"name": "Razel", "place": "quarter"}');
INSERT INTO public.quartier VALUES (960, 'S.E.E.G-Jean Violas', 's-e-e-g-jean-violas', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E610000019F4EF445A00234050E67A3606F8D63F', 5115327804, 'quarter', '{"name": "S.E.E.G-Jean Violas", "place": "quarter"}');
INSERT INTO public.quartier VALUES (961, 'STFO', 'stfo', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000169BFB500EEB2240EB8B29FD29FAD93F', 3780523296, 'suburb', '{"name": "STFO", "place": "suburb", "alt_name": "Société Technique de la Forêt d''Okoumé"}');
INSERT INTO public.quartier VALUES (962, 'Sablière', 'sabliere', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000F4C473B680C82240D1E57228E81BDF3F', 2036949387, 'suburb', '{"name": "Sablière", "place": "suburb"}');
INSERT INTO public.quartier VALUES (963, 'Setrag', 'setrag', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000002D3993DB9BFC22409B1E1494A215D53F', 5115327794, 'quarter', '{"name": "Setrag", "place": "quarter"}');
INSERT INTO public.quartier VALUES (964, 'Sibang', 'sibang', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000001E030D912EFD22400C080841A264DA3F', 1827771075, 'suburb', '{"name": "Sibang", "place": "suburb"}');
INSERT INTO public.quartier VALUES (965, 'Smag', 'smag', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000FC5987FE64F32240D01F3FC0FFFBD63F', 5115327805, 'suburb', '{"name": "Smag", "place": "suburb"}');
INSERT INTO public.quartier VALUES (966, 'Sorbonne', 'sorbonne', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000D7FB8D76DCE8224053E4B5B700D9D93F', 1827771076, 'suburb', '{"name": "Sorbonne", "place": "suburb", "name:el": "Σορμπόν"}');
INSERT INTO public.quartier VALUES (967, 'Sotega', 'sotega', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000BB5E9A22C0E922402AF6E16AAEE4DA3F', 1827771077, 'suburb', '{"name": "Sotega", "place": "suburb"}');
INSERT INTO public.quartier VALUES (968, 'Tahiti', 'tahiti', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000AC6928FFA4D3224042FD78F9E7B3DC3F', 1827907507, 'suburb', '{"name": "Tahiti", "place": "suburb"}');
INSERT INTO public.quartier VALUES (969, 'Terre-Nouvelle', 'terre-nouvelle', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E610000063416150A6F5224099FC0571D4C0D93F', 1827771078, 'suburb', '{"name": "Terre-Nouvelle", "place": "suburb"}');
INSERT INTO public.quartier VALUES (970, 'Toulon', 'toulon', 862, 'Import OSM (neighbourhood)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E61000003E2BC47EAAE9224067823C16365ED83F', 1827771079, 'neighbourhood', '{"name": "Toulon", "place": "neighbourhood"}');
INSERT INTO public.quartier VALUES (971, 'Trois quartiers', 'trois-quartiers', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000DA1A118C83DB224089F667F5C429DB3F', 12082630516, 'suburb', '{"name": "Trois quartiers", "place": "suburb", "source": "survey"}');
INSERT INTO public.quartier VALUES (972, 'Vallée Sainte Marie', 'vallee-sainte-marie', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000090B389556E12240E16BBE00B1DBD93F', 1827771080, 'suburb', '{"name": "Vallée Sainte Marie", "place": "suburb"}');
INSERT INTO public.quartier VALUES (973, 'Venez-Voir', 'venez-voir', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E610000049B1EDFEC2EC22401CAB39E576D4D93F', 1827771081, 'suburb', '{"name": "Venez-Voir", "place": "suburb"}');
INSERT INTO public.quartier VALUES (974, 'Zone Industrielle d''Oloumi', 'zone-industrielle-d-', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-25 12:48:26.060735', '0101000020E6100000F06C8FDE70EF2240D36C7940344ED83F', 1827771066, 'suburb', '{"name": "Zone Industrielle d''Oloumi", "place": "suburb"}');
INSERT INTO public.quartier VALUES (895, 'Bas de Gué-Gué', 'bas-de-gue-gue', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-30 10:55:30.047228', '0101000020E6100000B81E85EB51F82240AE47E17A14AED73F', 1827771042, 'suburb', '{"name": "Bas de Gué-Gué", "place": "suburb"}');
INSERT INTO public.quartier VALUES (900, 'Bel-Air', 'bel-air', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-30 10:55:30.047228', '0101000020E61000000000000000002340A4703D0AD7A3DC3F', 1827771032, 'suburb', '{"name": "Bel-Air", "place": "suburb"}');
INSERT INTO public.quartier VALUES (904, 'Camp des Boys', 'camp-des-boys', 862, 'Import OSM (neighbourhood)', true, '2025-11-25 12:48:26.060735', '2025-11-30 10:55:30.047228', '0101000020E61000005C8FC2F528FC2240703D0AD7A370D93F', 12086874296, 'neighbourhood', '{"name": "Camp des Boys", "place": "neighbourhood", "source": "survey"}');
INSERT INTO public.quartier VALUES (907, 'Centre Ville', 'centre-ville', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-30 10:55:30.047228', '0101000020E6100000B81E85EB51F822400AD7A3703D0AD73F', 1832438129, 'suburb', '{"name": "Centre Ville", "place": "suburb"}');
INSERT INTO public.quartier VALUES (919, 'Haut de Gué-Gué', 'haut-de-gue-gue', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-30 10:55:30.047228', '0101000020E61000005C8FC2F528FC2240CCCCCCCCCCCCD83F', 12061162444, 'suburb', '{"name": "Haut de Gué-Gué", "place": "suburb"}');
INSERT INTO public.quartier VALUES (920, 'I.A.I-Golf', 'i-a-i-golf', 863, 'Import OSM (quarter)', true, '2025-11-25 12:48:26.060735', '2025-11-30 10:55:30.047228', '0101000020E61000003E0AD7A370FD2240CCCCCCCCCCCCD83F', 5115327807, 'quarter', '{"name": "I.A.I-Golf", "place": "quarter"}');
INSERT INTO public.quartier VALUES (946, 'Ondogo', 'ondogo', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-30 10:55:30.047228', '0101000020E61000001E85EB51B81E234086EB51B81E85DF3F', 1827771068, 'suburb', '{"name": "Ondogo", "place": "suburb"}');
INSERT INTO public.quartier VALUES (958, 'Quaben', 'quaben', 864, 'Import OSM (suburb)', true, '2025-11-25 12:48:26.060735', '2025-11-30 10:55:30.047228', '0101000020E61000003333333333F3224086EB51B81E85D73F', 1827907504, 'suburb', '{"name": "Quaben", "place": "suburb"}');


--
-- Data for Name: type_contribuable; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.type_contribuable VALUES (149, 'Particulier', 'TC-001', NULL, true, '2025-11-20 21:29:20.117482', '2025-11-20 21:29:20.117482');
INSERT INTO public.type_contribuable VALUES (150, 'Entreprise', 'TC-002', NULL, true, '2025-11-20 21:29:20.117482', '2025-11-20 21:29:20.117482');
INSERT INTO public.type_contribuable VALUES (151, 'Commerce', 'TC-003', NULL, true, '2025-11-20 21:29:20.117482', '2025-11-20 21:29:20.117482');
INSERT INTO public.type_contribuable VALUES (152, 'Marché', 'TC-004', NULL, true, '2025-11-20 21:29:20.117482', '2025-11-20 21:29:20.117482');
INSERT INTO public.type_contribuable VALUES (153, 'Transport', 'TC-005', NULL, true, '2025-11-20 21:29:20.117482', '2025-11-20 21:29:20.117482');
INSERT INTO public.type_contribuable VALUES (154, 'Restaurant', 'TC-006', NULL, true, '2025-11-20 21:29:20.117482', '2025-11-20 21:29:20.117482');
INSERT INTO public.type_contribuable VALUES (155, 'Hôtel', 'TC-007', NULL, true, '2025-11-20 21:29:20.117482', '2025-11-20 21:29:20.117482');
INSERT INTO public.type_contribuable VALUES (156, 'Boutique', 'TC-008', NULL, true, '2025-11-20 21:29:20.117482', '2025-11-20 21:29:20.117482');
INSERT INTO public.type_contribuable VALUES (157, 'Artisan', 'TC-009', 'Type de contribuable : Artisan', true, '2025-11-20 21:29:20.124481', '2025-11-20 21:29:20.124481');
INSERT INTO public.type_contribuable VALUES (158, 'Prestataire', 'TC-010', 'Type de contribuable : Prestataire', true, '2025-11-20 21:29:20.124481', '2025-11-20 21:29:20.124481');
INSERT INTO public.type_contribuable VALUES (159, 'Vendeur ambulant', 'TC-011', 'Type de contribuable : Vendeur ambulant', true, '2025-11-20 21:29:20.124481', '2025-11-20 21:29:20.124481');
INSERT INTO public.type_contribuable VALUES (160, 'Taxi', 'TC-012', 'Type de contribuable : Taxi', true, '2025-11-20 21:29:20.124481', '2025-11-20 21:29:20.124481');
INSERT INTO public.type_contribuable VALUES (161, 'Moto-taxi', 'TC-013', 'Type de contribuable : Moto-taxi', true, '2025-11-20 21:29:20.124481', '2025-11-20 21:29:20.124481');
INSERT INTO public.type_contribuable VALUES (162, 'Garage', 'TC-014', 'Type de contribuable : Garage', true, '2025-11-20 21:29:20.124481', '2025-11-20 21:29:20.124481');
INSERT INTO public.type_contribuable VALUES (163, 'Pharmacie', 'TC-015', 'Type de contribuable : Pharmacie', true, '2025-11-20 21:29:20.124481', '2025-11-20 21:29:20.124481');
INSERT INTO public.type_contribuable VALUES (164, 'Superette', 'TC-016', 'Type de contribuable : Superette', true, '2025-11-20 21:29:20.124481', '2025-11-20 21:29:20.124481');
INSERT INTO public.type_contribuable VALUES (165, 'Boulangerie', 'TC-017', 'Type de contribuable : Boulangerie', true, '2025-11-20 21:29:20.124481', '2025-11-20 21:29:20.124481');
INSERT INTO public.type_contribuable VALUES (166, 'Coiffure', 'TC-018', 'Type de contribuable : Coiffure', true, '2025-11-20 21:29:20.124481', '2025-11-20 21:29:20.124481');
INSERT INTO public.type_contribuable VALUES (167, 'Salon de beauté', 'TC-019', 'Type de contribuable : Salon de beauté', true, '2025-11-20 21:29:20.124481', '2025-11-20 21:29:20.124481');
INSERT INTO public.type_contribuable VALUES (168, 'Cybercafé', 'TC-020', 'Type de contribuable : Cybercafé', true, '2025-11-20 21:29:20.124481', '2025-11-20 21:29:20.124481');
INSERT INTO public.type_contribuable VALUES (169, 'Imprimerie', 'TC-021', 'Type de contribuable : Imprimerie', true, '2025-11-20 21:29:20.124481', '2025-11-20 21:29:20.124481');
INSERT INTO public.type_contribuable VALUES (170, 'Photographe', 'TC-022', 'Type de contribuable : Photographe', true, '2025-11-20 21:29:20.124481', '2025-11-20 21:29:20.124481');
INSERT INTO public.type_contribuable VALUES (171, 'Bijoutier', 'TC-023', 'Type de contribuable : Bijoutier', true, '2025-11-20 21:29:20.124481', '2025-11-20 21:29:20.124481');
INSERT INTO public.type_contribuable VALUES (596, 'Type 24', 'TC-024', 'Type de contribuable : Type 24', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (597, 'Type 25', 'TC-025', 'Type de contribuable : Type 25', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (598, 'Type 26', 'TC-026', 'Type de contribuable : Type 26', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (599, 'Type 27', 'TC-027', 'Type de contribuable : Type 27', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (600, 'Type 28', 'TC-028', 'Type de contribuable : Type 28', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (601, 'Type 29', 'TC-029', 'Type de contribuable : Type 29', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (602, 'Type 30', 'TC-030', 'Type de contribuable : Type 30', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (603, 'Type 31', 'TC-031', 'Type de contribuable : Type 31', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (604, 'Type 32', 'TC-032', 'Type de contribuable : Type 32', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (605, 'Type 33', 'TC-033', 'Type de contribuable : Type 33', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (606, 'Type 34', 'TC-034', 'Type de contribuable : Type 34', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (607, 'Type 35', 'TC-035', 'Type de contribuable : Type 35', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (608, 'Type 36', 'TC-036', 'Type de contribuable : Type 36', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (609, 'Type 37', 'TC-037', 'Type de contribuable : Type 37', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (610, 'Type 38', 'TC-038', 'Type de contribuable : Type 38', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (611, 'Type 39', 'TC-039', 'Type de contribuable : Type 39', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (612, 'Type 40', 'TC-040', 'Type de contribuable : Type 40', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (613, 'Type 41', 'TC-041', 'Type de contribuable : Type 41', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (614, 'Type 42', 'TC-042', 'Type de contribuable : Type 42', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (615, 'Type 43', 'TC-043', 'Type de contribuable : Type 43', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (616, 'Type 44', 'TC-044', 'Type de contribuable : Type 44', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (617, 'Type 45', 'TC-045', 'Type de contribuable : Type 45', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (618, 'Type 46', 'TC-046', 'Type de contribuable : Type 46', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (619, 'Type 47', 'TC-047', 'Type de contribuable : Type 47', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (620, 'Type 48', 'TC-048', 'Type de contribuable : Type 48', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (621, 'Type 49', 'TC-049', 'Type de contribuable : Type 49', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_contribuable VALUES (622, 'Type 50', 'TC-050', 'Type de contribuable : Type 50', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');


--
-- Data for Name: contribuable; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.contribuable VALUES (265, 'NDONG', 'David', NULL, '+241062000015', 170, 900, 387, 'Avenue IndÃ©pendance 16', 0.46141900, 9.49846500, 'CTB-0015', true, '2025-11-20 22:59:10.253041', '2025-11-30 14:05:45.75961', NULL, NULL, '0101000020E61000006666666666E62240CDCCCCCCCCCCDC3F', 664.78, 'CONT-265-71E9B912');
INSERT INTO public.contribuable VALUES (284, 'MINTSA', 'Pierre', 'contribuable34@example.ga', '+241062000034', 159, 895, 399, 'Rue Massenet 35', 0.34664100, 9.47174200, 'CTB-0034', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000E17A14AE47E12240295C8FC2F528DC3F', 788.60, NULL);
INSERT INTO public.contribuable VALUES (264, 'MBOUMBA', 'Anne', 'contribuable14@example.ga', '+241062000014', 155, 895, 370, 'Rue Massenet 15', 0.37609500, 9.49537900, 'CTB-0014', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000E17A14AE47E12240295C8FC2F528DC3F', 788.60, NULL);
INSERT INTO public.contribuable VALUES (285, 'MBOUMBA', 'Paul', 'contribuable35@example.ga', '+241062000035', 165, 900, 391, 'Avenue IndÃ©pendance 36', 0.45113600, 9.49213300, 'CTB-0035', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E61000006666666666E62240CDCCCCCCCCCCDC3F', 664.78, NULL);
INSERT INTO public.contribuable VALUES (282, 'ESSONO', 'Jean', 'contribuable32@example.ga', '+241062000032', 162, 904, 390, 'Rue Nkrumah 33', 0.40866200, 9.52549000, 'CTB-0032', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000D7A3703D0AD72240E17A14AE47E1DA3F', 907.71, NULL);
INSERT INTO public.contribuable VALUES (262, 'MVE', 'Sophie', NULL, '+241062000012', 619, 904, 387, 'Rue Nkrumah 13', 0.38535800, 9.49507500, 'CTB-0012', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000D7A3703D0AD72240E17A14AE47E1DA3F', 907.71, NULL);
INSERT INTO public.contribuable VALUES (293, 'NDONG', 'Paul', 'contribuable43@example.ga', '+241062000043', 603, 907, 376, 'Avenue De Gaulle 44', 0.35887900, 9.45413700, 'CTB-0043', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000295C8FC2F5A822401F85EB51B81ED53F', 14408.47, NULL);
INSERT INTO public.contribuable VALUES (292, 'MBOUMBA', 'Pierre', NULL, '+241062000042', 152, 907, 354, 'Rue Nkrumah 43', 0.37340000, 9.50624600, 'CTB-0042', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000A4703D0AD7A322407B14AE47E17AD43F', 15919.44, NULL);
INSERT INTO public.contribuable VALUES (291, 'MINTSA', 'Marie', 'contribuable41@example.ga', '+241062000041', 164, 907, 360, 'Boulevard LÃ©on Mba 42', 0.36792200, 9.50370900, 'CTB-0041', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E61000001F85EB51B89E2240D7A3703D0AD7D33F', 17441.30, NULL);
INSERT INTO public.contribuable VALUES (290, 'MVE', 'Jean', 'contribuable40@example.ga', '+241062000040', 162, 907, 372, 'Avenue IndÃ©pendance 41', 0.36213500, 9.47206500, 'CTB-0040', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E61000009A99999999992240333333333333D33F', 18971.42, NULL);
INSERT INTO public.contribuable VALUES (273, 'OBAME', 'David', 'contribuable23@example.ga', '+241062000023', 597, 907, 362, 'Avenue De Gaulle 24', 0.34460300, 9.49566400, 'CTB-0023', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000295C8FC2F5A822401F85EB51B81ED53F', 14408.47, NULL);
INSERT INTO public.contribuable VALUES (272, 'NDONG', 'Anne', 'contribuable22@example.ga', '+241062000022', 150, 907, 366, 'Rue Nkrumah 23', 0.38394300, 9.47371000, 'CTB-0022', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000A4703D0AD7A322407B14AE47E17AD43F', 15919.44, NULL);
INSERT INTO public.contribuable VALUES (271, 'MBOUMBA', 'Luc', NULL, '+241062000021', 596, 907, 351, 'Boulevard LÃ©on Mba 22', 0.35917800, 9.47344100, 'CTB-0021', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E61000001F85EB51B89E2240D7A3703D0AD7D33F', 17441.30, NULL);
INSERT INTO public.contribuable VALUES (270, 'MINTSA', 'Sophie', 'contribuable20@example.ga', '+241062000020', 608, 907, 390, 'Avenue IndÃ©pendance 21', 0.37734500, 9.47362800, 'CTB-0020', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E61000009A99999999992240333333333333D33F', 18971.42, NULL);
INSERT INTO public.contribuable VALUES (253, 'BONGO', 'Paul', NULL, '+241062000003', 166, 907, 355, 'Avenue De Gaulle 4', 0.36191000, 9.47553100, 'CTB-0003', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000295C8FC2F5A822401F85EB51B81ED53F', 14408.47, NULL);
INSERT INTO public.contribuable VALUES (252, 'OBAME', 'Pierre', 'contribuable2@example.ga', '+241062000002', 149, 907, 396, 'Rue Nkrumah 3', 0.37384600, 9.44629800, 'CTB-0002', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000A4703D0AD7A322407B14AE47E17AD43F', 15919.44, NULL);
INSERT INTO public.contribuable VALUES (251, 'NDONG', 'Marie', 'contribuable1@example.ga', '+24177861364', 602, 907, 393, 'Boulevard LÃ©on Mba 2', 0.35723900, 9.47559600, 'CTB-0001', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E61000001F85EB51B89E2240D7A3703D0AD7D33F', 17441.30, NULL);
INSERT INTO public.contribuable VALUES (283, 'MVE', 'Marie', NULL, '+241062000033', 618, 919, 381, 'Avenue De Gaulle 34', 0.39986900, 9.46887600, 'CTB-0033', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E61000005C8FC2F528DC224085EB51B81E85DB3F', 79.49, NULL);
INSERT INTO public.contribuable VALUES (263, 'MINTSA', 'Luc', 'contribuable13@example.ga', '+241062000013', 151, 919, 355, 'Avenue De Gaulle 14', 0.40081600, 9.51381500, 'CTB-0013', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E61000005C8FC2F528DC224085EB51B81E85DB3F', 79.49, NULL);
INSERT INTO public.contribuable VALUES (301, 'BEBANE MOUKOUMBI', 'MARINA BRUNELLE', NULL, '+24107861364', 151, 920, 355, 'nombakélé', 0.38193000, 9.51296600, '79551545', true, '2025-11-20 23:47:39.858586', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000BC4F5D12CAF52240F4C3A5B6169ED73F', 278.91, NULL);
INSERT INTO public.contribuable VALUES (289, 'ESSONO', 'David', NULL, '+241062000039', 161, 946, 394, 'Rue Massenet 40', 0.51870700, 9.54177900, 'CTB-0039', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E61000007B14AE47E1FA22405C8FC2F5285CDF3F', 5566.45, NULL);
INSERT INTO public.contribuable VALUES (288, 'BONGO', 'Anne', 'contribuable38@example.ga', '+241062000038', 170, 946, 357, 'Avenue De Gaulle 39', 0.52512000, 9.54250100, 'CTB-0038', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000F6285C8FC2F52240B81E85EB51B8DE3F', 4061.82, NULL);
INSERT INTO public.contribuable VALUES (287, 'OBAME', 'Luc', 'contribuable37@example.ga', '+241062000037', 597, 946, 367, 'Rue Nkrumah 38', 0.49669900, 9.54508700, 'CTB-0037', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000713D0AD7A3F0224014AE47E17A14DE3F', 2637.60, NULL);
INSERT INTO public.contribuable VALUES (286, 'NDONG', 'Sophie', NULL, '+241062000036', 149, 946, 384, 'Boulevard LÃ©on Mba 37', 0.49188600, 9.54533900, 'CTB-0036', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000EC51B81E85EB2240713D0AD7A370DD3F', 1536.56, NULL);
INSERT INTO public.contribuable VALUES (269, 'MVE', 'Paul', 'contribuable19@example.ga', '+241062000019', 611, 946, 366, 'Rue Massenet 20', 0.45799100, 9.59077800, 'CTB-0019', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E61000007B14AE47E1FA22405C8FC2F5285CDF3F', 5566.45, NULL);
INSERT INTO public.contribuable VALUES (268, 'ESSONO', 'Pierre', NULL, '+241062000018', 161, 946, 386, 'Avenue De Gaulle 19', 0.51165300, 9.56275300, 'CTB-0018', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000F6285C8FC2F52240B81E85EB51B8DE3F', 4061.82, NULL);
INSERT INTO public.contribuable VALUES (267, 'BONGO', 'Marie', 'contribuable17@example.ga', '+241062000017', 151, 946, 375, 'Rue Nkrumah 18', 0.46982600, 9.55558400, 'CTB-0017', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000713D0AD7A3F0224014AE47E17A14DE3F', 2637.60, NULL);
INSERT INTO public.contribuable VALUES (266, 'OBAME', 'Jean', 'contribuable16@example.ga', '+241062000016', 610, 946, 372, 'Boulevard LÃ©on Mba 17', 0.52745400, 9.56334700, 'CTB-0016', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000EC51B81E85EB2240713D0AD7A370DD3F', 1536.56, NULL);
INSERT INTO public.contribuable VALUES (300, 'NDONG', 'Pierre', 'contribuable50@example.ga', '+241062000050', 614, 958, 381, 'Avenue IndÃ©pendance 51', 0.37482700, 9.46102400, 'CTB-0050', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000CDCCCCCCCCCC22409A9999999999D93F', 3667.22, NULL);
INSERT INTO public.contribuable VALUES (299, 'MBOUMBA', 'Marie', 'contribuable49@example.ga', '+241062000049', 160, 958, 354, 'Rue Massenet 50', 0.35730600, 9.49479700, 'CTB-0049', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E610000048E17A14AEC72240F6285C8FC2F5D83F', 5148.66, NULL);
INSERT INTO public.contribuable VALUES (298, 'MINTSA', 'Jean', NULL, '+241062000048', 602, 958, 390, 'Avenue De Gaulle 49', 0.34543600, 9.48826000, 'CTB-0048', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000C3F5285C8FC2224052B81E85EB51D83F', 6671.93, NULL);
INSERT INTO public.contribuable VALUES (297, 'MVE', 'David', 'contribuable47@example.ga', '+241062000047', 608, 958, 363, 'Rue Nkrumah 48', 0.36940800, 9.49734000, 'CTB-0047', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E61000003D0AD7A370BD2240AE47E17A14AED73F', 8213.78, NULL);
INSERT INTO public.contribuable VALUES (296, 'ESSONO', 'Anne', 'contribuable46@example.ga', '+241062000046', 598, 958, 379, 'Boulevard LÃ©on Mba 47', 0.33548000, 9.51353100, 'CTB-0046', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000B81E85EB51B822400AD7A3703D0AD73F', 9765.41, NULL);
INSERT INTO public.contribuable VALUES (295, 'BONGO', 'Luc', NULL, '+241062000045', 605, 958, 398, 'Avenue IndÃ©pendance 46', 0.39465600, 9.45539500, 'CTB-0045', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E61000003333333333B32240666666666666D63F', 11322.81, NULL);
INSERT INTO public.contribuable VALUES (294, 'OBAME', 'Sophie', 'contribuable44@example.ga', '+241062000044', 155, 958, 394, 'Rue Massenet 45', 0.34320500, 9.47359200, 'CTB-0044', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000AE47E17A14AE2240C3F5285C8FC2D53F', 12883.89, NULL);
INSERT INTO public.contribuable VALUES (281, 'BONGO', 'David', 'contribuable31@example.ga', '+241062000031', 617, 958, 394, 'Boulevard LÃ©on Mba 32', 0.33148900, 9.45272300, 'CTB-0031', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E610000052B81E85EBD122403D0AD7A3703DDA3F', 2309.53, NULL);
INSERT INTO public.contribuable VALUES (280, 'OBAME', 'Anne', NULL, '+241062000030', 596, 958, 359, 'Avenue IndÃ©pendance 31', 0.35321900, 9.48903600, 'CTB-0030', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000CDCCCCCCCCCC22409A9999999999D93F', 3667.22, NULL);
INSERT INTO public.contribuable VALUES (279, 'NDONG', 'Luc', 'contribuable29@example.ga', '+241062000029', 605, 958, 393, 'Rue Massenet 30', 0.36078300, 9.50085300, 'CTB-0029', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E610000048E17A14AEC72240F6285C8FC2F5D83F', 5148.66, NULL);
INSERT INTO public.contribuable VALUES (278, 'MBOUMBA', 'Sophie', 'contribuable28@example.ga', '+241062000028', 616, 958, 370, 'Avenue De Gaulle 29', 0.39801400, 9.47479200, 'CTB-0028', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000C3F5285C8FC2224052B81E85EB51D83F', 6671.93, NULL);
INSERT INTO public.contribuable VALUES (277, 'MINTSA', 'Paul', NULL, '+241062000027', 597, 958, 391, 'Rue Nkrumah 28', 0.39760700, 9.51272100, 'CTB-0027', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E61000003D0AD7A370BD2240AE47E17A14AED73F', 8213.78, NULL);
INSERT INTO public.contribuable VALUES (276, 'MVE', 'Pierre', 'contribuable26@example.ga', '+241062000026', 611, 958, 368, 'Boulevard LÃ©on Mba 27', 0.35797000, 9.44784300, 'CTB-0026', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000B81E85EB51B822400AD7A3703D0AD73F', 9765.41, NULL);
INSERT INTO public.contribuable VALUES (275, 'ESSONO', 'Marie', 'contribuable25@example.ga', '+241062000025', 597, 958, 389, 'Avenue IndÃ©pendance 26', 0.38697300, 9.50449600, 'CTB-0025', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E61000003333333333B32240666666666666D63F', 11322.81, NULL);
INSERT INTO public.contribuable VALUES (274, 'BONGO', 'Jean', NULL, '+241062000024', 597, 958, 351, 'Rue Massenet 25', 0.34083600, 9.46325500, 'CTB-0024', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000AE47E17A14AE2240C3F5285C8FC2D53F', 12883.89, NULL);
INSERT INTO public.contribuable VALUES (261, 'ESSONO', 'Paul', 'contribuable11@example.ga', '+241062000011', 597, 958, 360, 'Boulevard LÃ©on Mba 12', 0.36250400, 9.51965600, 'CTB-0011', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E610000052B81E85EBD122403D0AD7A3703DDA3F', 2309.53, NULL);
INSERT INTO public.contribuable VALUES (260, 'BONGO', 'Pierre', 'contribuable10@example.ga', '+241062000010', 611, 958, 388, 'Avenue IndÃ©pendance 11', 0.34580000, 9.51442300, 'CTB-0010', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000CDCCCCCCCCCC22409A9999999999D93F', 3667.22, NULL);
INSERT INTO public.contribuable VALUES (259, 'OBAME', 'Marie', NULL, '+241062000009', 620, 958, 383, 'Rue Massenet 10', 0.33296700, 9.47945400, 'CTB-0009', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E610000048E17A14AEC72240F6285C8FC2F5D83F', 5148.66, NULL);
INSERT INTO public.contribuable VALUES (258, 'NDONG', 'Jean', 'contribuable8@example.ga', '+241062000008', 606, 958, 399, 'Avenue De Gaulle 9', 0.37902400, 9.43656000, 'CTB-0008', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000C3F5285C8FC2224052B81E85EB51D83F', 6671.93, NULL);
INSERT INTO public.contribuable VALUES (257, 'MBOUMBA', 'David', 'contribuable7@example.ga', '+241062000007', 165, 958, 395, 'Rue Nkrumah 8', 0.35378000, 9.43914000, 'CTB-0007', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E61000003D0AD7A370BD2240AE47E17A14AED73F', 8213.78, NULL);
INSERT INTO public.contribuable VALUES (254, 'ESSONO', 'Sophie', 'contribuable4@example.ga', '+241062000004', 169, 958, 364, 'Rue Massenet 5', 0.35811000, 9.45258600, 'CTB-0004', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000AE47E17A14AE2240C3F5285C8FC2D53F', 12883.89, NULL);
INSERT INTO public.contribuable VALUES (256, 'MINTSA', 'Anne', NULL, '+241062000006', 618, 958, 361, 'Boulevard LÃ©on Mba 7', 0.36666400, 9.46890300, 'CTB-0006', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E6100000B81E85EB51B822400AD7A3703D0AD73F', 9765.41, NULL);
INSERT INTO public.contribuable VALUES (255, 'MVE', 'Luc', 'contribuable5@example.ga', '+241062000005', 165, 958, 378, 'Avenue IndÃ©pendance 6', 0.33414700, 9.48764400, 'CTB-0005', true, '2025-11-20 22:59:10.253041', '2025-11-30 10:56:12.590492', NULL, NULL, '0101000020E61000003333333333B32240666666666666D63F', 11322.81, NULL);


--
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.service VALUES (133, 'Service des Finances', 'Gestion financière', 'SRV-001', true, '2025-11-20 21:29:20.136877', '2025-11-20 21:29:20.136877');
INSERT INTO public.service VALUES (134, 'Service des Marchés', 'Gestion des marchés', 'SRV-002', true, '2025-11-20 21:29:20.136877', '2025-11-20 21:29:20.136877');
INSERT INTO public.service VALUES (135, 'Service de l''Urbanisme', 'Urbanisme et aménagement', 'SRV-003', true, '2025-11-20 21:29:20.136877', '2025-11-20 21:29:20.136877');
INSERT INTO public.service VALUES (136, 'Service des Transports', 'Gestion des transports', 'SRV-004', true, '2025-11-20 21:29:20.136877', '2025-11-20 21:29:20.136877');
INSERT INTO public.service VALUES (137, 'Service des Commerces', 'Gestion des commerces', 'SRV-005', true, '2025-11-20 21:29:20.136877', '2025-11-20 21:29:20.136877');
INSERT INTO public.service VALUES (138, 'Service de l''Environnement', 'Environnement et propreté', 'SRV-006', true, '2025-11-20 21:29:20.136877', '2025-11-20 21:29:20.136877');
INSERT INTO public.service VALUES (139, 'Service de la Voirie', 'Entretien de la voirie', 'SRV-007', true, '2025-11-20 21:29:20.136877', '2025-11-20 21:29:20.136877');
INSERT INTO public.service VALUES (140, 'Service de la Propreté', 'Service : Service de la Propreté', 'SRV-008', true, '2025-11-20 21:29:20.143267', '2025-11-20 21:29:20.143267');
INSERT INTO public.service VALUES (141, 'Service de l''Éclairage Public', 'Service : Service de l''Éclairage Public', 'SRV-009', true, '2025-11-20 21:29:20.143267', '2025-11-20 21:29:20.143267');
INSERT INTO public.service VALUES (142, 'Service des Espaces Verts', 'Service : Service des Espaces Verts', 'SRV-010', true, '2025-11-20 21:29:20.143267', '2025-11-20 21:29:20.143267');
INSERT INTO public.service VALUES (143, 'Service de la Sécurité', 'Service : Service de la Sécurité', 'SRV-011', true, '2025-11-20 21:29:20.143267', '2025-11-20 21:29:20.143267');
INSERT INTO public.service VALUES (144, 'Service de la Communication', 'Service : Service de la Communication', 'SRV-012', true, '2025-11-20 21:29:20.143267', '2025-11-20 21:29:20.143267');
INSERT INTO public.service VALUES (145, 'Service des Archives', 'Service : Service des Archives', 'SRV-013', true, '2025-11-20 21:29:20.143267', '2025-11-20 21:29:20.143267');
INSERT INTO public.service VALUES (146, 'Service de l''État Civil', 'Service : Service de l''État Civil', 'SRV-014', true, '2025-11-20 21:29:20.143267', '2025-11-20 21:29:20.143267');
INSERT INTO public.service VALUES (147, 'Service de la Population', 'Service : Service de la Population', 'SRV-015', true, '2025-11-20 21:29:20.143267', '2025-11-20 21:29:20.143267');
INSERT INTO public.service VALUES (148, 'Service de l''Action Sociale', 'Service : Service de l''Action Sociale', 'SRV-016', true, '2025-11-20 21:29:20.143267', '2025-11-20 21:29:20.143267');
INSERT INTO public.service VALUES (565, 'Service 17', 'Service : Service 17', 'SRV-017', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (566, 'Service 18', 'Service : Service 18', 'SRV-018', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (567, 'Service 19', 'Service : Service 19', 'SRV-019', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (568, 'Service 20', 'Service : Service 20', 'SRV-020', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (569, 'Service 21', 'Service : Service 21', 'SRV-021', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (570, 'Service 22', 'Service : Service 22', 'SRV-022', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (571, 'Service 23', 'Service : Service 23', 'SRV-023', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (572, 'Service 24', 'Service : Service 24', 'SRV-024', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (573, 'Service 25', 'Service : Service 25', 'SRV-025', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (574, 'Service 26', 'Service : Service 26', 'SRV-026', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (575, 'Service 27', 'Service : Service 27', 'SRV-027', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (576, 'Service 28', 'Service : Service 28', 'SRV-028', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (577, 'Service 29', 'Service : Service 29', 'SRV-029', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (578, 'Service 30', 'Service : Service 30', 'SRV-030', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (579, 'Service 31', 'Service : Service 31', 'SRV-031', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (580, 'Service 32', 'Service : Service 32', 'SRV-032', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (581, 'Service 33', 'Service : Service 33', 'SRV-033', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (582, 'Service 34', 'Service : Service 34', 'SRV-034', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (583, 'Service 35', 'Service : Service 35', 'SRV-035', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (584, 'Service 36', 'Service : Service 36', 'SRV-036', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (585, 'Service 37', 'Service : Service 37', 'SRV-037', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (586, 'Service 38', 'Service : Service 38', 'SRV-038', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (587, 'Service 39', 'Service : Service 39', 'SRV-039', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (588, 'Service 40', 'Service : Service 40', 'SRV-040', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (589, 'Service 41', 'Service : Service 41', 'SRV-041', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (590, 'Service 42', 'Service : Service 42', 'SRV-042', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (591, 'Service 43', 'Service : Service 43', 'SRV-043', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (592, 'Service 44', 'Service : Service 44', 'SRV-044', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (593, 'Service 45', 'Service : Service 45', 'SRV-045', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (594, 'Service 46', 'Service : Service 46', 'SRV-046', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (595, 'Service 47', 'Service : Service 47', 'SRV-047', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (596, 'Service 48', 'Service : Service 48', 'SRV-048', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (597, 'Service 49', 'Service : Service 49', 'SRV-049', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.service VALUES (598, 'Service 50', 'Service : Service 50', 'SRV-050', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');


--
-- Data for Name: type_taxe; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.type_taxe VALUES (139, 'Taxe de Marché', 'TT-001', 'Taxe sur les activités de marché', true, '2025-11-20 21:29:20.165491', '2025-11-20 21:29:20.165491');
INSERT INTO public.type_taxe VALUES (140, 'Taxe d''Occupation du Domaine Public', 'TT-002', 'Taxe pour occupation de l''espace public', true, '2025-11-20 21:29:20.165491', '2025-11-20 21:29:20.165491');
INSERT INTO public.type_taxe VALUES (141, 'Taxe sur les Activités Commerciales', 'TT-003', 'Taxe sur les activités commerciales', true, '2025-11-20 21:29:20.165491', '2025-11-20 21:29:20.165491');
INSERT INTO public.type_taxe VALUES (142, 'Taxe de Stationnement', 'TT-004', 'Taxe de stationnement', true, '2025-11-20 21:29:20.165491', '2025-11-20 21:29:20.165491');
INSERT INTO public.type_taxe VALUES (143, 'Taxe de Voirie', 'TT-005', 'Taxe de voirie', true, '2025-11-20 21:29:20.165491', '2025-11-20 21:29:20.165491');
INSERT INTO public.type_taxe VALUES (144, 'Taxe d''Enlèvement des Ordures', 'TT-006', 'Taxe pour l''enlèvement des ordures', true, '2025-11-20 21:29:20.165491', '2025-11-20 21:29:20.165491');
INSERT INTO public.type_taxe VALUES (145, 'Taxe sur les Transports', 'TT-007', 'Taxe sur les activités de transport', true, '2025-11-20 21:29:20.165491', '2025-11-20 21:29:20.165491');
INSERT INTO public.type_taxe VALUES (146, 'Taxe sur les Débits de Boissons', 'TT-008', 'Taxe sur les débits de boissons', true, '2025-11-20 21:29:20.165491', '2025-11-20 21:29:20.165491');
INSERT INTO public.type_taxe VALUES (147, 'Taxe sur les Hôtels', 'TT-009', 'Taxe sur les établissements hôteliers', true, '2025-11-20 21:29:20.165491', '2025-11-20 21:29:20.165491');
INSERT INTO public.type_taxe VALUES (148, 'Taxe sur les Publicités', 'TT-010', 'Taxe sur les publicités et enseignes', true, '2025-11-20 21:29:20.165491', '2025-11-20 21:29:20.165491');
INSERT INTO public.type_taxe VALUES (149, 'Taxe sur les Spectacles', 'TT-011', 'Type de taxe : Taxe sur les Spectacles', true, '2025-11-20 21:29:20.168505', '2025-11-20 21:29:20.168505');
INSERT INTO public.type_taxe VALUES (150, 'Taxe sur les Jeux', 'TT-012', 'Type de taxe : Taxe sur les Jeux', true, '2025-11-20 21:29:20.168505', '2025-11-20 21:29:20.168505');
INSERT INTO public.type_taxe VALUES (151, 'Taxe sur les Locations', 'TT-013', 'Type de taxe : Taxe sur les Locations', true, '2025-11-20 21:29:20.168505', '2025-11-20 21:29:20.168505');
INSERT INTO public.type_taxe VALUES (152, 'Taxe sur les Terrains', 'TT-014', 'Type de taxe : Taxe sur les Terrains', true, '2025-11-20 21:29:20.168505', '2025-11-20 21:29:20.168505');
INSERT INTO public.type_taxe VALUES (153, 'Taxe sur les Constructions', 'TT-015', 'Type de taxe : Taxe sur les Constructions', true, '2025-11-20 21:29:20.168505', '2025-11-20 21:29:20.168505');
INSERT INTO public.type_taxe VALUES (154, 'Taxe sur les Véhicules', 'TT-016', 'Type de taxe : Taxe sur les Véhicules', true, '2025-11-20 21:29:20.168505', '2025-11-20 21:29:20.168505');
INSERT INTO public.type_taxe VALUES (155, 'Taxe sur les Animaux', 'TT-017', 'Type de taxe : Taxe sur les Animaux', true, '2025-11-20 21:29:20.168505', '2025-11-20 21:29:20.168505');
INSERT INTO public.type_taxe VALUES (156, 'Taxe sur les Événements', 'TT-018', 'Type de taxe : Taxe sur les Événements', true, '2025-11-20 21:29:20.168505', '2025-11-20 21:29:20.168505');
INSERT INTO public.type_taxe VALUES (157, 'Taxe sur les Installations', 'TT-019', 'Type de taxe : Taxe sur les Installations', true, '2025-11-20 21:29:20.168505', '2025-11-20 21:29:20.168505');
INSERT INTO public.type_taxe VALUES (577, 'Type Taxe 20', 'TT-020', 'Description type taxe 20', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (578, 'Type Taxe 21', 'TT-021', 'Description type taxe 21', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (579, 'Type Taxe 22', 'TT-022', 'Description type taxe 22', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (580, 'Type Taxe 23', 'TT-023', 'Description type taxe 23', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (581, 'Type Taxe 24', 'TT-024', 'Description type taxe 24', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (582, 'Type Taxe 25', 'TT-025', 'Description type taxe 25', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (583, 'Type Taxe 26', 'TT-026', 'Description type taxe 26', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (584, 'Type Taxe 27', 'TT-027', 'Description type taxe 27', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (585, 'Type Taxe 28', 'TT-028', 'Description type taxe 28', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (586, 'Type Taxe 29', 'TT-029', 'Description type taxe 29', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (587, 'Type Taxe 30', 'TT-030', 'Description type taxe 30', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (588, 'Type Taxe 31', 'TT-031', 'Description type taxe 31', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (589, 'Type Taxe 32', 'TT-032', 'Description type taxe 32', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (590, 'Type Taxe 33', 'TT-033', 'Description type taxe 33', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (591, 'Type Taxe 34', 'TT-034', 'Description type taxe 34', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (592, 'Type Taxe 35', 'TT-035', 'Description type taxe 35', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (593, 'Type Taxe 36', 'TT-036', 'Description type taxe 36', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (594, 'Type Taxe 37', 'TT-037', 'Description type taxe 37', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (595, 'Type Taxe 38', 'TT-038', 'Description type taxe 38', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (596, 'Type Taxe 39', 'TT-039', 'Description type taxe 39', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (597, 'Type Taxe 40', 'TT-040', 'Description type taxe 40', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (598, 'Type Taxe 41', 'TT-041', 'Description type taxe 41', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (599, 'Type Taxe 42', 'TT-042', 'Description type taxe 42', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (600, 'Type Taxe 43', 'TT-043', 'Description type taxe 43', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (601, 'Type Taxe 44', 'TT-044', 'Description type taxe 44', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (602, 'Type Taxe 45', 'TT-045', 'Description type taxe 45', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (603, 'Type Taxe 46', 'TT-046', 'Description type taxe 46', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (604, 'Type Taxe 47', 'TT-047', 'Description type taxe 47', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (605, 'Type Taxe 48', 'TT-048', 'Description type taxe 48', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (606, 'Type Taxe 49', 'TT-049', 'Description type taxe 49', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.type_taxe VALUES (607, 'Type Taxe 50', 'TT-050', 'Description type taxe 50', true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');


--
-- Data for Name: taxe; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.taxe VALUES (1, 'Taxe de Marché Journalière', 'TAX-001', 'Taxe quotidienne pour les vendeurs de marché', 1000.00, false, 'journaliere', 139, 134, 5.00, true, '2025-11-20 21:29:20.202685', '2025-11-20 21:29:20.202685');
INSERT INTO public.taxe VALUES (2, 'Taxe de Marché Mensuelle', 'TAX-002', 'Taxe mensuelle pour les vendeurs de marché', 25000.00, false, 'mensuelle', 139, 134, 5.00, true, '2025-11-20 21:29:20.202685', '2025-11-20 21:29:20.202685');
INSERT INTO public.taxe VALUES (3, 'Taxe d''Occupation Domaine Public', 'TAX-003', 'Taxe pour occupation de l''espace public', 5000.00, true, 'mensuelle', 139, 134, 3.00, true, '2025-11-20 21:29:20.202685', '2025-11-20 21:29:20.202685');
INSERT INTO public.taxe VALUES (4, 'Taxe Commerciale Mensuelle', 'TAX-004', 'Taxe sur les activités commerciales', 15000.00, false, 'mensuelle', 139, 134, 4.00, true, '2025-11-20 21:29:20.202685', '2025-11-20 21:29:20.202685');
INSERT INTO public.taxe VALUES (5, 'Taxe de Stationnement', 'TAX-005', 'Taxe de stationnement journalière', 500.00, false, 'journaliere', 139, 134, 2.00, true, '2025-11-20 21:29:20.202685', '2025-11-20 21:29:20.202685');
INSERT INTO public.taxe VALUES (6, 'Taxe d''Enlèvement Ordures', 'TAX-006', 'Taxe pour l''enlèvement des ordures ménagères', 3000.00, false, 'mensuelle', 139, 134, 0.00, true, '2025-11-20 21:29:20.202685', '2025-11-20 21:29:20.202685');
INSERT INTO public.taxe VALUES (7, 'Taxe 7', 'TAX-007', 'Description de la taxe 7', 2000.00, true, 'hebdomadaire', 150, 144, 2.06, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (8, 'Taxe 8', 'TAX-008', 'Description de la taxe 8', 25000.00, true, 'trimestrielle', 153, 135, 8.96, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (9, 'Taxe 9', 'TAX-009', 'Description de la taxe 9', 30000.00, true, 'journaliere', 153, 138, 7.90, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (10, 'Taxe 10', 'TAX-010', 'Description de la taxe 10', 2000.00, true, 'hebdomadaire', 154, 134, 1.02, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (11, 'Taxe 11', 'TAX-011', 'Description de la taxe 11', 30000.00, false, 'trimestrielle', 157, 145, 1.83, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (12, 'Taxe 12', 'TAX-012', 'Description de la taxe 12', 20000.00, true, 'mensuelle', 142, 135, 4.62, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (13, 'Taxe 13', 'TAX-013', 'Description de la taxe 13', 15000.00, true, 'mensuelle', 141, 140, 2.91, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (14, 'Taxe 14', 'TAX-014', 'Description de la taxe 14', 3000.00, false, 'hebdomadaire', 143, 134, 6.59, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (15, 'Taxe 15', 'TAX-015', 'Description de la taxe 15', 3000.00, false, 'mensuelle', 144, 144, 1.96, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (16, 'Taxe 16', 'TAX-016', 'Description de la taxe 16', 30000.00, false, 'journaliere', 157, 136, 1.81, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (17, 'Taxe 17', 'TAX-017', 'Description de la taxe 17', 20000.00, true, 'journaliere', 154, 139, 7.07, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (18, 'Taxe 18', 'TAX-018', 'Description de la taxe 18', 2000.00, false, 'trimestrielle', 140, 138, 5.65, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (19, 'Taxe 19', 'TAX-019', 'Description de la taxe 19', 10000.00, false, 'journaliere', 149, 145, 0.21, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (20, 'Taxe 20', 'TAX-020', 'Description de la taxe 20', 25000.00, false, 'journaliere', 147, 133, 9.02, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (21, 'Taxe 21', 'TAX-021', 'Description de la taxe 21', 2000.00, false, 'journaliere', 139, 139, 4.54, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (22, 'Taxe 22', 'TAX-022', 'Description de la taxe 22', 3000.00, false, 'journaliere', 154, 133, 4.41, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (23, 'Taxe 23', 'TAX-023', 'Description de la taxe 23', 5000.00, true, 'hebdomadaire', 151, 145, 9.39, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (24, 'Taxe 24', 'TAX-024', 'Description de la taxe 24', 1000.00, false, 'trimestrielle', 157, 146, 8.51, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (25, 'Taxe 25', 'TAX-025', 'Description de la taxe 25', 10000.00, true, 'hebdomadaire', 143, 137, 0.91, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (26, 'Taxe 26', 'TAX-026', 'Description de la taxe 26', 15000.00, false, 'mensuelle', 145, 136, 0.07, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (27, 'Taxe 27', 'TAX-027', 'Description de la taxe 27', 3000.00, true, 'journaliere', 143, 134, 4.07, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (28, 'Taxe 28', 'TAX-028', 'Description de la taxe 28', 10000.00, true, 'mensuelle', 146, 140, 6.99, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (29, 'Taxe 29', 'TAX-029', 'Description de la taxe 29', 10000.00, true, 'trimestrielle', 142, 148, 2.96, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (30, 'Taxe 30', 'TAX-030', 'Description de la taxe 30', 3000.00, true, 'journaliere', 150, 143, 5.56, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (31, 'Taxe 31', 'TAX-031', 'Description de la taxe 31', 5000.00, false, 'mensuelle', 142, 135, 6.11, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (32, 'Taxe 32', 'TAX-032', 'Description de la taxe 32', 500.00, false, 'trimestrielle', 151, 137, 3.46, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (33, 'Taxe 33', 'TAX-033', 'Description de la taxe 33', 10000.00, false, 'hebdomadaire', 140, 141, 9.47, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (34, 'Taxe 34', 'TAX-034', 'Description de la taxe 34', 30000.00, false, 'journaliere', 143, 141, 1.73, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (35, 'Taxe 35', 'TAX-035', 'Description de la taxe 35', 10000.00, false, 'mensuelle', 145, 143, 3.68, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (36, 'Taxe 36', 'TAX-036', 'Description de la taxe 36', 15000.00, true, 'trimestrielle', 150, 147, 5.59, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (37, 'Taxe 37', 'TAX-037', 'Description de la taxe 37', 10000.00, false, 'trimestrielle', 157, 136, 9.74, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (38, 'Taxe 38', 'TAX-038', 'Description de la taxe 38', 2000.00, false, 'mensuelle', 148, 146, 1.76, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (39, 'Taxe 39', 'TAX-039', 'Description de la taxe 39', 20000.00, false, 'hebdomadaire', 149, 139, 0.95, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (40, 'Taxe 40', 'TAX-040', 'Description de la taxe 40', 30000.00, false, 'mensuelle', 156, 148, 3.74, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (41, 'Taxe 41', 'TAX-041', 'Description de la taxe 41', 1000.00, true, 'hebdomadaire', 146, 142, 7.02, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (42, 'Taxe 42', 'TAX-042', 'Description de la taxe 42', 10000.00, false, 'hebdomadaire', 147, 135, 2.28, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (43, 'Taxe 43', 'TAX-043', 'Description de la taxe 43', 15000.00, true, 'trimestrielle', 143, 146, 8.72, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (44, 'Taxe 44', 'TAX-044', 'Description de la taxe 44', 30000.00, true, 'journaliere', 146, 135, 5.50, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (45, 'Taxe 45', 'TAX-045', 'Description de la taxe 45', 20000.00, false, 'trimestrielle', 152, 141, 0.35, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (46, 'Taxe 46', 'TAX-046', 'Description de la taxe 46', 500.00, true, 'mensuelle', 151, 137, 9.96, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (47, 'Taxe 47', 'TAX-047', 'Description de la taxe 47', 15000.00, false, 'mensuelle', 148, 134, 0.28, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (48, 'Taxe 48', 'TAX-048', 'Description de la taxe 48', 10000.00, true, 'mensuelle', 147, 144, 3.15, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (49, 'Taxe 49', 'TAX-049', 'Description de la taxe 49', 3000.00, true, 'mensuelle', 150, 135, 4.20, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (50, 'Taxe 50', 'TAX-050', 'Description de la taxe 50', 500.00, true, 'journaliere', 153, 138, 4.34, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (51, 'Taxe 51', 'TAX-051', 'Description de la taxe 51', 25000.00, true, 'hebdomadaire', 151, 148, 2.84, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (52, 'Taxe 52', 'TAX-052', 'Description de la taxe 52', 1000.00, true, 'mensuelle', 141, 139, 9.40, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (53, 'Taxe 53', 'TAX-053', 'Description de la taxe 53', 25000.00, false, 'trimestrielle', 139, 142, 0.04, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (54, 'Taxe 54', 'TAX-054', 'Description de la taxe 54', 500.00, false, 'hebdomadaire', 148, 144, 7.08, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (55, 'Taxe 55', 'TAX-055', 'Description de la taxe 55', 3000.00, true, 'journaliere', 142, 134, 7.81, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (56, 'Taxe 56', 'TAX-056', 'Description de la taxe 56', 30000.00, true, 'mensuelle', 145, 142, 8.44, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (57, 'Taxe 57', 'TAX-057', 'Description de la taxe 57', 15000.00, true, 'trimestrielle', 141, 145, 4.71, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (58, 'Taxe 58', 'TAX-058', 'Description de la taxe 58', 25000.00, false, 'hebdomadaire', 148, 143, 0.76, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (59, 'Taxe 59', 'TAX-059', 'Description de la taxe 59', 30000.00, true, 'hebdomadaire', 145, 143, 8.92, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (60, 'Taxe 60', 'TAX-060', 'Description de la taxe 60', 20000.00, false, 'trimestrielle', 143, 133, 0.34, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (61, 'Taxe 61', 'TAX-061', 'Description de la taxe 61', 5000.00, false, 'hebdomadaire', 147, 145, 7.08, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (62, 'Taxe 62', 'TAX-062', 'Description de la taxe 62', 15000.00, false, 'trimestrielle', 147, 133, 3.95, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (63, 'Taxe 63', 'TAX-063', 'Description de la taxe 63', 3000.00, true, 'mensuelle', 143, 141, 6.15, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (64, 'Taxe 64', 'TAX-064', 'Description de la taxe 64', 30000.00, true, 'trimestrielle', 142, 136, 1.33, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (65, 'Taxe 65', 'TAX-065', 'Description de la taxe 65', 10000.00, true, 'trimestrielle', 152, 137, 2.97, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (66, 'Taxe 66', 'TAX-066', 'Description de la taxe 66', 20000.00, false, 'mensuelle', 148, 136, 9.19, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (67, 'Taxe 67', 'TAX-067', 'Description de la taxe 67', 25000.00, true, 'hebdomadaire', 150, 137, 5.45, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (68, 'Taxe 68', 'TAX-068', 'Description de la taxe 68', 3000.00, true, 'hebdomadaire', 143, 144, 3.68, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (69, 'Taxe 69', 'TAX-069', 'Description de la taxe 69', 25000.00, true, 'journaliere', 153, 147, 4.81, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (70, 'Taxe 70', 'TAX-070', 'Description de la taxe 70', 30000.00, true, 'hebdomadaire', 147, 145, 1.13, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (71, 'Taxe 71', 'TAX-071', 'Description de la taxe 71', 25000.00, true, 'trimestrielle', 141, 147, 1.13, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (72, 'Taxe 72', 'TAX-072', 'Description de la taxe 72', 2000.00, true, 'journaliere', 149, 134, 9.18, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (73, 'Taxe 73', 'TAX-073', 'Description de la taxe 73', 5000.00, false, 'mensuelle', 139, 141, 7.17, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (74, 'Taxe 74', 'TAX-074', 'Description de la taxe 74', 1000.00, true, 'mensuelle', 142, 148, 4.66, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (75, 'Taxe 75', 'TAX-075', 'Description de la taxe 75', 2000.00, true, 'journaliere', 140, 140, 2.84, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (76, 'Taxe 76', 'TAX-076', 'Description de la taxe 76', 10000.00, true, 'mensuelle', 145, 134, 8.69, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (77, 'Taxe 77', 'TAX-077', 'Description de la taxe 77', 500.00, true, 'mensuelle', 152, 134, 2.45, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (78, 'Taxe 78', 'TAX-078', 'Description de la taxe 78', 3000.00, false, 'trimestrielle', 143, 146, 5.76, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (79, 'Taxe 79', 'TAX-079', 'Description de la taxe 79', 30000.00, false, 'hebdomadaire', 156, 147, 9.01, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (80, 'Taxe 80', 'TAX-080', 'Description de la taxe 80', 10000.00, true, 'journaliere', 151, 137, 5.47, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (81, 'Taxe 81', 'TAX-081', 'Description de la taxe 81', 500.00, true, 'journaliere', 149, 145, 4.82, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (82, 'Taxe 82', 'TAX-082', 'Description de la taxe 82', 3000.00, true, 'journaliere', 143, 135, 5.02, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (83, 'Taxe 83', 'TAX-083', 'Description de la taxe 83', 10000.00, true, 'mensuelle', 156, 140, 3.08, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (84, 'Taxe 84', 'TAX-084', 'Description de la taxe 84', 30000.00, true, 'hebdomadaire', 146, 147, 9.47, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (85, 'Taxe 85', 'TAX-085', 'Description de la taxe 85', 25000.00, true, 'journaliere', 143, 137, 8.67, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (86, 'Taxe 86', 'TAX-086', 'Description de la taxe 86', 3000.00, false, 'mensuelle', 150, 144, 0.33, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (87, 'Taxe 87', 'TAX-087', 'Description de la taxe 87', 500.00, false, 'mensuelle', 157, 146, 5.62, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (88, 'Taxe 88', 'TAX-088', 'Description de la taxe 88', 10000.00, true, 'trimestrielle', 148, 140, 8.67, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (89, 'Taxe 89', 'TAX-089', 'Description de la taxe 89', 500.00, true, 'journaliere', 145, 138, 8.63, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (90, 'Taxe 90', 'TAX-090', 'Description de la taxe 90', 30000.00, false, 'mensuelle', 152, 133, 6.42, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (91, 'Taxe 91', 'TAX-091', 'Description de la taxe 91', 500.00, false, 'mensuelle', 153, 144, 3.76, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (92, 'Taxe 92', 'TAX-092', 'Description de la taxe 92', 25000.00, true, 'trimestrielle', 152, 146, 7.92, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (93, 'Taxe 93', 'TAX-093', 'Description de la taxe 93', 1000.00, true, 'journaliere', 152, 148, 5.69, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (94, 'Taxe 94', 'TAX-094', 'Description de la taxe 94', 500.00, true, 'trimestrielle', 146, 145, 6.02, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (95, 'Taxe 95', 'TAX-095', 'Description de la taxe 95', 2000.00, false, 'mensuelle', 149, 143, 0.67, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (96, 'Taxe 96', 'TAX-096', 'Description de la taxe 96', 500.00, false, 'journaliere', 154, 135, 4.26, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (97, 'Taxe 97', 'TAX-097', 'Description de la taxe 97', 2000.00, true, 'trimestrielle', 156, 143, 9.06, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (98, 'Taxe 98', 'TAX-098', 'Description de la taxe 98', 5000.00, true, 'trimestrielle', 140, 143, 0.24, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (99, 'Taxe 99', 'TAX-099', 'Description de la taxe 99', 15000.00, true, 'hebdomadaire', 144, 139, 5.09, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');
INSERT INTO public.taxe VALUES (100, 'Taxe 100', 'TAX-100', 'Description de la taxe 100', 15000.00, true, 'journaliere', 150, 141, 2.55, true, '2025-11-20 21:29:20.212912', '2025-11-20 21:29:20.212912');


--
-- Data for Name: affectation_taxe; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.affectation_taxe VALUES (51, 251, 3, '2025-10-19 23:32:52.971408', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (52, 251, 82, '2025-10-15 17:39:10.472585', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (53, 251, 56, '2025-05-31 10:29:44.361536', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (54, 252, 44, '2025-11-14 07:18:04.506818', '2026-11-14 07:18:04.506818', 35113.11, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (55, 253, 29, '2025-09-03 15:42:53.324267', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (56, 253, 45, '2025-06-29 06:29:00.805789', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (57, 254, 1, '2025-11-15 09:58:12.100597', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (58, 254, 70, '2025-07-01 13:07:21.656773', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (59, 254, 90, '2025-11-16 16:25:09.564287', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (60, 255, 28, '2025-06-29 21:39:03.153336', NULL, 14625.01, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (61, 256, 9, '2025-09-08 21:33:10.543792', '2026-09-08 21:33:10.543792', NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (62, 256, 52, '2025-05-31 07:49:40.969189', '2026-05-31 07:49:40.969189', NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (63, 257, 46, '2025-06-16 21:07:54.874696', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (64, 257, 80, '2025-06-05 01:54:05.376968', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (65, 257, 58, '2025-08-04 06:03:48.346275', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (66, 258, 2, '2025-08-09 04:51:09.560321', NULL, 25656.63, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (67, 259, 57, '2025-09-26 23:47:42.14542', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (68, 259, 92, '2025-11-05 10:36:12.877877', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (69, 260, 93, '2025-10-10 06:43:49.575687', '2026-10-10 06:43:49.575687', NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (70, 260, 87, '2025-10-24 16:03:28.538919', '2026-10-24 16:03:28.538919', NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (71, 260, 53, '2025-08-14 15:06:19.387576', '2026-08-14 15:06:19.387576', NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (72, 261, 37, '2025-09-30 18:06:01.483255', NULL, 10964.63, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (73, 262, 34, '2025-11-08 18:33:22.167749', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (74, 262, 57, '2025-07-23 03:12:43.984448', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (75, 263, 62, '2025-11-01 19:47:56.025701', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (76, 263, 67, '2025-10-27 07:26:39.502975', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (77, 263, 75, '2025-11-17 18:25:27.577323', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (78, 264, 13, '2025-11-05 15:16:54.332683', '2026-11-05 15:16:54.332683', 12061.58, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (79, 265, 8, '2025-10-09 13:27:21.17565', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (80, 265, 4, '2025-11-04 02:49:51.226436', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (81, 266, 82, '2025-09-20 07:10:55.763929', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (82, 266, 64, '2025-06-17 04:04:46.135971', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (83, 266, 38, '2025-08-18 22:41:54.526973', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (84, 267, 85, '2025-10-16 13:09:33.421988', NULL, 30231.43, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (85, 268, 16, '2025-07-27 07:25:57.935136', '2026-07-27 07:25:57.935136', NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (86, 268, 29, '2025-10-21 10:45:33.739488', '2026-10-21 10:45:33.739488', NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (87, 269, 7, '2025-07-23 08:10:38.93112', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (88, 269, 99, '2025-07-07 21:37:38.733422', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (89, 269, 17, '2025-06-15 03:33:32.325808', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (90, 270, 78, '2025-06-16 22:47:35.488038', NULL, 4182.49, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (91, 271, 96, '2025-11-06 22:50:03.160787', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (92, 271, 90, '2025-07-07 01:09:50.035908', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (93, 272, 21, '2025-06-25 21:00:40.806695', '2026-06-25 21:00:40.806695', NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (94, 272, 51, '2025-08-17 04:35:12.502434', '2026-08-17 04:35:12.502434', NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (95, 272, 35, '2025-09-04 08:56:12.739965', '2026-09-04 08:56:12.739965', NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (96, 273, 41, '2025-08-20 18:09:03.458821', NULL, 1151.42, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (97, 274, 2, '2025-07-20 04:31:34.463447', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (98, 274, 58, '2025-11-03 05:38:59.740851', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (99, 275, 7, '2025-10-22 14:19:51.625655', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.affectation_taxe VALUES (100, 275, 57, '2025-09-19 23:30:52.138368', NULL, NULL, true, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');


--
-- Data for Name: ville; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: commune; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: arrondissement; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: badge_collecteur; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: badge_feedback; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: caisse; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.caisse VALUES (1, 351, 'physique', 'ouverte', 'CAISSE-PHYS-COL-001', 'Caisse physique NDONG', 50000.00, 75000.00, '2025-11-26 04:01:37.80102', NULL, NULL, NULL, 'Caisse principale pour NDONG Marie', true, '2025-11-26 06:01:37.823676', '2025-11-26 06:01:37.823676');
INSERT INTO public.caisse VALUES (2, 351, 'en_ligne', 'ouverte', 'CAISSE-ONLINE-COL-001', 'Caisse mobile NDONG', 0.00, 25000.00, '2025-11-26 05:01:37.80102', NULL, NULL, NULL, 'Caisse mobile money pour NDONG', true, '2025-11-26 06:01:37.823676', '2025-11-26 06:01:37.823676');
INSERT INTO public.caisse VALUES (3, 352, 'physique', 'fermee', 'CAISSE-PHYS-COL-002', 'Caisse physique OBAME', 50000.00, 45000.00, NULL, NULL, NULL, NULL, 'Caisse principale pour OBAME Pierre', true, '2025-11-26 06:01:37.823676', '2025-11-26 06:01:37.823676');
INSERT INTO public.caisse VALUES (4, 352, 'en_ligne', 'fermee', 'CAISSE-ONLINE-COL-002', 'Caisse mobile OBAME', 0.00, 15000.00, NULL, NULL, NULL, NULL, 'Caisse mobile money pour OBAME', true, '2025-11-26 06:01:37.823676', '2025-11-26 06:01:37.823676');
INSERT INTO public.caisse VALUES (5, 353, 'physique', 'ouverte', 'CAISSE-PHYS-COL-003', 'Caisse physique BONGO', 50000.00, 75000.00, '2025-11-26 04:01:37.80102', NULL, NULL, NULL, 'Caisse principale pour BONGO Paul', true, '2025-11-26 06:01:37.823676', '2025-11-26 06:01:37.823676');
INSERT INTO public.caisse VALUES (6, 353, 'en_ligne', 'ouverte', 'CAISSE-ONLINE-COL-003', 'Caisse mobile BONGO', 0.00, 25000.00, '2025-11-26 05:01:37.80102', NULL, NULL, NULL, 'Caisse mobile money pour BONGO', true, '2025-11-26 06:01:37.823676', '2025-11-26 06:01:37.823676');
INSERT INTO public.caisse VALUES (7, 354, 'physique', 'fermee', 'CAISSE-PHYS-COL-004', 'Caisse physique ESSONO', 50000.00, 45000.00, NULL, NULL, NULL, NULL, 'Caisse principale pour ESSONO Sophie', true, '2025-11-26 06:01:37.823676', '2025-11-26 06:01:37.823676');
INSERT INTO public.caisse VALUES (8, 354, 'en_ligne', 'fermee', 'CAISSE-ONLINE-COL-004', 'Caisse mobile ESSONO', 0.00, 15000.00, NULL, NULL, NULL, NULL, 'Caisse mobile money pour ESSONO', true, '2025-11-26 06:01:37.823676', '2025-11-26 06:01:37.823676');
INSERT INTO public.caisse VALUES (9, 355, 'physique', 'ouverte', 'CAISSE-PHYS-COL-005', 'Caisse physique MVE', 50000.00, 75000.00, '2025-11-26 04:01:37.80102', NULL, NULL, NULL, 'Caisse principale pour MVE Luc', true, '2025-11-26 06:01:37.824829', '2025-11-26 06:01:37.824829');
INSERT INTO public.caisse VALUES (10, 355, 'en_ligne', 'ouverte', 'CAISSE-ONLINE-COL-005', 'Caisse mobile MVE', 0.00, 25000.00, '2025-11-26 05:01:37.80102', NULL, NULL, NULL, 'Caisse mobile money pour MVE', true, '2025-11-26 06:01:37.824829', '2025-11-26 06:01:37.824829');


--
-- Data for Name: info_collecte; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.info_collecte VALUES (51, 254, 1, 378, 1000.00, 50.00, 'mobile_money', 'completed', 'COL-20251022-0001', NULL, '2025-10-22 19:35:01.4232', NULL, false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (52, 261, 37, 392, 10000.00, 974.00, 'carte', 'completed', 'COL-20250905-0002', NULL, '2025-09-05 16:35:16.313203', NULL, true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (53, 257, 58, 395, 25000.00, 190.00, 'especes', 'pending', 'COL-20250903-0003', NULL, '2025-09-03 04:04:52.405054', '2025-09-03 04:25:13.380593', false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (54, 263, 67, 366, 25000.00, 1362.50, 'mobile_money', 'failed', 'COL-20250926-0004', NULL, '2025-09-26 03:17:04.2157', NULL, true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (55, 253, 29, 389, 10000.00, 296.00, 'carte', 'completed', 'COL-20251110-0005', NULL, '2025-11-10 06:59:00.669669', NULL, false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (56, 262, 57, 388, 15000.00, 706.50, 'especes', 'completed', 'COL-20251024-0006', '{"5000" : 6, "1000" : 6}', '2025-10-24 01:36:34.392902', '2025-10-24 06:01:50.742308', true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (57, 263, 75, 356, 2000.00, 56.80, 'mobile_money', 'completed', 'COL-20251105-0007', NULL, '2025-11-05 15:15:59.223944', NULL, false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (58, 269, 7, 394, 2000.00, 41.20, 'carte', 'pending', 'COL-20251013-0008', NULL, '2025-10-13 04:25:34.071749', NULL, true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (59, 266, 38, 356, 2000.00, 35.20, 'especes', 'failed', 'COL-20251028-0009', NULL, '2025-10-28 01:36:39.135233', '2025-10-28 07:19:17.651615', false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (60, 272, 35, 369, 10000.00, 368.00, 'mobile_money', 'completed', 'COL-20250928-0010', NULL, '2025-09-28 21:26:59.295893', NULL, true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (61, 254, 90, 378, 30000.00, 1926.00, 'carte', 'completed', 'COL-20250906-0011', NULL, '2025-09-06 12:10:39.120626', NULL, false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (62, 268, 29, 362, 10000.00, 296.00, 'especes', 'completed', 'COL-20250915-0012', '{"5000" : 2, "1000" : 12}', '2025-09-15 01:05:35.168148', '2025-09-15 07:47:13.021287', true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (63, 272, 35, 363, 10000.00, 368.00, 'mobile_money', 'pending', 'COL-20250929-0013', NULL, '2025-09-29 07:38:24.999414', NULL, false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (64, 254, 90, 358, 30000.00, 1926.00, 'carte', 'failed', 'COL-20251017-0014', NULL, '2025-10-17 00:03:26.963089', NULL, true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (65, 263, 62, 393, 15000.00, 592.50, 'especes', 'completed', 'COL-20251016-0015', NULL, '2025-10-16 20:37:06.085224', '2025-10-17 02:22:03.218418', false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (66, 268, 16, 384, 30000.00, 543.00, 'mobile_money', 'completed', 'COL-20251023-0016', NULL, '2025-10-23 06:00:39.893199', NULL, true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (67, 269, 17, 369, 20000.00, 1414.00, 'carte', 'completed', 'COL-20250828-0017', NULL, '2025-08-28 11:33:09.684128', NULL, false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (68, 274, 58, 353, 25000.00, 190.00, 'especes', 'pending', 'COL-20251118-0018', '{"5000" : 8, "1000" : 18}', '2025-11-18 04:57:14.312933', '2025-11-18 10:47:12.829179', true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (69, 269, 99, 396, 15000.00, 763.50, 'mobile_money', 'failed', 'COL-20251115-0019', NULL, '2025-11-15 17:01:43.948056', NULL, false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (70, 256, 9, 355, 30000.00, 2370.00, 'carte', 'completed', 'COL-20251029-0020', NULL, '2025-10-29 04:24:02.105094', NULL, true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (71, 271, 96, 368, 500.00, 21.30, 'especes', 'completed', 'COL-20250929-0021', NULL, '2025-09-29 03:45:33.226162', '2025-09-29 04:29:40.623182', false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (72, 256, 9, 358, 30000.00, 2370.00, 'mobile_money', 'completed', 'COL-20251020-0022', NULL, '2025-10-20 16:05:30.127434', NULL, true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (73, 260, 87, 392, 500.00, 28.10, 'carte', 'pending', 'COL-20250930-0023', NULL, '2025-09-30 03:16:00.101825', NULL, false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (74, 256, 52, 394, 1000.00, 94.00, 'especes', 'failed', 'COL-20251109-0024', '{"5000" : 4, "1000" : 4}', '2025-11-09 12:45:03.760266', '2025-11-09 18:01:56.245707', true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (75, 257, 80, 369, 10000.00, 547.00, 'mobile_money', 'completed', 'COL-20251008-0025', NULL, '2025-10-08 10:43:48.254514', NULL, false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (76, 262, 34, 397, 30000.00, 519.00, 'carte', 'completed', 'COL-20251022-0026', NULL, '2025-10-22 06:29:43.263858', NULL, true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (77, 257, 80, 390, 10000.00, 547.00, 'especes', 'completed', 'COL-20251002-0027', NULL, '2025-10-02 00:15:00.2336', '2025-10-02 03:51:05.214849', false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (78, 257, 58, 371, 25000.00, 190.00, 'mobile_money', 'pending', 'COL-20251107-0028', NULL, '2025-11-07 13:03:35.4582', NULL, true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (79, 265, 4, 391, 15000.00, 600.00, 'carte', 'failed', 'COL-20251116-0029', NULL, '2025-11-16 06:00:34.753911', NULL, false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (80, 256, 9, 388, 30000.00, 2370.00, 'especes', 'completed', 'COL-20250923-0030', '{"5000" : 0, "1000" : 10}', '2025-09-23 21:58:04.46501', '2025-09-24 05:27:31.269091', true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (81, 265, 4, 360, 15000.00, 600.00, 'mobile_money', 'completed', 'COL-20251120-0031', NULL, '2025-11-20 13:30:28.843512', NULL, false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (82, 271, 90, 388, 30000.00, 1926.00, 'carte', 'completed', 'COL-20251012-0032', NULL, '2025-10-12 17:54:31.988303', NULL, true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (83, 257, 46, 397, 500.00, 49.80, 'especes', 'pending', 'COL-20251001-0033', NULL, '2025-10-01 01:56:44.051218', '2025-10-01 02:42:33.356225', false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (84, 263, 75, 369, 2000.00, 56.80, 'mobile_money', 'failed', 'COL-20250924-0034', NULL, '2025-09-24 17:24:15.954807', NULL, true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (85, 254, 1, 379, 1000.00, 50.00, 'carte', 'completed', 'COL-20251007-0035', NULL, '2025-10-07 09:56:59.735989', NULL, false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (86, 269, 17, 357, 20000.00, 1414.00, 'especes', 'completed', 'COL-20251113-0036', '{"5000" : 6, "1000" : 16}', '2025-11-13 11:59:48.741197', '2025-11-13 16:30:13.644482', true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (87, 258, 2, 381, 25000.00, 1250.00, 'mobile_money', 'completed', 'COL-20250922-0037', NULL, '2025-09-22 19:29:30.420596', NULL, false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (88, 260, 53, 365, 25000.00, 10.00, 'carte', 'pending', 'COL-20251007-0038', NULL, '2025-10-07 03:59:14.929317', NULL, true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (89, 254, 70, 389, 30000.00, 339.00, 'especes', 'failed', 'COL-20250829-0039', NULL, '2025-08-29 14:28:27.744597', '2025-08-29 18:51:05.333083', false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (90, 268, 16, 394, 30000.00, 543.00, 'mobile_money', 'completed', 'COL-20251006-0040', NULL, '2025-10-06 23:04:28.807814', NULL, true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (91, 256, 9, 378, 30000.00, 2370.00, 'carte', 'completed', 'COL-20250917-0041', NULL, '2025-09-17 20:59:08.43451', NULL, false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (92, 253, 45, 353, 20000.00, 70.00, 'especes', 'completed', 'COL-20250902-0042', '{"5000" : 2, "1000" : 2}', '2025-09-02 01:35:13.092118', '2025-09-02 01:52:48.972549', true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (93, 253, 29, 367, 10000.00, 296.00, 'mobile_money', 'pending', 'COL-20250929-0043', NULL, '2025-09-29 18:08:25.464494', NULL, false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (94, 275, 7, 368, 2000.00, 41.20, 'carte', 'failed', 'COL-20250929-0044', NULL, '2025-09-29 16:59:07.800279', NULL, true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (95, 265, 8, 369, 25000.00, 2240.00, 'especes', 'completed', 'COL-20250826-0045', NULL, '2025-08-26 08:00:16.976428', '2025-08-26 11:04:57.029665', false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (96, 265, 8, 361, 25000.00, 2240.00, 'mobile_money', 'completed', 'COL-20250917-0046', NULL, '2025-09-17 02:28:16.321617', NULL, true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (97, 261, 37, 400, 10000.00, 974.00, 'carte', 'completed', 'COL-20250907-0047', NULL, '2025-09-07 17:29:07.449112', NULL, false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (98, 274, 58, 392, 25000.00, 190.00, 'especes', 'pending', 'COL-20250902-0048', '{"5000" : 8, "1000" : 8}', '2025-09-02 09:22:40.692876', '2025-09-02 11:34:44.851824', true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (99, 259, 92, 397, 25000.00, 1980.00, 'mobile_money', 'failed', 'COL-20250928-0049', NULL, '2025-09-28 16:49:08.301356', NULL, false, false, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.info_collecte VALUES (100, 268, 29, 376, 10000.00, 296.00, 'carte', 'completed', 'COL-20251011-0050', NULL, '2025-10-11 17:06:18.947849', NULL, true, true, false, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');


--
-- Data for Name: collecte_location; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: collecteur_zone; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: utilisateur; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.utilisateur VALUES (2, 'NDONG', 'Marie', 'user1@mairie-libreville.ga', '+241063000001', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_back_office', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (3, 'OBAME', 'Pierre', 'user2@mairie-libreville.ga', '+241063000002', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_front_office', true, '2025-11-15 10:12:42.289681', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (4, 'BONGO', 'Paul', 'user3@mairie-libreville.ga', '+241063000003', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'controleur_interne', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (5, 'ESSONO', 'Sophie', 'user4@mairie-libreville.ga', '+241063000004', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'collecteur', false, '2025-11-04 05:22:45.638806', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (6, 'MVE', 'Luc', 'user5@mairie-libreville.ga', '+241063000005', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'admin', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (7, 'MINTSA', 'Anne', 'user6@mairie-libreville.ga', '+241063000006', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_back_office', true, '2025-10-23 23:48:18.673569', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (8, 'MBOUMBA', 'David', 'user7@mairie-libreville.ga', '+241063000007', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_front_office', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (9, 'NDONG', 'Jean', 'user8@mairie-libreville.ga', '+241063000008', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'controleur_interne', false, '2025-11-15 01:49:33.899711', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (10, 'OBAME', 'Marie', 'user9@mairie-libreville.ga', '+241063000009', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'collecteur', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (11, 'BONGO', 'Pierre', 'user10@mairie-libreville.ga', '+241063000010', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'admin', true, '2025-11-10 13:18:50.768492', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (12, 'ESSONO', 'Paul', 'user11@mairie-libreville.ga', '+241063000011', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_back_office', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (13, 'MVE', 'Sophie', 'user12@mairie-libreville.ga', '+241063000012', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_front_office', false, '2025-11-13 01:58:32.206235', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (14, 'MINTSA', 'Luc', 'user13@mairie-libreville.ga', '+241063000013', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'controleur_interne', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (15, 'MBOUMBA', 'Anne', 'user14@mairie-libreville.ga', '+241063000014', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'collecteur', true, '2025-11-09 00:00:05.130438', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (16, 'NDONG', 'David', 'user15@mairie-libreville.ga', '+241063000015', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'admin', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (17, 'OBAME', 'Jean', 'user16@mairie-libreville.ga', '+241063000016', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_back_office', false, '2025-11-13 22:37:40.954319', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (18, 'BONGO', 'Marie', 'user17@mairie-libreville.ga', '+241063000017', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_front_office', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (19, 'ESSONO', 'Pierre', 'user18@mairie-libreville.ga', '+241063000018', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'controleur_interne', true, '2025-10-31 05:09:22.911137', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (20, 'MVE', 'Paul', 'user19@mairie-libreville.ga', '+241063000019', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'collecteur', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (21, 'MINTSA', 'Sophie', 'user20@mairie-libreville.ga', '+241063000020', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'admin', false, '2025-11-09 03:28:22.269075', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (22, 'MBOUMBA', 'Luc', 'user21@mairie-libreville.ga', '+241063000021', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_back_office', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (23, 'NDONG', 'Anne', 'user22@mairie-libreville.ga', '+241063000022', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_front_office', true, '2025-11-19 22:20:25.102268', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (24, 'OBAME', 'David', 'user23@mairie-libreville.ga', '+241063000023', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'controleur_interne', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (25, 'BONGO', 'Jean', 'user24@mairie-libreville.ga', '+241063000024', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'collecteur', false, '2025-10-26 12:40:29.115204', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (26, 'ESSONO', 'Marie', 'user25@mairie-libreville.ga', '+241063000025', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'admin', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (27, 'MVE', 'Pierre', 'user26@mairie-libreville.ga', '+241063000026', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_back_office', true, '2025-11-09 16:53:24.622753', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (28, 'MINTSA', 'Paul', 'user27@mairie-libreville.ga', '+241063000027', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_front_office', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (29, 'MBOUMBA', 'Sophie', 'user28@mairie-libreville.ga', '+241063000028', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'controleur_interne', false, '2025-11-15 19:03:58.148097', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (30, 'NDONG', 'Luc', 'user29@mairie-libreville.ga', '+241063000029', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'collecteur', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (31, 'OBAME', 'Anne', 'user30@mairie-libreville.ga', '+241063000030', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'admin', true, '2025-10-23 21:52:21.121149', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (32, 'BONGO', 'David', 'user31@mairie-libreville.ga', '+241063000031', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_back_office', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (33, 'ESSONO', 'Jean', 'user32@mairie-libreville.ga', '+241063000032', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_front_office', false, '2025-11-04 23:34:22.727327', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (34, 'MVE', 'Marie', 'user33@mairie-libreville.ga', '+241063000033', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'controleur_interne', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (35, 'MINTSA', 'Pierre', 'user34@mairie-libreville.ga', '+241063000034', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'collecteur', true, '2025-11-05 13:37:27.614067', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (36, 'MBOUMBA', 'Paul', 'user35@mairie-libreville.ga', '+241063000035', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'admin', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (37, 'NDONG', 'Sophie', 'user36@mairie-libreville.ga', '+241063000036', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_back_office', false, '2025-11-16 16:35:16.80156', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (38, 'OBAME', 'Luc', 'user37@mairie-libreville.ga', '+241063000037', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_front_office', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (39, 'BONGO', 'Anne', 'user38@mairie-libreville.ga', '+241063000038', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'controleur_interne', true, '2025-10-22 18:45:03.201236', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (40, 'ESSONO', 'David', 'user39@mairie-libreville.ga', '+241063000039', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'collecteur', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (41, 'MVE', 'Jean', 'user40@mairie-libreville.ga', '+241063000040', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'admin', false, '2025-10-22 08:19:12.265502', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (42, 'MINTSA', 'Marie', 'user41@mairie-libreville.ga', '+241063000041', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_back_office', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (43, 'MBOUMBA', 'Pierre', 'user42@mairie-libreville.ga', '+241063000042', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_front_office', true, '2025-11-07 16:01:33.325985', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (44, 'NDONG', 'Paul', 'user43@mairie-libreville.ga', '+241063000043', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'controleur_interne', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (45, 'OBAME', 'Sophie', 'user44@mairie-libreville.ga', '+241063000044', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'collecteur', false, '2025-11-19 13:24:47.265523', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (46, 'BONGO', 'Luc', 'user45@mairie-libreville.ga', '+241063000045', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'admin', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (47, 'ESSONO', 'Anne', 'user46@mairie-libreville.ga', '+241063000046', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_back_office', true, '2025-11-17 00:00:08.208066', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (48, 'MVE', 'David', 'user47@mairie-libreville.ga', '+241063000047', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'agent_front_office', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (49, 'MINTSA', 'Jean', 'user48@mairie-libreville.ga', '+241063000048', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'controleur_interne', false, '2025-11-19 23:04:51.7253', '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (50, 'MBOUMBA', 'Marie', 'user49@mairie-libreville.ga', '+241063000049', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5', 'collecteur', true, NULL, '2025-11-20 22:59:10.253041', '2025-11-20 22:59:10.253041');
INSERT INTO public.utilisateur VALUES (51, 'marina', 'MARINA BRUNELLE', 'collecteurmar@mairie-libreville.ga', '+24107861364', '$2b$12$iA5mRDoogCIALdSFX8hK2eoldGat8B/CR9IUzpjvqT4eKqLL8fv8e', 'collecteur', false, NULL, '2025-11-30 11:32:40.867217', '2025-11-30 13:05:10.327323');
INSERT INTO public.utilisateur VALUES (1, 'Admin', 'SystÃ¨me', 'admin@mairie-libreville.ga', '+241062345678', '$2a$06$gGjbEBFuRu1eA9rJv27R3eQgglx1PcX75imAK0tsjEV/XxdG9qhhm', 'admin', true, '2026-01-18 23:55:21.774884', '2025-11-20 22:59:10.253041', '2026-01-19 00:55:21.768978');


--
-- Data for Name: commission_fichier; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.commission_fichier VALUES (1, '2025-10-20', 'commissions\commission_2025-10-20_1764083832.json', 'json', 'en_attente', '2025-11-25 16:17:12.311708', 1, '{"total_collecteurs": 1}');
INSERT INTO public.commission_fichier VALUES (2, '2025-11-20', 'commissions\commission_2025-11-20_1764084407.json', 'json', 'en_attente', '2025-11-25 16:26:47.879628', 1, '{"format": "json", "total_collecteurs": 1}');
INSERT INTO public.commission_fichier VALUES (3, '2025-11-20', 'commissions\commission_2025-11-20_1764084615.pdf', 'pdf', 'en_attente', '2025-11-25 16:30:15.968275', 1, '{"format": "pdf", "total_collecteurs": 1}');
INSERT INTO public.commission_fichier VALUES (4, '2025-11-20', 'commissions\commission_2025-11-20_1764084798.json', 'json', 'en_attente', '2025-11-25 16:33:18.56884', 1, '{"format": "json", "total_collecteurs": 1}');
INSERT INTO public.commission_fichier VALUES (5, '2025-11-20', 'commissions\commission_2025-11-20_1764084802.pdf', 'pdf', 'en_attente', '2025-11-25 16:33:22.65246', 1, '{"format": "pdf", "total_collecteurs": 1}');
INSERT INTO public.commission_fichier VALUES (8, '2025-11-25', 'commissions/commission_2025-11-25_demo.json', 'json', 'en_attente', '2025-11-26 06:05:18.478441', 2, '{"format": "json", "total_collecteurs": 5, "montant_total_collecte": 1264286.0}');
INSERT INTO public.commission_fichier VALUES (9, '2025-11-24', 'commissions/commission_2025-11-24_demo.json', 'json', 'envoyee', '2025-11-26 06:05:18.483825', 2, '{"format": "json", "total_collecteurs": 5, "montant_total_collecte": 1316877.0}');
INSERT INTO public.commission_fichier VALUES (10, '2025-11-23', 'commissions/commission_2025-11-23_demo.json', 'json', 'envoyee', '2025-11-26 06:05:18.498711', 2, '{"format": "json", "total_collecteurs": 5, "montant_total_collecte": 1522943.0}');


--
-- Data for Name: commission_journaliere; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.commission_journaliere VALUES (1, '2025-10-20', 358, 30000.00, 2370.00, 7.90, 'en_attente', 1, '2025-11-25 16:17:12.341026');
INSERT INTO public.commission_journaliere VALUES (5, '2025-11-20', 360, 15000.00, 600.00, 4.00, 'en_attente', 5, '2025-11-25 16:33:22.708989');
INSERT INTO public.commission_journaliere VALUES (6, '2025-11-25', 351, 74333.00, 3716.65, 5.00, 'en_attente', 8, '2025-11-26 06:05:18.486856');
INSERT INTO public.commission_journaliere VALUES (7, '2025-11-25', 352, 335208.00, 16760.40, 5.00, 'en_attente', 8, '2025-11-26 06:05:18.486856');
INSERT INTO public.commission_journaliere VALUES (8, '2025-11-25', 353, 343508.00, 17175.40, 5.00, 'en_attente', 8, '2025-11-26 06:05:18.486856');
INSERT INTO public.commission_journaliere VALUES (9, '2025-11-25', 354, 241028.00, 12051.40, 5.00, 'en_attente', 8, '2025-11-26 06:05:18.486856');
INSERT INTO public.commission_journaliere VALUES (10, '2025-11-25', 355, 270209.00, 13510.45, 5.00, 'en_attente', 8, '2025-11-26 06:05:18.486856');
INSERT INTO public.commission_journaliere VALUES (11, '2025-11-24', 351, 453943.00, 22697.15, 5.00, 'payee', 9, '2025-11-26 06:05:18.501711');
INSERT INTO public.commission_journaliere VALUES (12, '2025-11-24', 352, 216429.00, 10821.45, 5.00, 'payee', 9, '2025-11-26 06:05:18.501711');
INSERT INTO public.commission_journaliere VALUES (13, '2025-11-24', 353, 352170.00, 17608.50, 5.00, 'payee', 9, '2025-11-26 06:05:18.501711');
INSERT INTO public.commission_journaliere VALUES (14, '2025-11-24', 354, 169617.00, 8480.85, 5.00, 'payee', 9, '2025-11-26 06:05:18.501711');
INSERT INTO public.commission_journaliere VALUES (15, '2025-11-24', 355, 124718.00, 6235.90, 5.00, 'payee', 9, '2025-11-26 06:05:18.501711');
INSERT INTO public.commission_journaliere VALUES (16, '2025-11-23', 351, 290127.00, 14506.35, 5.00, 'payee', 10, '2025-11-26 06:05:18.505149');
INSERT INTO public.commission_journaliere VALUES (17, '2025-11-23', 352, 339578.00, 16978.90, 5.00, 'payee', 10, '2025-11-26 06:05:18.505149');
INSERT INTO public.commission_journaliere VALUES (18, '2025-11-23', 353, 486166.00, 24308.30, 5.00, 'payee', 10, '2025-11-26 06:05:18.505149');
INSERT INTO public.commission_journaliere VALUES (19, '2025-11-23', 354, 230836.00, 11541.80, 5.00, 'payee', 10, '2025-11-26 06:05:18.505149');
INSERT INTO public.commission_journaliere VALUES (20, '2025-11-23', 355, 176236.00, 8811.80, 5.00, 'payee', 10, '2025-11-26 06:05:18.505149');


--
-- Data for Name: coupure_caisse; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.coupure_caisse VALUES (1, 50.00, 'XAF', 'piece', NULL, 1, true, '2025-11-26 08:04:45.226295', '2025-11-26 08:04:45.226295');
INSERT INTO public.coupure_caisse VALUES (2, 100.00, 'XAF', 'piece', NULL, 2, true, '2025-11-26 08:04:45.226295', '2025-11-26 08:04:45.226295');
INSERT INTO public.coupure_caisse VALUES (3, 500.00, 'XAF', 'billet', NULL, 3, true, '2025-11-26 08:04:45.226295', '2025-11-26 08:04:45.226295');
INSERT INTO public.coupure_caisse VALUES (4, 1000.00, 'XAF', 'billet', NULL, 4, true, '2025-11-26 08:04:45.226295', '2025-11-26 08:04:45.226295');
INSERT INTO public.coupure_caisse VALUES (5, 2000.00, 'XAF', 'billet', NULL, 5, true, '2025-11-26 08:04:45.226295', '2025-11-26 08:04:45.226295');
INSERT INTO public.coupure_caisse VALUES (6, 5000.00, 'XAF', 'billet', NULL, 6, true, '2025-11-26 08:04:45.226295', '2025-11-26 08:04:45.226295');
INSERT INTO public.coupure_caisse VALUES (7, 10000.00, 'XAF', 'billet', NULL, 7, true, '2025-11-26 08:04:45.226295', '2025-11-26 08:04:45.226295');


--
-- Data for Name: dossier_impaye; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.dossier_impaye VALUES (1, 251, 51, 5000.00, 0.00, 5000.00, 100.00, '2025-11-18 23:32:52.971408', 4, 'en_cours', 'faible', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (2, 251, 52, 3000.00, 0.00, 3000.00, 570.00, '2025-10-15 17:39:10.472585', 38, 'en_cours', 'normale', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (3, 251, 53, 30000.00, 0.00, 30000.00, 21750.00, '2025-06-30 10:29:44.361536', 145, 'en_cours', 'urgente', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (4, 252, 54, 35113.11, 0.00, 35113.11, 1580.09, '2025-11-14 07:18:04.506818', 9, 'en_cours', 'faible', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (5, 254, 57, 1000.00, 0.00, 1000.00, 35.00, '2025-11-15 09:58:12.100597', 7, 'en_cours', 'faible', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (6, 254, 58, 30000.00, 0.00, 30000.00, 20550.00, '2025-07-08 13:07:21.656773', 137, 'en_cours', 'urgente', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (7, 255, 60, 14625.01, 0.00, 14625.01, 8482.51, '2025-07-29 21:39:03.153336', 116, 'en_cours', 'urgente', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (8, 256, 62, 1000.00, 0.00, 1000.00, 730.00, '2025-06-30 07:49:40.969189', 146, 'en_cours', 'urgente', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (9, 257, 63, 500.00, 0.00, 500.00, 322.50, '2025-07-16 21:07:54.874696', 129, 'en_cours', 'urgente', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (10, 257, 65, 25000.00, 0.00, 25000.00, 13000.00, '2025-08-11 06:03:48.346275', 104, 'en_cours', 'urgente', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (11, 258, 66, 25656.63, 25000.00, 656.63, 249.52, '2025-09-08 04:51:09.560321', 76, 'en_cours', 'elevee', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (12, 260, 69, 1000.00, 0.00, 1000.00, 220.00, '2025-10-10 06:43:49.575687', 44, 'en_cours', 'normale', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (13, 260, 71, 25000.00, 0.00, 25000.00, 1250.00, '2025-11-12 15:06:19.387576', 10, 'en_cours', 'faible', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (14, 262, 73, 30000.00, 0.00, 30000.00, 2100.00, '2025-11-08 18:33:22.167749', 14, 'en_cours', 'faible', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (15, 263, 76, 25000.00, 0.00, 25000.00, 2500.00, '2025-11-03 07:26:39.502975', 20, 'en_cours', 'faible', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (16, 266, 81, 3000.00, 0.00, 3000.00, 960.00, '2025-09-20 07:10:55.763929', 64, 'en_cours', 'elevee', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (17, 266, 82, 30000.00, 0.00, 30000.00, 10350.00, '2025-09-15 04:04:46.135971', 69, 'en_cours', 'elevee', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (18, 266, 83, 2000.00, 0.00, 2000.00, 660.00, '2025-09-17 22:41:54.526973', 66, 'en_cours', 'elevee', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (19, 267, 84, 30231.43, 0.00, 30231.43, 5592.81, '2025-10-16 13:09:33.421988', 37, 'en_cours', 'normale', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (20, 269, 87, 2000.00, 0.00, 2000.00, 1160.00, '2025-07-30 08:10:38.93112', 116, 'en_cours', 'urgente', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (21, 269, 88, 15000.00, 0.00, 15000.00, 9825.00, '2025-07-14 21:37:38.733422', 131, 'en_cours', 'urgente', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (22, 270, 90, 4182.49, 0.00, 4182.49, 1442.96, '2025-09-14 22:47:35.488038', 69, 'en_cours', 'elevee', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (23, 271, 91, 500.00, 0.00, 500.00, 40.00, '2025-11-06 22:50:03.160787', 16, 'en_cours', 'faible', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (25, 272, 94, 25000.00, 0.00, 25000.00, 11375.00, '2025-08-24 04:35:12.502434', 91, 'en_cours', 'urgente', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (26, 273, 96, 1151.42, 0.00, 1151.42, 500.87, '2025-08-27 18:09:03.458821', 87, 'en_cours', 'elevee', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (27, 274, 97, 25000.00, 0.00, 25000.00, 12000.00, '2025-08-19 04:31:34.463447', 96, 'en_cours', 'urgente', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (28, 274, 98, 25000.00, 0.00, 25000.00, 1625.00, '2025-11-10 05:38:59.740851', 13, 'en_cours', 'faible', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (29, 275, 99, 2000.00, 0.00, 2000.00, 240.00, '2025-10-29 14:19:51.625655', 24, 'en_cours', 'faible', NULL, 0, NULL, NULL, NULL, NULL, '2025-11-23 08:44:09.957718', '2025-11-23 08:44:09.957718');
INSERT INTO public.dossier_impaye VALUES (24, 272, 93, 2000.00, 0.00, 2000.00, 1500.00, '2025-06-25 21:00:40.806695', 150, 'en_cours', 'urgente', NULL, 0, NULL, 351, '2025-11-24 15:34:02.061734', NULL, '2025-11-23 08:44:09.957718', '2025-11-24 16:34:02.058352');


--
-- Data for Name: journal_travaux; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.journal_travaux VALUES (1, '2025-11-26', 'en_cours', 0, 0.00, 73, 1869468.00, 93282.00, 0, 0, NULL, '2025-11-26 06:01:38.057892', '2025-11-26 06:01:38.057892', NULL, NULL);
INSERT INTO public.journal_travaux VALUES (2, '2025-11-25', 'en_cours', 0, 0.00, 0, 0.00, 0.00, 11, 4, 'Journal automatique pour 2025-11-25', '2025-11-26 06:01:38.057892', '2025-11-26 06:01:38.057892', NULL, NULL);
INSERT INTO public.journal_travaux VALUES (3, '2025-11-24', 'cloture', 0, 0.00, 0, 0.00, 0.00, 1, 4, 'Journal automatique pour 2025-11-24', '2025-11-26 06:01:38.057892', '2025-11-26 06:01:38.057892', '2025-11-24 06:01:38.044369', NULL);
INSERT INTO public.journal_travaux VALUES (4, '2025-11-23', 'cloture', 0, 0.00, 0, 0.00, 0.00, 11, 1, 'Journal automatique pour 2025-11-23', '2025-11-26 06:01:38.057892', '2025-11-26 06:01:38.057892', '2025-11-23 06:01:38.047547', NULL);
INSERT INTO public.journal_travaux VALUES (5, '2025-11-22', 'cloture', 0, 0.00, 0, 0.00, 0.00, 2, 0, 'Journal automatique pour 2025-11-22', '2025-11-26 06:01:38.057892', '2025-11-26 06:01:38.057892', '2025-11-22 06:01:38.050821', NULL);
INSERT INTO public.journal_travaux VALUES (6, '2025-11-21', 'cloture', 0, 0.00, 0, 0.00, 0.00, 9, 5, 'Journal automatique pour 2025-11-21', '2025-11-26 06:01:38.057892', '2025-11-26 06:01:38.057892', '2025-11-21 06:01:38.05402', NULL);
INSERT INTO public.journal_travaux VALUES (7, '2025-11-20', 'cloture', 1, 15000.00, 0, 0.00, 0.00, 0, 1, 'Journal automatique pour 2025-11-20', '2025-11-26 06:01:38.057892', '2025-11-26 06:01:38.057892', '2025-11-20 06:01:38.056878', NULL);


--
-- Data for Name: langue_disponible; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: notification_token; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: objectif_collecteur; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: operation_caisse; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.operation_caisse VALUES (1, 351, 'ouverture', 50000.00, 'Ouverture de caisse - Solde initial', NULL, 'OP-CAISSE-PHYS-COL-001-1764140400', NULL, '2025-11-26 06:00:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 1, 0.00, 50000.00);
INSERT INTO public.operation_caisse VALUES (2, 351, 'entree', 29603.00, 'Collecte #1 - NDONG', NULL, 'ENT-CAISSE-PHYS-COL-001-1-1764140400', NULL, '2025-11-26 06:00:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 1, 50000.00, 79603.00);
INSERT INTO public.operation_caisse VALUES (3, 351, 'entree', 11616.00, 'Collecte #2 - NDONG', NULL, 'ENT-CAISSE-PHYS-COL-001-2-1764140400', NULL, '2025-11-26 06:18:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 1, 79603.00, 91219.00);
INSERT INTO public.operation_caisse VALUES (4, 351, 'entree', 7252.00, 'Collecte #3 - NDONG', NULL, 'ENT-CAISSE-PHYS-COL-001-3-1764140400', NULL, '2025-11-26 06:36:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 1, 91219.00, 98471.00);
INSERT INTO public.operation_caisse VALUES (5, 351, 'entree', 42980.00, 'Collecte #4 - NDONG', NULL, 'ENT-CAISSE-PHYS-COL-001-4-1764140400', NULL, '2025-11-26 06:54:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 1, 98471.00, 141451.00);
INSERT INTO public.operation_caisse VALUES (6, 351, 'entree', 40197.00, 'Collecte #5 - NDONG', NULL, 'ENT-CAISSE-PHYS-COL-001-5-1764140400', NULL, '2025-11-26 07:12:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 1, 141451.00, 181648.00);
INSERT INTO public.operation_caisse VALUES (7, 351, 'entree', 48933.00, 'Collecte #6 - NDONG', NULL, 'ENT-CAISSE-PHYS-COL-001-6-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 1, 181648.00, 230581.00);
INSERT INTO public.operation_caisse VALUES (8, 351, 'entree', 23363.00, 'Collecte #7 - NDONG', NULL, 'ENT-CAISSE-PHYS-COL-001-7-1764140400', NULL, '2025-11-26 07:48:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 1, 230581.00, 253944.00);
INSERT INTO public.operation_caisse VALUES (9, 351, 'entree', 25949.00, 'Collecte #8 - NDONG', NULL, 'ENT-CAISSE-PHYS-COL-001-8-1764140400', NULL, '2025-11-26 08:06:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 1, 253944.00, 279893.00);
INSERT INTO public.operation_caisse VALUES (10, 351, 'ouverture', 0.00, 'Ouverture de caisse - Solde initial', NULL, 'OP-CAISSE-ONLINE-COL-001-1764140400', NULL, '2025-11-26 06:00:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 2, 0.00, 0.00);
INSERT INTO public.operation_caisse VALUES (11, 351, 'entree', 39010.00, 'Collecte #1 - NDONG', NULL, 'ENT-CAISSE-ONLINE-COL-001-1-1764140400', NULL, '2025-11-26 06:00:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 2, 0.00, 39010.00);
INSERT INTO public.operation_caisse VALUES (12, 351, 'entree', 11531.00, 'Collecte #2 - NDONG', NULL, 'ENT-CAISSE-ONLINE-COL-001-2-1764140400', NULL, '2025-11-26 06:18:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 2, 39010.00, 50541.00);
INSERT INTO public.operation_caisse VALUES (13, 351, 'entree', 6882.00, 'Collecte #3 - NDONG', NULL, 'ENT-CAISSE-ONLINE-COL-001-3-1764140400', NULL, '2025-11-26 06:36:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 2, 50541.00, 57423.00);
INSERT INTO public.operation_caisse VALUES (14, 351, 'entree', 39626.00, 'Collecte #4 - NDONG', NULL, 'ENT-CAISSE-ONLINE-COL-001-4-1764140400', NULL, '2025-11-26 06:54:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 2, 57423.00, 97049.00);
INSERT INTO public.operation_caisse VALUES (15, 351, 'entree', 38662.00, 'Collecte #5 - NDONG', NULL, 'ENT-CAISSE-ONLINE-COL-001-5-1764140400', NULL, '2025-11-26 07:12:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 2, 97049.00, 135711.00);
INSERT INTO public.operation_caisse VALUES (16, 351, 'entree', 11254.00, 'Collecte #6 - NDONG', NULL, 'ENT-CAISSE-ONLINE-COL-001-6-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 2, 135711.00, 146965.00);
INSERT INTO public.operation_caisse VALUES (17, 352, 'entree', 22601.00, 'Collecte #1 - OBAME', NULL, 'ENT-CAISSE-PHYS-COL-002-1-1764140400', NULL, '2025-11-26 06:00:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 3, 50000.00, 72601.00);
INSERT INTO public.operation_caisse VALUES (18, 352, 'entree', 33155.00, 'Collecte #2 - OBAME', NULL, 'ENT-CAISSE-PHYS-COL-002-2-1764140400', NULL, '2025-11-26 06:18:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 3, 72601.00, 105756.00);
INSERT INTO public.operation_caisse VALUES (19, 352, 'entree', 30333.00, 'Collecte #3 - OBAME', NULL, 'ENT-CAISSE-PHYS-COL-002-3-1764140400', NULL, '2025-11-26 06:36:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 3, 105756.00, 136089.00);
INSERT INTO public.operation_caisse VALUES (20, 352, 'entree', 7715.00, 'Collecte #4 - OBAME', NULL, 'ENT-CAISSE-PHYS-COL-002-4-1764140400', NULL, '2025-11-26 06:54:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 3, 136089.00, 143804.00);
INSERT INTO public.operation_caisse VALUES (21, 352, 'entree', 20046.00, 'Collecte #5 - OBAME', NULL, 'ENT-CAISSE-PHYS-COL-002-5-1764140400', NULL, '2025-11-26 07:12:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 3, 143804.00, 163850.00);
INSERT INTO public.operation_caisse VALUES (22, 352, 'entree', 47674.00, 'Collecte #6 - OBAME', NULL, 'ENT-CAISSE-PHYS-COL-002-6-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 3, 163850.00, 211524.00);
INSERT INTO public.operation_caisse VALUES (23, 352, 'sortie', 27142.00, 'Remise en banque', NULL, 'SORT-CAISSE-PHYS-COL-002-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 3, 211524.00, 184382.00);
INSERT INTO public.operation_caisse VALUES (24, 352, 'entree', 48084.00, 'Collecte #1 - OBAME', NULL, 'ENT-CAISSE-ONLINE-COL-002-1-1764140400', NULL, '2025-11-26 06:00:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 4, 0.00, 48084.00);
INSERT INTO public.operation_caisse VALUES (25, 352, 'entree', 31380.00, 'Collecte #2 - OBAME', NULL, 'ENT-CAISSE-ONLINE-COL-002-2-1764140400', NULL, '2025-11-26 06:18:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 4, 48084.00, 79464.00);
INSERT INTO public.operation_caisse VALUES (26, 352, 'entree', 12381.00, 'Collecte #3 - OBAME', NULL, 'ENT-CAISSE-ONLINE-COL-002-3-1764140400', NULL, '2025-11-26 06:36:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 4, 79464.00, 91845.00);
INSERT INTO public.operation_caisse VALUES (27, 352, 'entree', 26746.00, 'Collecte #4 - OBAME', NULL, 'ENT-CAISSE-ONLINE-COL-002-4-1764140400', NULL, '2025-11-26 06:54:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 4, 91845.00, 118591.00);
INSERT INTO public.operation_caisse VALUES (28, 352, 'entree', 31788.00, 'Collecte #5 - OBAME', NULL, 'ENT-CAISSE-ONLINE-COL-002-5-1764140400', NULL, '2025-11-26 07:12:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 4, 118591.00, 150379.00);
INSERT INTO public.operation_caisse VALUES (29, 352, 'entree', 41809.00, 'Collecte #6 - OBAME', NULL, 'ENT-CAISSE-ONLINE-COL-002-6-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 4, 150379.00, 192188.00);
INSERT INTO public.operation_caisse VALUES (30, 352, 'entree', 15519.00, 'Collecte #7 - OBAME', NULL, 'ENT-CAISSE-ONLINE-COL-002-7-1764140400', NULL, '2025-11-26 07:48:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 4, 192188.00, 207707.00);
INSERT INTO public.operation_caisse VALUES (31, 353, 'ouverture', 50000.00, 'Ouverture de caisse - Solde initial', NULL, 'OP-CAISSE-PHYS-COL-003-1764140400', NULL, '2025-11-26 06:00:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 5, 0.00, 50000.00);
INSERT INTO public.operation_caisse VALUES (32, 353, 'entree', 24959.00, 'Collecte #1 - BONGO', NULL, 'ENT-CAISSE-PHYS-COL-003-1-1764140400', NULL, '2025-11-26 06:00:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 5, 50000.00, 74959.00);
INSERT INTO public.operation_caisse VALUES (33, 353, 'entree', 15440.00, 'Collecte #2 - BONGO', NULL, 'ENT-CAISSE-PHYS-COL-003-2-1764140400', NULL, '2025-11-26 06:18:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 5, 74959.00, 90399.00);
INSERT INTO public.operation_caisse VALUES (34, 353, 'entree', 35703.00, 'Collecte #3 - BONGO', NULL, 'ENT-CAISSE-PHYS-COL-003-3-1764140400', NULL, '2025-11-26 06:36:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 5, 90399.00, 126102.00);
INSERT INTO public.operation_caisse VALUES (35, 353, 'entree', 14567.00, 'Collecte #4 - BONGO', NULL, 'ENT-CAISSE-PHYS-COL-003-4-1764140400', NULL, '2025-11-26 06:54:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 5, 126102.00, 140669.00);
INSERT INTO public.operation_caisse VALUES (36, 353, 'ouverture', 0.00, 'Ouverture de caisse - Solde initial', NULL, 'OP-CAISSE-ONLINE-COL-003-1764140400', NULL, '2025-11-26 06:00:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 6, 0.00, 0.00);
INSERT INTO public.operation_caisse VALUES (37, 353, 'entree', 44860.00, 'Collecte #1 - BONGO', NULL, 'ENT-CAISSE-ONLINE-COL-003-1-1764140400', NULL, '2025-11-26 06:00:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 6, 0.00, 44860.00);
INSERT INTO public.operation_caisse VALUES (38, 353, 'entree', 47520.00, 'Collecte #2 - BONGO', NULL, 'ENT-CAISSE-ONLINE-COL-003-2-1764140400', NULL, '2025-11-26 06:18:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 6, 44860.00, 92380.00);
INSERT INTO public.operation_caisse VALUES (39, 353, 'entree', 32791.00, 'Collecte #3 - BONGO', NULL, 'ENT-CAISSE-ONLINE-COL-003-3-1764140400', NULL, '2025-11-26 06:36:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 6, 92380.00, 125171.00);
INSERT INTO public.operation_caisse VALUES (40, 353, 'entree', 18650.00, 'Collecte #4 - BONGO', NULL, 'ENT-CAISSE-ONLINE-COL-003-4-1764140400', NULL, '2025-11-26 06:54:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 6, 125171.00, 143821.00);
INSERT INTO public.operation_caisse VALUES (41, 353, 'entree', 32047.00, 'Collecte #5 - BONGO', NULL, 'ENT-CAISSE-ONLINE-COL-003-5-1764140400', NULL, '2025-11-26 07:12:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 6, 143821.00, 175868.00);
INSERT INTO public.operation_caisse VALUES (42, 353, 'entree', 38481.00, 'Collecte #6 - BONGO', NULL, 'ENT-CAISSE-ONLINE-COL-003-6-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 6, 175868.00, 214349.00);
INSERT INTO public.operation_caisse VALUES (43, 353, 'sortie', 29028.00, 'Remise en banque', NULL, 'SORT-CAISSE-ONLINE-COL-003-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 6, 214349.00, 185321.00);
INSERT INTO public.operation_caisse VALUES (44, 354, 'entree', 39420.00, 'Collecte #1 - ESSONO', NULL, 'ENT-CAISSE-PHYS-COL-004-1-1764140400', NULL, '2025-11-26 06:00:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 7, 50000.00, 89420.00);
INSERT INTO public.operation_caisse VALUES (45, 354, 'entree', 17974.00, 'Collecte #2 - ESSONO', NULL, 'ENT-CAISSE-PHYS-COL-004-2-1764140400', NULL, '2025-11-26 06:18:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 7, 89420.00, 107394.00);
INSERT INTO public.operation_caisse VALUES (46, 354, 'entree', 40946.00, 'Collecte #3 - ESSONO', NULL, 'ENT-CAISSE-PHYS-COL-004-3-1764140400', NULL, '2025-11-26 06:36:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 7, 107394.00, 148340.00);
INSERT INTO public.operation_caisse VALUES (47, 354, 'entree', 49729.00, 'Collecte #4 - ESSONO', NULL, 'ENT-CAISSE-PHYS-COL-004-4-1764140400', NULL, '2025-11-26 06:54:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 7, 148340.00, 198069.00);
INSERT INTO public.operation_caisse VALUES (48, 354, 'entree', 29455.00, 'Collecte #5 - ESSONO', NULL, 'ENT-CAISSE-PHYS-COL-004-5-1764140400', NULL, '2025-11-26 07:12:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 7, 198069.00, 227524.00);
INSERT INTO public.operation_caisse VALUES (49, 354, 'entree', 7978.00, 'Collecte #6 - ESSONO', NULL, 'ENT-CAISSE-PHYS-COL-004-6-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 7, 227524.00, 235502.00);
INSERT INTO public.operation_caisse VALUES (50, 354, 'entree', 8713.00, 'Collecte #7 - ESSONO', NULL, 'ENT-CAISSE-PHYS-COL-004-7-1764140400', NULL, '2025-11-26 07:48:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 7, 235502.00, 244215.00);
INSERT INTO public.operation_caisse VALUES (51, 354, 'entree', 20955.00, 'Collecte #1 - ESSONO', NULL, 'ENT-CAISSE-ONLINE-COL-004-1-1764140400', NULL, '2025-11-26 06:00:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 8, 0.00, 20955.00);
INSERT INTO public.operation_caisse VALUES (52, 354, 'entree', 45360.00, 'Collecte #2 - ESSONO', NULL, 'ENT-CAISSE-ONLINE-COL-004-2-1764140400', NULL, '2025-11-26 06:18:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 8, 20955.00, 66315.00);
INSERT INTO public.operation_caisse VALUES (53, 354, 'entree', 44538.00, 'Collecte #3 - ESSONO', NULL, 'ENT-CAISSE-ONLINE-COL-004-3-1764140400', NULL, '2025-11-26 06:36:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 8, 66315.00, 110853.00);
INSERT INTO public.operation_caisse VALUES (54, 354, 'entree', 5227.00, 'Collecte #4 - ESSONO', NULL, 'ENT-CAISSE-ONLINE-COL-004-4-1764140400', NULL, '2025-11-26 06:54:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 8, 110853.00, 116080.00);
INSERT INTO public.operation_caisse VALUES (55, 354, 'entree', 21210.00, 'Collecte #5 - ESSONO', NULL, 'ENT-CAISSE-ONLINE-COL-004-5-1764140400', NULL, '2025-11-26 07:12:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 8, 116080.00, 137290.00);
INSERT INTO public.operation_caisse VALUES (56, 355, 'ouverture', 50000.00, 'Ouverture de caisse - Solde initial', NULL, 'OP-CAISSE-PHYS-COL-005-1764140400', NULL, '2025-11-26 06:00:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 9, 0.00, 50000.00);
INSERT INTO public.operation_caisse VALUES (57, 355, 'entree', 33251.00, 'Collecte #1 - MVE', NULL, 'ENT-CAISSE-PHYS-COL-005-1-1764140400', NULL, '2025-11-26 06:00:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 9, 50000.00, 83251.00);
INSERT INTO public.operation_caisse VALUES (58, 355, 'entree', 38090.00, 'Collecte #2 - MVE', NULL, 'ENT-CAISSE-PHYS-COL-005-2-1764140400', NULL, '2025-11-26 06:18:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 9, 83251.00, 121341.00);
INSERT INTO public.operation_caisse VALUES (59, 355, 'entree', 27594.00, 'Collecte #3 - MVE', NULL, 'ENT-CAISSE-PHYS-COL-005-3-1764140400', NULL, '2025-11-26 06:36:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 9, 121341.00, 148935.00);
INSERT INTO public.operation_caisse VALUES (60, 355, 'entree', 14623.00, 'Collecte #4 - MVE', NULL, 'ENT-CAISSE-PHYS-COL-005-4-1764140400', NULL, '2025-11-26 06:54:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 9, 148935.00, 163558.00);
INSERT INTO public.operation_caisse VALUES (61, 355, 'entree', 42403.00, 'Collecte #5 - MVE', NULL, 'ENT-CAISSE-PHYS-COL-005-5-1764140400', NULL, '2025-11-26 07:12:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 9, 163558.00, 205961.00);
INSERT INTO public.operation_caisse VALUES (62, 355, 'entree', 7131.00, 'Collecte #6 - MVE', NULL, 'ENT-CAISSE-PHYS-COL-005-6-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 9, 205961.00, 213092.00);
INSERT INTO public.operation_caisse VALUES (63, 355, 'entree', 8729.00, 'Collecte #7 - MVE', NULL, 'ENT-CAISSE-PHYS-COL-005-7-1764140400', NULL, '2025-11-26 07:48:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 9, 213092.00, 221821.00);
INSERT INTO public.operation_caisse VALUES (64, 355, 'sortie', 12988.00, 'Remise en banque', NULL, 'SORT-CAISSE-PHYS-COL-005-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 9, 221821.00, 208833.00);
INSERT INTO public.operation_caisse VALUES (65, 355, 'ouverture', 0.00, 'Ouverture de caisse - Solde initial', NULL, 'OP-CAISSE-ONLINE-COL-005-1764140400', NULL, '2025-11-26 06:00:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 10, 0.00, 0.00);
INSERT INTO public.operation_caisse VALUES (66, 355, 'entree', 19688.00, 'Collecte #1 - MVE', NULL, 'ENT-CAISSE-ONLINE-COL-005-1-1764140400', NULL, '2025-11-26 06:00:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 10, 0.00, 19688.00);
INSERT INTO public.operation_caisse VALUES (67, 355, 'entree', 34067.00, 'Collecte #2 - MVE', NULL, 'ENT-CAISSE-ONLINE-COL-005-2-1764140400', NULL, '2025-11-26 06:18:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 10, 19688.00, 53755.00);
INSERT INTO public.operation_caisse VALUES (68, 355, 'entree', 6381.00, 'Collecte #3 - MVE', NULL, 'ENT-CAISSE-ONLINE-COL-005-3-1764140400', NULL, '2025-11-26 06:36:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 10, 53755.00, 60136.00);
INSERT INTO public.operation_caisse VALUES (69, 355, 'entree', 29791.00, 'Collecte #4 - MVE', NULL, 'ENT-CAISSE-ONLINE-COL-005-4-1764140400', NULL, '2025-11-26 06:54:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 10, 60136.00, 89927.00);
INSERT INTO public.operation_caisse VALUES (70, 355, 'entree', 47532.00, 'Collecte #5 - MVE', NULL, 'ENT-CAISSE-ONLINE-COL-005-5-1764140400', NULL, '2025-11-26 07:12:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 10, 89927.00, 137459.00);
INSERT INTO public.operation_caisse VALUES (71, 355, 'entree', 10329.00, 'Collecte #6 - MVE', NULL, 'ENT-CAISSE-ONLINE-COL-005-6-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 10, 137459.00, 147788.00);
INSERT INTO public.operation_caisse VALUES (72, 355, 'entree', 17247.00, 'Collecte #7 - MVE', NULL, 'ENT-CAISSE-ONLINE-COL-005-7-1764140400', NULL, '2025-11-26 07:48:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 10, 147788.00, 165035.00);
INSERT INTO public.operation_caisse VALUES (73, 355, 'sortie', 24124.00, 'Remise en banque', NULL, 'SORT-CAISSE-ONLINE-COL-005-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:01:37.995582', '2025-11-26 06:01:37.995582', 10, 165035.00, 140911.00);
INSERT INTO public.operation_caisse VALUES (74, 351, 'sortie', 29271.00, 'Remise en banque', NULL, 'SORT-CAISSE-PHYS-COL-001-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:05:18.377548', '2025-11-26 06:05:18.377548', 1, 135400.00, 106129.00);
INSERT INTO public.operation_caisse VALUES (75, 352, 'entree', 28074.00, 'Collecte #7 - OBAME', NULL, 'ENT-CAISSE-PHYS-COL-002-7-1764140400', NULL, '2025-11-26 07:48:00', '2025-11-26 06:05:18.377548', '2025-11-26 06:05:18.377548', 3, 190252.00, 218326.00);
INSERT INTO public.operation_caisse VALUES (76, 352, 'entree', 31022.00, 'Collecte #8 - OBAME', NULL, 'ENT-CAISSE-PHYS-COL-002-8-1764140400', NULL, '2025-11-26 08:06:00', '2025-11-26 06:05:18.377548', '2025-11-26 06:05:18.377548', 3, 218326.00, 249348.00);
INSERT INTO public.operation_caisse VALUES (77, 353, 'entree', 8986.00, 'Collecte #5 - BONGO', NULL, 'ENT-CAISSE-PHYS-COL-003-5-1764140400', NULL, '2025-11-26 07:12:00', '2025-11-26 06:05:18.377548', '2025-11-26 06:05:18.377548', 5, 163574.00, 172560.00);
INSERT INTO public.operation_caisse VALUES (78, 353, 'entree', 49825.00, 'Collecte #6 - BONGO', NULL, 'ENT-CAISSE-PHYS-COL-003-6-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:05:18.377548', '2025-11-26 06:05:18.377548', 5, 172560.00, 222385.00);
INSERT INTO public.operation_caisse VALUES (79, 353, 'sortie', 13293.00, 'Remise en banque', NULL, 'SORT-CAISSE-PHYS-COL-003-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:05:18.377548', '2025-11-26 06:05:18.377548', 5, 222385.00, 209092.00);
INSERT INTO public.operation_caisse VALUES (80, 354, 'sortie', 28103.00, 'Remise en banque', NULL, 'SORT-CAISSE-PHYS-COL-004-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:05:18.377548', '2025-11-26 06:05:18.377548', 7, 128955.00, 100852.00);
INSERT INTO public.operation_caisse VALUES (81, 354, 'entree', 47788.00, 'Collecte #6 - ESSONO', NULL, 'ENT-CAISSE-ONLINE-COL-004-6-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:05:18.377548', '2025-11-26 06:05:18.377548', 8, 106172.00, 153960.00);
INSERT INTO public.operation_caisse VALUES (82, 354, 'entree', 40256.00, 'Collecte #7 - ESSONO', NULL, 'ENT-CAISSE-ONLINE-COL-004-7-1764140400', NULL, '2025-11-26 07:48:00', '2025-11-26 06:05:18.377548', '2025-11-26 06:05:18.377548', 8, 153960.00, 194216.00);
INSERT INTO public.operation_caisse VALUES (83, 354, 'sortie', 27496.00, 'Remise en banque', NULL, 'SORT-CAISSE-ONLINE-COL-004-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 06:05:18.377548', '2025-11-26 06:05:18.377548', 8, 194216.00, 166720.00);
INSERT INTO public.operation_caisse VALUES (84, 351, 'entree', 17305.00, 'Collecte #7 - NDONG', NULL, 'ENT-CAISSE-ONLINE-COL-001-7-1764140400', NULL, '2025-11-26 07:48:00', '2025-11-26 08:04:45.46983', '2025-11-26 08:04:45.46983', 2, 200472.00, 217777.00);
INSERT INTO public.operation_caisse VALUES (85, 351, 'entree', 8903.00, 'Collecte #8 - NDONG', NULL, 'ENT-CAISSE-ONLINE-COL-001-8-1764140400', NULL, '2025-11-26 08:06:00', '2025-11-26 08:04:45.46983', '2025-11-26 08:04:45.46983', 2, 217777.00, 226680.00);
INSERT INTO public.operation_caisse VALUES (86, 351, 'sortie', 24401.00, 'Remise en banque', NULL, 'SORT-CAISSE-ONLINE-COL-001-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 08:04:45.46983', '2025-11-26 08:04:45.46983', 2, 226680.00, 202279.00);
INSERT INTO public.operation_caisse VALUES (87, 352, 'sortie', 26528.00, 'Remise en banque', NULL, 'SORT-CAISSE-ONLINE-COL-002-1764140400', NULL, '2025-11-26 07:30:00', '2025-11-26 08:04:45.46983', '2025-11-26 08:04:45.46983', 4, 170426.00, 143898.00);


--
-- Data for Name: parametrage_notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.parametrage_notification VALUES (1, 'collecte_nouvelle', 'Nouvelle collecte', 'Notification envoyÃ©e lorsqu''une nouvelle collecte est effectuÃ©e', true, false, false, true, NULL, NULL, 'Nouvelle collecte de {montant} FCFA par {collecteur_nom}', '["admin", "agent_back_office"]', NULL, NULL);
INSERT INTO public.parametrage_notification VALUES (2, 'collecte_cloturee', 'Collecte clÃ´turÃ©e', 'Notification envoyÃ©e lorsqu''une collecte est clÃ´turÃ©e', true, false, false, true, NULL, NULL, 'Collecte clÃ´turÃ©e : {montant_total} FCFA', '["admin", "agent_back_office"]', NULL, NULL);
INSERT INTO public.parametrage_notification VALUES (3, 'relance_envoyee', 'Relance envoyÃ©e', 'Notification envoyÃ©e lorsqu''une relance est envoyÃ©e Ã  un contribuable', true, false, true, true, NULL, 'Relance envoyÃ©e Ã  {contribuable_nom}', 'Relance envoyÃ©e Ã  {contribuable_nom}', '["admin", "agent_back_office"]', NULL, NULL);
INSERT INTO public.parametrage_notification VALUES (4, 'paiement_reÃ§u', 'Paiement reÃ§u', 'Notification envoyÃ©e lorsqu''un paiement est reÃ§u', true, true, false, true, 'Paiement de {montant} FCFA reÃ§u de {contribuable_nom}', NULL, 'Paiement de {montant} FCFA reÃ§u', '["admin", "agent_back_office", "agent_front_office"]', NULL, NULL);
INSERT INTO public.parametrage_notification VALUES (5, 'alerte_impaye', 'Alerte impayÃ©', 'Notification envoyÃ©e lorsqu''un impayÃ© est dÃ©tectÃ©', true, true, true, true, 'Alerte : ImpayÃ© dÃ©tectÃ© pour {contribuable_nom}', 'Alerte impayÃ© : {contribuable_nom}', 'Alerte impayÃ© : {contribuable_nom}', '["admin", "agent_back_office", "controleur_interne"]', NULL, NULL);
INSERT INTO public.parametrage_notification VALUES (6, 'caisse_ouverte', 'Caisse ouverte', 'Notification envoyÃ©e lorsqu''une caisse est ouverte', true, false, false, true, NULL, NULL, 'Caisse {caisse_nom} ouverte', '["admin", "agent_back_office"]', NULL, NULL);
INSERT INTO public.parametrage_notification VALUES (7, 'caisse_fermee', 'Caisse fermÃ©e', 'Notification envoyÃ©e lorsqu''une caisse est fermÃ©e', true, true, false, true, 'Caisse {caisse_nom} fermÃ©e avec un solde de {solde} FCFA', NULL, 'Caisse {caisse_nom} fermÃ©e', '["admin", "agent_back_office"]', NULL, NULL);


--
-- Data for Name: performance_collecteur; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: preference_utilisateur; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: quartier_parametrage; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: relance; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.relance VALUES (1, 251, 51, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 5000.00 FCFA à payer. Échéance : 18/11/2025', 5000.00, '2025-11-18 23:32:52.971408', NULL, '2025-11-23 08:38:34.571721', '+241062000001', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (2, 251, 52, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 3000.00 FCFA à payer. Échéance : 15/10/2025', 3000.00, '2025-10-15 17:39:10.472585', NULL, '2025-11-23 08:38:34.582199', '+241062000001', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (3, 251, 53, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 30000.00 FCFA à payer. Échéance : 30/06/2025', 30000.00, '2025-06-30 10:29:44.361536', NULL, '2025-11-23 08:38:34.586359', '+241062000001', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (4, 252, 54, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 35113.11 FCFA à payer. Échéance : 14/11/2025', 35113.11, '2025-11-14 07:18:04.506818', NULL, '2025-11-23 08:38:34.589533', '+241062000002', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (5, 254, 57, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 1000.00 FCFA à payer. Échéance : 15/11/2025', 1000.00, '2025-11-15 09:58:12.100597', NULL, '2025-11-23 08:38:34.595737', '+241062000004', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (6, 254, 58, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 30000.00 FCFA à payer. Échéance : 08/07/2025', 30000.00, '2025-07-08 13:07:21.656773', NULL, '2025-11-23 08:38:34.601867', '+241062000004', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (7, 255, 60, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 14625.01 FCFA à payer. Échéance : 29/07/2025', 14625.01, '2025-07-29 21:39:03.153336', NULL, '2025-11-23 08:38:34.605906', '+241062000005', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (8, 256, 62, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 1000.00 FCFA à payer. Échéance : 30/06/2025', 1000.00, '2025-06-30 07:49:40.969189', NULL, '2025-11-23 08:38:34.614252', '+241062000006', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (9, 257, 63, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 500.00 FCFA à payer. Échéance : 16/07/2025', 500.00, '2025-07-16 21:07:54.874696', NULL, '2025-11-23 08:38:34.619947', '+241062000007', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (10, 257, 65, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 25000.00 FCFA à payer. Échéance : 11/08/2025', 25000.00, '2025-08-11 06:03:48.346275', NULL, '2025-11-23 08:38:34.624139', '+241062000007', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (11, 259, 67, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 15000.00 FCFA à payer. Échéance : 25/12/2025', 15000.00, '2025-12-25 23:47:42.14542', NULL, '2025-11-23 08:38:34.630142', '+241062000009', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (12, 259, 68, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 25000.00 FCFA à payer. Échéance : 03/02/2026', 25000.00, '2026-02-03 10:36:12.877877', NULL, '2025-11-23 08:38:34.63609', '+241062000009', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (13, 260, 69, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 1000.00 FCFA à payer. Échéance : 10/10/2025', 1000.00, '2025-10-10 06:43:49.575687', NULL, '2025-11-23 08:38:34.639537', '+241062000010', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (14, 260, 70, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 500.00 FCFA à payer. Échéance : 23/11/2025', 500.00, '2025-11-23 16:03:28.538919', NULL, '2025-11-23 08:38:34.644538', '+241062000010', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (15, 260, 71, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 25000.00 FCFA à payer. Échéance : 12/11/2025', 25000.00, '2025-11-12 15:06:19.387576', NULL, '2025-11-23 08:38:34.648548', '+241062000010', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (16, 261, 72, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 10964.63 FCFA à payer. Échéance : 29/12/2025', 10964.63, '2025-12-29 18:06:01.483255', NULL, '2025-11-23 08:38:34.652286', '+241062000011', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (17, 262, 73, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 30000.00 FCFA à payer. Échéance : 08/11/2025', 30000.00, '2025-11-08 18:33:22.167749', NULL, '2025-11-23 08:38:34.655611', '+241062000012', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (18, 263, 75, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 15000.00 FCFA à payer. Échéance : 30/01/2026', 15000.00, '2026-01-30 19:47:56.025701', NULL, '2025-11-23 08:38:34.660073', '+241062000013', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (19, 263, 76, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 25000.00 FCFA à payer. Échéance : 03/11/2025', 25000.00, '2025-11-03 07:26:39.502975', NULL, '2025-11-23 08:38:34.664958', '+241062000013', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (20, 264, 78, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 12061.58 FCFA à payer. Échéance : 05/12/2025', 12061.58, '2025-12-05 15:16:54.332683', NULL, '2025-11-23 08:38:34.669493', '+241062000014', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (21, 265, 79, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 25000.00 FCFA à payer. Échéance : 07/01/2026', 25000.00, '2026-01-07 13:27:21.17565', NULL, '2025-11-23 08:38:34.675376', '+241062000015', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (22, 266, 81, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 3000.00 FCFA à payer. Échéance : 20/09/2025', 3000.00, '2025-09-20 07:10:55.763929', NULL, '2025-11-23 08:38:34.681446', '+241062000016', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (23, 266, 82, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 30000.00 FCFA à payer. Échéance : 15/09/2025', 30000.00, '2025-09-15 04:04:46.135971', NULL, '2025-11-23 08:38:34.68752', '+241062000016', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (24, 266, 83, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 2000.00 FCFA à payer. Échéance : 17/09/2025', 2000.00, '2025-09-17 22:41:54.526973', NULL, '2025-11-23 08:38:34.69052', '+241062000016', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (25, 267, 84, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 30231.43 FCFA à payer. Échéance : 16/10/2025', 30231.43, '2025-10-16 13:09:33.421988', NULL, '2025-11-23 08:38:34.69273', '+241062000017', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (26, 268, 86, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 10000.00 FCFA à payer. Échéance : 19/01/2026', 10000.00, '2026-01-19 10:45:33.739488', NULL, '2025-11-23 08:38:34.700941', '+241062000018', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (27, 269, 87, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 2000.00 FCFA à payer. Échéance : 30/07/2025', 2000.00, '2025-07-30 08:10:38.93112', NULL, '2025-11-23 08:38:34.705972', '+241062000019', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (28, 269, 88, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 15000.00 FCFA à payer. Échéance : 14/07/2025', 15000.00, '2025-07-14 21:37:38.733422', NULL, '2025-11-23 08:38:34.710979', '+241062000019', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (29, 270, 90, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 4182.49 FCFA à payer. Échéance : 14/09/2025', 4182.49, '2025-09-14 22:47:35.488038', NULL, '2025-11-23 08:38:34.715972', '+241062000020', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (30, 271, 91, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 500.00 FCFA à payer. Échéance : 06/11/2025', 500.00, '2025-11-06 22:50:03.160787', NULL, '2025-11-23 08:38:34.720485', '+241062000021', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (31, 272, 93, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 2000.00 FCFA à payer. Échéance : 25/06/2025', 2000.00, '2025-06-25 21:00:40.806695', NULL, '2025-11-23 08:38:34.727131', '+241062000022', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (32, 272, 94, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 25000.00 FCFA à payer. Échéance : 24/08/2025', 25000.00, '2025-08-24 04:35:12.502434', NULL, '2025-11-23 08:38:34.732125', '+241062000022', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (33, 273, 96, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 1151.42 FCFA à payer. Échéance : 27/08/2025', 1151.42, '2025-08-27 18:09:03.458821', NULL, '2025-11-23 08:38:34.73649', '+241062000023', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (34, 274, 97, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 25000.00 FCFA à payer. Échéance : 19/08/2025', 25000.00, '2025-08-19 04:31:34.463447', NULL, '2025-11-23 08:38:34.740973', '+241062000024', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (35, 274, 98, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 25000.00 FCFA à payer. Échéance : 10/11/2025', 25000.00, '2025-11-10 05:38:59.740851', NULL, '2025-11-23 08:38:34.745978', '+241062000024', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (36, 275, 99, 'sms', 'en_attente', 'Rappel : Vous avez une taxe de 2000.00 FCFA à payer. Échéance : 29/10/2025', 2000.00, '2025-10-29 14:19:51.625655', NULL, '2025-11-23 08:38:34.749973', '+241062000025', false, NULL, NULL, NULL, '2025-11-23 08:38:34.758978', '2025-11-23 08:38:34.758978');
INSERT INTO public.relance VALUES (37, 275, 100, 'sms', 'echec', 'Rappel : Vous avez une taxe de 15000.00 FCFA à payer. Échéance : 18/12/2025', 15000.00, '2025-12-18 23:30:52.138368', NULL, '2025-11-23 08:38:34.753979', '+241062000025', false, NULL, 'Erreur envoi SMS: Impossible de récupérer le token d''accès Keycloak', NULL, '2025-11-23 08:38:34.758978', '2025-11-23 10:36:48.715224');
INSERT INTO public.relance VALUES (38, 251, NULL, 'sms', 'echec', NULL, 100.00, NULL, NULL, '2025-11-24 01:00:00', '+24177861364', false, NULL, 'Erreur envoi SMS: Impossible de récupérer le token d''accès Keycloak', NULL, '2025-11-24 10:25:18.993139', '2025-11-24 11:25:45.721635');
INSERT INTO public.relance VALUES (39, 251, NULL, 'sms', 'echec', NULL, 1000.00, '2025-11-12 01:00:00', NULL, '2025-11-24 01:00:00', '+24177861364', false, NULL, 'Erreur envoi SMS: [{"error":"Violation de contrainte","message":"Sender ID must be one of them [VENTIS, SFE-FID, BAMBOOASSUR, BAMBOO, BAMBOOTRANS, EMF-TONTINE]","path":"http://messaging.ventis.group/messaging/api/v1/message","statusCode":1003}]', NULL, '2025-11-24 10:32:06.783354', '2025-11-24 11:32:13.725858');
INSERT INTO public.relance VALUES (40, 251, NULL, 'sms', 'echec', NULL, 1000.00, '2025-11-30 01:00:00', NULL, '2025-11-24 01:00:00', '+24177861364', false, NULL, 'Erreur envoi SMS: [{"error":"Violation de contrainte","message":"Sender ID must be one of them [VENTIS, SFE-FID, BAMBOOASSUR, BAMBOO, BAMBOOTRANS, EMF-TONTINE]","path":"http://messaging.ventis.group/messaging/api/v1/message","statusCode":1003}]', NULL, '2025-11-24 10:39:02.482529', '2025-11-24 11:39:09.149277');
INSERT INTO public.relance VALUES (41, 251, NULL, 'sms', 'envoyee', NULL, 1000.00, NULL, '2025-11-24 14:24:42.527648', '2025-11-24 01:00:00', '24177861364', false, NULL, 'SMS envoyé via Ventis. UUID: 2c27d70c-b4d4-4f48-be48-ce15bc1ee5d0', NULL, '2025-11-24 14:23:54.081096', '2025-11-24 15:24:40.71393');
INSERT INTO public.relance VALUES (42, 251, NULL, 'sms', 'envoyee', NULL, 100.00, '2025-11-30 16:56:00', '2025-11-24 15:57:21.22499', '2025-11-24 16:56:00', '24177861364', false, NULL, 'SMS envoyé via Ventis. UUID: 508ba4ce-a424-4d3a-a6de-346346971bba', NULL, '2025-11-24 15:57:02.700602', '2025-11-24 16:57:18.172264');


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.role VALUES (1, 'collecteur', 'collecteur', 'jhgtrfertgyhujk', '["delete_users", "read_contribuables", "update_contribuables", "read_collectes", "create_collectes", "update_collectes", "read_taxes", "create_contribuables"]', true, '2025-11-30 11:25:00.329536', '2025-11-30 11:25:00.329536');


--
-- Data for Name: secteur_activite; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.secteur_activite VALUES (1, 'Commerce général', 'COM-GEN', 'Commerce de biens divers', true, '2025-11-30 11:26:20.755245', '2025-11-30 11:26:20.755245');
INSERT INTO public.secteur_activite VALUES (2, 'Restauration', 'REST', 'Restaurants, cafés, snacks', true, '2025-11-30 11:26:21.085055', '2025-11-30 11:26:21.085055');
INSERT INTO public.secteur_activite VALUES (3, 'Services financiers', 'FIN', 'Banques, microfinance, assurance', true, '2025-11-30 11:26:21.106091', '2025-11-30 11:26:21.106091');
INSERT INTO public.secteur_activite VALUES (4, 'Artisanat', 'ART', 'Artisanat local', true, '2025-11-30 11:26:21.11547', '2025-11-30 11:26:21.11547');
INSERT INTO public.secteur_activite VALUES (6, 'Éducation', 'EDUC', 'Écoles, formation', true, '2025-11-30 11:26:21.139297', '2025-11-30 11:26:21.139297');
INSERT INTO public.secteur_activite VALUES (5, 'Transport', 'TRANS', 'Transport de personnes et marchandises', true, '2025-11-30 11:26:21.137244', '2025-11-30 11:26:21.137244');
INSERT INTO public.secteur_activite VALUES (7, 'Hôtellerie', 'HOTEL', 'Hôtels, auberges, hébergement', true, '2025-11-30 11:26:21.150458', '2025-11-30 11:26:21.150458');
INSERT INTO public.secteur_activite VALUES (8, 'Bâtiment et travaux publics', 'BTP', 'Construction, travaux', true, '2025-11-30 11:26:21.151472', '2025-11-30 11:26:21.151472');
INSERT INTO public.secteur_activite VALUES (9, 'Santé', 'SANTE', 'Cliniques, pharmacies, cabinets médicaux', true, '2025-11-30 11:26:21.172112', '2025-11-30 11:26:21.172112');
INSERT INTO public.secteur_activite VALUES (10, 'Industrie', 'IND', 'Transformation, production', true, '2025-11-30 11:26:21.199636', '2025-11-30 11:26:21.199636');
INSERT INTO public.secteur_activite VALUES (11, 'Agriculture et élevage', 'AGRI', 'Production agricole et élevage', true, '2025-11-30 11:26:21.226808', '2025-11-30 11:26:21.226808');
INSERT INTO public.secteur_activite VALUES (12, 'Pêche', 'PECHE', 'Pêche artisanale et commerciale', true, '2025-11-30 11:26:21.232164', '2025-11-30 11:26:21.232164');
INSERT INTO public.secteur_activite VALUES (13, 'Services publics', 'PUB', 'Services administratifs', true, '2025-11-30 11:26:21.326477', '2025-11-30 11:26:21.326477');
INSERT INTO public.secteur_activite VALUES (14, 'Télécommunications', 'TELECOM', 'Téléphonie, internet', true, '2025-11-30 11:26:21.327479', '2025-11-30 11:26:21.327479');
INSERT INTO public.secteur_activite VALUES (15, 'Mines', 'MINES', 'Exploitation minière', true, '2025-11-30 11:26:21.359328', '2025-11-30 11:26:21.359328');
INSERT INTO public.secteur_activite VALUES (16, 'Énergie', 'ENERGIE', 'Production et distribution d''énergie', true, '2025-11-30 11:26:21.375449', '2025-11-30 11:26:21.375449');
INSERT INTO public.secteur_activite VALUES (17, 'Médias et communication', 'MEDIA', 'Presse, radio, télévision', true, '2025-11-30 11:26:21.400377', '2025-11-30 11:26:21.400377');
INSERT INTO public.secteur_activite VALUES (18, 'Services aux entreprises', 'SERV-ENT', 'Conseil, services professionnels', true, '2025-11-30 11:26:21.40483', '2025-11-30 11:26:21.40483');
INSERT INTO public.secteur_activite VALUES (19, 'Commerce de détail', 'RET', 'Vente au détail', true, '2025-11-30 11:26:21.418442', '2025-11-30 11:26:21.418442');
INSERT INTO public.secteur_activite VALUES (20, 'Commerce de gros', 'GROS', 'Vente en gros', true, '2025-11-30 11:26:21.419556', '2025-11-30 11:26:21.419556');
INSERT INTO public.secteur_activite VALUES (21, 'Loisirs et divertissement', 'LOISIRS', 'Divertissement, sports, culture', true, '2025-11-30 11:26:21.43742', '2025-11-30 11:26:21.43742');
INSERT INTO public.secteur_activite VALUES (22, 'Automobile', 'AUTO', 'Vente et réparation de véhicules', true, '2025-11-30 11:26:21.451995', '2025-11-30 11:26:21.451995');
INSERT INTO public.secteur_activite VALUES (23, 'Services à la personne', 'SERV-PERS', 'Services domestiques, ménage', true, '2025-11-30 11:26:21.477188', '2025-11-30 11:26:21.477188');
INSERT INTO public.secteur_activite VALUES (24, 'Immobilier', 'IMMO', 'Agence immobilière, location', true, '2025-11-30 11:26:21.478191', '2025-11-30 11:26:21.478191');
INSERT INTO public.secteur_activite VALUES (25, 'Autre', 'AUTRE', 'Autres activités non classées', true, '2025-11-30 11:26:21.490422', '2025-11-30 11:26:21.490422');


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: texte_localisation; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: transaction_bamboopay; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.transaction_bamboopay VALUES (1, NULL, NULL, 19, 'marina', '24174211156', NULL, NULL, 'TAX-20251124-24C36732', 10000.00, NULL, NULL, 'pending', NULL, 'http://localhost:8000/client/paiement/retour', 'http://localhost:8000/api/client/paiement/callback', NULL, 'web', NULL, '2025-11-24 05:07:24.014237', NULL, NULL, '2025-11-24 05:07:24.014237', '2025-11-24 05:07:24.014237');


--
-- Data for Name: zone_geographique; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: affectation_taxe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.affectation_taxe_id_seq', 100, true);


--
-- Name: arrondissement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.arrondissement_id_seq', 1, false);


--
-- Name: badge_collecteur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.badge_collecteur_id_seq', 1, false);


--
-- Name: badge_feedback_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.badge_feedback_id_seq', 1, false);


--
-- Name: caisse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.caisse_id_seq', 10, true);


--
-- Name: collecte_location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.collecte_location_id_seq', 1, false);


--
-- Name: collecteur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.collecteur_id_seq', 400, true);


--
-- Name: collecteur_zone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.collecteur_zone_id_seq', 1, false);


--
-- Name: commission_fichier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.commission_fichier_id_seq', 10, true);


--
-- Name: commission_journaliere_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.commission_journaliere_id_seq', 20, true);


--
-- Name: commune_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.commune_id_seq', 1, false);


--
-- Name: contribuable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contribuable_id_seq', 301, true);


--
-- Name: coupure_caisse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coupure_caisse_id_seq', 7, true);


--
-- Name: dossier_impaye_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dossier_impaye_id_seq', 29, true);


--
-- Name: info_collecte_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.info_collecte_id_seq', 100, true);


--
-- Name: journal_travaux_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.journal_travaux_id_seq', 7, true);


--
-- Name: langue_disponible_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.langue_disponible_id_seq', 1, false);


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_id_seq', 1, false);


--
-- Name: notification_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_token_id_seq', 1, false);


--
-- Name: objectif_collecteur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.objectif_collecteur_id_seq', 1, false);


--
-- Name: operation_caisse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.operation_caisse_id_seq', 87, true);


--
-- Name: parametrage_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.parametrage_notification_id_seq', 7, true);


--
-- Name: performance_collecteur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.performance_collecteur_id_seq', 1, false);


--
-- Name: preference_utilisateur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.preference_utilisateur_id_seq', 1, false);


--
-- Name: quartier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quartier_id_seq', 974, true);


--
-- Name: quartier_parametrage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quartier_parametrage_id_seq', 1, false);


--
-- Name: relance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.relance_id_seq', 42, true);


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_id_seq', 1, true);


--
-- Name: secteur_activite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.secteur_activite_id_seq', 25, true);


--
-- Name: service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_id_seq', 598, true);


--
-- Name: taxe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.taxe_id_seq', 350, true);


--
-- Name: texte_localisation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.texte_localisation_id_seq', 1, false);


--
-- Name: transaction_bamboopay_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaction_bamboopay_id_seq', 1, true);


--
-- Name: type_contribuable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.type_contribuable_id_seq', 622, true);


--
-- Name: type_taxe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.type_taxe_id_seq', 607, true);


--
-- Name: utilisateur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.utilisateur_id_seq', 51, true);


--
-- Name: ville_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ville_id_seq', 1, false);


--
-- Name: zone_geographique_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.zone_geographique_id_seq', 1, false);


--
-- Name: zone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.zone_id_seq', 864, true);


--
-- PostgreSQL database dump complete
--

