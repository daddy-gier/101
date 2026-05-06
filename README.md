# DockMaster

A single-file boat-slip management app for Nick. No servers, no signup, no
monthly fee — open `index.html` in any browser and you're running.

## What it does

- **Dashboard** — occupancy %, monthly revenue, available slips by size,
  leases expiring in the next 30 days
- **Slips** — inventory every slip: number, size, covered/open, power, water,
  monthly rate
- **Customers** — names, phones, emails, boat name & length
- **Rentals** — link a customer to a slip with start/end dates, rate, and
  paid-through date; occupancy and revenue update automatically
- **Waitlist** — track who's waiting for which size so empty slips get
  refilled fast
- **Export / Import** — one-click JSON backup and restore

Data is stored in your browser's `localStorage` under the key `dockmaster:v1`.
Nothing leaves your device.

## Run it

### Option A — double-click

1. Download `index.html`
2. Open it in Chrome, Safari, Edge, or Firefox

That's it. Comes pre-loaded with demo data so you can see it working
immediately. Use **Reset demo** in the header to wipe it and start clean.

### Option B — publish to the web (free)

Push this repo and enable GitHub Pages:

1. GitHub → repo → **Settings** → **Pages**
2. Source: **Deploy from a branch** → branch `master` → folder `/ (root)`
3. Visit the URL GitHub gives you (bookmark it on your phone)

## Backup

Click **Export** in the header → a timestamped `.json` file downloads. Stash
it in Dropbox/iCloud/email. To restore, click **Import** and pick the file.

> Browser data can be cleared by updates, profile resets, or clearing cache.
> Export every week or two.

## Tech

HTML + Tailwind (CDN) + vanilla JS. No build step, no `node_modules`, no
dependencies to install.
