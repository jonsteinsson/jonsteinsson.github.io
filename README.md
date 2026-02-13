# Website Update Guide

This guide explains the basic workflow for updating the website.

## What You Need

- A standard computer with a Terminal or Command Prompt app.
- A code editor ([VS Code](https://code.visualstudio.com/) or similar).
- [Git](https://git-scm.com/) and [Hugo](https://gohugo.io/) installed.
- [GitHub Desktop](https://desktop.github.com/).

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

1. Make your content/file edits.
2. Preview locally:
   - Open Terminal and navigate to the GitHub folder in your terminal: `C:\Dropbox\EmiJonShared\Webpages\jonsteinsson.github.io`.
   - Run `hugo serve`.
   - Open the provided localhost link in your browser.
   - Verify that the changes look correct.
3. Stop the preview server with `Control + C` in Terminal.
4. Open GitHub Desktop.
5. (Recommended) Review the changed files.
6. Write a clear commit message (example: `Add working paper on ...`).
7. Click **Commit to main**.
8. Click **Push origin**.

### How To Add a New Paper

1. Add the paper PDF (and any replication `.zip` or data files) to `static/papers/`. If a `.zip` file is larger than 100 mb, you will not be able to push it onto GitHub. In that case, upload the file to Google Drive and add a link to it in the research section. 
2. Open `content/research-list.yaml`.
3. Add a new entry in the correct section under `works:` using this format:

```yaml
sections:
  - id: (relevant section id, e.g., working-papers)
    title: (relevant section title, e.g., Working Papers)
    works:
      - id:(unique identifier, e.g. 999)
        title: "Paper title"
        pdflink: "/papers/your-paper-file.pdf"
        coauthors: "with [Coauthor Name](https://coauthor-website.com)"
        book: "Optional publication/status line (example: '*Journal Name*, volume(issue), pages, year', or 'by Oscar Jorda, Moritz Schularick, and Alan M. Taylor. Discussion at NBER ME Meeting, October 2016')."
        notes:
          - "Optional extra line"
        abstract: >
          Abstract text.
        links:
          - text: "Appendix"
            url: "/papers/appendix.pdf"
            note: "Optional note"
        link_notes:
          - "Optional extra line (example: 'Press: [article1 (date)](https://article-link.com)')"
```

4. Ensure you use a new `id` that is not already used. The actual `id` value does not matter, as long as it is unique.
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
