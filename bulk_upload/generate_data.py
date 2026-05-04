import uuid
from datetime import datetime

roles = ['teacher', 'candidate', 'parent']
data = []

# Generate 50 dummy users
for i in range(1, 51):
    u_id = str(uuid.uuid4())
    role = roles[i % 3]
    full_name = f"User {i}"
    email = f"user{i}@example.com"
    phone = f"+12345678{i:02d}"
    is_approved = "true" if role != 'teacher' or i % 2 == 0 else "false"
    created_at = datetime.now().isoformat()
    data.append(f"{u_id},{full_name},{email},{phone},{role},{is_approved},{created_at}")

with open('bulk_upload/combined_users.csv', 'w') as f:
    f.write("id,full_name,email,phone,role,is_approved,created_at\n")
    f.write("\n".join(data))

# Generate SQL
sql = ["-- Bulk import script for 50 users\nDO $$\nBEGIN"]
for line in data:
    parts = line.split(',')
    sql.append(f"""
    INSERT INTO auth.users (id, email, email_confirmed_at) VALUES ('{parts[0]}', '{parts[2]}', now()) ON CONFLICT (id) DO NOTHING;
    INSERT INTO public.profiles (id, email, full_name, phone, role, is_approved, created_at) 
    VALUES ('{parts[0]}', '{parts[2]}', '{parts[1]}', '{parts[3]}', '{parts[4]}', {parts[5]}, '{parts[6]}') ON CONFLICT (id) DO NOTHING;""")
sql.append("END $$;")

with open('bulk_upload/import_all.sql', 'w') as f:
    f.write("\n".join(sql))
