import { Pool } from "pg";

const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  throw new Error("DATABASE_URL fehlt in .env.local");
}

export const pool = new Pool({
  connectionString,
});
