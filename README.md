uci-thesis-latex
================

### A LaTeX template for thesis and dissertation documents at UC Irvine.

#### Download

Open the template in Overleaf using the UCI Libraries templates link: https://guides.lib.uci.edu/gradmanual/templates

#### Usage

The main file is `thesis.tex`, from which a number of other files are included. Take a look at the comments in the LaTeX sources for thesis/dissertation manual guidance and LaTeX notes.


#### PDF/UA-2 Accessibility Tagging

This template uses the modern LaTeX tagging system (`\DocumentMetadata{tagging=on, pdfstandard=ua-2}`) to produce a tagged, accessible PDF that aims to conform to PDF/UA-2 / Section 508 guidelines.

**Known build warnings (cosmetic, do not affect accessibility):**

When you compile, you may see a few warnings about `Destination 'figure.caption.N' (or 'table.caption.N') has no related structure. /Ref not updated`, plus mixed icons in Acrobat's tag panel for some paragraphs. This comes up if you try to use the \caption package, which is currently not compatible with the tagging project. 
You may also notice that TOC entries in the tag tree have `<Lbl>` nested inside the outer `<Link>` rather than as a direct child of `<TOCI>` (which the PDF/UA-2 ISO spec recommends as the strictest form). All of these come from limitations in the LaTeX tagging project (`tagpdf 0.99q` / `latex-lab` testphase modules in TeX Live 2025) that aren't yet fixed upstream — the produced PDF is structurally PDF/UA-2 compliant and validates with PAC 2024 / axesPDF QuickFix.

These warnings and structural quirks are expected to resolve as latex-lab's tagging support matures (TeX Live 2026 should close most of these gaps). For current upstream status, see the [LaTeX Tagging Project status page](https://latex3.github.io/tagging-project/tagging-status/).

**Verifying conformance:**

Use an up-to-date Adobe Acrobat (2026 or newer) for inspecting and finalizing tagging. Older Acrobat versions have stale tag-tree panels for PDF 2.0 tags. For example, the `<Title>` tag appears as `<p>` in Acrobat 2023's tree view (the underlying type is correct in the document Properties → Type field, and Acrobat 2026+ displays it correctly). Acrobat 2026 also handles PDF 2.0 features and namespaced tags properly, so any manual review or remediation should be done there.

For authoritative accessibility validation (independent of Acrobat's UI), use a PDF/UA-2-aware checker such as:

- **PAC 2024** (PDF Accessibility Checker, free) — https://pdfua.foundation/pac/
- **axesPDF QuickFix** — https://www.axes4.com/

These tools read the actual structure stream rather than Acrobat's UI display.



#### Disclaimer

See the UCI Thesis/Dissertation Manual for the most up-to-date information https://guides.lib.uci.edu/gradmanual/home

This Overleaf template has been created and updated periodically by grad students, so it may not stay as up-to-date as the Word version. When in doubt, refer to the Manual.


#### Credits

This template has been adapted by Isabela Figueira and Alyson Yin (graduate students at UC Irvine), and supported by Carrie Cullen, UCI Research Librarian, to include accessibility tagging and PDF 2.0 support. 

This template was adapted from https://github.com/lotten/uci-thesis-latex, which was authored by Xianping Ge, Trevor Harmon, and Lars Otten, and previously adapted from a blog post: http://vocaro.com/trevor/blog/2008/01/08/a-latex-template-for-uci-dissertations/.


Contents of the template follow the UCI Thesis/Dissertation Manual: https://guides.lib.uci.edu/gradmanual/home


Last Updated: July 17, 2026