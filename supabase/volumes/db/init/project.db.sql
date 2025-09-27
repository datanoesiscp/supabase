-- Create project tables
CREATE TABLE IF NOT EXISTS "my_project" (
  "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  "timestamp" timestamp with time zone DEFAULT now(),
  "filepath" text UNIQUE NOT NULL
);

-- Grant permissions for PostgREST API access
GRANT ALL ON TABLE "my_project" TO authenticator;
GRANT ALL ON TABLE "my_project" TO service_role;
GRANT ALL ON TABLE "my_project" TO anon;
