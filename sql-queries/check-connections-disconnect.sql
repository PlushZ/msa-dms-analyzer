SELECT pid, usename, application_name, client_addr
FROM pg_stat_activity
WHERE datname = 'test_database';

SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'test_database';
