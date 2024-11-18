-- Insert sample users with different roles
INSERT INTO public.users (username, npm, password, email, full_name, role, semester, image_url, academic_year) VALUES
    ('johndoe', '50421100', 'hashedpass123', 'john.doe@example.com', 'John Doe', 'lecturer', 0, 'https://example.com/john.jpg', '2023/2024'),
    ('janesmith', '50421101', 'hashedpass456', 'jane.smith@example.com', 'Jane Smith', 'student', 4, 'https://example.com/jane.jpg', '2023/2024'),
    ('bobwhite', '50421102', 'hashedpass789', 'bob.white@example.com', 'Bob White', 'student', 4, 'https://example.com/bob.jpg', '2023/2024'),
    ('alicebrown', '50421103', 'hashedpassabc', 'alice.brown@example.com', 'Alice Brown', 'lecturer', 0, 'https://example.com/alice.jpg', '2023/2024');

-- Get the generated UUIDs for reference (save these for use in subsequent inserts)
WITH lecturer_ids AS (
    SELECT user_id FROM public.users WHERE role = 'lecturer'
)
-- Insert sample classes
INSERT INTO public.classes (title, subtitle, description, semester, credits, lecturer_id, room, class_section) 
SELECT 
    'Mobile Programming',
    'Learn Flutter and Dart',
    'Comprehensive mobile app development course',
    4,
    3,
    (SELECT user_id FROM users WHERE username = 'johndoe'),
    '7.4.3',
    'A'
UNION ALL
SELECT 
    'Web Programming',
    'Full Stack Development',
    'Learn modern web development',
    4,
    3,
    (SELECT user_id FROM users WHERE username = 'alicebrown'),
    '7.4.4',
    'B';

-- Insert class schedules
INSERT INTO public.class_schedules (class_id, day, time) 
SELECT 
    (SELECT class_id FROM classes WHERE title = 'Mobile Programming'),
    'Monday',
    '08:00-09:40'
UNION ALL
SELECT 
    (SELECT class_id FROM classes WHERE title = 'Mobile Programming'),
    'Wednesday',
    '13:00-14:40'
UNION ALL
SELECT 
    (SELECT class_id FROM classes WHERE title = 'Web Programming'),
    'Tuesday',
    '10:00-11:40';

-- Insert activities
INSERT INTO public.activities (title, subtitle, route, type, date_time) VALUES
    ('Mobile Programming Quiz', 'Mid-term Assessment', '/quiz/mobile', 'exam', TIMESTAMP WITH TIME ZONE '2024-04-15 09:00:00+07'),
    ('Web Programming Project', 'Final Project Submission', '/project/web', 'project', TIMESTAMP WITH TIME ZONE '2024-05-20 23:59:59+07'),
    ('Flutter Basics Quiz', 'Week 1 Assessment', '/quiz/mobile/week1', 'quiz', TIMESTAMP WITH TIME ZONE '2024-02-20 09:00:00+07'),
    ('Dart Programming Test', 'Week 2 Assessment', '/quiz/mobile/week2', 'quiz', TIMESTAMP WITH TIME ZONE '2024-03-05 09:00:00+07'),
    ('UI Components Assignment', 'Week 3 Task', '/assignment/mobile/week3', 'assignment', TIMESTAMP WITH TIME ZONE '2024-03-12 23:59:59+07'),
    ('State Management Project', 'Week 4-5 Project', '/project/mobile/state', 'project', TIMESTAMP WITH TIME ZONE '2024-03-26 23:59:59+07'),
    ('Mobile Programming Mid-Review', 'Pre-midterm Review Session', '/review/mobile/mid', 'review', TIMESTAMP WITH TIME ZONE '2024-04-10 13:00:00+07'),
    ('Mobile Programming Mid-Exam', 'Mid-term Examination', '/exam/mobile/mid', 'exam', TIMESTAMP WITH TIME ZONE '2024-04-17 09:00:00+07'),
    ('API Integration Workshop', 'Week 8 Workshop', '/workshop/mobile/api', 'workshop', TIMESTAMP WITH TIME ZONE '2024-05-01 13:00:00+07'),
    ('Firebase Implementation', 'Week 9 Project', '/project/mobile/firebase', 'project', TIMESTAMP WITH TIME ZONE '2024-05-15 23:59:59+07'),
    ('App Testing Assignment', 'Week 10 Task', '/assignment/mobile/testing', 'assignment', TIMESTAMP WITH TIME ZONE '2024-05-22 23:59:59+07'),
    ('Final Project Proposal', 'Project Planning Phase', '/project/mobile/final/proposal', 'project', TIMESTAMP WITH TIME ZONE '2024-06-01 23:59:59+07'),
    ('Final Project Progress', 'Development Phase Review', '/project/mobile/final/progress', 'project', TIMESTAMP WITH TIME ZONE '2024-06-15 23:59:59+07'),
    ('Mobile Programming Final-Review', 'Pre-final Review Session', '/review/mobile/final', 'review', TIMESTAMP WITH TIME ZONE '2024-06-20 13:00:00+07'),
    ('Final Project Presentation', 'Project Demo and Defense', '/project/mobile/final/presentation', 'presentation', TIMESTAMP WITH TIME ZONE '2024-06-25 09:00:00+07'),
    ('Mobile Programming Final-Exam', 'Final Examination', '/exam/mobile/final', 'exam', TIMESTAMP WITH TIME ZONE '2024-06-30 09:00:00+07');

