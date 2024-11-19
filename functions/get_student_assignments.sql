CREATE OR REPLACE FUNCTION get_student_assignments(
    student_uuid TEXT,
    class_uuid TEXT
)
RETURNS TABLE (
    assignment_id UUID,
    title TEXT,
    description TEXT,
    due_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ,
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
        a.assignment_id,
        a.title,
        a.description,
        a.due_date,
        a.created_at,
        c.title AS class_title,
        c.subtitle AS class_subtitle,
        s.submission_id,
        s.file_path AS submission_file,
        s.submission_date,
        s.score,
        s.feedback
    FROM assignments a
    JOIN classes c ON a.class_id = c.class_id
    LEFT JOIN submissions s ON a.assignment_id = s.assignment_id 
        AND s.student_id = student_uuid::UUID
    WHERE a.class_id = class_uuid::UUID
    ORDER BY a.due_date DESC;
END;
$$ LANGUAGE plpgsql; 