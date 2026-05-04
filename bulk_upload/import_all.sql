-- Complete SQL Import for 46 Dummy Users
-- This script handles both auth.users and public.profiles to satisfy foreign key constraints.

DO $$
BEGIN
    -- TEACHERS
    PERFORM create_dummy_user('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'teacher1@example.com', 'Teacher One', '+1234567801', 'teacher', true);
    PERFORM create_dummy_user('a2eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'teacher2@example.com', 'Teacher Two', '+1234567802', 'teacher', false);
    PERFORM create_dummy_user('a3eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'teacher3@example.com', 'Teacher Three', '+1234567803', 'teacher', true);
    
    -- STUDENTS
    PERFORM create_dummy_user('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'student1@example.com', 'Student One', '+1234567811', 'candidate', true);
    PERFORM create_dummy_user('b2eebc99-9c0b-4ef8-bb6d-6bb9bd380b12', 'student2@example.com', 'Student Two', '+1234567812', 'candidate', true);
    PERFORM create_dummy_user('b3eebc99-9c0b-4ef8-bb6d-6bb9bd380b13', 'student3@example.com', 'Student Three', '+1234567813', 'candidate', true);
    
    -- PARENTS
    PERFORM create_dummy_user('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380c11', 'parent1@example.com', 'Parent One', '+1234567821', 'parent', true);
    PERFORM create_dummy_user('c2eebc99-9c0b-4ef8-bb6d-6bb9bd380c12', 'parent2@example.com', 'Parent Two', '+1234567822', 'parent', true);
    PERFORM create_dummy_user('c3eebc99-9c0b-4ef8-bb6d-6bb9bd380c13', 'parent3@example.com', 'Parent Three', '+1234567823', 'parent', true);

    -- ... AND THE REST (Users 11 to 46) ...
    PERFORM create_dummy_user('e1eebc99-9c0b-4ef8-bb6d-6bb9bd380e11', 'u11@example.com', 'User Eleven', '+1234567841', 'candidate', true);
    PERFORM create_dummy_user('e2eebc99-9c0b-4ef8-bb6d-6bb9bd380e12', 'u12@example.com', 'User Twelve', '+1234567842', 'teacher', true);
    PERFORM create_dummy_user('e3eebc99-9c0b-4ef8-bb6d-6bb9bd380e13', 'u13@example.com', 'User Thirteen', '+1234567843', 'parent', true);
    PERFORM create_dummy_user('f1eebc99-9c0b-4ef8-bb6d-6bb9bd380f11', 'u14@example.com', 'User Fourteen', '+1234567844', 'candidate', true);
    PERFORM create_dummy_user('f2eebc99-9c0b-4ef8-bb6d-6bb9bd380f12', 'u15@example.com', 'User Fifteen', '+1234567845', 'teacher', false);
    PERFORM create_dummy_user('f3eebc99-9c0b-4ef8-bb6d-6bb9bd380f13', 'u16@example.com', 'User Sixteen', '+1234567846', 'parent', true);
    PERFORM create_dummy_user('g1eebc99-9c0b-4ef8-bb6d-6bb9bd380g11', 'u17@example.com', 'User Seventeen', '+1234567847', 'candidate', true);
    PERFORM create_dummy_user('g2eebc99-9c0b-4ef8-bb6d-6bb9bd380g12', 'u18@example.com', 'User Eighteen', '+1234567848', 'teacher', true);
    PERFORM create_dummy_user('g3eebc99-9c0b-4ef8-bb6d-6bb9bd380g13', 'u19@example.com', 'User Nineteen', '+1234567849', 'parent', true);
    PERFORM create_dummy_user('h1eebc99-9c0b-4ef8-bb6d-6bb9bd380h11', 'u20@example.com', 'User Twenty', '+1234567850', 'candidate', true);
    PERFORM create_dummy_user('h2eebc99-9c0b-4ef8-bb6d-6bb9bd380h12', 'u21@example.com', 'User Twenty One', '+1234567851', 'teacher', false);
    PERFORM create_dummy_user('h3eebc99-9c0b-4ef8-bb6d-6bb9bd380h13', 'u22@example.com', 'User Twenty Two', '+1234567852', 'parent', true);
    PERFORM create_dummy_user('i1eebc99-9c0b-4ef8-bb6d-6bb9bd380i11', 'u23@example.com', 'User Twenty Three', '+1234567853', 'candidate', true);
    PERFORM create_dummy_user('i2eebc99-9c0b-4ef8-bb6d-6bb9bd380i12', 'u24@example.com', 'User Twenty Four', '+1234567854', 'teacher', true);
    PERFORM create_dummy_user('i3eebc99-9c0b-4ef8-bb6d-6bb9bd380i13', 'u25@example.com', 'User Twenty Five', '+1234567855', 'parent', true);
    PERFORM create_dummy_user('j1eebc99-9c0b-4ef8-bb6d-6bb9bd380j11', 'u26@example.com', 'User Twenty Six', '+1234567856', 'candidate', true);
    PERFORM create_dummy_user('j2eebc99-9c0b-4ef8-bb6d-6bb9bd380j12', 'u27@example.com', 'User Twenty Seven', '+1234567857', 'teacher', false);
    PERFORM create_dummy_user('j3eebc99-9c0b-4ef8-bb6d-6bb9bd380j13', 'u28@example.com', 'User Twenty Eight', '+1234567858', 'parent', true);
    PERFORM create_dummy_user('k1eebc99-9c0b-4ef8-bb6d-6bb9bd380k11', 'u29@example.com', 'User Twenty Nine', '+1234567859', 'candidate', true);
    PERFORM create_dummy_user('k2eebc99-9c0b-4ef8-bb6d-6bb9bd380k12', 'u30@example.com', 'User Thirty', '+1234567860', 'teacher', true);
    PERFORM create_dummy_user('k3eebc99-9c0b-4ef8-bb6d-6bb9bd380k13', 'u31@example.com', 'User Thirty One', '+1234567861', 'parent', true);
    PERFORM create_dummy_user('l1eebc99-9c0b-4ef8-bb6d-6bb9bd380l11', 'u32@example.com', 'User Thirty Two', '+1234567862', 'candidate', true);
    PERFORM create_dummy_user('l2eebc99-9c0b-4ef8-bb6d-6bb9bd380l12', 'u33@example.com', 'User Thirty Three', '+1234567863', 'teacher', false);
    PERFORM create_dummy_user('l3eebc99-9c0b-4ef8-bb6d-6bb9bd380l13', 'u34@example.com', 'User Thirty Four', '+1234567864', 'parent', true);
    PERFORM create_dummy_user('m1eebc99-9c0b-4ef8-bb6d-6bb9bd380m11', 'u35@example.com', 'User Thirty Five', '+1234567865', 'candidate', true);
    PERFORM create_dummy_user('m2eebc99-9c0b-4ef8-bb6d-6bb9bd380m12', 'u36@example.com', 'User Thirty Six', '+1234567866', 'teacher', true);
    PERFORM create_dummy_user('m3eebc99-9c0b-4ef8-bb6d-6bb9bd380m13', 'u37@example.com', 'User Thirty Seven', '+1234567867', 'parent', true);
    PERFORM create_dummy_user('n1eebc99-9c0b-4ef8-bb6d-6bb9bd380n11', 'u38@example.com', 'User Thirty Eight', '+1234567868', 'candidate', true);
    PERFORM create_dummy_user('n2eebc99-9c0b-4ef8-bb6d-6bb9bd380n12', 'u39@example.com', 'User Thirty Nine', '+1234567869', 'teacher', false);
    PERFORM create_dummy_user('n3eebc99-9c0b-4ef8-bb6d-6bb9bd380n13', 'u40@example.com', 'User Forty', '+1234567870', 'parent', true);
    PERFORM create_dummy_user('o1eebc99-9c0b-4ef8-bb6d-6bb9bd380o11', 'u41@example.com', 'User Forty One', '+1234567871', 'candidate', true);
    PERFORM create_dummy_user('o2eebc99-9c0b-4ef8-bb6d-6bb9bd380o12', 'u42@example.com', 'User Forty Two', '+1234567872', 'teacher', true);
    PERFORM create_dummy_user('o3eebc99-9c0b-4ef8-bb6d-6bb9bd380o13', 'u43@example.com', 'User Forty Three', '+1234567873', 'parent', true);
    PERFORM create_dummy_user('p1eebc99-9c0b-4ef8-bb6d-6bb9bd380p11', 'u44@example.com', 'User Forty Four', '+1234567874', 'candidate', true);
    PERFORM create_dummy_user('p2eebc99-9c0b-4ef8-bb6d-6bb9bd380p12', 'u45@example.com', 'User Forty Five', '+1234567875', 'teacher', false);
    PERFORM create_dummy_user('p3eebc99-9c0b-4ef8-bb6d-6bb9bd380p13', 'u46@example.com', 'User Forty Six', '+1234567876', 'parent', true);
END $$;

-- Helper function to avoid repetition
CREATE OR REPLACE FUNCTION create_dummy_user(
    u_id UUID, 
    u_email TEXT, 
    u_name TEXT, 
    u_phone TEXT, 
    u_role TEXT, 
    u_approved BOOLEAN
) RETURNS VOID AS $$
BEGIN
    INSERT INTO auth.users (id, email, email_confirmed_at) 
    VALUES (u_id, u_email, now()) 
    ON CONFLICT (id) DO NOTHING;
    
    INSERT INTO public.profiles (id, email, full_name, phone, role, is_approved, created_at) 
    VALUES (u_id, u_email, u_name, u_phone, u_role, u_approved, now()) 
    ON CONFLICT (id) DO NOTHING;
END;
$$ LANGUAGE plpgsql;
