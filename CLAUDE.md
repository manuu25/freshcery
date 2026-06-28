# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Freshcery is a groceries store demo built in **plain PHP 7.4 + MySQL/MariaDB** with **no framework, no Composer, and no build step**. There is no package manager, test suite, or linter — code is edited and run directly under a local Apache stack (XAMPP/WAMP). Vendored front-end libraries (Bootstrap 4, jQuery, owl-carousel, o2system-ui, etc.) live pre-built under `assets/packages/`.

## Running locally

The app is served by Apache and **must be reachable at `http://localhost/freshcery`** — this path is hardcoded as `APPURL`/`ADMINURL`/`IMGURL*` constants (see `includes/header.php` and `admin-panel/layouts/header.php`). Changing the folder name or port requires editing those constants everywhere.

1. Place this folder so it serves as `localhost/freshcery` (e.g. in `htdocs/`).
2. Import the schema into a MySQL database named `freshcery`. Two copies of the dump exist: `freshcery.sql` (repo root) and `SQL_FILE/freshcery.sql`.
3. DB credentials live in `config/config.php`: host `localhost`, db `freshcery`, user `root`, empty password (default XAMPP). Edit that file to change them.
4. Customer site entry point: `index.php`. Admin panel: `admin-panel/` (login at `admin-panel/admins/login-admins.php`).

Seed accounts in the dump: admins `admin.first@gmail.com` / `admin.second@gmail.com`; user `mohame@gmail.com`. Password hashes are bcrypt — set new ones via `password_hash()` if you don't know the plaintext.

## Architecture & conventions

Every page is a standalone PHP script that mixes logic and HTML. There is no router or controller layer — the file path *is* the route.

**Page boilerplate.** Customer pages start with `require "../includes/header.php"` then `require "../config/config.php"`, and end with `require "../includes/footer.php"`. Admin pages use `admin-panel/layouts/header.php` + `footer.php` instead. `header.php` is what calls `session_start()`, defines the URL constants, and opens the PDO connection.

**Database access (`$conn`).** `config/config.php` creates a global `$conn` PDO handle (`ERRMODE_EXCEPTION`). Two query styles coexist in this codebase:
- **Reads** are almost always built with `$conn->query("... '$var' ...")` using direct string interpolation of `$_GET`/`$_SESSION` values — these are SQL-injectable. When touching read queries, prefer converting them to prepared statements.
- **Writes** (cart inserts, orders, etc.) use `$conn->prepare(...)` with named `:placeholder` params — follow this pattern for any new write.

**Auth & sessions.** No middleware. Each protected page guards itself by checking `$_SESSION` at the top:
- Customer session keys: `username`, `email`, `user_id`, `image`. Set on login in `auth/login.php`.
- Admin session keys: `adminname`, `email`, `admin_id`. Set in `admin-panel/admins/login-admins.php`.
- Passwords are stored in the `mypassword` column and verified with `password_verify()`.
- A "logged-out" guard typically `echo`s a `<script>window.location.href=...</script>` redirect but does **not** `exit;`, so the rest of the page still renders — keep this quirk in mind.

**Redirects** are done by emitting inline JavaScript (`echo "<script>window.location.href='...'</script>"`), not PHP `header('Location:')`. Some sensitive endpoints (`products/charge.php`, `checkout.php`) gate on `$_SERVER['HTTP_REFERER']` and use a real `header()` redirect when accessed directly.

**Checkout flow.** `products/cart.php` (stores chosen price in `$_SESSION['price']`) → `products/checkout.php` (collects billing info, inserts a row into `orders`, adds $20 shipping into `$_SESSION['total_price']`) → `products/charge.php` (PayPal JS SDK button; the client-id is hardcoded in the file) → `products/success.php`. Add-to-cart happens in `products/detail-product.php`, which inserts into the `cart` table.

**Images.** Product/category images are filenames stored in the DB; the actual files live under `admin-panel/products-admins/img_product/` and `admin-panel/categories-admins/img_category/`, referenced via the `IMGURLPRODUCT`/`IMGURLCATEGORY` constants.

## Data model (tables)

`users`, `admins`, `categories`, `products`, `cart`, `orders`. Notable: `cart` denormalizes product fields (`pro_title`, `pro_price`, etc.) and is scoped by `user_id`; `products.status` (1/0) toggles visibility and read queries filter on `status = 1`; `products.category_id` → `categories.id`. The password column is named `mypassword` in both `users` and `admins`.

## Deployment

The app is deployed all-in-Render (Docker PHP + managed PostgreSQL) — see `DEPLOY.md`.
To support this without breaking local XAMPP dev, two things became env-overridable (the
old hardcoded values are the fallbacks):
- **DB** (`config/config.php`): `DB_DRIVER` (`mysql` local / `pgsql` on Render),
  `DB_HOST/PORT/NAME/USER/PASS`. The PDO DSN is built per driver.
- **Base URL** (`includes/header.php`, `admin-panel/layouts/header.php`, and every
  hardcoded redirect): resolved from `APP_URL` → Render's `RENDER_EXTERNAL_URL` →
  `http://localhost/freshcery`.

`freshcery.pg.sql` is the Postgres-converted schema/seed (the app SQL itself is portable
— no MySQL-only syntax); `docker/entrypoint.sh` auto-seeds it on first boot and binds
Apache to Render's `$PORT`.

## Styling

`assets/css/theme.css` is compiled from `assets/sass/theme.scss` (+ partials in `assets/sass/_partials/`). No Sass build is wired up in the repo — if you change `.scss` you must compile to `theme.css` yourself with a Sass compiler. The admin panel uses a separate `admin-panel/styles/style.css` plus a CDN Bootstrap 4.
