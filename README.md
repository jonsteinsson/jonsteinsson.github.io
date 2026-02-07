## How to Edit Each Section

### Sidebar

Sidebar is controlled by the file `config.toml`.

- `title` is the title of the website.
- `shortbio` is the text displayed right under the title.
- `logo` is the filename of the picture. The file is placed in `content/`. For example, if `logo = "gr.jpg"` then the picture should be placed at `content/gr.jpg` (as it is now).

### Bio, Contact, From Another Life, and Personal

Those four sections are controlled by `content/sections/{aboutme.md, contact.md, from-another-life.md, personal.md}`. The files are formatted using "Markdown" (`.md`), a lightweight markup language. A quick guide is available [here](https://guides.github.com/features/mastering-markdown/). To modify those sections, simply edit the corresponding Markdown file.

### Editing Research Content

The research page is rendered from:

- `/content/research-list.yaml`

Each section has this shape:

```yaml
sections:
  - id: working-papers
    title: Working Papers
    works:
      - id: 1
        title: "Paper title"
        pdflink: "/papers/paper.pdf"
        coauthors: "with [Coauthor Name](https://example.com)"
        book: "*Journal Name*, volume(issue), pages, year."
        notes:
          - "Optional extra line"
        abstract: >
          Abstract text.
        links:
          - text: "Appendix"
            url: "/papers/appendix.pdf"
            note: "Optional note"
        link_notes:
          - "Optional extra resource line"
```

Tips:

- Add/edit papers in `works`.
- Reorder papers by moving entries up/down.
- Update abstracts by editing `abstract`.
- Use Markdown in `coauthors`, `book`, `notes`, and `link_notes` (links, italics, etc.).
- Keep `id` unique per paper because it is used by the abstract toggle.
