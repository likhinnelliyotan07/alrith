-- SQL Script to bulk import dummy users into Supabase Auth and Profiles
-- Paste this into your Supabase SQL Editor and run it.

DO $$
DECLARE
    teacher_id UUID;
    student_id UUID;
    parent_id UUID;
BEGIN
    -- --- TEACHERS ---
    
    -- John Doe
    INSERT INTO auth.users (id, email, raw_user_meta_data, email_confirmed_at)
    VALUES ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'john.teacher@example.com', '{"full_name": "John Doe"}', now())
    ON CONFLICT (id) DO NOTHING;
    
    INSERT INTO public.profiles (id, email, full_name, phone, role, is_approved, created_at)
    VALUES ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'john.teacher@example.com', 'John Doe', '+1234567890', 'teacher', true, now())
    ON CONFLICT (id) DO NOTHING;

    -- Jane Smith
    INSERT INTO auth.users (id, email, raw_user_meta_data, email_confirmed_at)
    VALUES ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'jane.teacher@example.com', '{"full_name": "Jane Smith"}', now())
    ON CONFLICT (id) DO NOTHING;
    
    INSERT INTO public.profiles (id, email, full_name, phone, role, is_approved, created_at)
    VALUES ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'jane.teacher@example.com', 'Jane Smith', '+1234567891', 'teacher', false, now())
    ON CONFLICT (id) DO NOTHING;

    -- --- STUDENTS ---
    
    -- Alice Johnson
    INSERT INTO auth.users (id, email, raw_user_meta_data, email_confirmed_at)
    VALUES ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'alice.student@example.com', '{"full_name": "Alice Johnson"}', now())
    ON CONFLICT (id) DO NOTHING;
    
    INSERT INTO public.profiles (id, email, full_name, phone, role, is_approved, created_at)
    VALUES ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'alice.student@example.com', 'Alice Johnson', '+1234567800', 'candidate', true, now())
    ON CONFLICT (id) DO NOTHING;

    -- --- PARENTS ---
    
    -- Sarah Johnson
    INSERT INTO auth.users (id, email, raw_user_meta_data, email_confirmed_at)
    VALUES ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c11', 'sarah.parent@example.com', '{"full_name": "Sarah Johnson"}', now())
    ON CONFLICT (id) DO NOTHING;
    
    INSERT INTO public.profiles (id, email, full_name, phone, role, is_approved, created_at)
    VALUES ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c11', 'sarah.parent@example.com', 'Sarah Johnson', '+1234567900', 'parent', true, now())
    ON CONFLICT (id) DO NOTHING;

END $$;
