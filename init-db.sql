-- Create role first
CREATE ROLE myapp WITH LOGIN PASSWORD 'myapppass';
ALTER ROLE myapp CREATEDB;

-- Create databases
CREATE DATABASE myapp OWNER myapp;
CREATE DATABASE myapp_test OWNER myapp;

-- Connect to myapp database and set up permissions
\c myapp
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO myapp;
GRANT USAGE, CREATE ON SCHEMA public TO myapp;

-- Connect to test database and set up permissions
\c myapp_test
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO myapp;
GRANT USAGE, CREATE ON SCHEMA public TO myapp; 