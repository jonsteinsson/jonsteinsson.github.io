# Website Update Guide

This guide explains the basic workflow for updating the website.

## What You Need

- A code editor (VS Code or similar).
- Terminal app.
- [GitHub Desktop](https://desktop.github.com/).
- Hugo installed on your device.

## Where Things Live

- Main website text/content: `content/`
  - Bio: `content/home.md`.
  - Research papers list: `content/research-list.yaml`.
  - Teaching: `content/teaching.html`.
  - Writings in Icelandic: `content/writings-icelandic.html`, `content/gmoggi.html`, `content/gdeigla.html`, and `content/galmennt.html`.
- PDFs, replication packages, and downloadable files: `static/` (usually `static/papers/`)
- Sidebar settings (name, short bio, profile photo): `config.toml`

Do not manually edit `public/` (it is generated automatically).

## Standard Workflow (Every Update)

1. Open this folder in your editor:
   - `/GitHub/jonsteinsson.github.io`
2. Make your content/file edits.
3. Preview locally:
   - Open Terminal
   - Run:
     ```bash
     cd .../GitHub/jonsteinsson.github.io
     hugo serve
     ```
   - Open the provided localhost link in your browser.
   - Verify that the changes look correct.
4. Stop the preview server with `Control + C` in Terminal.
5. Open GitHub Desktop.
6. (Recommended) Review the changed files.
7. Write a clear commit message (example: `Add working paper on ...`).
8. Click **Commit to main**.
9. Click **Push origin**.

### How To Add a New Paper

1. Add the paper PDF (and any replication `.zip` or data files) to:
   - `static/papers/`
2. Open:
   - `content/research-list.yaml`
3. Add a new entry in the correct section under `works:` using this format:

```yaml
- id: (unique identifier, e.g. 999)
  title: "Paper title"
  pdflink: "/papers/your-paper-file.pdf"
  coauthors: "with [Coauthor Name](https://example.com)"
  book: "Optional publication/status line (example: 'by Oscar Jorda, Moritz Schularick, and Alan M. Taylor. Discussion at NBER ME Meeting, October 2016')"
  abstract: >-
    Optional abstract text.
  links:
  - text: "Replication Package"
    url: "/papers/your-replication-file.zip"
```

4. Use a new `id` that is not already used.
5. Save the file.
6. Preview with `hugo serve`.
7. If it looks good, commit and push from GitHub Desktop.

### Other Common Edits

- Edit an existing paper: update its entry in `content/research-list.yaml`.
- Reorder papers: move entries up/down within `works:` (inside `content/research-list.yaml`).
- Edit bio/contact text: update `content/home.md` using [markdown syntax](https://www.markdownguide.org/basic-syntax/).
- Update sidebar title/short bio/photo filename: edit `config.toml`.

## Quick Checklist Before Pushing

- Site preview looks correct with `hugo serve`.
- New links open correctly.
- PDF/ZIP paths start with `/papers/...` if stored in `static/papers/`.
- No accidental changes to unrelated files.
