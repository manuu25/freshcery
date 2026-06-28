# Deploying Freshcery to Render

This app is **PHP 8.1 + Apache (Docker)** on Render, talking to an **external MySQL**
database (Render has no managed MySQL). All hardcoded `localhost/freshcery` URLs are
now derived from the environment, and DB credentials come from env vars — local XAMPP
development still works unchanged (the fallbacks are the old defaults).

## 1. Create a free MySQL database

Render only offers managed PostgreSQL, so the DB lives elsewhere. Easiest options:

- **Railway** (recommended — plain connection, no SSL fuss): new project → *Add MySQL*.
  Copy `MYSQLHOST`, `MYSQLPORT`, `MYSQLDATABASE`, `MYSQLUSER`, `MYSQLPASSWORD`.
- **Aiven** / **Clever Cloud**: also free MySQL, but Aiven enforces TLS (the current
  `config/config.php` connects without an SSL CA, so prefer Railway unless you add SSL).

## 2. Import the schema

Load `freshcery.sql` (repo root) into that database, e.g.:

```bash
mysql -h <DB_HOST> -P <DB_PORT> -u <DB_USER> -p <DB_NAME> < freshcery.sql
```

…or paste its contents into the provider's web SQL console.

## 3. Put the code on your GitHub

The current `origin` points at the original author's repo. Create your own and push:

```bash
gh repo create freshcery --public --source=. --remote=deploy --push
```

## 4. Create the Render service

1. Render dashboard → **New → Blueprint**, pick your repo. It reads `render.yaml`
   and provisions a free Docker web service automatically.
   *(Or: New → Web Service → Docker runtime, repo root, free plan.)*
2. Under the service's **Environment**, set:
   | Key       | Value (from step 1)        |
   |-----------|----------------------------|
   | `DB_HOST` | your MySQL host            |
   | `DB_PORT` | e.g. `3306` (Railway differs) |
   | `DB_NAME` | your database name         |
   | `DB_USER` | your DB user               |
   | `DB_PASS` | your DB password           |
3. Leave `APP_URL` empty — the app auto-uses Render's `RENDER_EXTERNAL_URL`
   (`https://<service>.onrender.com`). Only set `APP_URL` if you add a custom domain.
4. **Create / Deploy.** First build pulls the PHP image and compiles `pdo_mysql`
   (~2–3 min).

Your subdomain will be `https://<service-name>.onrender.com`.

## Notes

- Free Render web services **sleep after ~15 min idle**; the first request after that
  takes ~30–50 s to wake.
- Admin panel: `/<base>/admin-panel/admins/login-admins.php`. Seeded admin/user
  password hashes are in the dump but the plaintext is unknown — if you can't log in,
  insert a fresh row with a hash from `password_hash('yourpass', PASSWORD_DEFAULT)`.
- PayPal in `products/charge.php` uses a sandbox client-id; payments are demo-only.
- The container rewrites Apache to listen on Render's `$PORT` via `docker/entrypoint.sh`.
