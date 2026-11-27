# Setup: members add their own photos and info

Files: `join.html` (members), `admin.html` (you approve), `index.html` (the deck), `config.js`, `supabase-setup.sql`.

## 1. Create the Supabase project (5 min, free)
1. supabase.com > New project (any name, pick a region close to Morocco, e.g. Frankfurt/Paris). Save the database password.
2. **SQL Editor > New query**: paste all of `supabase-setup.sql` > Run.
3. **Authentication > Users > Add user**: create your admin email + password (tick "Auto Confirm User").
   Then turn OFF "Allow new users to sign up" (Authentication > Sign In / Providers) so nobody else can create an account.
4. **Project Settings > API**: copy the **Project URL** and the **anon / publishable key**.
5. Paste both into `config.js`.

## 2. Put the files online
Upload the whole folder (keep `assets/` next to the html files) to Netlify Drop, GitHub Pages or Cloudflare Pages.
- Members get: `https://YOUR-SITE/join.html`
- You use: `https://YOUR-SITE/admin.html` and `https://YOUR-SITE/` (the deck)
Don't share the admin link.

## 3. Run it
1. Send `join.html` to the members (WhatsApp group, QR code).
2. Open `admin.html`, log in, review "À valider", click **Approuver** (you can fix a typo first, or **Supprimer**).
3. Open the deck: approved profiles appear automatically (refreshes every minute).

## How slots are filled
- Bureau 2026-27 / sortant: a role starting with "Président" goes to the first card AND the Speech slide. Everyone else fills the next cards in order of arrival (max 11 + president).
- Parrains: first 3 approved.
- To force a position, type a number in the "Position" box in the admin page (1 = first card).

## Before the show
Open the deck once with Wi-Fi on the laptop you'll present from: data and photos are cached in the browser (on https), so it still works if the network drops.

## Good to know
- Members can't edit after sending; delete the entry in admin and they resubmit.
- Photos are compressed JPEGs (about 80 KB). They only appear on the deck after approval (the file itself is reachable by anyone who knows its random link).
- The key in `config.js` is meant to be public; the rules in `supabase-setup.sql` only allow "read approved rows" and "submit pending rows".
- Edit mode in the deck (pencil) still works for local tweaks, but approved data overrides it on reload.