-- Insert materials
INSERT INTO public.materials (class_id, title, description, file_url, date, has_task, has_attachment, attachment_url) 
SELECT 
    (SELECT class_id FROM classes WHERE title = 'Mobile Programming'),
    'Introduction to Flutter',
    'Basic concepts of Flutter framework',
    'https://example.com/files/flutter-intro.pdf',
    TIMESTAMP WITH TIME ZONE '2024-02-10 08:00:00+07',
    true,
    true,
    'https://example.com/files/flutter-assignment.pdf'
UNION ALL
SELECT 
    (SELECT class_id FROM classes WHERE title = 'Web Programming'),
    'React Fundamentals',
    'Getting started with React',
    'https://example.com/files/react-basics.pdf',
    TIMESTAMP WITH TIME ZONE '2024-02-12 10:00:00+07',
    false,
    false,
    null;

-- Insert attendances
INSERT INTO public.attendances (schedule_id, student_id, date, status) 
SELECT 
    (SELECT schedule_id FROM class_schedules WHERE day = 'Monday' AND time = '08:00-09:40'),
    (SELECT user_id FROM users WHERE username = 'janesmith'),
    TIMESTAMP WITH TIME ZONE '2024-02-10 08:00:00+07',
    'present'
UNION ALL
SELECT 
    (SELECT schedule_id FROM class_schedules WHERE day = 'Monday' AND time = '08:00-09:40'),
    (SELECT user_id FROM users WHERE username = 'bobwhite'),
    TIMESTAMP WITH TIME ZONE '2024-02-10 08:00:00+07',
    'absent'
UNION ALL
SELECT 
    (SELECT schedule_id FROM class_schedules WHERE day = 'Tuesday' AND time = '10:00-11:40'),
    (SELECT user_id FROM users WHERE username = 'janesmith'),
    TIMESTAMP WITH TIME ZONE '2024-02-11 10:00:00+07',
    'present';

-- Insert submissions
INSERT INTO public.submissions (assignment_id, student_id, file_path, submission_date, score, feedback) 
SELECT 
    (SELECT material_id FROM materials WHERE title = 'Introduction to Flutter'),
    (SELECT user_id FROM users WHERE username = 'janesmith'),
    'submissions/flutter-assignment-jane.pdf',
    TIMESTAMP WITH TIME ZONE '2024-02-15 20:30:00+07',
    85.5,
    'Good work, but needs more comments'
UNION ALL
SELECT 
    (SELECT material_id FROM materials WHERE title = 'Introduction to Flutter'),
    (SELECT user_id FROM users WHERE username = 'bobwhite'),
    'submissions/flutter-assignment-bob.pdf',
    TIMESTAMP WITH TIME ZONE '2024-02-15 22:45:00+07',
    92.0,
    'Excellent implementation';

-- Create function to get student materials
CREATE OR REPLACE FUNCTION get_student_materials(
    student_uuid TEXT,
    class_uuid TEXT
)
RETURNS TABLE (
    material_id UUID,
    material_title TEXT,
    description TEXT,
    file_url TEXT,
    date TIMESTAMPTZ,
    has_task BOOLEAN,
    has_attachment BOOLEAN,
    attachment_url TEXT,
    class_title TEXT,
    class_subtitle TEXT,
    submission_id UUID,
    submission_file TEXT,
    submission_date TIMESTAMPTZ,
    score DOUBLE PRECISION,
    feedback TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m.material_id,
        m.title,
        m.description,
        m.file_url,
        m.date,
        m.has_task,
        m.has_attachment,
        m.attachment_url,
        c.title,
        c.subtitle,
        s.submission_id,
        s.file_path AS submission_file,
        s.submission_date,
        s.score,
        s.feedback
    FROM materials m
    JOIN classes c ON m.class_id = c.class_id
    LEFT JOIN submissions s ON m.material_id = s.assignment_id 
        AND s.student_id = student_uuid::UUID
    WHERE m.class_id = class_uuid::UUID
    ORDER BY m.date DESC;
END;
$$ LANGUAGE plpgsql;