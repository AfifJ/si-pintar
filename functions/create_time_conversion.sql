-- Create a function to convert time between time zones
create or replace function convert_time(
    input_time text,
    source_format text,
    source_timezone text,
    target_timezone text
) returns text
language plpgsql
as $$
declare
    parsed_timestamp timestamp with time zone;
    result text;
begin
    -- Parse the input time based on the source format
    -- Common formats: 'HH24:MI', 'HH12:MI AM', etc.
    parsed_timestamp := to_timestamp(input_time, source_format) at time zone source_timezone;
    
    -- Convert to target timezone and format as HH24:MI
    result := to_char(parsed_timestamp at time zone target_timezone, 'HH24:MI');
    
    return result;
exception when others then
    -- Return null or original time if conversion fails
    return null;
end;
$$;

-- Example usage:
-- select convert_time('14:30', 'HH24:MI', 'UTC', 'Asia/Jakarta');
-- select convert_time('02:30 PM', 'HH12:MI AM', 'America/New_York', 'Asia/Jakarta');