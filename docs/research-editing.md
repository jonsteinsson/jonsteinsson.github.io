# Editing Research Content

The research page is rendered from:

- `/data/research/list.yaml`

Each section has this shape:

```yaml
sections:
  - id: working-papers
    title: Working Papers
    works:
      - id: 1
        title: "Paper title"
        pdflink: "/jsteinsson/papers/paper.pdf"
        coauthors: "with [Coauthor Name](https://example.com)"
        book: "*Journal Name*, volume(issue), pages, year."
        notes:
          - "Optional extra line"
        abstract: >
          Abstract text.
        links:
          - text: "Appendix"
            url: "/jsteinsson/papers/appendix.pdf"
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
