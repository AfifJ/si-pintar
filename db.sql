-- Drop tables if they exist (in correct order due to dependencies)
DROP TABLE IF EXISTS public.submissions CASCADE;
DROP TABLE IF EXISTS public.attendances CASCADE;
DROP TABLE IF EXISTS public.materials CASCADE;
DROP TABLE IF EXISTS public.activities CASCADE;
DROP TABLE IF EXISTS public.class_schedules CASCADE;
DROP TABLE IF EXISTS public.classes CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;

-- Create users table
CREATE TABLE public.users (
    user_id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    username text NOT NULL UNIQUE,
    npm text NOT NULL UNIQUE,
    password text NOT NULL,
    email text NOT NULL UNIQUE,
    full_name text NOT NULL,
    role text NOT NULL,
    semester integer NOT NULL,
    image_url text DEFAULT '',
    academic_year text DEFAULT '',
    created_at timestamp with time zone DEFAULT current_timestamp,
    CONSTRAINT users_pkey PRIMARY KEY (user_id)
);

-- Create classes table
CREATE TABLE public.classes (
    class_id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    title text NOT NULL,
    subtitle text NOT NULL,
    description text,
    semester integer NOT NULL,
    credits integer NOT NULL,
    lecturer_id uuid,
    room text NOT NULL,
    class_section text NOT NULL,
    created_at timestamp with time zone DEFAULT current_timestamp,
    CONSTRAINT classes_pkey PRIMARY KEY (class_id),
    CONSTRAINT classes_lecturer_id_fkey FOREIGN KEY (lecturer_id)
        REFERENCES users(user_id) ON DELETE SET NULL
);

-- Create class_schedules table
CREATE TABLE public.class_schedules (
    schedule_id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    class_id uuid NOT NULL,
    day text NOT NULL,
    time text NOT NULL,
    created_at timestamp with time zone DEFAULT current_timestamp,
    CONSTRAINT class_schedules_pkey PRIMARY KEY (schedule_id),
    CONSTRAINT class_schedules_class_id_fkey FOREIGN KEY (class_id)
        REFERENCES classes(class_id) ON DELETE CASCADE
);

-- Create activities table
CREATE TABLE public.activities (
    activity_id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    title text NOT NULL,
    subtitle text NOT NULL,
    route text NOT NULL,
    type text NOT NULL,
    date_time timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT current_timestamp,
    CONSTRAINT activities_pkey PRIMARY KEY (activity_id)
);

-- Create materials table
CREATE TABLE public.materials (
    material_id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    class_id uuid NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    file_url text NOT NULL,
    date timestamp with time zone NOT NULL,
    has_task boolean DEFAULT false,
    has_attachment boolean DEFAULT false,
    attachment_url text,
    created_at timestamp with time zone DEFAULT current_timestamp,
    CONSTRAINT materials_pkey PRIMARY KEY (material_id),
    CONSTRAINT materials_class_id_fkey FOREIGN KEY (class_id)
        REFERENCES classes(class_id) ON DELETE CASCADE
);

-- Create attendances table
CREATE TABLE public.attendances (
    attendance_id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    schedule_id uuid NOT NULL,
    student_id uuid NOT NULL,
    date timestamp with time zone NOT NULL,
    status text NOT NULL,
    created_at timestamp with time zone DEFAULT current_timestamp,
    CONSTRAINT attendances_pkey PRIMARY KEY (attendance_id),
    CONSTRAINT attendances_schedule_id_fkey FOREIGN KEY (schedule_id)
        REFERENCES class_schedules(schedule_id) ON DELETE CASCADE,
    CONSTRAINT attendances_student_id_fkey FOREIGN KEY (student_id)
        REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create submissions table
CREATE TABLE public.submissions (
    submission_id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    assignment_id uuid NOT NULL,
    student_id uuid NOT NULL,
    file_path text NOT NULL,
    submission_date timestamp with time zone NOT NULL,
    score double precision,
    feedback text,
    created_at timestamp with time zone DEFAULT current_timestamp,
    CONSTRAINT submissions_pkey PRIMARY KEY (submission_id),
    CONSTRAINT submissions_student_id_fkey FOREIGN KEY (student_id)
        REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create indexes for better query performance
CREATE INDEX idx_users_role ON public.users(role);
CREATE INDEX idx_classes_lecturer ON public.classes(lecturer_id);
CREATE INDEX idx_class_schedules_class ON public.class_schedules(class_id);
CREATE INDEX idx_materials_class ON public.materials(class_id);
CREATE INDEX idx_attendances_schedule ON public.attendances(schedule_id);
CREATE INDEX idx_attendances_student ON public.attendances(student_id);
CREATE INDEX idx_submissions_student ON public.submissions(student_id);
CREATE INDEX idx_submissions_assignment ON public.submissions(assignment_id);

-- Create class_enrollments table
CREATE TABLE public.class_enrollments (
    enrollment_id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    class_id uuid NOT NULL,
    student_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT current_timestamp,
    CONSTRAINT class_enrollments_pkey PRIMARY KEY (enrollment_id),
    CONSTRAINT class_enrollments_class_fkey FOREIGN KEY (class_id) 
        REFERENCES classes(class_id) ON DELETE CASCADE,
    CONSTRAINT class_enrollments_student_fkey FOREIGN KEY (student_id) 
        REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT unique_class_enrollment UNIQUE (class_id, student_id)
);

-- Create indexes for better performance
CREATE INDEX idx_class_enrollments_student ON public.class_enrollments(student_id);
CREATE INDEX idx_class_enrollments_class ON public.class_enrollments(class_id);

-- Create function to get student attendances
CREATE OR REPLACE FUNCTION get_student_attendances(
    student_uuid TEXT,
    class_uuid TEXT
)
RETURNS TABLE (
    attendance_date TIMESTAMPTZ,
    attendance_status TEXT,
    class_title TEXT,
    class_subtitle TEXT,
    schedule_day TEXT,
    schedule_time TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.date AS attendance_date,
        a.status AS attendance_status,
        c.title AS class_title,
        c.subtitle AS class_subtitle,
        cs.day AS schedule_day,
        cs.time AS schedule_time
    FROM attendances a
    JOIN class_schedules cs ON a.schedule_id = cs.schedule_id
    JOIN classes c ON cs.class_id = c.class_id
    WHERE a.student_id = student_uuid::UUID 
    AND c.class_id = class_uuid::UUID
    ORDER BY a.date DESC;
END;
$$ LANGUAGE plpgsql;
