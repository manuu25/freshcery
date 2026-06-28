# Deploying Freshcery to Render (all-in-Render, free)

Everything runs on Render: a **Docker PHP 8.1 + Apache** web service and a **managed
PostgreSQL** database. The app was migrated from MySQL to Postgres via a runtime driver
switch (`DB_DRIVER`), so local XAMPP/MySQL development still works unchanged.

## One-click deploy (Blueprint)

1. Push this repo to your GitHub (already done: `manuu25/freshcery`).
2. Render dashboard → **New → Blueprint** → select the repo.
   Render reads [`render.yaml`](render.yaml) and creates **both**:
   - `freshcery` — the Docker web service (free)
   - `freshcery-db` — a managed PostgreSQL database (free)
3. Click **Apply**. That's it — no env vars to set by hand:
   - The DB credentials (`DB_HOST/PORT/NAME/USER/PASS`) are wired automatically from
     `freshcery-db` via `fromDatabase`.
   - `DB_DRIVER=pgsql` is set in the blueprint.
   - The base URL comes from Render's auto-injected `RENDER_EXTERNAL_URL`.
4. On first boot the container **auto-seeds the database** from
   [`freshcery.pg.sql`](freshcery.pg.sql) (schema + demo products/categories/users).
   This is idempotent: it only runs when the `users` table is missing, so restarts and
   redeploys never wipe your data.

First build takes ~3–4 min (pulls the PHP image, compiles `pdo_pgsql`, installs `psql`).
Your site will be at **`https://freshcery-xxxx.onrender.com`**.

## Manual DB seeding (only if you skip auto-seed)

If you ever need to (re)load the schema yourself, grab the database's *External
Connection* string from the Render dashboard and run:

```bash
psql "<EXTERNAL_DATABASE_URL>" -f freshcery.pg.sql
```

## Notes

- **Free tier sleeps** after ~15 min idle; the first request afterwards takes ~30–50 s
  to wake. Render's **free PostgreSQL is removed after ~30 days** — fine for a demo,
  upgrade if you need it to persist.
- Admin panel: `/admin-panel/admins/login-admins.php`. The seeded admin/user password
  hashes are in `freshcery.pg.sql` but the plaintext is unknown. To get in, insert a row
  with a known hash, e.g. run in psql:
  ```sql
  INSERT INTO admins (adminname, email, mypassword)
  VALUES ('me', 'me@example.com', '<paste output of password_hash()>');
  ```
- PayPal in `products/charge.php` uses a sandbox client-id — payments are demo-only.
- Want to switch back to MySQL (e.g. an external provider) instead of Postgres? Set
  `DB_DRIVER=mysql` and point `DB_*` at the MySQL host; import `freshcery.sql` (the
  original MySQL dump) instead.
