-- Users
INSERT INTO user (user_id, first_name, last_name, email, password)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'Yassine', 'Test', 'yassine@example.com', '$2a$10$hash'),
  ('22222222-2222-2222-2222-222222222222', 'Admin', 'Agency', 'admin@example.com', '$2a$10$hash');

-- Agency
INSERT INTO agency (agency_id, name, address)
VALUES ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Your Car Your Way - Paris', '10 Rue Exemple, 75000 Paris');

-- Vehicle
INSERT INTO vehicle (vehicle_id, model, category, available, agency_id)
VALUES ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Peugeot 208', 'EDMR', TRUE, 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa');

-- Offer
INSERT INTO offer (offer_id, agency_id, vehicle_id, city_start, city_end, start_date, end_date, price)
VALUES ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Paris', 'Lyon', '2025-09-01', '2025-09-07', 19900);

-- Reservation
INSERT INTO reservation (reservation_id, offer_id, user_id, status)
VALUES ('dddddddd-dddd-dddd-dddd-dddddddddddd', 'cccccccc-cccc-cccc-cccc-cccccccccccc',
        '11111111-1111-1111-1111-111111111111', 'pending');

-- Payment
INSERT INTO payment (payment_id, reservation_id, amount, status)
VALUES ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 19900, 'pending');

-- Message
INSERT INTO messages (message_id, sender_id, receiver_id, content, status)
VALUES ('ffffffff-ffff-ffff-ffff-ffffffffffff', '11111111-1111-1111-1111-111111111111',
        '22222222-2222-2222-2222-222222222222', 'Bonjour !', 'sent');

-- Video Call
INSERT INTO video_call (call_id, caller_id, receiver_id, status, call_url)
VALUES ('99999999-9999-9999-9999-999999999999', '11111111-1111-1111-1111-111111111111',
        '22222222-2222-2222-2222-222222222222', 'ongoing', 'https://meet.example.com/call/9999');
